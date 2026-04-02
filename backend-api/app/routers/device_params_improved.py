"""Device parameters router for MQTT-based parameter operations (GE/SE commands)."""

import asyncio
from typing import Dict, Any, Optional
from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.ext.asyncio import AsyncSession

from ..database import get_db
from ..dependencies import CurrentUserDep
from ..mqtt import publish_device_command
from ..redis import cache_get, cache_set, cache_delete
from ..schemas.common import MessageResponse
from ..utils.security import generate_installer_id
from ..utils.mqtt_protocol import ParameterCommand, PARAMETER_FIELDS
from .devices import _get_user_device
from .installer_sessions import _ensure_installer_session

router = APIRouter(prefix="/devices")

COMMAND_TIMEOUT = 15  # seconds


@router.get("/{device_id}/params")
async def get_device_parameters(
    device_id: int,
    current_user: CurrentUserDep,
    db: AsyncSession = Depends(get_db),
    force_refresh: bool = False
):
    """Get device parameters via MQTT GE command with cache fallback.
    
    Args:
        device_id: Device ID
        current_user: Current authenticated user
        db: Database session
        force_refresh: Force refresh from device via MQTT
        
    Returns:
        Device parameters
    """
    # Check device access
    device = await _get_user_device(device_id, current_user.id, db)
    
    # Check cache first (unless force refresh)
    cache_key = f"device:{device.serial_number}:parameters"
    if not force_refresh:
        cached_params = await cache_get(cache_key)
        if cached_params:
            return {
                "device_id": device_id,
                "device_name": device.name,
                "parameters": cached_params,
                "source": "cache",
                "last_updated": cached_params.get("_cached_at"),
                "parameter_fields": PARAMETER_FIELDS
            }
    
    # Try to get fresh parameters via MQTT GE command
    try:
        # Generate installer ID
        installer_id = generate_installer_id(current_user.id)
        
        # Ensure installer session is active
        session_active = await _ensure_installer_session(device.serial_number, installer_id)
        if not session_active:
            # Fall back to cache or default if MQTT fails
            return await _get_fallback_parameters(device, cache_key)
        
        # Send GE (Get Parameters) command
        await publish_device_command(
            device.serial_number,
            ParameterCommand.GET_PARAMS,
            idInstaller=installer_id
        )
        
        # Wait for response
        response = await _wait_for_command_response(device.serial_number, COMMAND_TIMEOUT)
        
        if response and response.get("AC") == "GE":
            # Extract parameters from GE response
            parameters = _extract_parameters_from_ge_response(response)
            
            # Cache the parameters
            parameters["_cached_at"] = asyncio.get_event_loop().time()
            await cache_set(cache_key, parameters, expire=3600)  # 1 hour
            
            return {
                "device_id": device_id,
                "device_name": device.name,
                "parameters": parameters,
                "source": "realtime",
                "last_updated": parameters["_cached_at"],
                "parameter_fields": PARAMETER_FIELDS
            }
        else:
            # MQTT command failed, fall back to cache
            return await _get_fallback_parameters(device, cache_key)
            
    except Exception as e:
        # MQTT failed, fall back to cache or defaults
        print(f"Failed to get parameters via MQTT: {e}")
        return await _get_fallback_parameters(device, cache_key)


@router.put("/{device_id}/params", response_model=MessageResponse)
async def set_device_parameters(
    device_id: int,
    params: Dict[str, Any],
    current_user: CurrentUserDep,
    db: AsyncSession = Depends(get_db)
):
    """Set device parameters via MQTT SE command.
    
    Args:
        device_id: Device ID
        params: Parameters to set
        current_user: Current authenticated user
        db: Database session
        
    Returns:
        MessageResponse: Set operation result
    """
    # Check device access and configure permissions
    device = await _get_user_device(device_id, current_user.id, db)
    
    # Validate parameters
    _validate_parameters(params)
    
    # Generate installer ID
    installer_id = generate_installer_id(current_user.id)
    
    try:
        # Ensure installer session is active
        session_active = await _ensure_installer_session(device.serial_number, installer_id)
        if not session_active:
            raise HTTPException(
                status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                detail="Failed to establish installer session"
            )
        
        # Send SE (Set Parameters) command with parameters
        se_params = {
            "idInstaller": installer_id,
            **params  # Include all parameters in the SE command
        }
        
        await publish_device_command(
            device.serial_number,
            ParameterCommand.SET_PARAMS,
            **se_params
        )
        
        # Wait for response
        response = await _wait_for_command_response(device.serial_number, COMMAND_TIMEOUT)
        
        if response and response.get("result") == "OK":
            # Update cache with new parameters
            cache_key = f"device:{device.serial_number}:parameters"
            cached_params = await cache_get(cache_key) or {}
            cached_params.update(params)
            cached_params["_cached_at"] = asyncio.get_event_loop().time()
            await cache_set(cache_key, cached_params, expire=3600)
            
            return MessageResponse(
                message=f"Parameters updated successfully. {len(params)} parameters set.",
                success=True
            )
        else:
            error_msg = response.get("error", "Command failed") if response else "No response from device"
            raise HTTPException(
                status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                detail=f"Failed to set parameters: {error_msg}"
            )
            
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Failed to set parameters: {str(e)}"
        )


@router.get("/{device_id}/params/fields")
async def get_parameter_fields(
    device_id: int,
    current_user: CurrentUserDep,
    db: AsyncSession = Depends(get_db)
):
    """Get parameter field definitions.
    
    Args:
        device_id: Device ID
        current_user: Current authenticated user
        db: Database session
        
    Returns:
        Parameter field definitions
    """
    # Check device access
    device = await _get_user_device(device_id, current_user.id, db)
    
    return {
        "device_id": device_id,
        "device_name": device.name,
        "parameter_fields": PARAMETER_FIELDS,
        "categories": {
            "motor": ["dP", "P5", "LC", "FE"],
            "auto_close": ["CA", "tC"],
            "opening": ["AP"],
            "modes": ["Co", "rA"],
            "maintenance": ["CC"],
            "photocells": ["FF"],
            "lighting": ["FL", "LE"],
            "security": ["bL", "tA"],
            "network": ["labelVita", "setWifi", "ssid", "ssidPassword"]
        }
    }


@router.post("/{device_id}/params/refresh", response_model=MessageResponse)
async def refresh_device_parameters(
    device_id: int,
    current_user: CurrentUserDep,
    db: AsyncSession = Depends(get_db)
):
    """Force refresh parameters from device.
    
    Args:
        device_id: Device ID
        current_user: Current authenticated user
        db: Database session
        
    Returns:
        MessageResponse: Refresh result
    """
    try:
        # Call get_device_parameters with force_refresh=True
        result = await get_device_parameters(
            device_id=device_id,
            current_user=current_user,
            db=db,
            force_refresh=True
        )
        
        if result.get("source") == "realtime":
            return MessageResponse(
                message="Parameters refreshed successfully from device",
                success=True
            )
        else:
            return MessageResponse(
                message="Could not refresh from device, using cached parameters",
                success=False
            )
            
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Failed to refresh parameters: {str(e)}"
        )


def _validate_parameters(params: Dict[str, Any]) -> None:
    """Validate parameter values.
    
    Args:
        params: Parameters to validate
        
    Raises:
        HTTPException: If validation fails
    """
    for key, value in params.items():
        if key not in PARAMETER_FIELDS:
            # Allow unknown parameters but warn
            print(f"Warning: Unknown parameter {key}")
            continue
        
        field_info = PARAMETER_FIELDS[key]
        
        # Type validation
        if field_info["type"] == "int":
            if not isinstance(value, int):
                raise HTTPException(
                    status_code=status.HTTP_400_BAD_REQUEST,
                    detail=f"Parameter {key} must be an integer"
                )
            
            # Range validation
            if "range" in field_info:
                range_parts = field_info["range"].split("-")
                if len(range_parts) == 2:
                    min_val, max_val = int(range_parts[0]), int(range_parts[1])
                    if not min_val <= value <= max_val:
                        raise HTTPException(
                            status_code=status.HTTP_400_BAD_REQUEST,
                            detail=f"Parameter {key} must be between {min_val} and {max_val}"
                        )
        
        elif field_info["type"] == "string":
            if not isinstance(value, str):
                raise HTTPException(
                    status_code=status.HTTP_400_BAD_REQUEST,
                    detail=f"Parameter {key} must be a string"
                )


def _extract_parameters_from_ge_response(response: Dict[str, Any]) -> Dict[str, Any]:
    """Extract parameters from GE response.
    
    Args:
        response: MQTT GE response
        
    Returns:
        Dict: Extracted parameters
    """
    parameters = {}
    
    # Map known fields from GE response to parameter names
    for param_key, field_info in PARAMETER_FIELDS.items():
        if param_key in response:
            parameters[param_key] = response[param_key]
    
    # Also include any other fields that might be parameters
    known_system_fields = ["AC", "result", "idInstaller", "_cached_at"]
    for key, value in response.items():
        if key not in known_system_fields and key not in parameters:
            parameters[key] = value
    
    return parameters


async def _get_fallback_parameters(device, cache_key: str) -> Dict[str, Any]:
    """Get fallback parameters from cache or defaults.
    
    Args:
        device: Device object
        cache_key: Cache key for parameters
        
    Returns:
        Dict: Fallback parameters
    """
    # Try cache first
    cached_params = await cache_get(cache_key)
    if cached_params:
        return {
            "device_id": device.id,
            "device_name": device.name,
            "parameters": cached_params,
            "source": "cache",
            "last_updated": cached_params.get("_cached_at"),
            "parameter_fields": PARAMETER_FIELDS
        }
    
    # Use defaults
    default_params = {
        "dP": 0,  # Motor Direction: Right
        "P5": 3,  # Soft Stop
        "LC": 1,  # Limit Switches: NC
        "CA": 1,  # Auto Close: ON
        "tC": 3,  # Auto Close Time: 1 min
        "AP": 3,  # Pedestrian Opening: 50%
        "FE": 5,  # Push Force: medium
        "Co": 0,  # Condo Mode: OFF
        "rA": 0,  # Auxiliary Relay Mode
        "CC": 5,  # Maintenance Limit
        "FF": 1,  # Photocell Close: ON
        "FL": 0,  # Lamp Mode: Fixed
        "LE": 2,  # Courtesy Light: 2 min
        "bL": 0,  # Block: OFF
        "tA": 0,  # Keep Open: OFF
        "labelVita": device.name,
        "setWifi": 0,
        "_cached_at": None
    }
    
    return {
        "device_id": device.id,
        "device_name": device.name,
        "parameters": default_params,
        "source": "defaults",
        "last_updated": None,
        "parameter_fields": PARAMETER_FIELDS
    }


async def _wait_for_command_response(device_serial: str, timeout: int) -> Optional[Dict[str, Any]]:
    """Wait for command response from device.
    
    Args:
        device_serial: Device serial number
        timeout: Timeout in seconds
        
    Returns:
        Optional[Dict]: Response data or None if timeout
    """
    response_key = f"device:{device_serial}:last_response"
    
    # Poll for response (in production, use WebSocket or pub/sub)
    for _ in range(timeout * 10):  # Check every 100ms
        response = await cache_get(response_key)
        if response:
            # Clear the response so it doesn't interfere with next command
            await cache_delete(response_key)
            return response
            
        await asyncio.sleep(0.1)
    
    return None
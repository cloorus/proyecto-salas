"""Photocell management router for MQTT-based photocell operations."""

import asyncio
from typing import Optional, Dict, Any
from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.ext.asyncio import AsyncSession

from ..database import get_db
from ..dependencies import CurrentUserDep
from ..mqtt import publish_device_command
from ..redis import cache_get, cache_delete
from ..schemas.common import MessageResponse
from ..utils.security import generate_installer_id
from ..utils.mqtt_protocol import PhotocellCommand
from .devices import _get_user_device
from .installer_sessions import _ensure_installer_session

router = APIRouter(prefix="/devices")

COMMAND_TIMEOUT = 15  # seconds - photocell commands may take longer

# Map action names to MQTT commands
PHOTOCELL_COMMANDS = {
    "pair_open": PhotocellCommand.PAIR_OPEN,      # PA
    "pair_close": PhotocellCommand.PAIR_CLOSE,    # AC
    "test_close": PhotocellCommand.TEST_CLOSE,    # t1
    "test_open": PhotocellCommand.TEST_OPEN       # t2
}


@router.post("/{device_id}/photocell/{action}", response_model=MessageResponse)
async def execute_photocell_command(
    device_id: int,
    action: str,
    current_user: CurrentUserDep,
    db: AsyncSession = Depends(get_db)
):
    """Execute photocell command on device.
    
    Args:
        device_id: Device ID
        action: Photocell action (pair_open, pair_close, test_close, test_open)
        current_user: Current authenticated user
        db: Database session
        
    Returns:
        MessageResponse: Command execution result
    """
    # Validate action
    if action not in PHOTOCELL_COMMANDS:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=f"Invalid photocell action: {action}. Valid actions: {', '.join(PHOTOCELL_COMMANDS.keys())}"
        )
    
    # Check device access and installer permissions
    device = await _get_user_device(device_id, current_user.id, db)
    
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
        
        # Get MQTT command for action
        mqtt_command = PHOTOCELL_COMMANDS[action]
        
        # Publish photocell command
        await publish_device_command(
            device.serial_number,
            mqtt_command,
            idInstaller=installer_id
        )
        
        # Wait for response
        response = await _wait_for_command_response(device.serial_number, COMMAND_TIMEOUT)
        
        if response:
            if response.get("result") == "OK":
                return MessageResponse(
                    message=f"Photocell command '{action}' executed successfully",
                    success=True
                )
            else:
                error_msg = response.get("error", "Command failed")
                raise HTTPException(
                    status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                    detail=f"Photocell command failed: {error_msg}"
                )
        else:
            raise HTTPException(
                status_code=status.HTTP_408_REQUEST_TIMEOUT,
                detail=f"Photocell command '{action}' timed out - device may be offline"
            )
            
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Failed to execute photocell command: {str(e)}"
        )


@router.get("/{device_id}/photocell/actions")
async def get_available_photocell_actions(
    device_id: int,
    current_user: CurrentUserDep,
    db: AsyncSession = Depends(get_db)
):
    """Get available photocell actions for device.
    
    Args:
        device_id: Device ID
        current_user: Current authenticated user
        db: Database session
        
    Returns:
        Available photocell actions with descriptions
    """
    # Check device access
    device = await _get_user_device(device_id, current_user.id, db)
    
    actions = {
        "pair_open": {
            "command": "PA",
            "name": "Pair Opening Photocell",
            "description": "Pair photocell for opening detection",
            "category": "pairing",
            "requires_physical_photocell": True
        },
        "pair_close": {
            "command": "AC", 
            "name": "Pair Closing Photocell",
            "description": "Pair photocell for closing detection",
            "category": "pairing",
            "requires_physical_photocell": True
        },
        "test_close": {
            "command": "t1",
            "name": "Test Close Photocell",
            "description": "Test closing photocell functionality",
            "category": "testing",
            "requires_paired_photocell": True
        },
        "test_open": {
            "command": "t2",
            "name": "Test Open Photocell", 
            "description": "Test opening photocell functionality",
            "category": "testing",
            "requires_paired_photocell": True
        }
    }
    
    return {
        "device_id": device_id,
        "device_name": device.name,
        "actions": actions,
        "categories": {
            "pairing": "Photocell Pairing",
            "testing": "Photocell Testing"
        },
        "instructions": {
            "pairing": "Place photocell in pairing mode before executing pair commands",
            "testing": "Ensure photocells are properly installed and paired before testing"
        }
    }


@router.get("/{device_id}/photocell/status")
async def get_photocell_status(
    device_id: int,
    current_user: CurrentUserDep,
    db: AsyncSession = Depends(get_db)
):
    """Get photocell status for device.
    
    Args:
        device_id: Device ID
        current_user: Current authenticated user
        db: Database session
        
    Returns:
        Photocell status information
    """
    # Check device access
    device = await _get_user_device(device_id, current_user.id, db)
    
    # Try to get real-time status from cache
    status_key = f"device:{device.serial_number}:state"
    device_state = await cache_get(status_key)
    
    if device_state:
        return {
            "device_id": device_id,
            "device_name": device.name,
            "photocells": {
                "open": {
                    "state": device_state.get("Fc_OpenState", 0),
                    "state_name": "Free" if device_state.get("Fc_OpenState", 0) == 0 else "Interrupted",
                    "battery_level": device_state.get("fc_Open_Battery", 0),
                    "is_paired": device_state.get("fc_Open_Battery", 0) > 0
                },
                "close": {
                    "state": device_state.get("Fc_CloseState", 0),
                    "state_name": "Free" if device_state.get("Fc_CloseState", 0) == 0 else "Interrupted",
                    "battery_level": device_state.get("fc_Close_Battery", 0),
                    "is_paired": device_state.get("fc_Close_Battery", 0) > 0
                }
            },
            "last_updated": device_state.get("last_heartbeat"),
            "source": "realtime"
        }
    else:
        # Return default/unknown status
        return {
            "device_id": device_id,
            "device_name": device.name,
            "photocells": {
                "open": {
                    "state": 0,
                    "state_name": "Unknown",
                    "battery_level": 0,
                    "is_paired": False
                },
                "close": {
                    "state": 0,
                    "state_name": "Unknown", 
                    "battery_level": 0,
                    "is_paired": False
                }
            },
            "last_updated": None,
            "source": "unknown"
        }


@router.post("/{device_id}/photocell/sequence", response_model=MessageResponse)
async def execute_photocell_sequence(
    device_id: int,
    actions: list[str],
    current_user: CurrentUserDep,
    db: AsyncSession = Depends(get_db)
):
    """Execute a sequence of photocell commands.
    
    Args:
        device_id: Device ID
        actions: List of photocell actions to execute in sequence
        current_user: Current authenticated user
        db: Database session
        
    Returns:
        MessageResponse: Sequence execution result
    """
    # Validate all actions first
    invalid_actions = [action for action in actions if action not in PHOTOCELL_COMMANDS]
    if invalid_actions:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=f"Invalid photocell actions: {', '.join(invalid_actions)}"
        )
    
    if not actions:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="No actions specified"
        )
    
    if len(actions) > 5:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Maximum 5 actions allowed in photocell sequence"
        )
    
    # Check device access
    device = await _get_user_device(device_id, current_user.id, db)
    
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
        
        executed_actions = []
        failed_actions = []
        
        # Execute each action in sequence
        for i, action in enumerate(actions):
            try:
                # Get MQTT command for action
                mqtt_command = PHOTOCELL_COMMANDS[action]
                
                # Publish photocell command
                await publish_device_command(
                    device.serial_number,
                    mqtt_command,
                    idInstaller=installer_id
                )
                
                # Wait for response
                response = await _wait_for_command_response(device.serial_number, COMMAND_TIMEOUT)
                
                if response and response.get("result") == "OK":
                    executed_actions.append(action)
                else:
                    failed_actions.append({
                        "action": action,
                        "error": response.get("error", "Command failed") if response else "Timeout"
                    })
                    break  # Stop on first failure
                
                # Longer delay between photocell commands
                if i < len(actions) - 1:
                    await asyncio.sleep(3)
                    
            except Exception as e:
                failed_actions.append({
                    "action": action,
                    "error": str(e)
                })
                break
        
        # Build response
        if not failed_actions:
            return MessageResponse(
                message=f"Photocell sequence completed successfully. Executed {len(executed_actions)} actions.",
                success=True
            )
        else:
            error_msg = f"Photocell sequence partially completed. Executed: {len(executed_actions)}, Failed: {len(failed_actions)}. "
            error_msg += f"First failure: {failed_actions[0]['action']} - {failed_actions[0]['error']}"
            
            raise HTTPException(
                status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                detail=error_msg
            )
            
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Failed to execute photocell sequence: {str(e)}"
        )


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
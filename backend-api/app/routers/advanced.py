"""Advanced configuration router for MQTT-based advanced operations."""

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
from ..utils.mqtt_protocol import AdvancedCommand
from .devices import _get_user_device
from .installer_sessions import _ensure_installer_session

router = APIRouter(prefix="/devices")

COMMAND_TIMEOUT = 30  # seconds - advanced commands may take longer

# Map action names to MQTT commands
ADVANCED_COMMANDS = {
    "factory_reset": AdvancedCommand.FACTORY_RESET,        # CF
    "clear_rf_controls": AdvancedCommand.CLEAR_RF_CONTROLS, # bC
    "clear_pcb_params": AdvancedCommand.CLEAR_PCB_PARAMS,  # bP
    "reset_esp": AdvancedCommand.RESET_ESP,               # rE
    "reset_maintenance": AdvancedCommand.RESET_MAINTENANCE, # rC
    "delete_wifi": AdvancedCommand.DELETE_WIFI,           # DelWifi
    "limit_switch_config": AdvancedCommand.LIMIT_SWITCH    # LC
}


@router.post("/{device_id}/advanced/{action}", response_model=MessageResponse)
async def execute_advanced_command(
    device_id: int,
    action: str,
    current_user: CurrentUserDep,
    db: AsyncSession = Depends(get_db),
    confirm: bool = False
):
    """Execute advanced configuration command on device.
    
    Args:
        device_id: Device ID
        action: Advanced action (factory_reset, clear_rf_controls, etc.)
        current_user: Current authenticated user
        db: Database session
        confirm: Confirmation flag for destructive operations
        
    Returns:
        MessageResponse: Command execution result
    """
    # Validate action
    if action not in ADVANCED_COMMANDS:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=f"Invalid advanced action: {action}. Valid actions: {', '.join(ADVANCED_COMMANDS.keys())}"
        )
    
    # Check for destructive operations requiring confirmation
    destructive_actions = ["factory_reset", "clear_rf_controls", "clear_pcb_params", "reset_esp", "delete_wifi"]
    if action in destructive_actions and not confirm:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=f"Action '{action}' is destructive and requires confirmation. Add ?confirm=true to proceed."
        )
    
    # Check device access and installer permissions
    device = await _get_user_device(device_id, current_user.id, db)
    
    # Additional permission check for factory reset (owner only)
    if action == "factory_reset" and device.owner_id != current_user.id:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Factory reset can only be performed by device owner"
        )
    
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
        mqtt_command = ADVANCED_COMMANDS[action]
        
        # Publish advanced command
        await publish_device_command(
            device.serial_number,
            mqtt_command,
            idInstaller=installer_id
        )
        
        # Wait for response (longer timeout for advanced operations)
        response = await _wait_for_command_response(device.serial_number, COMMAND_TIMEOUT)
        
        if response:
            if response.get("result") == "OK":
                return MessageResponse(
                    message=f"Advanced command '{action}' executed successfully",
                    success=True
                )
            else:
                error_msg = response.get("error", "Command failed")
                raise HTTPException(
                    status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                    detail=f"Advanced command failed: {error_msg}"
                )
        else:
            # For some commands like reset_esp, no response is expected
            if action in ["reset_esp", "factory_reset"]:
                return MessageResponse(
                    message=f"Advanced command '{action}' sent successfully (device will restart)",
                    success=True
                )
            else:
                raise HTTPException(
                    status_code=status.HTTP_408_REQUEST_TIMEOUT,
                    detail=f"Advanced command '{action}' timed out - device may be offline"
                )
            
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Failed to execute advanced command: {str(e)}"
        )


@router.get("/{device_id}/advanced/actions")
async def get_available_advanced_actions(
    device_id: int,
    current_user: CurrentUserDep,
    db: AsyncSession = Depends(get_db)
):
    """Get available advanced actions for device.
    
    Args:
        device_id: Device ID
        current_user: Current authenticated user
        db: Database session
        
    Returns:
        Available advanced actions with descriptions and warnings
    """
    # Check device access
    device = await _get_user_device(device_id, current_user.id, db)
    
    is_owner = device.owner_id == current_user.id
    
    actions = {
        "factory_reset": {
            "command": "CF",
            "name": "Factory Reset",
            "description": "Reset device to factory configuration",
            "category": "reset",
            "is_destructive": True,
            "requires_owner": True,
            "available": is_owner,
            "warning": "⚠️ This will erase ALL settings and return device to factory defaults"
        },
        "clear_rf_controls": {
            "command": "bC",
            "name": "Clear RF Controls",
            "description": "Clear all RF remote controls",
            "category": "controls",
            "is_destructive": True,
            "requires_owner": False,
            "available": True,
            "warning": "⚠️ This will remove ALL paired remote controls"
        },
        "clear_pcb_params": {
            "command": "bP",
            "name": "Clear PCB Parameters",
            "description": "Clear PCB configuration parameters",
            "category": "configuration",
            "is_destructive": True,
            "requires_owner": False,
            "available": True,
            "warning": "⚠️ This will reset motor configuration parameters"
        },
        "reset_esp": {
            "command": "rE",
            "name": "Reset ESP32",
            "description": "Restart ESP32 microcontroller",
            "category": "reset",
            "is_destructive": True,
            "requires_owner": False,
            "available": True,
            "warning": "⚠️ Device will restart and be offline temporarily"
        },
        "reset_maintenance": {
            "command": "rC",
            "name": "Reset Maintenance Counter",
            "description": "Reset maintenance cycle counter",
            "category": "maintenance",
            "is_destructive": False,
            "requires_owner": False,
            "available": True,
            "warning": None
        },
        "delete_wifi": {
            "command": "DelWifi",
            "name": "Delete WiFi Configuration",
            "description": "Remove saved WiFi credentials",
            "category": "network",
            "is_destructive": True,
            "requires_owner": False,
            "available": True,
            "warning": "⚠️ Device will lose network connectivity"
        },
        "limit_switch_config": {
            "command": "LC",
            "name": "Configure Limit Switches",
            "description": "Configure limit switch settings",
            "category": "configuration",
            "is_destructive": False,
            "requires_owner": False,
            "available": True,
            "warning": None
        }
    }
    
    return {
        "device_id": device_id,
        "device_name": device.name,
        "is_owner": is_owner,
        "actions": actions,
        "categories": {
            "reset": "Reset Operations",
            "controls": "Control Management",
            "configuration": "Configuration",
            "maintenance": "Maintenance",
            "network": "Network Settings"
        },
        "safety_notice": "Advanced operations can affect device functionality. Proceed with caution."
    }


@router.get("/{device_id}/advanced/maintenance")
async def get_maintenance_info(
    device_id: int,
    current_user: CurrentUserDep,
    db: AsyncSession = Depends(get_db)
):
    """Get device maintenance information.
    
    Args:
        device_id: Device ID
        current_user: Current authenticated user
        db: Database session
        
    Returns:
        Maintenance information
    """
    # Check device access
    device = await _get_user_device(device_id, current_user.id, db)
    
    # Try to get real-time status from cache
    status_key = f"device:{device.serial_number}:state"
    device_state = await cache_get(status_key)
    
    if device_state:
        total_cycles = device_state.get("Total_Cycles", 0)
        maintenance_limit = device_state.get("Par_MaintenanceLimit", 0)
        cycles_since_maintenance = device_state.get("Cycles_SinceMaintenance", 0)
        maintenance_count = device_state.get("Maintenance_Count", 0)
        
        # Calculate maintenance status
        needs_maintenance = cycles_since_maintenance >= maintenance_limit if maintenance_limit > 0 else False
        cycles_until_maintenance = max(0, maintenance_limit - cycles_since_maintenance) if maintenance_limit > 0 else 0
        
        return {
            "device_id": device_id,
            "device_name": device.name,
            "maintenance": {
                "total_cycles": total_cycles,
                "maintenance_count": maintenance_count,
                "cycles_since_maintenance": cycles_since_maintenance,
                "maintenance_limit": maintenance_limit,
                "needs_maintenance": needs_maintenance,
                "cycles_until_maintenance": cycles_until_maintenance,
                "maintenance_percentage": round((cycles_since_maintenance / maintenance_limit * 100), 2) if maintenance_limit > 0 else 0
            },
            "last_updated": device_state.get("last_heartbeat"),
            "source": "realtime"
        }
    else:
        return {
            "device_id": device_id,
            "device_name": device.name,
            "maintenance": {
                "total_cycles": 0,
                "maintenance_count": 0,
                "cycles_since_maintenance": 0,
                "maintenance_limit": 0,
                "needs_maintenance": False,
                "cycles_until_maintenance": 0,
                "maintenance_percentage": 0
            },
            "last_updated": None,
            "source": "unknown"
        }


@router.post("/{device_id}/advanced/maintenance/reset", response_model=MessageResponse)
async def reset_maintenance_counter(
    device_id: int,
    current_user: CurrentUserDep,
    db: AsyncSession = Depends(get_db)
):
    """Reset device maintenance counter.
    
    Args:
        device_id: Device ID
        current_user: Current authenticated user
        db: Database session
        
    Returns:
        MessageResponse: Reset result
    """
    return await execute_advanced_command(
        device_id=device_id,
        action="reset_maintenance",
        current_user=current_user,
        db=db,
        confirm=True  # Auto-confirm for maintenance reset
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
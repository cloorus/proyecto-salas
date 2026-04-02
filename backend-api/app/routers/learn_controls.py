"""Learn controls router for MQTT-based learn command execution."""

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
from ..utils.mqtt_protocol import LearnCommand
from .devices import _get_user_device
from .installer_sessions import _ensure_installer_session

router = APIRouter(prefix="/devices")

COMMAND_TIMEOUT = 15  # seconds - learning commands may take longer

# Map action names to MQTT commands
LEARN_COMMANDS = {
    "total_open": LearnCommand.LEARN_TOTAL_OPEN,      # Ct
    "pedestrian": LearnCommand.LEARN_PEDESTRIAN,      # CP
    "lamp": LearnCommand.LEARN_LAMP,                  # CL
    "relay_pcb": LearnCommand.LEARN_RELAY_PCB,        # Cr
    "block": LearnCommand.LEARN_BLOCK,                # Cb
    "open": LearnCommand.LEARN_OPEN,                  # Ai
    "close": LearnCommand.LEARN_CLOSE,                # AE
    "stop": LearnCommand.LEARN_STOP,                  # AA
    "keep_open": LearnCommand.LEARN_KEEP_OPEN,        # At
    "travel_limit": LearnCommand.LEARN_TRAVEL_LIMIT,  # AL
    "add_travel": LearnCommand.ADD_TRAVEL,            # 5r
    "subtract_travel": LearnCommand.SUBTRACT_TRAVEL   # rr
}


@router.post("/{device_id}/learn/{action}", response_model=MessageResponse)
async def execute_learn_command(
    device_id: int,
    action: str,
    current_user: CurrentUserDep,
    db: AsyncSession = Depends(get_db)
):
    """Execute learn control command on device.
    
    Args:
        device_id: Device ID
        action: Learn action (total_open, pedestrian, lamp, etc.)
        current_user: Current authenticated user
        db: Database session
        
    Returns:
        MessageResponse: Command execution result
    """
    # Validate action
    if action not in LEARN_COMMANDS:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=f"Invalid learn action: {action}. Valid actions: {', '.join(LEARN_COMMANDS.keys())}"
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
        mqtt_command = LEARN_COMMANDS[action]
        
        # Publish learn command
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
                    message=f"Learn command '{action}' executed successfully",
                    success=True
                )
            else:
                error_msg = response.get("error", "Command failed")
                raise HTTPException(
                    status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                    detail=f"Learn command failed: {error_msg}"
                )
        else:
            raise HTTPException(
                status_code=status.HTTP_408_REQUEST_TIMEOUT,
                detail=f"Learn command '{action}' timed out - device may be offline"
            )
            
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Failed to execute learn command: {str(e)}"
        )


@router.get("/{device_id}/learn/actions")
async def get_available_learn_actions(
    device_id: int,
    current_user: CurrentUserDep,
    db: AsyncSession = Depends(get_db)
):
    """Get available learn actions for device.
    
    Args:
        device_id: Device ID
        current_user: Current authenticated user
        db: Database session
        
    Returns:
        Available learn actions with descriptions
    """
    # Check device access
    device = await _get_user_device(device_id, current_user.id, db)
    
    actions = {
        "total_open": {
            "command": "Ct",
            "name": "Learn Total Open Control",
            "description": "Program total opening control for the device",
            "category": "control"
        },
        "pedestrian": {
            "command": "CP",
            "name": "Learn Pedestrian Control", 
            "description": "Program pedestrian opening control",
            "category": "control"
        },
        "lamp": {
            "command": "CL",
            "name": "Learn Lamp Control",
            "description": "Program lamp control functionality",
            "category": "control"
        },
        "relay_pcb": {
            "command": "Cr",
            "name": "Learn Relay PCB Control",
            "description": "Program relay PCB control",
            "category": "control"
        },
        "block": {
            "command": "Cb",
            "name": "Learn Block Control",
            "description": "Program blocking functionality",
            "category": "control"
        },
        "open": {
            "command": "Ai",
            "name": "Learn Open Control",
            "description": "Program opening movement control",
            "category": "movement"
        },
        "close": {
            "command": "AE",
            "name": "Learn Close Control",
            "description": "Program closing movement control",
            "category": "movement"
        },
        "stop": {
            "command": "AA",
            "name": "Learn Stop Control",
            "description": "Program stop functionality",
            "category": "movement"
        },
        "keep_open": {
            "command": "At",
            "name": "Learn Keep Open Control",
            "description": "Program keep-open functionality",
            "category": "movement"
        },
        "travel_limit": {
            "command": "AL",
            "name": "Learn Travel Limit",
            "description": "Program travel distance limits",
            "category": "limits"
        },
        "add_travel": {
            "command": "5r",
            "name": "Add Travel Distance",
            "description": "Increase travel distance setting",
            "category": "adjustment"
        },
        "subtract_travel": {
            "command": "rr",
            "name": "Subtract Travel Distance",
            "description": "Decrease travel distance setting",
            "category": "adjustment"
        }
    }
    
    return {
        "device_id": device_id,
        "device_name": device.name,
        "actions": actions,
        "categories": {
            "control": "Control Programming",
            "movement": "Movement Programming", 
            "limits": "Limit Programming",
            "adjustment": "Distance Adjustments"
        }
    }


@router.post("/{device_id}/learn/sequence", response_model=MessageResponse)
async def execute_learn_sequence(
    device_id: int,
    actions: list[str],
    current_user: CurrentUserDep,
    db: AsyncSession = Depends(get_db)
):
    """Execute a sequence of learn commands.
    
    Args:
        device_id: Device ID
        actions: List of learn actions to execute in sequence
        current_user: Current authenticated user
        db: Database session
        
    Returns:
        MessageResponse: Sequence execution result
    """
    # Validate all actions first
    invalid_actions = [action for action in actions if action not in LEARN_COMMANDS]
    if invalid_actions:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=f"Invalid learn actions: {', '.join(invalid_actions)}"
        )
    
    if not actions:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="No actions specified"
        )
    
    if len(actions) > 10:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Maximum 10 actions allowed in sequence"
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
                mqtt_command = LEARN_COMMANDS[action]
                
                # Publish learn command
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
                
                # Small delay between commands
                if i < len(actions) - 1:
                    await asyncio.sleep(1)
                    
            except Exception as e:
                failed_actions.append({
                    "action": action,
                    "error": str(e)
                })
                break
        
        # Build response
        if not failed_actions:
            return MessageResponse(
                message=f"Learn sequence completed successfully. Executed {len(executed_actions)} actions.",
                success=True
            )
        else:
            error_msg = f"Learn sequence partially completed. Executed: {len(executed_actions)}, Failed: {len(failed_actions)}. "
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
            detail=f"Failed to execute learn sequence: {str(e)}"
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
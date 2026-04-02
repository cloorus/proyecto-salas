"""Device command router for MQTT-based device control."""

import asyncio
import uuid
from datetime import datetime, timedelta
from typing import Optional, Dict, Any
from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.ext.asyncio import AsyncSession

from ..database import get_db
from ..models.command import Command
from ..schemas.command import CommandRequest, CommandResponse
from ..dependencies import CurrentUserDep
from ..mqtt import publish_device_command
from ..redis import cache_get, cache_set, cache_delete
from ..utils.security import generate_installer_id
from ..utils.mqtt_protocol import get_command_for_action
from .devices import _get_user_device

router = APIRouter(prefix="/devices")

COMMAND_TIMEOUT = 10  # seconds


@router.post("/{device_id}/command", response_model=CommandResponse)
async def send_device_command(
    device_id: int,
    request: CommandRequest,
    current_user: CurrentUserDep,
    db: AsyncSession = Depends(get_db)
):
    """Send command to device via MQTT.
    
    Args:
        device_id: Device ID
        request: Command request data
        current_user: Current authenticated user
        db: Database session
        
    Returns:
        CommandResponse: Command execution result
    """
    # Check device access and control permissions
    device = await _get_user_device(device_id, current_user.id, db)
    
    # TODO: Check if user has control permissions for this device
    # For now, assume all users with access can control
    
    # Generate installer ID for MQTT commands
    installer_id = generate_installer_id(current_user.id)
    
    # Create command record
    command = Command(
        device_id=device_id,
        user_id=current_user.id,
        command_type=request.command,
        mqtt_ac=get_command_for_action(request.command),
        status="pending"
    )
    
    db.add(command)
    await db.commit()
    await db.refresh(command)
    
    try:
        # Ensure installer session is active (simplified - in real implementation,
        # we would manage sessions properly)
        session_active = await _ensure_installer_session(device.serial_number, installer_id)
        if not session_active:
            command.status = "failed"
            command.response = {"error": "Failed to establish installer session"}
            command.completed_at = datetime.utcnow()
            await db.commit()
            
            raise HTTPException(
                status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                detail="Failed to establish device session"
            )
        
        # Publish MQTT command
        mqtt_command = {
            "AC": get_command_for_action(request.command),
            "idInstaller": installer_id
        }
        
        # Add any additional parameters
        if request.parameters:
            mqtt_command.update(request.parameters)
        
        await publish_device_command(device.serial_number, mqtt_command["AC"], **mqtt_command)
        
        # Wait for response with timeout
        response = await _wait_for_command_response(device.serial_number, command.id, COMMAND_TIMEOUT)
        
        if response:
            command.status = "completed" if response.get("result") == "OK" else "failed"
            command.response = response
        else:
            command.status = "timeout"
            command.response = {"error": "Command timeout"}
        
        command.completed_at = datetime.utcnow()
        await db.commit()
        await db.refresh(command)
        
        return CommandResponse(
            id=str(command.id),
            device_id=command.device_id,
            command_type=command.command_type,
            status=command.status,
            response=command.response,
            created_at=command.created_at.isoformat() + "Z",
            completed_at=command.completed_at.isoformat() + "Z" if command.completed_at else None,
            duration_ms=command.get_duration_ms()
        )
        
    except Exception as e:
        # Update command with error
        command.status = "failed"
        command.response = {"error": str(e)}
        command.completed_at = datetime.utcnow()
        await db.commit()
        
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Failed to execute command: {str(e)}"
        )


async def _ensure_installer_session(device_serial: str, installer_id: str) -> bool:
    """Ensure installer session is active for the device.
    
    Args:
        device_serial: Device serial number
        installer_id: Installer ID
        
    Returns:
        bool: True if session is active, False otherwise
    """
    try:
        # Check if session already exists in cache
        session_key = f"session:{device_serial}:installer"
        session_data = await cache_get(session_key)
        
        if session_data:
            # Session exists and is valid
            return True
        
        # Initialize new session
        await publish_device_command(device_serial, "IS", idInstaller=installer_id)
        
        # Wait for session confirmation (simplified)
        await asyncio.sleep(1)
        
        # Store session in cache
        session_data = {
            "installer_id": installer_id,
            "started_at": datetime.utcnow().isoformat(),
            "expires_at": (datetime.utcnow() + timedelta(minutes=30)).isoformat()
        }
        await cache_set(session_key, session_data, expire=1800)  # 30 minutes
        
        return True
        
    except Exception:
        return False


async def _wait_for_command_response(device_serial: str, command_id: str, timeout: int) -> Optional[Dict[str, Any]]:
    """Wait for command response from device.
    
    Args:
        device_serial: Device serial number
        command_id: Command ID
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
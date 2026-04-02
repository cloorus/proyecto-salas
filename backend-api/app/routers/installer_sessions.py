"""Installer session management router for MQTT-based session control."""

import asyncio
from datetime import datetime, timedelta
from typing import Optional, Dict, Any
from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.ext.asyncio import AsyncSession

from ..database import get_db
from ..dependencies import CurrentUserDep
from ..mqtt import publish_device_command
from ..redis import cache_get, cache_set, cache_delete
from ..schemas.common import MessageResponse
from ..utils.security import generate_installer_id
from ..utils.mqtt_protocol import SessionCommand
from .devices import _get_user_device

router = APIRouter(prefix="/devices")

SESSION_TIMEOUT = 30 * 60  # 30 minutes in seconds
COMMAND_TIMEOUT = 10  # seconds


@router.post("/{device_id}/session/start", response_model=MessageResponse)
async def start_installer_session(
    device_id: int,
    current_user: CurrentUserDep,
    db: AsyncSession = Depends(get_db)
):
    """Start installer session for device.
    
    Args:
        device_id: Device ID
        current_user: Current authenticated user
        db: Database session
        
    Returns:
        MessageResponse: Session start result
    """
    # Check device access and installer permissions
    device = await _get_user_device(device_id, current_user.id, db)
    
    # Generate installer ID
    installer_id = generate_installer_id(current_user.id)
    
    try:
        # Publish IS (Initialize Session) command
        await publish_device_command(
            device.serial_number,
            SessionCommand.INIT_SESSION,
            idInstaller=installer_id
        )
        
        # Wait for response
        response = await _wait_for_command_response(device.serial_number, COMMAND_TIMEOUT)
        
        if response and response.get("result") == "OK":
            # Store session in cache
            session_key = f"session:{device.serial_number}:installer"
            session_data = {
                "installer_id": installer_id,
                "user_id": current_user.id,
                "device_id": device_id,
                "started_at": datetime.utcnow().isoformat(),
                "expires_at": (datetime.utcnow() + timedelta(seconds=SESSION_TIMEOUT)).isoformat()
            }
            await cache_set(session_key, session_data, expire=SESSION_TIMEOUT)
            
            return MessageResponse(
                message="Installer session started successfully",
                success=True
            )
        else:
            raise HTTPException(
                status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                detail="Failed to start installer session - no response from device"
            )
            
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Failed to start installer session: {str(e)}"
        )


@router.post("/{device_id}/session/extend", response_model=MessageResponse)
async def extend_installer_session(
    device_id: int,
    current_user: CurrentUserDep,
    db: AsyncSession = Depends(get_db)
):
    """Extend installer session for device.
    
    Args:
        device_id: Device ID
        current_user: Current authenticated user
        db: Database session
        
    Returns:
        MessageResponse: Session extend result
    """
    # Check device access
    device = await _get_user_device(device_id, current_user.id, db)
    
    # Check if session exists
    session_key = f"session:{device.serial_number}:installer"
    session_data = await cache_get(session_key)
    
    if not session_data:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="No active installer session found"
        )
    
    # Verify session belongs to current user
    if session_data.get("user_id") != current_user.id:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Session belongs to another user"
        )
    
    installer_id = session_data.get("installer_id")
    
    try:
        # Publish AS (Amplify Session) command
        await publish_device_command(
            device.serial_number,
            SessionCommand.AMPLIFY_SESSION,
            idInstaller=installer_id
        )
        
        # Wait for response
        response = await _wait_for_command_response(device.serial_number, COMMAND_TIMEOUT)
        
        if response and response.get("result") == "OK":
            # Extend session in cache
            session_data["expires_at"] = (datetime.utcnow() + timedelta(seconds=SESSION_TIMEOUT)).isoformat()
            await cache_set(session_key, session_data, expire=SESSION_TIMEOUT)
            
            return MessageResponse(
                message="Installer session extended successfully",
                success=True
            )
        else:
            raise HTTPException(
                status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                detail="Failed to extend installer session - no response from device"
            )
            
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Failed to extend installer session: {str(e)}"
        )


@router.post("/{device_id}/session/close", response_model=MessageResponse)
async def close_installer_session(
    device_id: int,
    current_user: CurrentUserDep,
    db: AsyncSession = Depends(get_db)
):
    """Close installer session for device.
    
    Args:
        device_id: Device ID
        current_user: Current authenticated user
        db: Database session
        
    Returns:
        MessageResponse: Session close result
    """
    # Check device access
    device = await _get_user_device(device_id, current_user.id, db)
    
    # Check if session exists
    session_key = f"session:{device.serial_number}:installer"
    session_data = await cache_get(session_key)
    
    if not session_data:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="No active installer session found"
        )
    
    # Verify session belongs to current user
    if session_data.get("user_id") != current_user.id:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Session belongs to another user"
        )
    
    installer_id = session_data.get("installer_id")
    
    try:
        # Publish CS (Close Session) command
        await publish_device_command(
            device.serial_number,
            SessionCommand.CLOSE_SESSION,
            idInstaller=installer_id
        )
        
        # Wait for response
        response = await _wait_for_command_response(device.serial_number, COMMAND_TIMEOUT)
        
        # Remove session from cache regardless of response
        await cache_delete(session_key)
        
        if response and response.get("result") == "OK":
            return MessageResponse(
                message="Installer session closed successfully",
                success=True
            )
        else:
            return MessageResponse(
                message="Installer session closed (device may be offline)",
                success=True
            )
            
    except Exception as e:
        # Still remove session from cache
        await cache_delete(session_key)
        
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Failed to close installer session: {str(e)}"
        )


@router.get("/{device_id}/session/status")
async def get_installer_session_status(
    device_id: int,
    current_user: CurrentUserDep,
    db: AsyncSession = Depends(get_db)
):
    """Get installer session status for device.
    
    Args:
        device_id: Device ID
        current_user: Current authenticated user
        db: Database session
        
    Returns:
        Session status information
    """
    # Check device access
    device = await _get_user_device(device_id, current_user.id, db)
    
    # Check if session exists
    session_key = f"session:{device.serial_number}:installer"
    session_data = await cache_get(session_key)
    
    if not session_data:
        return {
            "device_id": device_id,
            "has_active_session": False,
            "session": None
        }
    
    return {
        "device_id": device_id,
        "has_active_session": True,
        "session": {
            "installer_id": session_data.get("installer_id"),
            "user_id": session_data.get("user_id"),
            "is_owner": session_data.get("user_id") == current_user.id,
            "started_at": session_data.get("started_at"),
            "expires_at": session_data.get("expires_at")
        }
    }


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
        await publish_device_command(
            device_serial,
            SessionCommand.INIT_SESSION,
            idInstaller=installer_id
        )
        
        # Wait for session confirmation
        response = await _wait_for_command_response(device_serial, COMMAND_TIMEOUT)
        
        if response and response.get("result") == "OK":
            # Store session in cache
            session_data = {
                "installer_id": installer_id,
                "started_at": datetime.utcnow().isoformat(),
                "expires_at": (datetime.utcnow() + timedelta(seconds=SESSION_TIMEOUT)).isoformat()
            }
            await cache_set(session_key, session_data, expire=SESSION_TIMEOUT)
            return True
        
        return False
        
    except Exception:
        return False


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
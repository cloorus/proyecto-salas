"""Device management router for CRUD operations."""

from typing import List
from datetime import datetime
from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy import select, and_
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.orm import selectinload

from ..database import get_db
from ..models.device import Device
from ..models.device_user import DeviceUser
from ..schemas.device import DeviceCreate, DeviceUpdate, DeviceResponse, DeviceFullResponse
from ..schemas.common import MessageResponse, PaginatedResponse
from ..dependencies import CurrentUserDep

router = APIRouter(prefix="/devices")


@router.get("", response_model=PaginatedResponse[DeviceResponse])
async def list_devices(
    current_user: CurrentUserDep,
    db: AsyncSession = Depends(get_db),
    limit: int = 20,
    cursor: str = None
):
    """List all devices accessible to current user.
    
    Args:
        current_user: Current authenticated user
        db: Database session
        limit: Maximum number of devices to return
        cursor: Pagination cursor
        
    Returns:
        PaginatedResponse[DeviceResponse]: Paginated list of devices
    """
    # Get devices where user is owner or has access
    stmt = (
        select(Device)
        .join(DeviceUser, and_(
            DeviceUser.device_id == Device.id,
            DeviceUser.user_id == current_user.id
        ), isouter=True)
        .where(
            (Device.owner_id == current_user.id) |
            (DeviceUser.user_id == current_user.id)
        )
        .order_by(Device.created_at.desc())
        .limit(limit + 1)  # +1 to check if there are more results
    )
    
    result = await db.execute(stmt)
    devices = result.unique().scalars().all()
    
    # Check if there are more results
    has_more = len(devices) > limit
    if has_more:
        devices = devices[:limit]
    
    # Convert to response format
    device_responses = []
    for device in devices:
        device_responses.append(DeviceResponse(
            id=device.id,
            serial_number=device.serial_number,
            mac_address=device.mac_address,
            name=device.name,
            description=device.description,
            device_type=device.device_type,
            location=device.location,
            model=device.model,
            firmware_version=device.firmware_version,
            is_online=device.is_online,
            last_seen=device.last_seen.isoformat() + "Z" if device.last_seen else None,
            motor_status=device.cached_motor_status,
            motor_status_name=device.get_motor_status_name(),
            owner_id=device.owner_id,
            created_at=device.created_at.isoformat() + "Z",
            updated_at=device.updated_at.isoformat() + "Z"
        ))
    
    return PaginatedResponse(
        data=device_responses,
        pagination={
            "cursor": str(devices[-1].id) if devices and has_more else None,
            "has_more": has_more,
            "total": len(device_responses)  # TODO: Implement actual total count
        }
    )


@router.post("", response_model=DeviceResponse)
async def create_device(
    device_data: DeviceCreate,
    current_user: CurrentUserDep,
    db: AsyncSession = Depends(get_db)
):
    """Create a new device.
    
    Args:
        device_data: Device creation data
        current_user: Current authenticated user
        db: Database session
        
    Returns:
        DeviceResponse: Created device
    """
    # Check if serial number already exists
    stmt = select(Device).where(Device.serial_number == device_data.serial_number)
    result = await db.execute(stmt)
    existing_device = result.scalar_one_or_none()
    
    if existing_device:
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail="Device with this serial number already exists"
        )
    
    # Create device
    device = Device(
        serial_number=device_data.serial_number,
        mac_address=device_data.mac_address,
        name=device_data.name,
        description=device_data.description,
        device_type=device_data.device_type,
        location=device_data.location,
        model=device_data.model,
        owner_id=current_user.id
    )
    
    db.add(device)
    await db.commit()
    await db.refresh(device)
    
    # Create owner access record
    device_user = DeviceUser(
        device_id=device.id,
        user_id=current_user.id,
        role="owner",
        granted_by=current_user.id
    )
    
    db.add(device_user)
    await db.commit()
    
    return DeviceResponse(
        id=device.id,
        serial_number=device.serial_number,
        mac_address=device.mac_address,
        name=device.name,
        description=device.description,
        device_type=device.device_type,
        location=device.location,
        model=device.model,
        firmware_version=device.firmware_version,
        is_online=device.is_online,
        last_seen=device.last_seen.isoformat() + "Z" if device.last_seen else None,
        motor_status=device.cached_motor_status,
        motor_status_name=device.get_motor_status_name(),
        owner_id=device.owner_id,
        created_at=device.created_at.isoformat() + "Z",
        updated_at=device.updated_at.isoformat() + "Z"
    )


@router.get("/{device_id}", response_model=DeviceResponse)
async def get_device(
    device_id: int,
    current_user: CurrentUserDep,
    db: AsyncSession = Depends(get_db)
):
    """Get device by ID.
    
    Args:
        device_id: Device ID
        current_user: Current authenticated user
        db: Database session
        
    Returns:
        DeviceResponse: Device information
    """
    # Check if user has access to device
    device = await _get_user_device(device_id, current_user.id, db)
    
    return DeviceResponse(
        id=device.id,
        serial_number=device.serial_number,
        mac_address=device.mac_address,
        name=device.name,
        description=device.description,
        device_type=device.device_type,
        location=device.location,
        model=device.model,
        firmware_version=device.firmware_version,
        is_online=device.is_online,
        last_seen=device.last_seen.isoformat() + "Z" if device.last_seen else None,
        motor_status=device.cached_motor_status,
        motor_status_name=device.get_motor_status_name(),
        owner_id=device.owner_id,
        created_at=device.created_at.isoformat() + "Z",
        updated_at=device.updated_at.isoformat() + "Z"
    )


@router.put("/{device_id}", response_model=DeviceResponse)
async def update_device(
    device_id: int,
    device_data: DeviceUpdate,
    current_user: CurrentUserDep,
    db: AsyncSession = Depends(get_db)
):
    """Update device information.
    
    Args:
        device_id: Device ID
        device_data: Device update data
        current_user: Current authenticated user
        db: Database session
        
    Returns:
        DeviceResponse: Updated device
    """
    # Check if user has admin access to device
    device = await _get_user_device(device_id, current_user.id, db, require_admin=True)
    
    # Update device fields
    if device_data.name is not None:
        device.name = device_data.name
    if device_data.description is not None:
        device.description = device_data.description
    if device_data.location is not None:
        device.location = device_data.location
    
    device.updated_at = datetime.utcnow()
    
    await db.commit()
    await db.refresh(device)
    
    return DeviceResponse(
        id=device.id,
        serial_number=device.serial_number,
        mac_address=device.mac_address,
        name=device.name,
        description=device.description,
        device_type=device.device_type,
        location=device.location,
        model=device.model,
        firmware_version=device.firmware_version,
        is_online=device.is_online,
        last_seen=device.last_seen.isoformat() + "Z" if device.last_seen else None,
        motor_status=device.cached_motor_status,
        motor_status_name=device.get_motor_status_name(),
        owner_id=device.owner_id,
        created_at=device.created_at.isoformat() + "Z",
        updated_at=device.updated_at.isoformat() + "Z"
    )


@router.delete("/{device_id}", response_model=MessageResponse)
async def delete_device(
    device_id: int,
    current_user: CurrentUserDep,
    db: AsyncSession = Depends(get_db)
):
    """Delete device (owner only).
    
    Args:
        device_id: Device ID
        current_user: Current authenticated user
        db: Database session
        
    Returns:
        MessageResponse: Success message
    """
    # Check if user is the owner
    stmt = select(Device).where(
        Device.id == device_id,
        Device.owner_id == current_user.id
    )
    result = await db.execute(stmt)
    device = result.scalar_one_or_none()
    
    if not device:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Device not found or you don't have permission to delete it"
        )
    
    # Delete device (cascading deletes will handle related records)
    await db.delete(device)
    await db.commit()
    
    return MessageResponse(
        message=f"Device '{device.name}' has been deleted",
        success=True
    )


@router.get("/{device_id}/full", response_model=DeviceFullResponse)
async def get_device_full(
    device_id: int,
    current_user: CurrentUserDep,
    db: AsyncSession = Depends(get_db)
):
    """Get complete device information including parameters, status, users, and events.
    
    Args:
        device_id: Device ID
        current_user: Current authenticated user
        db: Database session
        
    Returns:
        DeviceFullResponse: Complete device information
    """
    # TODO: Implement full device response with all related data
    raise HTTPException(
        status_code=status.HTTP_501_NOT_IMPLEMENTED,
        detail="Full device information endpoint not yet implemented"
    )


# Helper function
async def _get_user_device(device_id: int, user_id: int, db: AsyncSession, require_admin: bool = False) -> Device:
    """Get device that user has access to.
    
    Args:
        device_id: Device ID
        user_id: User ID
        db: Database session
        require_admin: Whether admin access is required
        
    Returns:
        Device: Device instance
        
    Raises:
        HTTPException: If device not found or no access
    """
    # Get device with user access information
    stmt = (
        select(Device)
        .outerjoin(DeviceUser, and_(
            DeviceUser.device_id == Device.id,
            DeviceUser.user_id == user_id
        ))
        .where(
            Device.id == device_id,
            (Device.owner_id == user_id) | (DeviceUser.user_id == user_id)
        )
    )
    
    result = await db.execute(stmt)
    device = result.unique().scalar_one_or_none()
    
    if not device:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Device not found or you don't have access to it"
        )
    
    # Check admin requirement
    if require_admin:
        # Get user's role for this device
        stmt = select(DeviceUser).where(
            DeviceUser.device_id == device_id,
            DeviceUser.user_id == user_id
        )
        result = await db.execute(stmt)
        device_user = result.scalar_one_or_none()
        
        is_owner = device.owner_id == user_id
        is_admin = device_user and device_user.is_admin
        
        if not (is_owner or is_admin):
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Admin access required for this operation"
            )
    
    return device
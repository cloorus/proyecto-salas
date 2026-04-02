"""Device parameters router for GE/SE operations."""

from fastapi import APIRouter, HTTPException, status
from ..schemas.device import DeviceParameters

router = APIRouter(prefix="/devices")


@router.get("/{device_id}/params")
async def get_device_parameters(device_id: int):
    """Get device parameters via GE command.
    
    Args:
        device_id: Device ID
        
    Returns:
        Device parameters
    """
    raise HTTPException(
        status_code=status.HTTP_501_NOT_IMPLEMENTED,
        detail="Device parameters endpoint not yet implemented"
    )


@router.put("/{device_id}/params")
async def set_device_parameters(device_id: int, params: DeviceParameters):
    """Set device parameters via SE command.
    
    Args:
        device_id: Device ID
        params: Parameters to set
        
    Returns:
        Success message
    """
    raise HTTPException(
        status_code=status.HTTP_501_NOT_IMPLEMENTED,
        detail="Set device parameters endpoint not yet implemented"
    )
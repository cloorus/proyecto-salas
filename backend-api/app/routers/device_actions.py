"""Device dynamic actions router."""

from fastapi import APIRouter, HTTPException, status

router = APIRouter(prefix="/devices")


@router.get("/{device_id}/actions")
async def get_device_actions(device_id: int):
    """Get available actions for device (merged templates + overrides)."""
    raise HTTPException(
        status_code=status.HTTP_501_NOT_IMPLEMENTED,
        detail="Device actions endpoint not yet implemented"
    )
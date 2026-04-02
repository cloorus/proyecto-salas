"""Device events router."""

from fastapi import APIRouter, HTTPException, status

router = APIRouter(prefix="/devices")


@router.get("/{device_id}/events")
async def get_device_events(device_id: int):
    """Get device event history."""
    raise HTTPException(
        status_code=status.HTTP_501_NOT_IMPLEMENTED,
        detail="Device events endpoint not yet implemented"
    )
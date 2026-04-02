"""Device user sharing router."""

from fastapi import APIRouter, HTTPException, status

router = APIRouter(prefix="/devices")


@router.get("/{device_id}/users")
async def list_device_users(device_id: int):
    """List users with access to device."""
    raise HTTPException(
        status_code=status.HTTP_501_NOT_IMPLEMENTED,
        detail="List device users endpoint not yet implemented"
    )


@router.post("/{device_id}/users")
async def invite_user_to_device(device_id: int):
    """Invite user to access device."""
    raise HTTPException(
        status_code=status.HTTP_501_NOT_IMPLEMENTED,
        detail="Invite user endpoint not yet implemented"
    )


@router.delete("/{device_id}/users/{user_id}")
async def revoke_device_access(device_id: int, user_id: int):
    """Revoke user access to device."""
    raise HTTPException(
        status_code=status.HTTP_501_NOT_IMPLEMENTED,
        detail="Revoke device access endpoint not yet implemented"
    )


@router.put("/{device_id}/users/{user_id}/role")
async def change_user_role(device_id: int, user_id: int):
    """Change user role for device."""
    raise HTTPException(
        status_code=status.HTTP_501_NOT_IMPLEMENTED,
        detail="Change user role endpoint not yet implemented"
    )
"""User profile management router."""

from fastapi import APIRouter, HTTPException, status
from ..schemas.user import UserResponse, UserUpdate

router = APIRouter(prefix="/users")


@router.get("/me")
async def get_user_profile():
    """Get current user profile."""
    raise HTTPException(
        status_code=status.HTTP_501_NOT_IMPLEMENTED,
        detail="User profile endpoint not yet implemented"
    )


@router.put("/me")
async def update_user_profile(profile: UserUpdate):
    """Update user profile."""
    raise HTTPException(
        status_code=status.HTTP_501_NOT_IMPLEMENTED,
        detail="Update user profile endpoint not yet implemented"
    )


@router.post("/me/photo")
async def upload_profile_photo():
    """Upload user profile photo."""
    raise HTTPException(
        status_code=status.HTTP_501_NOT_IMPLEMENTED,
        detail="Upload profile photo endpoint not yet implemented"
    )


@router.delete("/me/photo")
async def delete_profile_photo():
    """Delete user profile photo."""
    raise HTTPException(
        status_code=status.HTTP_501_NOT_IMPLEMENTED,
        detail="Delete profile photo endpoint not yet implemented"
    )
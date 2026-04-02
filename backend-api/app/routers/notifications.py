"""Notifications management router."""

from fastapi import APIRouter, HTTPException, status
from ..schemas.notification import NotificationTokenRequest, NotificationPreferencesUpdate

router = APIRouter(prefix="/notifications")


@router.post("/register-token")
async def register_fcm_token(token: NotificationTokenRequest):
    """Register FCM token for push notifications."""
    raise HTTPException(
        status_code=status.HTTP_501_NOT_IMPLEMENTED,
        detail="Register FCM token endpoint not yet implemented"
    )


@router.delete("/unregister-token")
async def unregister_fcm_token():
    """Unregister FCM token."""
    raise HTTPException(
        status_code=status.HTTP_501_NOT_IMPLEMENTED,
        detail="Unregister FCM token endpoint not yet implemented"
    )


@router.get("")
async def list_notifications():
    """List user notifications."""
    raise HTTPException(
        status_code=status.HTTP_501_NOT_IMPLEMENTED,
        detail="List notifications endpoint not yet implemented"
    )


@router.put("/{notification_id}/read")
async def mark_notification_read(notification_id: int):
    """Mark notification as read."""
    raise HTTPException(
        status_code=status.HTTP_501_NOT_IMPLEMENTED,
        detail="Mark notification read endpoint not yet implemented"
    )


@router.put("/read-all")
async def mark_all_notifications_read():
    """Mark all notifications as read."""
    raise HTTPException(
        status_code=status.HTTP_501_NOT_IMPLEMENTED,
        detail="Mark all notifications read endpoint not yet implemented"
    )


@router.get("/preferences")
async def get_notification_preferences():
    """Get notification preferences."""
    raise HTTPException(
        status_code=status.HTTP_501_NOT_IMPLEMENTED,
        detail="Get notification preferences endpoint not yet implemented"
    )


@router.put("/preferences")
async def update_notification_preferences(preferences: NotificationPreferencesUpdate):
    """Update notification preferences."""
    raise HTTPException(
        status_code=status.HTTP_501_NOT_IMPLEMENTED,
        detail="Update notification preferences endpoint not yet implemented"
    )
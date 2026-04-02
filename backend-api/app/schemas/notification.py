"""Notification Pydantic schemas for push notifications and preferences."""

from typing import Optional, Dict, Any
from pydantic import BaseModel, Field


class NotificationTokenRequest(BaseModel):
    """FCM token registration schema."""
    
    fcm_token: str = Field(..., description="FCM token from mobile device")
    device_info: Optional[str] = Field(None, max_length=200, description="Device information")
    
    class Config:
        schema_extra = {
            "example": {
                "fcm_token": "fGzJ8K9Q2eA:APA91bG...",
                "device_info": "iPhone 15, iOS 18.1"
            }
        }


class NotificationResponse(BaseModel):
    """Notification response schema."""
    
    id: int = Field(..., description="Notification ID")
    type: str = Field(..., description="Notification type")
    title: str = Field(..., description="Notification title")
    body: str = Field(..., description="Notification body")
    metadata: Dict[str, Any] = Field(..., description="Additional notification data")
    is_read: bool = Field(..., description="Whether notification is read")
    device_id: Optional[int] = Field(None, description="Related device ID")
    created_at: str = Field(..., description="Notification creation timestamp")
    
    class Config:
        from_attributes = True
        schema_extra = {
            "example": {
                "id": 1,
                "type": "action_executed",
                "title": "Device Action",
                "body": "John opened the front gate",
                "metadata": {
                    "action": "OPEN",
                    "actor_name": "John Doe",
                    "device_name": "Front Gate"
                },
                "is_read": False,
                "device_id": 1,
                "created_at": "2026-03-02T10:30:00Z"
            }
        }


class NotificationPreferencesResponse(BaseModel):
    """Notification preferences response schema."""
    
    id: int = Field(..., description="Preference ID")
    user_id: int = Field(..., description="User ID")
    device_id: int = Field(..., description="Device ID")
    notify_actions: bool = Field(..., description="Notify on device actions")
    notify_offline: bool = Field(..., description="Notify when device goes offline")
    notify_status_change: bool = Field(..., description="Notify on status changes")
    
    class Config:
        from_attributes = True
        schema_extra = {
            "example": {
                "id": 1,
                "user_id": 1,
                "device_id": 1,
                "notify_actions": True,
                "notify_offline": True,
                "notify_status_change": False
            }
        }


class NotificationPreferencesUpdate(BaseModel):
    """Notification preferences update schema."""
    
    device_id: int = Field(..., description="Device ID")
    notify_actions: Optional[bool] = Field(None, description="Notify on device actions")
    notify_offline: Optional[bool] = Field(None, description="Notify when device goes offline")
    notify_status_change: Optional[bool] = Field(None, description="Notify on status changes")
    
    class Config:
        schema_extra = {
            "example": {
                "device_id": 1,
                "notify_actions": True,
                "notify_offline": False,
                "notify_status_change": True
            }
        }
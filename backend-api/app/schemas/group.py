"""Group Pydantic schemas for device grouping."""

from typing import List, Optional
from pydantic import BaseModel, Field


class GroupCreate(BaseModel):
    """Group creation schema."""
    
    name: str = Field(..., min_length=1, max_length=100, description="Group name")
    description: Optional[str] = Field(None, max_length=200, description="Group description")
    
    class Config:
        schema_extra = {
            "example": {
                "name": "Front Entrance",
                "description": "All devices at the front entrance"
            }
        }


class GroupUpdate(BaseModel):
    """Group update schema."""
    
    name: Optional[str] = Field(None, min_length=1, max_length=100, description="Group name")
    description: Optional[str] = Field(None, max_length=200, description="Group description")
    
    class Config:
        schema_extra = {
            "example": {
                "name": "Main Entrance",
                "description": "Updated description"
            }
        }


class GroupResponse(BaseModel):
    """Group response schema."""
    
    id: int = Field(..., description="Group ID")
    name: str = Field(..., description="Group name")
    description: Optional[str] = Field(None, description="Group description")
    owner_id: int = Field(..., description="Group owner user ID")
    device_count: int = Field(..., description="Number of devices in group")
    created_at: str = Field(..., description="Group creation timestamp")
    
    class Config:
        from_attributes = True
        schema_extra = {
            "example": {
                "id": 1,
                "name": "Front Entrance",
                "description": "All devices at the front entrance",
                "owner_id": 1,
                "device_count": 3,
                "created_at": "2026-03-01T10:30:00Z"
            }
        }


class GroupDeviceAdd(BaseModel):
    """Add device to group schema."""
    
    device_id: int = Field(..., description="Device ID to add")
    
    class Config:
        schema_extra = {
            "example": {
                "device_id": 1
            }
        }


class GroupCommandRequest(BaseModel):
    """Group command request schema."""
    
    command: str = Field(..., description="Command to execute on all devices")
    
    class Config:
        schema_extra = {
            "example": {
                "command": "OCS"
            }
        }
"""User profile Pydantic schemas for request/response validation."""

from typing import Optional
from pydantic import BaseModel, EmailStr, Field, validator
import re


class UserResponse(BaseModel):
    """User profile response schema."""
    
    id: int = Field(..., description="User ID")
    email: str = Field(..., description="User email address")
    full_name: Optional[str] = Field(None, description="User full name")
    phone: Optional[str] = Field(None, description="Phone number")
    country: Optional[str] = Field(None, description="Country name")
    is_active: bool = Field(..., description="Whether user account is active")
    created_at: str = Field(..., description="Account creation timestamp")
    updated_at: str = Field(..., description="Last update timestamp")
    
    class Config:
        from_attributes = True
        schema_extra = {
            "example": {
                "id": 1,
                "email": "user@example.com",
                "full_name": "John Doe",
                "phone": "+1234567890",
                "country": "United States",
                "is_active": True,
                "created_at": "2026-03-01T10:30:00Z",
                "updated_at": "2026-03-01T10:30:00Z"
            }
        }


class UserUpdate(BaseModel):
    """User profile update schema."""
    
    full_name: Optional[str] = Field(None, min_length=2, max_length=200, description="User full name")
    phone: Optional[str] = Field(None, max_length=20, description="Phone number")
    country: Optional[str] = Field(None, max_length=100, description="Country name")
    
    @validator('phone')
    def validate_phone(cls, v):
        """Validate phone number format."""
        if v and not re.match(r'^\+?[\d\s\-\(\)]{7,20}$', v):
            raise ValueError('Invalid phone number format')
        return v
    
    class Config:
        schema_extra = {
            "example": {
                "full_name": "Jane Doe",
                "phone": "+1987654321",
                "country": "Canada"
            }
        }


class UserProfilePhoto(BaseModel):
    """User profile photo response schema."""
    
    photo_url: Optional[str] = Field(None, description="Profile photo URL")
    uploaded_at: Optional[str] = Field(None, description="Photo upload timestamp")
    
    class Config:
        schema_extra = {
            "example": {
                "photo_url": "https://cdn.example.com/photos/user123.jpg",
                "uploaded_at": "2026-03-01T10:30:00Z"
            }
        }
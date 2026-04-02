"""Authentication Pydantic schemas for request/response validation."""

from typing import Optional
from pydantic import BaseModel, EmailStr, Field, validator
import re


class LoginRequest(BaseModel):
    """Login request schema."""
    
    email: EmailStr = Field(..., description="User email address")
    password: str = Field(..., min_length=6, description="User password")
    
    class Config:
        schema_extra = {
            "example": {
                "email": "user@example.com",
                "password": "securepassword"
            }
        }


class RegisterRequest(BaseModel):
    """User registration request schema."""
    
    email: EmailStr = Field(..., description="User email address")
    password: str = Field(..., min_length=8, description="User password")
    full_name: str = Field(..., min_length=2, max_length=200, description="User full name")
    phone: Optional[str] = Field(None, max_length=20, description="Phone number")
    country: Optional[str] = Field(None, max_length=100, description="Country name")
    
    @validator('password')
    def validate_password(cls, v):
        """Validate password strength."""
        if len(v) < 8:
            raise ValueError('Password must be at least 8 characters long')
        if not re.search(r"[A-Z]", v):
            raise ValueError('Password must contain at least one uppercase letter')
        if not re.search(r"[a-z]", v):
            raise ValueError('Password must contain at least one lowercase letter')
        if not re.search(r"\d", v):
            raise ValueError('Password must contain at least one digit')
        return v
    
    @validator('phone')
    def validate_phone(cls, v):
        """Validate phone number format."""
        if v and not re.match(r'^\+?[\d\s\-\(\)]{7,20}$', v):
            raise ValueError('Invalid phone number format')
        return v
    
    class Config:
        schema_extra = {
            "example": {
                "email": "newuser@example.com",
                "password": "SecurePass123",
                "full_name": "John Doe",
                "phone": "+1234567890",
                "country": "United States"
            }
        }


class TokenResponse(BaseModel):
    """Authentication token response schema."""
    
    access_token: str = Field(..., description="JWT access token")
    refresh_token: str = Field(..., description="JWT refresh token")
    token_type: str = Field("bearer", description="Token type")
    expires_in: int = Field(..., description="Access token expiration time in seconds")
    
    class Config:
        schema_extra = {
            "example": {
                "access_token": "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9...",
                "refresh_token": "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9...",
                "token_type": "bearer",
                "expires_in": 900
            }
        }


class RefreshTokenRequest(BaseModel):
    """Refresh token request schema."""
    
    refresh_token: str = Field(..., description="JWT refresh token")
    
    class Config:
        schema_extra = {
            "example": {
                "refresh_token": "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9..."
            }
        }


class ForgotPasswordRequest(BaseModel):
    """Forgot password request schema."""
    
    email: EmailStr = Field(..., description="User email address")
    
    class Config:
        schema_extra = {
            "example": {
                "email": "user@example.com"
            }
        }


class ResetPasswordRequest(BaseModel):
    """Reset password request schema."""
    
    email: EmailStr = Field(..., description="User email address")
    reset_code: str = Field(..., min_length=6, max_length=6, description="Reset code from email")
    new_password: str = Field(..., min_length=8, description="New password")
    
    @validator('new_password')
    def validate_password(cls, v):
        """Validate password strength."""
        if len(v) < 8:
            raise ValueError('Password must be at least 8 characters long')
        if not re.search(r"[A-Z]", v):
            raise ValueError('Password must contain at least one uppercase letter')
        if not re.search(r"[a-z]", v):
            raise ValueError('Password must contain at least one lowercase letter')
        if not re.search(r"\d", v):
            raise ValueError('Password must contain at least one digit')
        return v
    
    class Config:
        schema_extra = {
            "example": {
                "email": "user@example.com",
                "reset_code": "123456",
                "new_password": "NewSecurePass123"
            }
        }


class ChangePasswordRequest(BaseModel):
    """Change password request schema."""
    
    current_password: str = Field(..., description="Current password")
    new_password: str = Field(..., min_length=8, description="New password")
    
    @validator('new_password')
    def validate_password(cls, v):
        """Validate password strength."""
        if len(v) < 8:
            raise ValueError('Password must be at least 8 characters long')
        if not re.search(r"[A-Z]", v):
            raise ValueError('Password must contain at least one uppercase letter')
        if not re.search(r"[a-z]", v):
            raise ValueError('Password must contain at least one lowercase letter')
        if not re.search(r"\d", v):
            raise ValueError('Password must contain at least one digit')
        return v
    
    class Config:
        schema_extra = {
            "example": {
                "current_password": "OldPassword123",
                "new_password": "NewSecurePass123"
            }
        }


class UserResponse(BaseModel):
    """User profile response schema."""
    
    id: int = Field(..., description="User ID")
    email: str = Field(..., description="User email address")
    full_name: Optional[str] = Field(None, description="User full name")
    phone: Optional[str] = Field(None, description="Phone number")
    country: Optional[str] = Field(None, description="Country name")
    is_active: bool = Field(..., description="Whether user account is active")
    created_at: str = Field(..., description="Account creation timestamp")
    
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
                "created_at": "2026-03-01T10:30:00Z"
            }
        }
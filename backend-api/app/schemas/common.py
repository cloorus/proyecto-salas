"""Common Pydantic schemas for API responses."""

from typing import Optional, Any, List, Generic, TypeVar
from pydantic import BaseModel, Field


T = TypeVar('T')


class ErrorResponse(BaseModel):
    """Standard error response format."""
    
    error: dict = Field(..., description="Error details")
    
    class Config:
        schema_extra = {
            "example": {
                "error": {
                    "code": "DEVICE_NOT_FOUND",
                    "message": "The device was not found",
                    "details": {}
                }
            }
        }


class ErrorDetail(BaseModel):
    """Error detail structure."""
    
    code: str = Field(..., description="Error code")
    message: str = Field(..., description="Human-readable error message")
    details: Optional[dict] = Field(default={}, description="Additional error details")


class PaginationInfo(BaseModel):
    """Pagination information."""
    
    cursor: Optional[str] = Field(None, description="Cursor for next page")
    has_more: bool = Field(..., description="Whether more results are available")
    total: Optional[int] = Field(None, description="Total number of results")


class PaginatedResponse(BaseModel, Generic[T]):
    """Generic paginated response format."""
    
    data: List[T] = Field(..., description="Response data")
    pagination: PaginationInfo = Field(..., description="Pagination information")


class HealthResponse(BaseModel):
    """Health check response."""
    
    status: str = Field("healthy", description="Service health status")
    version: str = Field(..., description="API version")
    timestamp: str = Field(..., description="Response timestamp")
    services: dict = Field(..., description="Service status details")
    
    class Config:
        schema_extra = {
            "example": {
                "status": "healthy",
                "version": "2.0.0",
                "timestamp": "2026-03-02T10:30:00Z",
                "services": {
                    "database": "connected",
                    "redis": "connected", 
                    "mqtt": "connected"
                }
            }
        }


class StatusResponse(BaseModel):
    """Status endpoint response."""
    
    api_version: str = Field(..., description="API version")
    environment: str = Field(..., description="Environment (development, production)")
    uptime_seconds: int = Field(..., description="API uptime in seconds")
    active_connections: int = Field(..., description="Number of active connections")


class MessageResponse(BaseModel):
    """Simple message response."""
    
    message: str = Field(..., description="Response message")
    success: bool = Field(True, description="Whether operation was successful")
    
    class Config:
        schema_extra = {
            "example": {
                "message": "Operation completed successfully",
                "success": True
            }
        }
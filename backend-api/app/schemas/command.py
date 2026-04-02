"""Command Pydantic schemas for device control requests."""

from typing import Optional, Any, Dict
from pydantic import BaseModel, Field, validator


class CommandRequest(BaseModel):
    """Device command request schema."""
    
    command: str = Field(..., description="Command to execute")
    parameters: Optional[Dict[str, Any]] = Field(None, description="Additional command parameters")
    
    @validator('command')
    def validate_command(cls, v):
        """Validate command type."""
        allowed_commands = [
            'OPEN', 'CLOSE', 'STOP', 'OCS', 'PEDESTRIAN', 'LAMP', 'RELAY',
            'GET_PARAMS', 'SET_PARAMS', 'GET_STATUS'
        ]
        if v not in allowed_commands:
            raise ValueError(f'Command must be one of: {", ".join(allowed_commands)}')
        return v
    
    class Config:
        schema_extra = {
            "example": {
                "command": "OPEN",
                "parameters": {}
            }
        }


class CommandResponse(BaseModel):
    """Device command response schema."""
    
    id: str = Field(..., description="Command ID (UUID)")
    device_id: int = Field(..., description="Device ID")
    command_type: str = Field(..., description="Command type")
    status: str = Field(..., description="Command status")
    response: Optional[Dict[str, Any]] = Field(None, description="MQTT response from device")
    created_at: str = Field(..., description="Command creation timestamp")
    completed_at: Optional[str] = Field(None, description="Command completion timestamp")
    duration_ms: Optional[int] = Field(None, description="Command duration in milliseconds")
    
    class Config:
        from_attributes = True
        schema_extra = {
            "example": {
                "id": "550e8400-e29b-41d4-a716-446655440000",
                "device_id": 1,
                "command_type": "OPEN",
                "status": "completed",
                "response": {
                    "AC": "OPEN",
                    "idVita": "VITA123456",
                    "result": "OK"
                },
                "created_at": "2026-03-02T10:30:00Z",
                "completed_at": "2026-03-02T10:30:02Z",
                "duration_ms": 2000
            }
        }


class LearnCommandRequest(BaseModel):
    """Learn command request schema."""
    
    learn_type: str = Field(..., description="Type of control to learn")
    
    @validator('learn_type')
    def validate_learn_type(cls, v):
        """Validate learn command type."""
        allowed_types = [
            'total_open', 'pedestrian', 'lamp', 'relay', 'block',
            'open', 'close', 'stop', 'keep_open', 'travel_limit',
            'add_travel', 'subtract_travel'
        ]
        if v not in allowed_types:
            raise ValueError(f'Learn type must be one of: {", ".join(allowed_types)}')
        return v
    
    class Config:
        schema_extra = {
            "example": {
                "learn_type": "total_open"
            }
        }


class PhotocellCommandRequest(BaseModel):
    """Photocell command request schema."""
    
    photocell_type: str = Field(..., description="Type of photocell operation")
    
    @validator('photocell_type')
    def validate_photocell_type(cls, v):
        """Validate photocell command type."""
        allowed_types = ['pair_open', 'pair_close', 'test_open', 'test_close']
        if v not in allowed_types:
            raise ValueError(f'Photocell type must be one of: {", ".join(allowed_types)}')
        return v
    
    class Config:
        schema_extra = {
            "example": {
                "photocell_type": "pair_open"
            }
        }


class AdvancedCommandRequest(BaseModel):
    """Advanced command request schema."""
    
    advanced_type: str = Field(..., description="Type of advanced operation")
    
    @validator('advanced_type')
    def validate_advanced_type(cls, v):
        """Validate advanced command type."""
        allowed_types = [
            'factory_reset', 'clear_rf', 'clear_pcb', 'reset_esp',
            'reset_maintenance', 'delete_wifi', 'limit_switch'
        ]
        if v not in allowed_types:
            raise ValueError(f'Advanced type must be one of: {", ".join(allowed_types)}')
        return v
    
    class Config:
        schema_extra = {
            "example": {
                "advanced_type": "factory_reset"
            }
        }


class SessionResponse(BaseModel):
    """Installer session response schema."""
    
    session_id: str = Field(..., description="Session ID")
    device_id: int = Field(..., description="Device ID")
    user_id: int = Field(..., description="User ID")
    status: str = Field(..., description="Session status")
    started_at: str = Field(..., description="Session start timestamp")
    expires_at: str = Field(..., description="Session expiration timestamp")
    
    class Config:
        schema_extra = {
            "example": {
                "session_id": "session_123456",
                "device_id": 1,
                "user_id": 1,
                "status": "active",
                "started_at": "2026-03-02T10:30:00Z",
                "expires_at": "2026-03-02T11:30:00Z"
            }
        }
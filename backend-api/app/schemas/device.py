"""Device Pydantic schemas for request/response validation."""

from typing import Optional, List, Dict, Any
from pydantic import BaseModel, Field, validator
from datetime import datetime


class DeviceCreate(BaseModel):
    """Device creation schema."""
    
    serial_number: str = Field(..., min_length=5, max_length=50, description="Device serial number")
    name: str = Field(..., min_length=1, max_length=100, description="Device name")
    description: Optional[str] = Field(None, max_length=500, description="Device description")
    device_type: str = Field(..., description="Device type (gate, barrier, door)")
    location: Optional[str] = Field(None, max_length=200, description="Device location")
    model: Optional[str] = Field(None, max_length=100, description="Device model")
    mac_address: Optional[str] = Field(None, description="MAC address")
    
    @validator('device_type')
    def validate_device_type(cls, v):
        """Validate device type."""
        allowed_types = ['gate', 'barrier', 'door', 'camera', 'other']
        if v not in allowed_types:
            raise ValueError(f'Device type must be one of: {", ".join(allowed_types)}')
        return v
    
    @validator('mac_address')
    def validate_mac_address(cls, v):
        """Validate MAC address format."""
        if v and not v.replace(':', '').replace('-', '').isalnum():
            raise ValueError('Invalid MAC address format')
        return v
    
    class Config:
        schema_extra = {
            "example": {
                "serial_number": "VITA123456",
                "name": "Front Gate",
                "description": "Main entrance gate",
                "device_type": "gate",
                "location": "Front yard",
                "model": "VITA Pro",
                "mac_address": "AA:BB:CC:DD:EE:FF"
            }
        }


class DeviceUpdate(BaseModel):
    """Device update schema."""
    
    name: Optional[str] = Field(None, min_length=1, max_length=100, description="Device name")
    description: Optional[str] = Field(None, max_length=500, description="Device description")
    location: Optional[str] = Field(None, max_length=200, description="Device location")
    
    class Config:
        schema_extra = {
            "example": {
                "name": "Back Gate",
                "description": "Secondary entrance",
                "location": "Back yard"
            }
        }


class DeviceResponse(BaseModel):
    """Device response schema."""
    
    id: int = Field(..., description="Device ID")
    serial_number: str = Field(..., description="Device serial number")
    mac_address: Optional[str] = Field(None, description="MAC address")
    name: str = Field(..., description="Device name")
    description: Optional[str] = Field(None, description="Device description")
    device_type: str = Field(..., description="Device type")
    location: Optional[str] = Field(None, description="Device location")
    model: Optional[str] = Field(None, description="Device model")
    firmware_version: Optional[str] = Field(None, description="Firmware version")
    is_online: bool = Field(..., description="Device online status")
    last_seen: Optional[str] = Field(None, description="Last seen timestamp")
    motor_status: Optional[int] = Field(None, description="Current motor status")
    motor_status_name: Optional[str] = Field(None, description="Human-readable motor status")
    owner_id: int = Field(..., description="Device owner user ID")
    created_at: str = Field(..., description="Device creation timestamp")
    updated_at: str = Field(..., description="Last update timestamp")
    
    class Config:
        from_attributes = True
        schema_extra = {
            "example": {
                "id": 1,
                "serial_number": "VITA123456",
                "mac_address": "AA:BB:CC:DD:EE:FF",
                "name": "Front Gate",
                "description": "Main entrance gate",
                "device_type": "gate",
                "location": "Front yard",
                "model": "VITA Pro",
                "firmware_version": "2026030110",
                "is_online": True,
                "last_seen": "2026-03-02T10:29:00Z",
                "motor_status": 2,
                "motor_status_name": "Closed",
                "owner_id": 1,
                "created_at": "2026-03-01T10:30:00Z",
                "updated_at": "2026-03-01T10:30:00Z"
            }
        }


class DeviceParameters(BaseModel):
    """Device parameters schema for GE/SE operations."""
    
    # Motor configuration
    motor_direction: Optional[int] = Field(None, ge=0, le=1, description="Motor direction (0=Right, 1=Left)")
    soft_stop: Optional[int] = Field(None, ge=0, le=10, description="Soft stop configuration")
    limit_switches: Optional[int] = Field(None, ge=0, le=1, description="Limit switches (0=NO, 1=NC)")
    
    # Auto close settings
    auto_close: Optional[int] = Field(None, ge=0, le=1, description="Auto close (0=OFF, 1=ON)")
    auto_close_time: Optional[int] = Field(None, ge=0, le=9, description="Auto close time")
    
    # Pedestrian settings
    pedestrian_opening: Optional[int] = Field(None, ge=1, le=5, description="Pedestrian opening percentage")
    
    # Force settings
    push_force: Optional[int] = Field(None, ge=0, le=9, description="Push force")
    
    # Special modes
    condo_mode: Optional[int] = Field(None, ge=0, le=1, description="Condo mode (0=OFF, 1=ON)")
    auxiliary_relay_mode: Optional[int] = Field(None, ge=0, le=2, description="Auxiliary relay mode")
    maintenance_limit: Optional[int] = Field(None, ge=0, le=9, description="Maintenance cycle limit")
    
    # Photocells
    photocell_close: Optional[int] = Field(None, ge=0, le=1, description="Close by photocells")
    
    # Lamp settings
    lamp_mode: Optional[int] = Field(None, ge=0, le=1, description="Lamp mode (0=Fixed, 1=Flashing)")
    courtesy_light: Optional[int] = Field(None, ge=0, le=5, description="Courtesy light time in minutes")
    
    # Advanced options
    block_function: Optional[int] = Field(None, ge=0, le=1, description="Block function")
    keep_open: Optional[int] = Field(None, ge=0, le=1, description="Keep open")
    
    # Device label and WiFi
    device_label: Optional[str] = Field(None, max_length=100, description="Device label")
    save_wifi: Optional[int] = Field(None, ge=0, le=1, description="Save WiFi credentials")
    wifi_ssid: Optional[str] = Field(None, max_length=100, description="WiFi network name")
    wifi_password: Optional[str] = Field(None, max_length=100, description="WiFi password")
    
    class Config:
        schema_extra = {
            "example": {
                "motor_direction": 0,
                "soft_stop": 5,
                "limit_switches": 1,
                "auto_close": 1,
                "auto_close_time": 3,
                "pedestrian_opening": 3,
                "push_force": 5,
                "condo_mode": 0,
                "auxiliary_relay_mode": 1,
                "maintenance_limit": 5,
                "photocell_close": 1,
                "lamp_mode": 0,
                "courtesy_light": 3,
                "block_function": 0,
                "keep_open": 0,
                "device_label": "Front Gate Controller",
                "save_wifi": 1,
                "wifi_ssid": "MyHomeWiFi",
                "wifi_password": "password123"
            }
        }


class DeviceStatus(BaseModel):
    """Device real-time status schema."""
    
    is_online: bool = Field(..., description="Device online status")
    motor_status: Optional[int] = Field(None, description="Motor status code")
    motor_status_name: Optional[str] = Field(None, description="Motor status name")
    lamp_status: Optional[int] = Field(None, description="Lamp status (0=off, 1=on)")
    relay_status: Optional[int] = Field(None, description="Relay status (0=off, 1=on)")
    last_heartbeat: Optional[str] = Field(None, description="Last heartbeat timestamp")
    firmware_version: Optional[str] = Field(None, description="Firmware version")
    
    class Config:
        schema_extra = {
            "example": {
                "is_online": True,
                "motor_status": 2,
                "motor_status_name": "Closed",
                "lamp_status": 0,
                "relay_status": 1,
                "last_heartbeat": "2026-03-02T10:29:00Z",
                "firmware_version": "2026030110"
            }
        }


class DeviceFullResponse(BaseModel):
    """Complete device information with all related data."""
    
    device: DeviceResponse = Field(..., description="Device information")
    parameters: Dict[str, Any] = Field(..., description="Device parameters")
    status: DeviceStatus = Field(..., description="Device status")
    users: List[dict] = Field(..., description="Users with access")
    recent_events: List[dict] = Field(..., description="Recent events")
    
    class Config:
        schema_extra = {
            "example": {
                "device": {
                    "id": 1,
                    "serial_number": "VITA123456",
                    "name": "Front Gate",
                    "device_type": "gate"
                },
                "parameters": {
                    "motor_direction": 0,
                    "auto_close": 1,
                    "auto_close_time": 3
                },
                "status": {
                    "is_online": True,
                    "motor_status": 2,
                    "motor_status_name": "Closed"
                },
                "users": [],
                "recent_events": []
            }
        }
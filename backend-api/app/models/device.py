"""Device model for VITA hardware management."""

from datetime import datetime
from sqlalchemy import Column, Integer, String, Boolean, DateTime, Text, ForeignKey, JSON
from sqlalchemy.orm import relationship

from ..database import Base


class Device(Base):
    """VITA device model for hardware management."""
    
    __tablename__ = "devices"
    
    # Primary key
    id = Column(Integer, primary_key=True, index=True)
    
    # Device identification
    serial_number = Column(String(50), unique=True, nullable=False, index=True)
    mac_address = Column(String(17), unique=True, nullable=True, index=True)
    
    # Device metadata
    name = Column(String(100), nullable=False)
    description = Column(Text, nullable=True)
    device_type = Column(String(50), nullable=False, index=True)  # gate, barrier, door
    location = Column(String(200), nullable=True)
    model = Column(String(100), nullable=True)
    firmware_version = Column(String(20), nullable=True)
    
    # Ownership
    owner_id = Column(Integer, ForeignKey("users.id"), nullable=False, index=True)
    
    # Online status
    is_online = Column(Boolean, default=False, nullable=False)
    last_seen = Column(DateTime, nullable=True)
    
    # Cached firmware parameters (from GE response)
    cached_params = Column(JSON, default={}, nullable=False)
    cached_motor_status = Column(Integer, nullable=True)
    
    # Timestamps
    created_at = Column(DateTime, default=datetime.utcnow, nullable=False)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow, nullable=False)
    
    # Relationships
    owner = relationship("User", back_populates="owned_devices", foreign_keys=[owner_id])
    device_users = relationship("DeviceUser", back_populates="device", cascade="all, delete-orphan")
    action_overrides = relationship("DeviceActionOverride", back_populates="device", cascade="all, delete-orphan")
    group_memberships = relationship("GroupDevice", back_populates="device")
    commands = relationship("Command", back_populates="device")
    events = relationship("DeviceEvent", back_populates="device")
    notifications = relationship("Notification", back_populates="device")
    notification_preferences = relationship("NotificationPreference", back_populates="device")
    
    @property
    def is_gate(self) -> bool:
        """Check if device is a gate type."""
        return self.device_type in ["gate", "barrier"]
    
    @property
    def is_door(self) -> bool:
        """Check if device is a door type."""
        return self.device_type == "door"
    
    def get_motor_status_name(self) -> str:
        """Get human-readable motor status name."""
        status_map = {
            0: "Open", 1: "Opening", 2: "Closed", 3: "Closing",
            4: "Stopped", 5: "PedOpen", 6: "PedOpening"
        }
        return status_map.get(self.cached_motor_status, "Unknown")
    
    def __repr__(self) -> str:
        return f"<Device(id={self.id}, serial='{self.serial_number}', name='{self.name}')>"
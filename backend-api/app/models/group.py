"""Group models for device grouping and batch operations."""

from datetime import datetime
from sqlalchemy import Column, Integer, String, DateTime, ForeignKey, Text
from sqlalchemy.orm import relationship

from ..database import Base


class Group(Base):
    """Group model for organizing devices."""
    
    __tablename__ = "groups"
    
    # Primary key
    id = Column(Integer, primary_key=True, index=True)
    
    # Group metadata
    name = Column(String(100), nullable=False)
    description = Column(String(200), nullable=True)
    
    # Ownership
    owner_id = Column(Integer, ForeignKey("users.id"), nullable=False, index=True)
    
    # Timestamps
    created_at = Column(DateTime, default=datetime.utcnow, nullable=False)
    
    # Relationships
    owner = relationship("User", back_populates="owned_groups")
    group_devices = relationship("GroupDevice", back_populates="group", cascade="all, delete-orphan")
    
    @property
    def device_count(self) -> int:
        """Get number of devices in this group."""
        return len(self.group_devices)
    
    def __repr__(self) -> str:
        return f"<Group(id={self.id}, name='{self.name}', owner_id={self.owner_id})>"


class GroupDevice(Base):
    """Association table for group-device relationships."""
    
    __tablename__ = "group_devices"
    
    # Composite primary key
    group_id = Column(Integer, ForeignKey("groups.id", ondelete="CASCADE"), primary_key=True)
    device_id = Column(Integer, ForeignKey("devices.id", ondelete="CASCADE"), primary_key=True)
    
    # Relationships
    group = relationship("Group", back_populates="group_devices")
    device = relationship("Device", back_populates="group_memberships")
    
    def __repr__(self) -> str:
        return f"<GroupDevice(group_id={self.group_id}, device_id={self.device_id})>"
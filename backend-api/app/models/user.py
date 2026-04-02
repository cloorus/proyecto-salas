"""User model for authentication and profile management."""

from datetime import datetime
from sqlalchemy import Column, Integer, String, Boolean, DateTime, Text
from sqlalchemy.orm import relationship

from ..database import Base


class User(Base):
    """User model for authentication and profile management."""
    
    __tablename__ = "users"
    
    # Primary key
    id = Column(Integer, primary_key=True, index=True)
    
    # Authentication fields
    email = Column(String(255), unique=True, nullable=False, index=True)
    password_hash = Column(String(255), nullable=False)
    
    # Profile fields
    full_name = Column(String(200), nullable=True)
    phone = Column(String(20), nullable=True)
    country = Column(String(100), nullable=True)
    
    # Status fields
    is_active = Column(Boolean, default=True, nullable=False)
    
    # Timestamps
    created_at = Column(DateTime, default=datetime.utcnow, nullable=False)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow, nullable=False)
    
    # Relationships
    owned_devices = relationship("Device", back_populates="owner", foreign_keys="[Device.owner_id]")
    device_access = relationship("DeviceUser", back_populates="user", foreign_keys="[DeviceUser.user_id]")
    owned_groups = relationship("Group", back_populates="owner")
    commands = relationship("Command", back_populates="user")
    events = relationship("DeviceEvent", back_populates="user", foreign_keys="[DeviceEvent.user_id]")
    notifications = relationship("Notification", back_populates="user")
    notification_tokens = relationship("NotificationToken", back_populates="user")
    notification_preferences = relationship("NotificationPreference", back_populates="user")
    
    def __repr__(self) -> str:
        return f"<User(id={self.id}, email='{self.email}', name='{self.full_name}')>"
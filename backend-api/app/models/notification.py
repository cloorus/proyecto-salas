"""Notification models for push notifications and preferences."""

from datetime import datetime
from sqlalchemy import Column, Integer, String, Boolean, DateTime, ForeignKey, Text, JSON, UniqueConstraint
from sqlalchemy.orm import relationship

from ..database import Base


class NotificationToken(Base):
    """FCM token model for push notifications."""
    
    __tablename__ = "notification_tokens"
    
    # Primary key
    id = Column(Integer, primary_key=True, index=True)
    
    # Foreign key
    user_id = Column(Integer, ForeignKey("users.id", ondelete="CASCADE"), nullable=False, index=True)
    
    # Token details
    fcm_token = Column(String(255), nullable=False)
    device_info = Column(String(200), nullable=True)  # "iPhone 15, iOS 18"
    
    # Timestamps
    created_at = Column(DateTime, default=datetime.utcnow, nullable=False)
    
    # Constraints
    __table_args__ = (
        UniqueConstraint('user_id', 'fcm_token', name='_user_token_uc'),
    )
    
    # Relationships
    user = relationship("User", back_populates="notification_tokens")
    
    def __repr__(self) -> str:
        return f"<NotificationToken(user_id={self.user_id}, device='{self.device_info}')>"


class Notification(Base):
    """Notification model for in-app and push notifications."""
    
    __tablename__ = "notifications"
    
    # Primary key
    id = Column(Integer, primary_key=True, index=True)
    
    # Foreign keys
    user_id = Column(Integer, ForeignKey("users.id", ondelete="CASCADE"), nullable=False, index=True)
    device_id = Column(Integer, ForeignKey("devices.id", ondelete="SET NULL"), nullable=True, index=True)
    
    # Notification content
    type = Column(String(50), nullable=False, index=True)  # action_executed, device_offline, etc.
    title = Column(String(200), nullable=False)
    body = Column(Text, nullable=False)
    extra_data = Column("metadata", JSON, default={}, nullable=False)  # Additional notification data
    
    # Status
    is_read = Column(Boolean, default=False, nullable=False, index=True)
    
    # Timestamps
    created_at = Column(DateTime, default=datetime.utcnow, nullable=False, index=True)
    
    # Relationships
    user = relationship("User", back_populates="notifications")
    device = relationship("Device", back_populates="notifications")
    
    @property
    def is_device_related(self) -> bool:
        """Check if notification is related to a device."""
        return self.device_id is not None
    
    def get_formatted_metadata(self) -> dict:
        """Get formatted metadata for display."""
        formatted = self.metadata.copy()
        
        # Add human-readable timestamps
        if "timestamp" in formatted:
            formatted["formatted_time"] = datetime.fromisoformat(formatted["timestamp"]).strftime("%Y-%m-%d %H:%M")
        
        # Add device name if available
        if self.device:
            formatted["device_name"] = self.device.name
        
        return formatted
    
    def __repr__(self) -> str:
        return f"<Notification(id={self.id}, user_id={self.user_id}, type='{self.type}', read={self.is_read})>"


class NotificationPreference(Base):
    """User notification preferences per device."""
    
    __tablename__ = "notification_preferences"
    
    # Primary key
    id = Column(Integer, primary_key=True, index=True)
    
    # Foreign keys
    user_id = Column(Integer, ForeignKey("users.id", ondelete="CASCADE"), nullable=False, index=True)
    device_id = Column(Integer, ForeignKey("devices.id", ondelete="CASCADE"), nullable=False, index=True)
    
    # Preference settings
    notify_actions = Column(Boolean, default=True, nullable=False)           # Action executed notifications
    notify_offline = Column(Boolean, default=True, nullable=False)           # Device offline notifications
    notify_status_change = Column(Boolean, default=True, nullable=False)     # Status change notifications
    
    # Constraints
    __table_args__ = (
        UniqueConstraint('user_id', 'device_id', name='_user_device_pref_uc'),
    )
    
    # Relationships
    user = relationship("User", back_populates="notification_preferences")
    device = relationship("Device", back_populates="notification_preferences")
    
    def should_notify_for_type(self, notification_type: str) -> bool:
        """Check if user wants notifications for given type.
        
        Args:
            notification_type: Type of notification
            
        Returns:
            bool: True if user wants this type of notification
        """
        type_mapping = {
            "action_executed": self.notify_actions,
            "device_offline": self.notify_offline,
            "device_online": self.notify_offline,  # Same as offline
            "status_change": self.notify_status_change,
        }
        return type_mapping.get(notification_type, False)
    
    def __repr__(self) -> str:
        return f"<NotificationPreference(user_id={self.user_id}, device_id={self.device_id})>"
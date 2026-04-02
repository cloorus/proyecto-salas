"""Device event model for activity logging."""

from datetime import datetime
from sqlalchemy import Column, Integer, String, DateTime, ForeignKey, Text, JSON
from sqlalchemy.orm import relationship

from ..database import Base


class DeviceEvent(Base):
    """Device event model for activity logging."""
    
    __tablename__ = "device_events"
    
    # Primary key
    id = Column(Integer, primary_key=True, index=True)
    
    # Foreign keys
    device_id = Column(Integer, ForeignKey("devices.id", ondelete="CASCADE"), nullable=False, index=True)
    user_id = Column(Integer, ForeignKey("users.id"), nullable=True, index=True)
    
    # Event details
    event_type = Column(String(50), nullable=False, index=True)  # action_executed, status_change, etc.
    description = Column(Text, nullable=True)
    extra_data = Column("metadata", JSON, default={}, nullable=False)  # Additional event data
    
    # Timestamps
    created_at = Column(DateTime, default=datetime.utcnow, nullable=False, index=True)
    
    # Relationships
    device = relationship("Device", back_populates="events")
    user = relationship("User", back_populates="events", foreign_keys=[user_id])
    
    def get_formatted_description(self) -> str:
        """Get formatted event description with metadata."""
        if self.description:
            return self.description
        
        # Generate description based on event type and metadata
        if self.event_type == "action_executed":
            action = self.metadata.get("action", "unknown")
            actor = self.metadata.get("actor_name", "Unknown user")
            return f"{actor} executed action: {action}"
        elif self.event_type == "status_change":
            old_status = self.metadata.get("old_status")
            new_status = self.metadata.get("new_status")
            return f"Motor status changed from {old_status} to {new_status}"
        elif self.event_type == "device_online":
            return "Device came online"
        elif self.event_type == "device_offline":
            return "Device went offline"
        elif self.event_type == "parameters_changed":
            changed_params = self.metadata.get("changed_parameters", [])
            return f"Parameters changed: {', '.join(changed_params)}"
        
        return f"Event: {self.event_type}"
    
    def __repr__(self) -> str:
        return f"<DeviceEvent(id={self.id}, device_id={self.device_id}, type='{self.event_type}')>"
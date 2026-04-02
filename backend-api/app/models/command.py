"""Command model for MQTT command history and tracking."""

import uuid
from datetime import datetime
from sqlalchemy import Column, Integer, String, DateTime, ForeignKey, JSON
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import relationship

from ..database import Base


class Command(Base):
    """Command model for MQTT command history and tracking."""
    
    __tablename__ = "commands"
    
    # Primary key (UUID)
    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4, index=True)
    
    # Foreign keys
    device_id = Column(Integer, ForeignKey("devices.id", ondelete="CASCADE"), nullable=False, index=True)
    user_id = Column(Integer, ForeignKey("users.id"), nullable=True, index=True)
    
    # Command details
    command_type = Column(String(50), nullable=False, index=True)  # OPEN, CLOSE, SET_PARAMS, etc.
    mqtt_ac = Column(String(20), nullable=True)  # AC code sent to firmware
    
    # Status tracking
    status = Column(String(50), default="pending", nullable=False, index=True)  # pending, completed, failed, timeout
    response = Column(JSON, nullable=True)  # MQTT response from device
    
    # Timestamps
    created_at = Column(DateTime, default=datetime.utcnow, nullable=False, index=True)
    completed_at = Column(DateTime, nullable=True)
    
    # Relationships
    device = relationship("Device", back_populates="commands")
    user = relationship("User", back_populates="commands")
    
    @property
    def is_pending(self) -> bool:
        """Check if command is still pending."""
        return self.status == "pending"
    
    @property
    def is_completed(self) -> bool:
        """Check if command completed successfully."""
        return self.status == "completed"
    
    @property
    def is_failed(self) -> bool:
        """Check if command failed."""
        return self.status in ["failed", "timeout"]
    
    def get_duration_ms(self) -> int:
        """Get command duration in milliseconds."""
        if not self.completed_at:
            return 0
        delta = self.completed_at - self.created_at
        return int(delta.total_seconds() * 1000)
    
    def __repr__(self) -> str:
        return f"<Command(id={self.id}, device_id={self.device_id}, type='{self.command_type}', status='{self.status}')>"
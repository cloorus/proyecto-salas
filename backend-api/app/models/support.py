"""Support request model for technical assistance."""

from datetime import datetime
from sqlalchemy import Column, Integer, String, DateTime, ForeignKey, Text, JSON
from sqlalchemy.orm import relationship

from ..database import Base


class SupportRequest(Base):
    """Support request model for technical assistance."""
    
    __tablename__ = "support_requests"
    
    # Primary key
    id = Column(Integer, primary_key=True, index=True)
    
    # Foreign keys
    user_id = Column(Integer, ForeignKey("users.id"), nullable=False, index=True)
    device_id = Column(Integer, ForeignKey("devices.id"), nullable=True, index=True)
    
    # Request details
    subject = Column(String(200), nullable=False)
    description = Column(Text, nullable=False)
    category = Column(String(50), nullable=False, index=True)  # technical, billing, general
    priority = Column(String(20), default="medium", nullable=False, index=True)  # low, medium, high, urgent
    status = Column(String(30), default="open", nullable=False, index=True)  # open, in_progress, resolved, closed
    
    # Additional data
    extra_data = Column("metadata", JSON, default={}, nullable=False)  # Device info, error logs, etc.
    
    # Timestamps
    created_at = Column(DateTime, default=datetime.utcnow, nullable=False, index=True)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow, nullable=False)
    resolved_at = Column(DateTime, nullable=True)
    
    # Relationships
    user = relationship("User")
    device = relationship("Device")
    
    @property
    def is_open(self) -> bool:
        """Check if support request is open."""
        return self.status in ["open", "in_progress"]
    
    @property
    def is_resolved(self) -> bool:
        """Check if support request is resolved."""
        return self.status in ["resolved", "closed"]
    
    def get_age_days(self) -> int:
        """Get age of support request in days."""
        delta = datetime.utcnow() - self.created_at
        return delta.days
    
    def get_priority_level(self) -> int:
        """Get numeric priority level for sorting."""
        priority_levels = {"low": 1, "medium": 2, "high": 3, "urgent": 4}
        return priority_levels.get(self.priority, 2)
    
    def __repr__(self) -> str:
        return f"<SupportRequest(id={self.id}, user_id={self.user_id}, status='{self.status}', priority='{self.priority}')>"
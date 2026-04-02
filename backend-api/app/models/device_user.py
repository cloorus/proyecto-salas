"""Device user access model for sharing and permissions."""

from datetime import datetime
from sqlalchemy import Column, Integer, String, DateTime, ForeignKey, UniqueConstraint
from sqlalchemy.orm import relationship

from ..database import Base


class DeviceUser(Base):
    """Device user access model for sharing and permissions."""
    
    __tablename__ = "device_users"
    
    # Primary key
    id = Column(Integer, primary_key=True, index=True)
    
    # Foreign keys
    device_id = Column(Integer, ForeignKey("devices.id", ondelete="CASCADE"), nullable=False, index=True)
    user_id = Column(Integer, ForeignKey("users.id", ondelete="CASCADE"), nullable=False, index=True)
    granted_by = Column(Integer, ForeignKey("users.id"), nullable=True, index=True)
    
    # Access control
    role = Column(String(50), nullable=False, index=True)  # owner, admin, operator, viewer, guest
    expires_at = Column(DateTime, nullable=True)  # NULL = permanent access
    
    # Timestamps
    created_at = Column(DateTime, default=datetime.utcnow, nullable=False)
    
    # Constraints
    __table_args__ = (
        UniqueConstraint('device_id', 'user_id', name='_device_user_uc'),
    )
    
    # Relationships
    device = relationship("Device", back_populates="device_users")
    user = relationship("User", back_populates="device_access", foreign_keys=[user_id])
    granter = relationship("User", foreign_keys=[granted_by])
    
    @property
    def is_expired(self) -> bool:
        """Check if access has expired."""
        if self.expires_at is None:
            return False
        return datetime.utcnow() > self.expires_at
    
    @property
    def is_owner(self) -> bool:
        """Check if user is the owner."""
        return self.role == "owner"
    
    @property
    def is_admin(self) -> bool:
        """Check if user is admin or owner."""
        return self.role in ["owner", "admin"]
    
    @property
    def can_control(self) -> bool:
        """Check if user can control the device."""
        return self.role in ["owner", "admin", "operator"]
    
    @property
    def can_view(self) -> bool:
        """Check if user can view the device."""
        return self.role in ["owner", "admin", "operator", "viewer", "guest"]
    
    def get_permissions(self) -> dict:
        """Get user permissions for this device."""
        permissions = {
            "owner": {
                "view": True, "control": True, "configure": True, 
                "share": True, "delete": True, "learn": True
            },
            "admin": {
                "view": True, "control": True, "configure": True, 
                "share": True, "delete": False, "learn": True
            },
            "operator": {
                "view": True, "control": True, "configure": False, 
                "share": False, "delete": False, "learn": False
            },
            "viewer": {
                "view": True, "control": False, "configure": False, 
                "share": False, "delete": False, "learn": False
            },
            "guest": {
                "view": True, "control": False, "configure": False, 
                "share": False, "delete": False, "learn": False
            }
        }
        return permissions.get(self.role, permissions["guest"])
    
    def __repr__(self) -> str:
        return f"<DeviceUser(device_id={self.device_id}, user_id={self.user_id}, role='{self.role}')>"
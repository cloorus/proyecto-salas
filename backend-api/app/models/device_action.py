"""Device action models for dynamic action templates and overrides."""

from datetime import datetime
from sqlalchemy import Column, Integer, String, Boolean, DateTime, ForeignKey, Text, UniqueConstraint
from sqlalchemy.orm import relationship

from ..database import Base


class DeviceActionTemplate(Base):
    """Template for device actions by device type."""
    
    __tablename__ = "device_action_templates"
    
    # Primary key
    id = Column(Integer, primary_key=True, index=True)
    
    # Template definition
    device_type = Column(String(50), nullable=False, index=True)  # gate, barrier, door, camera, etc.
    action_key = Column(String(50), nullable=False, index=True)   # OPEN, CLOSE, LAMP, etc.
    
    # MQTT protocol
    mqtt_ac = Column(String(20), nullable=True)  # AC code for firmware
    
    # Display settings
    default_label = Column(String(100), nullable=False)    # "Abrir", "Encender cámara"
    default_icon = Column(String(50), nullable=False)      # Material icon name
    show_in_list = Column(Boolean, default=False, nullable=False)      # Visible in device list card
    show_in_detail = Column(Boolean, default=True, nullable=False)     # Visible in device detail
    sort_order = Column(Integer, default=0, nullable=False)
    is_toggle = Column(Boolean, default=False, nullable=False)         # Has on/off state
    
    # Timestamps
    created_at = Column(DateTime, default=datetime.utcnow, nullable=False)
    
    # Constraints
    __table_args__ = (
        UniqueConstraint('device_type', 'action_key', name='_device_type_action_uc'),
    )
    
    def __repr__(self) -> str:
        return f"<DeviceActionTemplate(type='{self.device_type}', action='{self.action_key}', label='{self.default_label}')>"


class DeviceActionOverride(Base):
    """Device-specific action overrides for customization."""
    
    __tablename__ = "device_action_overrides"
    
    # Primary key
    id = Column(Integer, primary_key=True, index=True)
    
    # Foreign keys
    device_id = Column(Integer, ForeignKey("devices.id", ondelete="CASCADE"), nullable=False, index=True)
    action_key = Column(String(50), nullable=False, index=True)
    
    # Override settings (NULL = use template default)
    custom_label = Column(String(100), nullable=True)
    custom_icon = Column(String(50), nullable=True)
    show_in_list = Column(Boolean, nullable=True)
    show_in_detail = Column(Boolean, nullable=True)
    is_enabled = Column(Boolean, default=True, nullable=False)  # false = hide this action
    sort_order = Column(Integer, nullable=True)
    
    # Constraints
    __table_args__ = (
        UniqueConstraint('device_id', 'action_key', name='_device_action_override_uc'),
    )
    
    # Relationships
    device = relationship("Device", back_populates="action_overrides")
    
    def __repr__(self) -> str:
        return f"<DeviceActionOverride(device_id={self.device_id}, action='{self.action_key}', enabled={self.is_enabled})>"
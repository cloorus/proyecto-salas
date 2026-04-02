"""Technical support router for support requests and contact information."""

from datetime import datetime
from typing import Optional, Dict, Any, List
from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy import select, and_, desc
from sqlalchemy.ext.asyncio import AsyncSession
from pydantic import BaseModel, EmailStr

from ..database import get_db
from ..dependencies import CurrentUserDep
from ..models.support_request import SupportRequest
from ..models.device import Device
from ..schemas.common import MessageResponse, PaginatedResponse
from .devices import _get_user_device

router = APIRouter()

# Support contact information
SUPPORT_CONTACTS = {
    "technical": {
        "name": "Soporte Técnico VITA",
        "email": "soporte@vita.com.co",
        "phone": "+57 (1) 234-5678",
        "whatsapp": "+57 300 123 4567",
        "hours": "Lunes a Viernes 8:00 AM - 6:00 PM",
        "timezone": "America/Bogota"
    },
    "commercial": {
        "name": "Ventas VITA",
        "email": "ventas@vita.com.co", 
        "phone": "+57 (1) 234-5679",
        "whatsapp": "+57 300 123 4568",
        "hours": "Lunes a Viernes 8:00 AM - 6:00 PM",
        "timezone": "America/Bogota"
    },
    "emergency": {
        "name": "Emergencias 24/7",
        "phone": "+57 300 911 VITA",
        "whatsapp": "+57 300 911 8482",
        "hours": "24 horas, 7 días",
        "note": "Solo para emergencias críticas"
    }
}


class SupportRequestCreate(BaseModel):
    """Support request creation schema."""
    device_id: Optional[int] = None
    category: str  # technical, commercial, warranty, bug_report
    priority: str = "medium"  # low, medium, high, urgent
    subject: str
    description: str
    contact_method: str = "email"  # email, phone, whatsapp
    phone_number: Optional[str] = None
    
    class Config:
        schema_extra = {
            "example": {
                "device_id": 123,
                "category": "technical",
                "priority": "high",
                "subject": "Device not responding to remote",
                "description": "My VITA gate opener stopped responding to remote controls after the recent firmware update.",
                "contact_method": "whatsapp",
                "phone_number": "+57 300 123 4567"
            }
        }


class SupportRequestResponse(BaseModel):
    """Support request response schema."""
    id: str
    device_id: Optional[int]
    device_name: Optional[str]
    category: str
    priority: str
    subject: str
    description: str
    status: str
    contact_method: str
    phone_number: Optional[str]
    user_email: str
    user_name: str
    created_at: str
    updated_at: str
    resolved_at: Optional[str]
    
    class Config:
        from_attributes = True


@router.get("/devices/{device_id}/support")
async def get_device_support_info(
    device_id: int,
    current_user: CurrentUserDep,
    db: AsyncSession = Depends(get_db)
):
    """Get support information for specific device.
    
    Args:
        device_id: Device ID
        current_user: Current authenticated user
        db: Database session
        
    Returns:
        Device-specific support information
    """
    # Check device access
    device = await _get_user_device(device_id, current_user.id, db)
    
    # Get recent support requests for this device
    stmt = (
        select(SupportRequest)
        .where(and_(
            SupportRequest.device_id == device_id,
            SupportRequest.user_id == current_user.id
        ))
        .order_by(desc(SupportRequest.created_at))
        .limit(5)
    )
    result = await db.execute(stmt)
    recent_requests = result.scalars().all()
    
    # Format recent requests
    formatted_requests = []
    for request in recent_requests:
        formatted_requests.append({
            "id": str(request.id),
            "subject": request.subject,
            "status": request.status,
            "priority": request.priority,
            "created_at": request.created_at.isoformat() + "Z"
        })
    
    return {
        "device": {
            "id": device.id,
            "name": device.name,
            "serial_number": device.serial_number,
            "model": device.model,
            "firmware_version": device.firmware_version
        },
        "support_contacts": SUPPORT_CONTACTS,
        "recent_requests": formatted_requests,
        "quick_actions": {
            "create_request": f"/api/v1/support/request",
            "view_requests": f"/api/v1/support/requests",
            "device_manual": f"/docs/devices/{device.model}/manual.pdf",
            "troubleshooting": f"/docs/devices/{device.model}/troubleshooting.html"
        },
        "emergency_info": {
            "is_emergency_contact_available": True,
            "emergency_categories": ["device_malfunction", "safety_issue", "security_breach"],
            "emergency_phone": SUPPORT_CONTACTS["emergency"]["phone"]
        }
    }


@router.get("/support/contacts")
async def get_support_contacts():
    """Get general support contact information.
    
    Returns:
        Support contact information
    """
    return {
        "contacts": SUPPORT_CONTACTS,
        "business_hours": "Lunes a Viernes 8:00 AM - 6:00 PM (GMT-5)",
        "response_times": {
            "email": "24-48 horas hábiles",
            "phone": "Durante horario de atención",
            "whatsapp": "2-4 horas hábiles",
            "emergency": "Inmediato"
        },
        "languages": ["Español", "English"],
        "coverage": {
            "colombia": {
                "cities": ["Bogotá", "Medellín", "Cali", "Barranquilla", "Cartagena"],
                "nationwide": True
            }
        }
    }


@router.post("/support/request", response_model=SupportRequestResponse)
async def create_support_request(
    request: SupportRequestCreate,
    current_user: CurrentUserDep,
    db: AsyncSession = Depends(get_db)
):
    """Create a new support request.
    
    Args:
        request: Support request data
        current_user: Current authenticated user
        db: Database session
        
    Returns:
        SupportRequestResponse: Created support request
    """
    # Validate category
    valid_categories = ["technical", "commercial", "warranty", "bug_report", "feature_request"]
    if request.category not in valid_categories:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=f"Invalid category. Valid categories: {', '.join(valid_categories)}"
        )
    
    # Validate priority
    valid_priorities = ["low", "medium", "high", "urgent"]
    if request.priority not in valid_priorities:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=f"Invalid priority. Valid priorities: {', '.join(valid_priorities)}"
        )
    
    # Validate contact method
    valid_contact_methods = ["email", "phone", "whatsapp"]
    if request.contact_method not in valid_contact_methods:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=f"Invalid contact method. Valid methods: {', '.join(valid_contact_methods)}"
        )
    
    # If phone/whatsapp contact method, phone number is required
    if request.contact_method in ["phone", "whatsapp"] and not request.phone_number:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Phone number is required for phone/whatsapp contact methods"
        )
    
    # Validate device access if device_id provided
    device_name = None
    if request.device_id:
        device = await _get_user_device(request.device_id, current_user.id, db)
        device_name = device.name
    
    # Create support request
    support_request = SupportRequest(
        device_id=request.device_id,
        user_id=current_user.id,
        category=request.category,
        priority=request.priority,
        subject=request.subject,
        description=request.description,
        contact_method=request.contact_method,
        phone_number=request.phone_number,
        status="open"
    )
    
    db.add(support_request)
    await db.commit()
    await db.refresh(support_request)
    
    return SupportRequestResponse(
        id=str(support_request.id),
        device_id=support_request.device_id,
        device_name=device_name,
        category=support_request.category,
        priority=support_request.priority,
        subject=support_request.subject,
        description=support_request.description,
        status=support_request.status,
        contact_method=support_request.contact_method,
        phone_number=support_request.phone_number,
        user_email=current_user.email,
        user_name=current_user.full_name,
        created_at=support_request.created_at.isoformat() + "Z",
        updated_at=support_request.updated_at.isoformat() + "Z",
        resolved_at=support_request.resolved_at.isoformat() + "Z" if support_request.resolved_at else None
    )


@router.get("/support/requests", response_model=PaginatedResponse[SupportRequestResponse])
async def list_support_requests(
    current_user: CurrentUserDep,
    db: AsyncSession = Depends(get_db),
    limit: int = 20,
    status_filter: Optional[str] = None,
    category_filter: Optional[str] = None
):
    """List user's support requests.
    
    Args:
        current_user: Current authenticated user
        db: Database session
        limit: Maximum number of requests to return
        status_filter: Filter by status (open, in_progress, resolved, closed)
        category_filter: Filter by category
        
    Returns:
        PaginatedResponse[SupportRequestResponse]: Paginated list of support requests
    """
    # Build query
    stmt = (
        select(SupportRequest)
        .where(SupportRequest.user_id == current_user.id)
    )
    
    # Add filters
    if status_filter:
        stmt = stmt.where(SupportRequest.status == status_filter)
    
    if category_filter:
        stmt = stmt.where(SupportRequest.category == category_filter)
    
    stmt = stmt.order_by(desc(SupportRequest.created_at)).limit(limit + 1)
    
    result = await db.execute(stmt)
    requests = result.scalars().all()
    
    # Check if there are more results
    has_more = len(requests) > limit
    if has_more:
        requests = requests[:limit]
    
    # Format requests
    formatted_requests = []
    for request in requests:
        # Get device name if exists
        device_name = None
        if request.device_id:
            device_stmt = select(Device).where(Device.id == request.device_id)
            device_result = await db.execute(device_stmt)
            device = device_result.scalar_one_or_none()
            if device:
                device_name = device.name
        
        formatted_requests.append(SupportRequestResponse(
            id=str(request.id),
            device_id=request.device_id,
            device_name=device_name,
            category=request.category,
            priority=request.priority,
            subject=request.subject,
            description=request.description,
            status=request.status,
            contact_method=request.contact_method,
            phone_number=request.phone_number,
            user_email=current_user.email,
            user_name=current_user.full_name,
            created_at=request.created_at.isoformat() + "Z",
            updated_at=request.updated_at.isoformat() + "Z",
            resolved_at=request.resolved_at.isoformat() + "Z" if request.resolved_at else None
        ))
    
    return PaginatedResponse(
        data=formatted_requests,
        pagination={
            "cursor": str(requests[-1].id) if requests and has_more else None,
            "has_more": has_more,
            "total": len(formatted_requests)
        }
    )


@router.get("/support/requests/{request_id}", response_model=SupportRequestResponse)
async def get_support_request(
    request_id: str,
    current_user: CurrentUserDep,
    db: AsyncSession = Depends(get_db)
):
    """Get specific support request.
    
    Args:
        request_id: Support request ID
        current_user: Current authenticated user
        db: Database session
        
    Returns:
        SupportRequestResponse: Support request details
    """
    # Get support request
    stmt = (
        select(SupportRequest)
        .where(and_(
            SupportRequest.id == request_id,
            SupportRequest.user_id == current_user.id
        ))
    )
    result = await db.execute(stmt)
    request = result.scalar_one_or_none()
    
    if not request:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Support request not found"
        )
    
    # Get device name if exists
    device_name = None
    if request.device_id:
        device_stmt = select(Device).where(Device.id == request.device_id)
        device_result = await db.execute(device_stmt)
        device = device_result.scalar_one_or_none()
        if device:
            device_name = device.name
    
    return SupportRequestResponse(
        id=str(request.id),
        device_id=request.device_id,
        device_name=device_name,
        category=request.category,
        priority=request.priority,
        subject=request.subject,
        description=request.description,
        status=request.status,
        contact_method=request.contact_method,
        phone_number=request.phone_number,
        user_email=current_user.email,
        user_name=current_user.full_name,
        created_at=request.created_at.isoformat() + "Z",
        updated_at=request.updated_at.isoformat() + "Z",
        resolved_at=request.resolved_at.isoformat() + "Z" if request.resolved_at else None
    )
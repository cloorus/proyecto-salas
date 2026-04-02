"""Authentication router for login, register, and token management."""

from datetime import datetime, timedelta
from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from ..database import get_db
from ..models.user import User
from ..schemas.auth import (
    LoginRequest, RegisterRequest, TokenResponse, RefreshTokenRequest,
    ForgotPasswordRequest, ResetPasswordRequest, ChangePasswordRequest, UserResponse
)
from ..schemas.common import MessageResponse
from ..utils.security import (
    hash_password, verify_password, create_access_token, create_refresh_token, decode_jwt_token
)
from ..dependencies import CurrentUserDep
from ..config import settings

router = APIRouter(prefix="/auth")


@router.post("/login", response_model=TokenResponse)
async def login(request: LoginRequest, db: AsyncSession = Depends(get_db)):
    """Authenticate user and return JWT tokens.
    
    Args:
        request: Login credentials
        db: Database session
        
    Returns:
        TokenResponse: JWT access and refresh tokens
    """
    # Get user by email
    stmt = select(User).where(User.email == request.email, User.is_active == True)
    result = await db.execute(stmt)
    user = result.scalar_one_or_none()
    
    # Validate credentials
    if not user or not verify_password(request.password, user.password_hash):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Incorrect email or password"
        )
    
    # Create tokens
    token_data = {"sub": str(user.id), "email": user.email}
    access_token = create_access_token(token_data)
    refresh_token = create_refresh_token(token_data)
    
    return TokenResponse(
        access_token=access_token,
        refresh_token=refresh_token,
        expires_in=settings.ACCESS_TOKEN_EXPIRE_MINUTES * 60
    )


@router.post("/register", response_model=TokenResponse)
async def register(request: RegisterRequest, db: AsyncSession = Depends(get_db)):
    """Register a new user account.
    
    Args:
        request: Registration data
        db: Database session
        
    Returns:
        TokenResponse: JWT tokens for new user
    """
    # Check if user already exists
    stmt = select(User).where(User.email == request.email)
    result = await db.execute(stmt)
    existing_user = result.scalar_one_or_none()
    
    if existing_user:
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail="Email already registered"
        )
    
    # Create new user
    user = User(
        email=request.email,
        password_hash=hash_password(request.password),
        full_name=request.full_name,
        phone=request.phone,
        country=request.country
    )
    
    db.add(user)
    await db.commit()
    await db.refresh(user)
    
    # Create tokens
    token_data = {"sub": str(user.id), "email": user.email}
    access_token = create_access_token(token_data)
    refresh_token = create_refresh_token(token_data)
    
    return TokenResponse(
        access_token=access_token,
        refresh_token=refresh_token,
        expires_in=settings.ACCESS_TOKEN_EXPIRE_MINUTES * 60
    )


@router.post("/refresh", response_model=TokenResponse)
async def refresh_token(request: RefreshTokenRequest, db: AsyncSession = Depends(get_db)):
    """Refresh access token using refresh token.
    
    Args:
        request: Refresh token request
        db: Database session
        
    Returns:
        TokenResponse: New JWT tokens
    """
    try:
        # Decode refresh token
        payload = decode_jwt_token(request.refresh_token)
        
        if payload.get("type") != "refresh":
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Invalid token type"
            )
        
        user_id = payload.get("sub")
        if not user_id:
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Invalid token payload"
            )
        
        # Get user
        stmt = select(User).where(User.id == int(user_id), User.is_active == True)
        result = await db.execute(stmt)
        user = result.scalar_one_or_none()
        
        if not user:
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="User not found"
            )
        
        # Create new tokens
        token_data = {"sub": str(user.id), "email": user.email}
        access_token = create_access_token(token_data)
        refresh_token = create_refresh_token(token_data)
        
        return TokenResponse(
            access_token=access_token,
            refresh_token=refresh_token,
            expires_in=settings.ACCESS_TOKEN_EXPIRE_MINUTES * 60
        )
        
    except Exception:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid refresh token"
        )


@router.get("/me", response_model=UserResponse)
async def get_current_user_profile(current_user: CurrentUserDep):
    """Get current user profile information.
    
    Args:
        current_user: Current authenticated user
        
    Returns:
        UserResponse: User profile data
    """
    return UserResponse(
        id=current_user.id,
        email=current_user.email,
        full_name=current_user.full_name,
        phone=current_user.phone,
        country=current_user.country,
        is_active=current_user.is_active,
        created_at=current_user.created_at.isoformat() + "Z"
    )


@router.post("/forgot-password", response_model=MessageResponse)
async def forgot_password(request: ForgotPasswordRequest, db: AsyncSession = Depends(get_db)):
    """Send password reset code to user email.
    
    Args:
        request: Forgot password request
        db: Database session
        
    Returns:
        MessageResponse: Success message
    """
    # TODO: Implement email sending logic
    # For now, return success message
    return MessageResponse(
        message="If an account with this email exists, a reset code has been sent",
        success=True
    )


@router.post("/reset-password", response_model=MessageResponse)  
async def reset_password(request: ResetPasswordRequest, db: AsyncSession = Depends(get_db)):
    """Reset password using reset code.
    
    Args:
        request: Reset password request  
        db: Database session
        
    Returns:
        MessageResponse: Success message
    """
    # TODO: Implement reset code validation and password update
    # For now, return success message
    return MessageResponse(
        message="Password has been reset successfully",
        success=True
    )


@router.post("/change-password", response_model=MessageResponse)
async def change_password(
    request: ChangePasswordRequest, 
    current_user: CurrentUserDep,
    db: AsyncSession = Depends(get_db)
):
    """Change user password.
    
    Args:
        request: Change password request
        current_user: Current authenticated user
        db: Database session
        
    Returns:
        MessageResponse: Success message
    """
    # Verify current password
    if not verify_password(request.current_password, current_user.password_hash):
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Current password is incorrect"
        )
    
    # Update password
    current_user.password_hash = hash_password(request.new_password)
    current_user.updated_at = datetime.utcnow()
    
    await db.commit()
    
    return MessageResponse(
        message="Password changed successfully",
        success=True
    )
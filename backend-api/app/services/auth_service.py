"""Authentication service for JWT and password management."""

from typing import Optional
from datetime import datetime, timedelta

from ..config import settings
from ..utils.security import hash_password, verify_password, create_access_token, create_refresh_token


class AuthService:
    """Service for authentication operations."""
    
    @staticmethod
    def hash_password(password: str) -> str:
        """Hash a password.
        
        Args:
            password: Plain text password
            
        Returns:
            str: Hashed password
        """
        return hash_password(password)
    
    @staticmethod
    def verify_password(plain_password: str, hashed_password: str) -> bool:
        """Verify a password against its hash.
        
        Args:
            plain_password: Plain text password
            hashed_password: Hashed password
            
        Returns:
            bool: True if password is valid
        """
        return verify_password(plain_password, hashed_password)
    
    @staticmethod
    def create_tokens_for_user(user_id: int, email: str) -> dict:
        """Create access and refresh tokens for user.
        
        Args:
            user_id: User ID
            email: User email
            
        Returns:
            dict: Token data with access_token, refresh_token, and expires_in
        """
        token_data = {"sub": str(user_id), "email": email}
        access_token = create_access_token(token_data)
        refresh_token = create_refresh_token(token_data)
        
        return {
            "access_token": access_token,
            "refresh_token": refresh_token,
            "token_type": "bearer",
            "expires_in": settings.ACCESS_TOKEN_EXPIRE_MINUTES * 60
        }
    
    @staticmethod
    async def invalidate_refresh_token(refresh_token: str) -> None:
        """Invalidate a refresh token (logout).
        
        Args:
            refresh_token: Refresh token to invalidate
        """
        # TODO: Implement token blacklisting in Redis
        pass
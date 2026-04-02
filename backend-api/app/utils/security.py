"""Security utilities for password hashing and JWT tokens."""

from datetime import datetime, timedelta, timezone
from typing import Dict, Any, Optional
from passlib.context import CryptContext
from jose import JWTError, jwt

from ..config import settings

# Password hashing context
pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")


def hash_password(password: str) -> str:
    """Hash a password using bcrypt (truncated to 72 bytes for bcrypt limit).
    
    Args:
        password: Plain text password
        
    Returns:
        str: Hashed password
    """
    return pwd_context.hash(password[:72])


def verify_password(plain_password: str, hashed_password: str) -> bool:
    """Verify a password against its hash.
    
    Args:
        plain_password: Plain text password
        hashed_password: Hashed password from database
        
    Returns:
        bool: True if password is correct, False otherwise
    """
    return pwd_context.verify(plain_password[:72], hashed_password)


def create_access_token(data: Dict[str, Any]) -> str:
    """Create a JWT access token.
    
    Args:
        data: Data to encode in the token
        
    Returns:
        str: JWT access token
    """
    to_encode = data.copy()
    expire = datetime.now(timezone.utc) + timedelta(minutes=settings.ACCESS_TOKEN_EXPIRE_MINUTES)
    to_encode.update({"exp": expire, "type": "access"})
    
    return jwt.encode(to_encode, settings.JWT_SECRET, algorithm=settings.JWT_ALGORITHM)


def create_refresh_token(data: Dict[str, Any]) -> str:
    """Create a JWT refresh token.
    
    Args:
        data: Data to encode in the token
        
    Returns:
        str: JWT refresh token
    """
    to_encode = data.copy()
    expire = datetime.now(timezone.utc) + timedelta(days=settings.REFRESH_TOKEN_EXPIRE_DAYS)
    to_encode.update({"exp": expire, "type": "refresh"})
    
    return jwt.encode(to_encode, settings.JWT_SECRET, algorithm=settings.JWT_ALGORITHM)


def decode_jwt_token(token: str) -> Dict[str, Any]:
    """Decode and validate a JWT token.
    
    Args:
        token: JWT token to decode
        
    Returns:
        Dict[str, Any]: Decoded token payload
        
    Raises:
        JWTError: If token is invalid or expired
    """
    try:
        payload = jwt.decode(token, settings.JWT_SECRET, algorithms=[settings.JWT_ALGORITHM])
        return payload
    except JWTError:
        raise ValueError("Invalid or expired token")


def generate_installer_id(user_id: int) -> str:
    """Generate installer ID for MQTT commands.
    
    Args:
        user_id: User ID
        
    Returns:
        str: Installer ID for MQTT commands
    """
    data = {"sub": str(user_id), "type": "installer"}
    return create_access_token(data)
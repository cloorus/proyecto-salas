"""Application configuration using Pydantic Settings."""

from typing import List
from pydantic import Field
from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    """Application settings loaded from environment variables."""
    
    model_config = SettingsConfigDict(env_file=".env", extra="ignore")
    
    # Database Configuration
    DATABASE_URL: str = Field(
        default="postgresql+asyncpg://vita:password@localhost:5433/vita_db",
        description="PostgreSQL database URL"
    )
    
    # Redis Configuration
    REDIS_URL: str = Field(
        default="redis://localhost:6380",
        description="Redis connection URL"
    )
    
    # MQTT Configuration
    MQTT_BROKER: str = Field(
        default="104.131.36.215",
        description="EMQX MQTT broker hostname"
    )
    MQTT_PORT: int = Field(
        default=1883,
        description="MQTT broker port"
    )
    MQTT_USER: str = Field(
        default="vita_backend",
        description="MQTT username"
    )
    MQTT_PASS: str = Field(
        default="mqtt_password",
        description="MQTT password"
    )
    
    # JWT Configuration
    JWT_SECRET: str = Field(
        default="your-secret-key-should-be-at-least-32-characters-long",
        description="JWT secret key for token signing"
    )
    JWT_ALGORITHM: str = Field(
        default="RS256",
        description="JWT signing algorithm"
    )
    ACCESS_TOKEN_EXPIRE_MINUTES: int = Field(
        default=15,
        description="Access token expiration time in minutes"
    )
    REFRESH_TOKEN_EXPIRE_DAYS: int = Field(
        default=30,
        description="Refresh token expiration time in days"
    )
    
    # FCM Configuration (Optional)
    FCM_CREDENTIALS_PATH: str = Field(
        default="",
        description="Path to Firebase credentials JSON file"
    )
    
    # CORS Configuration
    CORS_ORIGINS: List[str] = Field(
        default=["http://localhost:3000"],
        description="Allowed CORS origins"
    )
    
    # Application Configuration
    DEBUG: bool = Field(
        default=False,
        description="Enable debug mode"
    )
    API_VERSION: str = Field(
        default="v1",
        description="API version"
    )
    API_PREFIX: str = Field(
        default="/api/v1",
        description="API URL prefix"
    )
    
    # Rate Limiting
    RATE_LIMIT_AUTH: str = Field(
        default="5/minute",
        description="Rate limit for auth endpoints"
    )
    RATE_LIMIT_API: str = Field(
        default="100/minute",
        description="Rate limit for general API endpoints"
    )
    RATE_LIMIT_COMMANDS: str = Field(
        default="10/minute",
        description="Rate limit for device commands"
    )


# Global settings instance
settings = Settings()
"""Health check router for monitoring and status."""

import time
from datetime import datetime
from fastapi import APIRouter
from sqlalchemy import text

from ..database import async_session
from ..redis import get_redis
from ..mqtt import vita_mqtt
from ..schemas.common import HealthResponse, StatusResponse

router = APIRouter()

# Track startup time
startup_time = time.time()


@router.get("/health", response_model=HealthResponse)
async def health_check():
    """Health check endpoint for monitoring services.
    
    Returns:
        HealthResponse: Service health status
    """
    services = {}
    
    # Check database
    try:
        async with async_session() as session:
            await session.execute(text("SELECT 1"))
        services["database"] = "connected"
    except Exception:
        services["database"] = "disconnected"
    
    # Check Redis
    try:
        redis_client = await get_redis()
        await redis_client.ping()
        services["redis"] = "connected"
    except Exception:
        services["redis"] = "disconnected"
    
    # Check MQTT
    try:
        if vita_mqtt and vita_mqtt.is_connected:
            services["mqtt"] = "connected"
        else:
            services["mqtt"] = "disconnected"
    except Exception:
        services["mqtt"] = "disconnected"
    
    # Overall status
    all_connected = all(status == "connected" for status in services.values())
    overall_status = "healthy" if all_connected else "degraded"
    
    return HealthResponse(
        status=overall_status,
        version="2.0.0",
        timestamp=datetime.utcnow().isoformat() + "Z",
        services=services
    )


@router.get("/api/v1/status", response_model=StatusResponse)
async def api_status():
    """API status endpoint with detailed information.
    
    Returns:
        StatusResponse: API status information
    """
    uptime_seconds = int(time.time() - startup_time)
    
    return StatusResponse(
        api_version="2.0.0",
        environment="development" if __debug__ else "production",
        uptime_seconds=uptime_seconds,
        active_connections=0  # TODO: Track active connections
    )
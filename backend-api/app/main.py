"""Main FastAPI application with middleware, startup/shutdown events."""

import asyncio
from datetime import datetime
from contextlib import asynccontextmanager
from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse

from .config import settings
from .database import init_db, close_db
from .redis import init_redis, close_redis  
from .mqtt import init_mqtt, close_mqtt, vita_mqtt
from .middleware.error_handler import ErrorHandlerMiddleware
from .middleware.rate_limit import RateLimitMiddleware

# Import routers
from .routers import (
    auth, health, users, devices, commands, device_params,
    device_users, device_actions, groups, events, notifications
)


@asynccontextmanager
async def lifespan(app: FastAPI):
    """Application lifespan manager for startup/shutdown events."""
    
    # Startup
    print("🚀 Starting VITA Backend API v2.0...")
    
    try:
        # Initialize database
        print("📊 Connecting to database...")
        if settings.DEBUG:
            await init_db()  # Only in development
        
        # Initialize Redis
        print("🔄 Connecting to Redis...")
        await init_redis()
        
        # Initialize MQTT
        print("📡 Connecting to MQTT broker...")
        await init_mqtt()
        
        # Start MQTT listener
        print("👂 Starting MQTT listener...")
        if vita_mqtt:
            asyncio.create_task(vita_mqtt.listen_for_responses())
        
        print("✅ All services connected successfully!")
        
    except Exception as e:
        print(f"❌ Failed to start services: {e}")
        raise
    
    yield
    
    # Shutdown
    print("🛑 Shutting down VITA Backend API...")
    
    try:
        await close_mqtt()
        await close_redis()
        await close_db()
        print("✅ All services disconnected successfully!")
    except Exception as e:
        print(f"⚠️ Error during shutdown: {e}")


# Create FastAPI app
app = FastAPI(
    title="VITA Backend API",
    description="FastAPI backend for VITA device management and control",
    version="2.0.0",
    lifespan=lifespan,
    docs_url="/docs" if settings.DEBUG else None,
    redoc_url="/redoc" if settings.DEBUG else None,
)

# CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.CORS_ORIGINS,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Custom middleware
app.add_middleware(ErrorHandlerMiddleware)
app.add_middleware(RateLimitMiddleware)

# Include routers
app.include_router(health.router, tags=["Health"])
app.include_router(auth.router, prefix=settings.API_PREFIX, tags=["Authentication"])
app.include_router(users.router, prefix=settings.API_PREFIX, tags=["Users"])
app.include_router(devices.router, prefix=settings.API_PREFIX, tags=["Devices"])
app.include_router(commands.router, prefix=settings.API_PREFIX, tags=["Commands"])
app.include_router(device_params.router, prefix=settings.API_PREFIX, tags=["Device Parameters"])
app.include_router(device_users.router, prefix=settings.API_PREFIX, tags=["Device Sharing"])
app.include_router(device_actions.router, prefix=settings.API_PREFIX, tags=["Device Actions"])
app.include_router(groups.router, prefix=settings.API_PREFIX, tags=["Groups"])
app.include_router(events.router, prefix=settings.API_PREFIX, tags=["Events"])
app.include_router(notifications.router, prefix=settings.API_PREFIX, tags=["Notifications"])


@app.exception_handler(HTTPException)
async def http_exception_handler(request, exc: HTTPException):
    """Custom HTTP exception handler."""
    return JSONResponse(
        status_code=exc.status_code,
        content={
            "error": {
                "code": f"HTTP_{exc.status_code}",
                "message": exc.detail,
                "details": {}
            }
        }
    )


@app.exception_handler(Exception)
async def general_exception_handler(request, exc: Exception):
    """General exception handler for unhandled errors."""
    return JSONResponse(
        status_code=500,
        content={
            "error": {
                "code": "INTERNAL_SERVER_ERROR",
                "message": "An internal error occurred",
                "details": {"type": type(exc).__name__} if settings.DEBUG else {}
            }
        }
    )


# Root endpoint
@app.get("/")
async def root():
    """Root endpoint."""
    return {
        "message": "VITA Backend API v2.0",
        "version": "2.0.0",
        "status": "healthy",
        "timestamp": datetime.utcnow().isoformat() + "Z",
        "docs_url": "/docs" if settings.DEBUG else None
    }
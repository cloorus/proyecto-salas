"""Rate limiting middleware."""

import time
from typing import Dict
from fastapi import Request, HTTPException
from starlette.middleware.base import BaseHTTPMiddleware
from starlette.responses import Response

from ..redis import cache_get, cache_set


class RateLimitMiddleware(BaseHTTPMiddleware):
    """Middleware to implement rate limiting."""
    
    def __init__(self, app):
        super().__init__(app)
        self.rate_limits = {
            "/api/v1/auth/": {"limit": 5, "window": 60},  # 5 per minute
            "/api/v1/devices/": {"limit": 100, "window": 60},  # 100 per minute
            "/api/v1/commands/": {"limit": 10, "window": 60},  # 10 per minute
        }
    
    async def dispatch(self, request: Request, call_next) -> Response:
        """Process request and apply rate limiting."""
        
        # Skip rate limiting for health checks
        if request.url.path in ["/", "/health"]:
            return await call_next(request)
        
        # Determine rate limit for this path
        rate_limit = self._get_rate_limit(request.url.path)
        if not rate_limit:
            return await call_next(request)
        
        # Get client identifier (IP or user ID if authenticated)
        client_id = self._get_client_id(request)
        
        # Check rate limit
        if await self._is_rate_limited(client_id, request.url.path, rate_limit):
            return Response(
                status_code=429,
                content='{"error":{"code":"RATE_LIMIT_EXCEEDED","message":"Too many requests"}}',
                media_type="application/json",
                headers={
                    "X-RateLimit-Limit": str(rate_limit["limit"]),
                    "X-RateLimit-Window": str(rate_limit["window"]),
                    "Retry-After": str(rate_limit["window"])
                }
            )
        
        # Process request
        response = await call_next(request)
        
        # Add rate limit headers
        response.headers["X-RateLimit-Limit"] = str(rate_limit["limit"])
        response.headers["X-RateLimit-Window"] = str(rate_limit["window"])
        
        return response
    
    def _get_rate_limit(self, path: str) -> Dict:
        """Get rate limit configuration for path."""
        for pattern, config in self.rate_limits.items():
            if path.startswith(pattern):
                return config
        return None
    
    def _get_client_id(self, request: Request) -> str:
        """Get client identifier for rate limiting."""
        # Try to get user ID from token (simplified)
        auth_header = request.headers.get("Authorization")
        if auth_header:
            # In a real implementation, we'd decode the JWT token
            # For now, use the token hash as identifier
            return f"user_{hash(auth_header) % 10000}"
        
        # Fall back to IP address
        client_ip = request.client.host
        forwarded_for = request.headers.get("X-Forwarded-For")
        if forwarded_for:
            client_ip = forwarded_for.split(",")[0].strip()
        
        return f"ip_{client_ip}"
    
    async def _is_rate_limited(self, client_id: str, path: str, rate_limit: Dict) -> bool:
        """Check if client is rate limited."""
        cache_key = f"rate_limit:{client_id}:{path}"
        current_time = int(time.time())
        window_start = current_time - rate_limit["window"]
        
        try:
            # Get current request count
            requests = await cache_get(cache_key) or []
            
            # Filter out old requests
            recent_requests = [req_time for req_time in requests if req_time > window_start]
            
            # Check if limit exceeded
            if len(recent_requests) >= rate_limit["limit"]:
                return True
            
            # Add current request
            recent_requests.append(current_time)
            await cache_set(cache_key, recent_requests, expire=rate_limit["window"])
            
            return False
            
        except Exception:
            # If Redis is unavailable, allow the request
            return False
"""Global error handler middleware."""

import traceback
from fastapi import Request, HTTPException
from fastapi.responses import JSONResponse
from starlette.middleware.base import BaseHTTPMiddleware
from starlette.responses import Response

from ..config import settings


class ErrorHandlerMiddleware(BaseHTTPMiddleware):
    """Middleware to handle errors globally and return standard error format."""
    
    async def dispatch(self, request: Request, call_next) -> Response:
        """Process request and handle any errors."""
        try:
            response = await call_next(request)
            return response
            
        except HTTPException:
            # Re-raise HTTP exceptions to be handled by FastAPI
            raise
            
        except Exception as exc:
            # Log the error
            if settings.DEBUG:
                print(f"Unhandled error: {exc}")
                print(traceback.format_exc())
            
            # Return standard error format
            return JSONResponse(
                status_code=500,
                content={
                    "error": {
                        "code": "INTERNAL_SERVER_ERROR",
                        "message": "An internal error occurred",
                        "details": {
                            "type": type(exc).__name__,
                            "message": str(exc)
                        } if settings.DEBUG else {}
                    }
                }
            )
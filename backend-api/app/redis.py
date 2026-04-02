"""Redis connection and caching utilities."""

from typing import Optional, Any
import json
import redis.asyncio as redis
from redis.asyncio import Redis

from .config import settings

# Global Redis connection
redis_client: Optional[Redis] = None


async def init_redis() -> None:
    """Initialize Redis connection."""
    global redis_client
    redis_client = redis.from_url(
        settings.REDIS_URL,
        encoding="utf-8",
        decode_responses=True,
        socket_keepalive=True,
        socket_keepalive_options={},
        health_check_interval=30,
    )


async def close_redis() -> None:
    """Close Redis connection."""
    global redis_client
    if redis_client:
        await redis_client.close()
        redis_client = None


async def get_redis() -> Redis:
    """Get Redis client instance.
    
    Returns:
        Redis: Redis client instance
        
    Raises:
        RuntimeError: If Redis is not initialized
    """
    global redis_client
    if not redis_client:
        raise RuntimeError("Redis not initialized. Call init_redis() first.")
    return redis_client


# Cache utilities
async def cache_set(key: str, value: Any, expire: Optional[int] = None) -> None:
    """Set value in Redis cache.
    
    Args:
        key: Cache key
        value: Value to cache (will be JSON serialized)
        expire: Expiration time in seconds
    """
    client = await get_redis()
    serialized_value = json.dumps(value) if not isinstance(value, str) else value
    if expire:
        await client.setex(key, expire, serialized_value)
    else:
        await client.set(key, serialized_value)


async def cache_get(key: str) -> Optional[Any]:
    """Get value from Redis cache.
    
    Args:
        key: Cache key
        
    Returns:
        Cached value or None if not found
    """
    client = await get_redis()
    value = await client.get(key)
    if value is None:
        return None
    
    try:
        return json.loads(value)
    except (json.JSONDecodeError, TypeError):
        return value


async def cache_delete(key: str) -> None:
    """Delete key from Redis cache.
    
    Args:
        key: Cache key to delete
    """
    client = await get_redis()
    await client.delete(key)


async def cache_exists(key: str) -> bool:
    """Check if key exists in Redis cache.
    
    Args:
        key: Cache key to check
        
    Returns:
        True if key exists, False otherwise
    """
    client = await get_redis()
    return await client.exists(key) > 0
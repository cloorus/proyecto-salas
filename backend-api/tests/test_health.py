"""Health check tests."""

import pytest
from fastapi.testclient import TestClient


def test_health_endpoint(client: TestClient):
    """Test health check endpoint."""
    response = client.get("/health")
    assert response.status_code == 200
    
    data = response.json()
    assert "status" in data
    assert "version" in data
    assert "timestamp" in data
    assert "services" in data
    
    # Check service status
    services = data["services"]
    assert "database" in services
    # Note: redis and mqtt will be "disconnected" in tests


def test_api_status_endpoint(client: TestClient):
    """Test API status endpoint."""
    response = client.get("/api/v1/status")
    assert response.status_code == 200
    
    data = response.json()
    assert "api_version" in data
    assert "environment" in data
    assert "uptime_seconds" in data
    assert "active_connections" in data
    
    assert data["api_version"] == "2.0.0"


def test_root_endpoint(client: TestClient):
    """Test root endpoint."""
    response = client.get("/")
    assert response.status_code == 200
    
    data = response.json()
    assert "message" in data
    assert "version" in data
    assert "status" in data
    assert "timestamp" in data
    
    assert data["version"] == "2.0.0"
    assert data["status"] == "healthy"
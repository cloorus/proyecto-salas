# VITA Backend API v2.0

FastAPI-based backend for VITA device management and control system. This API provides REST endpoints for mobile app integration and MQTT communication with VITA ESP32 devices.

## 🏗️ Architecture

```
┌─────────────┐     ┌─────────────────────┐     ┌──────────────┐
│  Flutter App│────▶│   FastAPI Backend   │◀───▶│  PostgreSQL  │
│  (Mobile)   │     │   (this project)    │     │  Database    │
└─────────────┘     └──────────┬──────────┘     └──────────────┘
                               │
                    ┌──────────▼──────────┐
                    │   MQTT Bridge       │     ┌──────────────┐
                    │   (aiomqtt)         │────▶│  EMQX Broker │
                    └─────────────────────┘     └──────────────┘
                                                       │
                                                ┌──────▼──────┐
                                                │  VITA ESP32  │
                                                │  Devices     │
                                                └─────────────┘
```

### Technology Stack

- **FastAPI** - Modern, fast web framework for Python APIs
- **PostgreSQL 15** - Primary database with async support
- **Redis 7** - Caching and session storage
- **EMQX** - MQTT broker for device communication
- **SQLAlchemy 2.0** - Async ORM with Alembic migrations
- **Pydantic** - Data validation and serialization
- **JWT** - Token-based authentication

## 🚀 Quick Start

### Using Docker (Recommended)

1. **Clone and setup environment:**
   ```bash
   git clone <repository>
   cd vita-api
   cp .env.example .env
   # Edit .env with your configuration
   ```

2. **Start services:**
   ```bash
   # Production
   docker-compose up -d
   
   # Development (with hot reload)
   docker-compose -f docker-compose.yml -f docker-compose.dev.yml up -d
   ```

3. **Run database migrations:**
   ```bash
   docker-compose exec api alembic upgrade head
   ```

4. **API is available at:**
   - **API:** http://localhost:8000
   - **Health:** http://localhost:8000/health
   - **Docs:** http://localhost:8000/docs (development only)

### Manual Installation

```bash
# Create virtual environment
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt

# Setup database (PostgreSQL required)
export DATABASE_URL="postgresql+asyncpg://user:pass@localhost:5432/vita_db"
alembic upgrade head

# Start server
uvicorn app.main:app --host 0.0.0.0 --port 8000 --reload
```

## 🔧 Configuration

### Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `DATABASE_URL` | PostgreSQL connection URL | `postgresql+asyncpg://vita:password@localhost:5433/vita_db` |
| `REDIS_URL` | Redis connection URL | `redis://localhost:6380` |
| `MQTT_BROKER` | EMQX broker hostname | `104.131.36.215` |
| `MQTT_PORT` | MQTT broker port | `1883` |
| `MQTT_USER` | MQTT username | `vita_backend` |
| `MQTT_PASS` | MQTT password | - |
| `JWT_SECRET` | JWT signing secret | - |
| `JWT_ALGORITHM` | JWT algorithm | `RS256` |
| `ACCESS_TOKEN_EXPIRE_MINUTES` | Token expiry time | `15` |
| `FCM_CREDENTIALS_PATH` | Firebase credentials file | - |
| `DEBUG` | Enable debug mode | `false` |

### MQTT Topics

- **Commands:** `vita/{serial}/command`
- **Responses:** `vita/{serial}/response`  
- **Heartbeat:** `vita/{serial}/heartbeat`

## 📡 API Endpoints

### Authentication
- `POST /api/v1/auth/login` - User login
- `POST /api/v1/auth/register` - User registration  
- `POST /api/v1/auth/refresh` - Refresh access token
- `GET /api/v1/auth/me` - Get current user profile
- `POST /api/v1/auth/change-password` - Change password

### Device Management
- `GET /api/v1/devices` - List user devices
- `POST /api/v1/devices` - Register new device
- `GET /api/v1/devices/{id}` - Get device details
- `PUT /api/v1/devices/{id}` - Update device
- `DELETE /api/v1/devices/{id}` - Delete device
- `GET /api/v1/devices/{id}/full` - Complete device info

### Device Control
- `POST /api/v1/devices/{id}/command` - Send device command
- `GET /api/v1/devices/{id}/params` - Get device parameters
- `PUT /api/v1/devices/{id}/params` - Set device parameters
- `GET /api/v1/devices/{id}/actions` - Get available actions

### Device Sharing
- `GET /api/v1/devices/{id}/users` - List shared users
- `POST /api/v1/devices/{id}/users` - Invite user
- `DELETE /api/v1/devices/{id}/users/{uid}` - Revoke access
- `PUT /api/v1/devices/{id}/users/{uid}/role` - Change user role

### Groups
- `GET /api/v1/groups` - List groups
- `POST /api/v1/groups` - Create group
- `POST /api/v1/groups/{id}/command` - Group command

### Notifications  
- `POST /api/v1/notifications/register-token` - Register FCM token
- `GET /api/v1/notifications` - List notifications
- `PUT /api/v1/notifications/{id}/read` - Mark as read

### Health & Status
- `GET /health` - Health check
- `GET /api/v1/status` - API status

## 🔐 Authentication

The API uses JWT (JSON Web Tokens) for authentication:

1. **Login:** POST credentials to `/api/v1/auth/login`
2. **Tokens:** Receive `access_token` (15 min) and `refresh_token` (30 days)  
3. **Authorization:** Include `Authorization: Bearer <access_token>` header
4. **Refresh:** Use refresh token at `/api/v1/auth/refresh` when access token expires

## 🎯 Device Commands

### Basic Controls
- `OPEN` - Open gate/door
- `CLOSE` - Close gate/door  
- `STOP` - Stop movement
- `OCS` - Open-Close-Stop sequence
- `PEDESTRIAN` - Pedestrian opening
- `LAMP` - Toggle lamp
- `RELAY` - Toggle auxiliary relay

### Parameters (GE/SE)
Read and write 20+ device parameters including:
- Motor direction, force, soft stop
- Auto-close settings and timing
- Pedestrian opening percentage  
- Lamp and relay configurations
- WiFi credentials

### Learn Commands
- Learn controls (open, close, stop, lamp, relay)
- Learn travel limits and distances
- Pair photocells (open/close)
- Test photocell functionality

## 🗄️ Database Schema

### Core Tables
- **users** - User accounts and profiles
- **devices** - VITA device registry  
- **device_users** - Device sharing and permissions
- **groups** - Device grouping
- **commands** - Command history and status
- **device_events** - Activity logging

### Dynamic Actions
- **device_action_templates** - Action definitions by device type
- **device_action_overrides** - Custom actions per device

### Notifications  
- **notifications** - In-app notifications
- **notification_tokens** - FCM device tokens
- **notification_preferences** - User notification settings

## 🧪 Development

### Running Tests
```bash
# Install test dependencies
pip install pytest pytest-asyncio httpx

# Run tests  
pytest

# Run with coverage
pytest --cov=app --cov-report=html
```

### Database Migrations
```bash
# Create migration
alembic revision --autogenerate -m "Description"

# Apply migrations
alembic upgrade head

# Rollback
alembic downgrade -1
```

### Code Quality
```bash
# Format code
black app/ tests/

# Sort imports  
isort app/ tests/

# Lint code
flake8 app/ tests/
```

## 📚 API Documentation

When running in development mode (`DEBUG=true`), interactive API documentation is available:

- **Swagger UI:** http://localhost:8000/docs
- **ReDoc:** http://localhost:8000/redoc

## 🔄 MQTT Protocol

### Command Format (Backend → Device)
```json
{
  "AC": "OPEN",
  "idInstaller": "jwt-token-hash"
}
```

### Response Format (Device → Backend)  
```json
{
  "AC": "OPEN", 
  "idVita": "device-serial",
  "result": "OK"
}
```

### Session Management
All device modifications require an active installer session:
- `IS` - Initialize session
- `AS` - Amplify (extend) session  
- `CS` - Close session

## 🚨 Error Handling

All API errors follow a standard format:

```json
{
  "error": {
    "code": "DEVICE_NOT_FOUND",
    "message": "The device was not found", 
    "details": {}
  }
}
```

### Common HTTP Status Codes
- `400` - Bad Request (validation errors)
- `401` - Unauthorized (invalid/missing token)
- `403` - Forbidden (insufficient permissions)
- `404` - Not Found  
- `409` - Conflict (duplicate resource)
- `422` - Unprocessable Entity
- `429` - Too Many Requests (rate limit)
- `500` - Internal Server Error

## 📊 Monitoring & Health

### Health Checks
- **Database:** Connection and query test
- **Redis:** Ping test
- **MQTT:** Connection status
- **Overall:** Healthy if all services connected

### Metrics (TODO)
- Request/response metrics
- Database query performance  
- MQTT message throughput
- Device online status

## 🔒 Security

### Rate Limiting
- Auth endpoints: 5 req/min per IP
- API endpoints: 100 req/min per user
- Device commands: 10 req/min per device

### Data Protection
- Passwords hashed with bcrypt
- JWT tokens with RS256 signing
- MQTT credentials encrypted
- Input validation with Pydantic

## 🌐 Deployment

### Production Checklist
- [ ] Set strong `JWT_SECRET`
- [ ] Configure production database  
- [ ] Set up Redis cluster
- [ ] Configure EMQX authentication
- [ ] Set up SSL/TLS certificates
- [ ] Configure log aggregation
- [ ] Set up monitoring alerts
- [ ] Enable backup automation

### Docker Production
```bash
# Build production image
docker build -t vita-api:latest .

# Run with production compose
docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d
```

## 📞 Support

For technical support or questions:
- **Issues:** GitHub Issues
- **Documentation:** `/docs` endpoint
- **Architecture:** See `docs/BACKEND-REDESIGN.md`

---

**VITA Backend API v2.0** - Built with ❤️ using FastAPI
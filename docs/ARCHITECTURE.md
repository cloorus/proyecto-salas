# 🏗️ Arquitectura del Sistema BGnius VITA

## Diagrama General

```
┌──────────────────────────────────────────────────────────────────┐
│                         USUARIOS                                  │
├────────────────┬─────────────────┬───────────────────────────────┤
│ Dueño Portón   │   Instalador    │      Admin Web                │
│ (Flutter App)  │  (React Native) │  (vita-webapp HTML)          │
└────────┬───────┴────────┬────────┴──────────┬───────────────────┘
         │                │                    │
         │ HTTPS REST     │ HTTPS REST         │ HTTPS REST
         │ WebSocket      │ BLE ←─────────┐    │
         ▼                ▼                │    ▼
┌────────────────────────────────────────┐│┌───────────────────────┐
│         VITA Backend API               │││  VITA WebApp (demo)   │
│         (FastAPI + Python)             │││  (HTML+JS)            │
│                                        │││                       │
│  • Auth (JWT)                          │││  • Prototipo rápido   │
│  • Devices CRUD                        │││  • Prueba endpoints   │
│  • Users & Permissions                 │││  • Mobile-first UI    │
│  • Groups                              │││  http://157../static  │
│  • Commands & Actions                  ││└───────────────────────┘
│  • Parameters (GE/SE)                  ││
│  • Installer Sessions (IS/AS/CS)       ││
│  • Learn Controls (RF)                 ││
│  • Photocells                          ││
│  • Events & Notifications              ││
│  • Support Requests                    ││
│                                        ││
│  http://157.245.1.231:8000             ││
└────────┬──────────────┬────────────────┘│
         │              │                  │
         │ SQL          │ MQTT pub/sub     │
         ▼              ▼                  │
┌────────────────┐  ┌────────────────────┐│
│  PostgreSQL 15 │  │  EMQX MQTT Broker  ││
│  + Redis 7     │  │  104.131.36.215    ││
│  (Docker)      │  │  Port 1883         ││
└────────────────┘  └─────────┬──────────┘│
                              │            │
                              │ MQTT       │
                              ▼            │
                    ┌────────────────────┐ │
                    │  VITA ESP32        │ │
                    │  (Firmware Daniel) │ │
                    │                    │ │
                    │  • Motor control   │ │
                    │  • RF learning     │ │
                    │  • Photocells      │ │
                    │  • 20+ params      │ │
                    │  • WiFi config     │ │
                    └──────────┬─────────┘ │
                               │            │
                               │ BLE        │
                               └────────────┘
```

---

## Capas del Sistema

### 1. **Capa de Presentación (Frontends)**

#### Flutter App (antigravity_app)
- **Usuario:** Dueño del portón/barrera
- **Plataformas:** Web, Android, iOS
- **Funcionalidad:**
  - Control remoto de dispositivos (OPEN, CLOSE, STOP, etc.)
  - Ver estado en tiempo real (online/offline, posición)
  - Gestionar permisos (compartir acceso)
  - Configurar parámetros básicos
  - Grupos de dispositivos
  - Notificaciones push
  - Historial de eventos

#### React Native App (app_bgnius_instalador)
- **Usuario:** Instalador técnico
- **Plataformas:** Android, iOS
- **Funcionalidad:**
  - Conexión BLE directa al ESP32
  - Asistente de instalación paso a paso
  - Configuración completa de parámetros (20+)
  - Aprendizaje de controles RF (9 tipos)
  - Emparejamiento de fotoceldas
  - Configuración WiFi del dispositivo
  - Pruebas de motor y límites (carreras)
  - Activación de dispositivos
  - Manuales PDF y bitácoras

#### VITA WebApp (vita-webapp)
- **Usuario:** Admin / testing
- **Plataforma:** Web móvil
- **Funcionalidad:**
  - Prototipo rápido para validar backend
  - Todas las features del Flutter app
  - HTML+JS vanilla (sin build step)

---

### 2. **Capa de Aplicación (Backend)**

#### VITA Backend API (FastAPI)
**Responsabilidades:**
- **Autenticación:** JWT tokens, refresh tokens, registro, login
- **Autorización:** Roles (admin, owner, installer, guest), permisos por dispositivo
- **Gestión de Dispositivos:** CRUD, ownership, metadata
- **Comandos:** Proxy MQTT, validación, logging
- **Parámetros:** Cache Redis, sync con ESP32 via MQTT
- **Sesiones Instalador:** Timeouts, tokens temporales, validación
- **Sharing:** Invitaciones, permisos granulares
- **Grupos:** Agrupación lógica, comandos batch
- **Eventos:** Logging de actividad, timeline
- **Notificaciones:** FCM push, preferences
- **Soporte:** Sistema de tickets, contactos

**Endpoints principales:**
```
POST   /api/v1/auth/login
POST   /api/v1/auth/register
GET    /api/v1/devices
POST   /api/v1/devices
GET    /api/v1/devices/{id}
POST   /api/v1/devices/{id}/command
GET    /api/v1/devices/{id}/params
PUT    /api/v1/devices/{id}/params
POST   /api/v1/devices/{id}/session/start
GET    /api/v1/devices/{id}/users
POST   /api/v1/groups
GET    /api/v1/notifications
POST   /api/v1/support/requests
```

**Tecnologías:**
- FastAPI (async Python)
- SQLAlchemy 2.0 (async ORM)
- Alembic (migrations)
- Pydantic (validation)
- aiomqtt (MQTT client)
- Redis (cache + sessions)

---

### 3. **Capa de Datos**

#### PostgreSQL 15
**Schema principal:**
```
users
├── id (PK)
├── email (unique)
├── password_hash
├── full_name
├── role (enum: admin, installer, user)
└── created_at

devices
├── id (PK)
├── owner_id (FK → users)
├── serial_number (unique)
├── mac_address (unique)
├── device_type (gate, barrier, door)
├── name
├── location
├── status (online, offline, error)
├── firmware_version
└── last_seen

device_users (sharing)
├── device_id (FK)
├── user_id (FK)
├── role (owner, admin, user, guest)
└── granted_at

groups
├── id (PK)
├── owner_id (FK)
├── name
└── created_at

device_groups
├── group_id (FK)
└── device_id (FK)

commands
├── id (PK)
├── device_id (FK)
├── user_id (FK)
├── action (OPEN, CLOSE, etc)
├── status (pending, sent, acked, failed)
├── sent_at
└── completed_at

device_events
├── id (PK)
├── device_id (FK)
├── event_type (command, status_change, error, etc)
├── data (jsonb)
└── timestamp

notifications
├── id (PK)
├── user_id (FK)
├── title
├── message
├── type (info, warning, error)
├── read (boolean)
└── created_at

installer_sessions
├── id (PK)
├── device_id (FK)
├── installer_id (FK → users)
├── session_token
├── started_at
├── expires_at
└── closed_at
```

#### Redis 7
**Uso:**
- Cache de parámetros de dispositivos (TTL 5 min)
- Sesiones de usuario (JWT refresh tokens)
- Rate limiting
- MQTT message queue (pending commands)
- Device online status (TTL con heartbeat)

---

### 4. **Capa de Comunicación**

#### EMQX MQTT Broker
**Topics:**
```
vita/{serial}/command     → Backend → Device (comandos)
vita/{serial}/response    → Device → Backend (respuestas)
vita/{serial}/heartbeat   → Device → Backend (keepalive)
```

**Formato de mensajes:**

**Backend → Device (command):**
```json
{
  "AC": "OPEN",
  "idInstaller": "jwt-token-hash"
}
```

**Device → Backend (response):**
```json
{
  "AC": "OPEN",
  "idVita": "VITA123456",
  "result": "OK",
  "Cur_MotorStatus": 1,
  "Total_Cycles": 1234
}
```

**Sesiones Instalador:**
```json
{"AC": "IS", "idInstaller": "token"}  // Initialize
{"AC": "AS", "idInstaller": "token"}  // Amplify (extend)
{"AC": "CS", "idInstaller": "token"}  // Close
```

**Parámetros:**
```json
{"AC": "GE", "PA": "dP"}              // Get parameter
{"AC": "SE", "PA": "dP", "VA": "1"}   // Set parameter
```

#### Bluetooth Low Energy (BLE)
**Uso:** App Instalador ↔ ESP32 directo
- Provisioning inicial (WiFi, serial, MAC)
- Configuración sin conexión a internet
- Debugging en campo
- Firmware updates (OTA via BLE)

**Servicios BLE:**
- UUID Config: `0000ffe0-...-...` (R/W parámetros)
- UUID Command: `0000ffe1-...-...` (W comandos, R respuestas)
- UUID WiFi: `0000ffe2-...-...` (W credenciales WiFi)

---

### 5. **Capa de Dispositivos (Hardware)**

#### VITA ESP32 (Firmware Daniel)
**Responsabilidades:**
- Control de motor (PWM, dirección, velocidad)
- Lectura de sensores (límites, fotoceldas, corriente)
- Gestión de controles RF (receptor 433MHz)
- Conexión WiFi (STA mode)
- MQTT client (pub/sub)
- BLE server (provisioning + debug)
- Almacenamiento de parámetros (EEPROM/NVS)
- Watchdog y recovery automático

**Parámetros configurables (20+):**
| Código | Nombre | Tipo | Rango |
|--------|--------|------|-------|
| dP | Dirección motor | bool | 0/1 |
| P5 | Soft stop | bool | 0/1 |
| LC | Límite de ciclos | int | 0-999999 |
| CA | Contador ciclos actual | int | readonly |
| tC | Tiempo de cierre (s) | int | 5-120 |
| AP | Apertura peatonal (%) | int | 10-100 |
| FE | Fotoceldas habilitadas | bool | 0/1 |
| Co | Modo configuración | bool | 0/1 |
| FF | Fuerza cierre (%) | int | 10-100 |
| FL | Fuerza apertura (%) | int | 10-100 |
| ... | | | |

**Estados del motor:**
```
0 = Stopped
1 = Opening
2 = Closing
3 = Open (fully)
4 = Closed (fully)
5 = Error
6 = Paused
```

---

## Flujos de Datos Principales

### 1. Control Remoto de Dispositivo

```
[Usuario en Flutter App]
   ↓ Tap "ABRIR"
   ↓ POST /api/v1/devices/123/command {"action": "OPEN"}
[Backend API]
   ↓ Valida permisos (device_users.role >= 'user')
   ↓ Crea registro en tabla 'commands' (status=pending)
   ↓ Publica MQTT vita/VITA123456/command {"AC":"OPEN"}
[EMQX Broker]
   ↓ Forward message a subscribers
[ESP32]
   ↓ Recibe comando via MQTT
   ↓ Valida checksums, sesión, etc
   ↓ Ejecuta motor.open()
   ↓ Publica respuesta vita/VITA123456/response {"AC":"OPEN","result":"OK"}
[Backend API]
   ↓ Recibe respuesta via MQTT subscriber
   ↓ Actualiza registro commands (status=acked)
   ↓ Emite WebSocket event a Flutter (si conectado)
[Flutter App]
   ↓ WebSocket recibe confirmación
   ↓ Actualiza UI (botón verde → animación → check)
```

### 2. Instalación de Dispositivo Nuevo

```
[Instalador con React Native App]
   ↓ Scan BLE → encuentra "VITA_123456"
   ↓ Connect BLE
   ↓ Envía WiFi credentials via BLE (SSID + password)
[ESP32]
   ↓ Guarda WiFi en NVS
   ↓ Conecta a WiFi
   ↓ Obtiene IP (DHCP)
   ↓ Conecta a EMQX MQTT broker
   ↓ Subscribe a vita/VITA123456/command
   ↓ Publica vita/VITA123456/heartbeat (online)
[React Native App]
   ↓ POST /api/v1/devices/session/start {"serial": "VITA123456"}
[Backend API]
   ↓ Crea installer_session con token temporal (30 min)
   ↓ Publica MQTT {"AC":"IS", "idInstaller":"token"}
[ESP32]
   ↓ Recibe IS, activa modo instalador
   ↓ Habilita comandos de configuración (SE, learn, etc)
[React Native App]
   ↓ Asistente paso a paso:
   ↓   1. Dirección motor (SE dP)
   ↓   2. Aprender límites (motor run hasta photocell)
   ↓   3. Aprender control RF (AC Ct, presiona control remoto)
   ↓   4. Configurar parámetros (tC, AP, FF, FL)
   ↓   5. Prueba completa (OCS)
   ↓ POST /api/v1/devices {"serial":"VITA123456","owner_id":456}
   ↓ POST /api/v1/devices/session/end
[Backend API]
   ↓ Cierra installer_session
   ↓ Publica MQTT {"AC":"CS"}
[ESP32]
   ↓ Sale de modo instalador
   ↓ Modo normal (solo comandos básicos)
```

### 3. Compartir Dispositivo con Otro Usuario

```
[Owner en Flutter App]
   ↓ Navega a "Usuarios" del dispositivo
   ↓ Tap "Invitar Usuario"
   ↓ Ingresa email: "amigo@example.com"
   ↓ Selecciona rol: "user" (control básico)
   ↓ POST /api/v1/devices/123/users {"email":"amigo@..","role":"user"}
[Backend API]
   ↓ Busca user_id por email
   ↓ INSERT device_users (device_id=123, user_id=789, role='user')
   ↓ Envía email notificación (opcional, via nodemailer/SES)
   ↓ Si amigo tiene FCM token → push notification
[Flutter App del Amigo]
   ↓ Recibe push notification "Te compartieron un dispositivo"
   ↓ Abre app → GET /api/v1/devices
   ↓ Ahora ve device_id=123 en su lista
   ↓ Puede controlarlo (OPEN, CLOSE) según permisos rol 'user'
```

---

## Seguridad

### Autenticación
- JWT tokens (RS256, 15 min expiry)
- Refresh tokens (30 días, rotación)
- Bcrypt password hashing

### Autorización
- RBAC: admin > owner > installer > user > guest
- Permisos por dispositivo (device_users.role)
- Installer sessions con timeout automático

### MQTT
- Credenciales por cliente (no anónimo)
- ACL: cada cliente solo puede pub/sub sus propios topics
- TLS opcional (producción recomendado)

### BLE
- Pairing con PIN (6 dígitos, generado por ESP32)
- Cifrado BLE nativo (AES-128)
- Timeout de conexión (5 min inactividad)

### Rate Limiting
- Auth endpoints: 5 req/min por IP
- Command endpoints: 10 req/min por dispositivo
- Global: 100 req/min por usuario

---

## Escalabilidad

### Horizontal Scaling
- Backend API: stateless, múltiples instancias (load balancer)
- PostgreSQL: read replicas
- Redis: cluster mode (sharding)
- EMQX: cluster nativo (hasta 10M conexiones)

### Vertical Scaling
- PostgreSQL: connection pooling (asyncpg)
- Backend: async I/O (FastAPI + asyncio)
- Cache agresivo (Redis TTL 5 min)

### Optimizaciones
- Cursor pagination (no offset/limit)
- Lazy loading de relaciones
- Índices DB en foreign keys + búsquedas frecuentes
- WebSocket para notificaciones (no polling)

---

## Monitoreo y Logging

### Health Checks
- `/health` endpoint: DB + Redis + MQTT status
- Heartbeats MQTT cada 30s (device online status)
- Automated alerts (Discord/Telegram via webhook)

### Logging
- Structured JSON logs (loguru)
- Niveles: DEBUG, INFO, WARNING, ERROR, CRITICAL
- Log aggregation (futuro: Loki, CloudWatch)

### Metrics (futuro)
- Prometheus + Grafana
- Request latency (p50, p95, p99)
- Command success rate
- Device uptime
- Active users

---

## Deployment

### Desarrollo
- Docker Compose local
- Hot reload (FastAPI --reload, Flutter hot restart)
- SQLite para tests unitarios

### Staging
- DigitalOcean droplet (157.245.1.231)
- Docker Compose producción
- PostgreSQL + Redis containers
- EMQX standalone

### Producción (futuro)
- Kubernetes cluster (GKE/EKS)
- Managed PostgreSQL (RDS/Cloud SQL)
- Redis cluster (ElastiCache)
- EMQX cluster (3+ nodes)
- CDN para Flutter web assets
- CI/CD: GitHub Actions

---

**Última actualización:** 2 Abril 2026  
**Versión:** 1.0

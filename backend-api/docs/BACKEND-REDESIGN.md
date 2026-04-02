# Documento de Diseño: Backend VITA v2.0

**Fecha:** 2026-03-01  
**Autor:** Orus (asistente IA) + Andrey Mena  
**Estado:** BORRADOR — pendiente revisión

---

## 1. Resumen Ejecutivo

El backend actual (FastAPI en 157.245.1.231) fue construido como demo. Tiene ~90 archivos Python, muchos módulos `_unused/`, Prometheus innecesario, AI layer placeholder, y **no habla el protocolo real del firmware VITA** (Daniel). Este documento propone un rediseño alineado a tres fuentes de verdad:

1. **Protocolo firmware VITA** (ESP32, definido por Daniel)
2. **App Flutter** (Clean Architecture + Riverpod)
3. **Legacy web** (Node.js + React, referencia para entidades admin)

### Decisión clave
> Reconstruir desde cero. El backend actual es irrecuperable como base — la deuda técnica supera lo rescatable. Se conserva la BD PostgreSQL con ajustes al schema.

---

## 2. Arquitectura Propuesta

```
┌─────────────┐     ┌─────────────────────┐     ┌──────────────┐
│  App Flutter │────▶│   API REST (FastAPI) │◀───▶│  PostgreSQL  │
│  (móvil)    │     │   api.bgnius.com/v1  │     │  (puerto 5433)│
└─────────────┘     └──────────┬──────────┘     └──────────────┘
                               │
                    ┌──────────▼──────────┐
                    │   MQTT Bridge       │     ┌──────────────┐
                    │   (en el mismo      │────▶│  EMQX Broker │
                    │    proceso FastAPI)  │     │  104.131.36.215│
                    └─────────────────────┘     └──────────────┘
                                                       │
                                                ┌──────▼──────┐
                                                │  VITA ESP32  │
                                                │  (firmware)  │
                                                └─────────────┘
```

**Stack:**
- **FastAPI** (Python 3.11) — REST API
- **PostgreSQL 15** — persistencia (reusar contenedor existente)
- **Redis 7** — cache de sesiones installer, estado real-time de dispositivos
- **EMQX** — broker MQTT existente (104.131.36.215:1883)
- **JWT** — autenticación (conservar del backend actual)

---

## 3. Mapeo Pantallas Flutter → Endpoints → MQTT

### 3.1 Autenticación (features/auth/)

| Pantalla Flutter | Endpoint API | Método | Notas |
|---|---|---|---|
| `l_login_screen` | `/api/v1/auth/login` | POST | JWT token |
| `b_register_screen` | `/api/v1/auth/register` | POST | Nombre, email, teléfono, país |
| `m_reset_password_screen` | `/api/v1/auth/forgot-password` | POST | Envía código |
| — | `/api/v1/auth/reset-password` | POST | Valida código + nueva contraseña |
| — | `/api/v1/auth/refresh` | POST | Refresh token |
| — | `/api/v1/auth/me` | GET | Perfil del usuario actual |
| — | `/api/v1/auth/change-password` | POST | Cambiar contraseña (requiere current_password + new_password) |

### 3.2 Dispositivos — CRUD (features/devices/)

| Pantalla Flutter | Endpoint API | Método | Notas |
|---|---|---|---|
| `a_devices_list_screen` | `/api/v1/devices` | GET | Lista dispositivos del usuario |
| `d_add_device_screen` | `/api/v1/devices` | POST | Registrar dispositivo nuevo |
| `f_device_edit_screen` | `/api/v1/devices/{id}` | PUT | Editar nombre, descripción, ubicación |
| — | `/api/v1/devices/{id}` | DELETE | Eliminar dispositivo |
| `h_device_info_screen` | `/api/v1/devices/{id}` | GET | Detalle completo (incluye params firmware) |
| `r_device_all_details_screen` | `/api/v1/devices/{id}/full` | GET | Todo: info + params + eventos + usuarios |

### 3.3 Control de Dispositivo (MQTT commands)

| Pantalla Flutter | Endpoint API | Método | Comando MQTT (AC) | Notas |
|---|---|---|---|---|
| `j_device_control_screen` | `/api/v1/devices/{id}/command` | POST | `OPEN` | Abrir |
| — | — | — | `CLOSE` | Cerrar |
| — | — | — | `stop` | Parar |
| — | — | — | `OCS` | Open-Close-Stop (toggle) |
| — | — | — | `PEDESTRIAN` | Apertura peatonal |
| — | — | — | `LAMP` | Toggle lámpara |
| — | — | — | `RELE` | Toggle relé |

**Formato del POST:**
```json
{
  "command": "OPEN"
}
```

**Flujo interno:**
1. API recibe POST con `command`
2. Valida que el usuario tenga permiso sobre el dispositivo
3. Inicia sesión installer si no hay una activa (`AC: IS`)
4. Publica al topic MQTT: `vita/{serial_number}/cmd`
5. Espera respuesta en `vita/{serial_number}/res` (timeout 10s)
6. Retorna resultado al Flutter via HTTP (o WebSocket para real-time)

### 3.4 Parámetros del Dispositivo (firmware SE/GE)

| Pantalla Flutter | Endpoint API | Método | Comando MQTT | Notas |
|---|---|---|---|---|
| `i_device_parameters_screen` | `/api/v1/devices/{id}/params` | GET | `GE` | Lee todos los parámetros |
| — | `/api/v1/devices/{id}/params` | PUT | `SE` | Escribe parámetros |

**Parámetros firmware (SE/GE):**

| Campo firmware | Nombre legible | Tipo | Rango | Descripción |
|---|---|---|---|---|
| `dP` | Dirección puerta | int | 0-1 | 0=Derecha, 1=Izquierda |
| `P5` | Paro suave | int | 0-10 | 0=desactivado |
| `LC` | Límites carrera | int | 0-1 | 0=NO, 1=NC |
| `CA` | Cierre automático | int | 0-1 | 0=OFF, 1=ON |
| `tC` | Tiempo cierre auto | int | 0-9 | 0=10s, 1=20s, 2=30s, 3=1min... 9=4min |
| `AP` | Apertura peatonal | int | 1-5 | 1=0%, 2=25%, 3=50%, 4=75%, 5=100% |
| `FE` | Fuerza empuje | int | 0-9 | — |
| `Co` | Modo condominio | int | 0-1 | Solo abre (no cierra con OCS) |
| `rA` | Relé auxiliar | int | 0-2 | Modo del relé |
| `CC` | Límite mantenimientos | int | 0-9 | Ciclos para avisar mantenimiento |
| `FF` | Cierre por fotoceldas | int | 0-1 | — |
| `FL` | Modo lámpara | int | 0-1 | 0=Fija, 1=Destellante |
| `LE` | Luz cortesía | int | 0-5 | Minutos encendida post-operación |
| `bL` | Bloqueo | int | 0-1 | Solo en estado cerrado |
| `tA` | Mantener abierto | int | 0-1 | Solo en estado abierto |
| `labelVita` | Etiqueta | string | — | Nombre puesto por instalador |
| `setWifi` | Guardar WiFi | int | 0-1 | Si 1, guarda ssid+password |
| `ssid` | Red WiFi | string | — | — |
| `ssidPassword` | Contraseña WiFi | string | — | — |

**Respuesta GE adicional (solo lectura):**

| Campo | Nombre | Tipo | Descripción |
|---|---|---|---|
| `Cur_MotorStatus` | Estado motor | int | 0=Open, 1=Opening, 2=Closed, 3=Closing, 4=Stopped, 5=PedOpen, 6=PedOpening |
| `current_Type` | Tipo corriente | int | 0=AC, 1=DC |
| `motor_Type` | Tipo motor | int | 0=piston, 1=rack, 2=curtain, 3=barrier, 4=sliding_door, 5=electronic_door, 6=other |
| `IdPCB` | ID PCB | int | 0=fac500 |
| `Maintenance_Count` | Total mantenimientos | int | 0-99 |
| `Total_Cycles` | Ciclos totales | int | 0-9999999 |
| `Par_MaintenanceLimit` | Límite ciclos mant. | int | 0-9000 |
| `Cycles_SinceMaintenance` | Ciclos desde mant. | int | 0-9999 |
| `Fc_OpenState` | Fotocelda apertura | int | 0=libre, 1=interrumpida |
| `Fc_CloseState` | Fotocelda cierre | int | 0=libre, 1=interrumpida |
| `fc_Open_Battery` | Batería FC apertura | int | 0-99% |
| `fc_Close_Battery` | Batería FC cierre | int | 0-99% |
| `Lamp_Status` | Estado lámpara | int | 0=apagado, 1=encendido |
| `Relay_Status` | Estado relé | int | 0=apagado, 1=encendido |
| `FV` | Versión firmware | string | "YYYYMMDDHHmm" |

### 3.5 Sesiones de Instalador (firmware IS/CS/AS)

| Endpoint API | Método | Comando MQTT | Notas |
|---|---|---|---|
| `/api/v1/devices/{id}/session/start` | POST | `IS` | Inicia sesión con `idInstaller` |
| `/api/v1/devices/{id}/session/extend` | POST | `AS` | Amplía tiempo de sesión |
| `/api/v1/devices/{id}/session/close` | POST | `CS` | Cierra sesión |

**Regla:** Todo comando que modifique el dispositivo requiere sesión activa. La API gestiona esto automáticamente — el Flutter no necesita manejar sesiones directamente.

### 3.6 Aprender Controles (firmware learn commands)

| Endpoint API | Método | Comando MQTT (AC) | Descripción |
|---|---|---|---|
| `/api/v1/devices/{id}/learn/total-open` | POST | `Ct` | Control apertura total |
| `/api/v1/devices/{id}/learn/pedestrian` | POST | `CP` | Control peatonal |
| `/api/v1/devices/{id}/learn/lamp` | POST | `CL` | Control lámpara |
| `/api/v1/devices/{id}/learn/relay` | POST | `Cr` | Control relé PCB |
| `/api/v1/devices/{id}/learn/block` | POST | `Cb` | Control bloqueo |
| `/api/v1/devices/{id}/learn/open` | POST | `Ai` | Control abrir |
| `/api/v1/devices/{id}/learn/close` | POST | `AE` | Control cerrar |
| `/api/v1/devices/{id}/learn/stop` | POST | `AA` | Control parar |
| `/api/v1/devices/{id}/learn/keep-open` | POST | `At` | Control mantener abierto |
| `/api/v1/devices/{id}/learn/travel-limit` | POST | `AL` | Aprender límite carrera |
| `/api/v1/devices/{id}/learn/add-travel` | POST | `5r` | Sumar recorrido |
| `/api/v1/devices/{id}/learn/subtract-travel` | POST | `rr` | Restar recorrido |

### 3.7 Fotoceldas

| Endpoint API | Método | Comando MQTT (AC) | Descripción |
|---|---|---|---|
| `/api/v1/devices/{id}/photocell/pair-open` | POST | `PA` | Emparejar fotocelda apertura |
| `/api/v1/devices/{id}/photocell/pair-close` | POST | `AC` | Emparejar fotocelda cierre |
| `/api/v1/devices/{id}/photocell/test-close` | POST | `t1` | Test fotocelda cierre |
| `/api/v1/devices/{id}/photocell/test-open` | POST | `t2` | Test fotocelda apertura |

### 3.8 Opciones Avanzadas

| Endpoint API | Método | Comando MQTT (AC) | Descripción |
|---|---|---|---|
| `/api/v1/devices/{id}/advanced/factory-reset` | POST | `CF` | Config de fábrica |
| `/api/v1/devices/{id}/advanced/clear-rf` | POST | `bC` | Borrar controles RF |
| `/api/v1/devices/{id}/advanced/clear-pcb` | POST | `bP` | Borrar parámetros PCB |
| `/api/v1/devices/{id}/advanced/reset-esp` | POST | `rE` | Reiniciar VITA (ESP32) |
| `/api/v1/devices/{id}/advanced/reset-maintenance` | POST | `rC` | Reset contador mantenimientos |
| `/api/v1/devices/{id}/advanced/delete-wifi` | POST | `DelWifi` | Eliminar red WiFi |
| `/api/v1/devices/{id}/advanced/limit-switch` | POST | `LC` | Config límites carrera (NO/NC) |

### 3.9 Usuarios Compartidos y Permisos

| Pantalla Flutter | Endpoint API | Método | Notas |
|---|---|---|---|
| `g_shared_users_screen` | `/api/v1/devices/{id}/users` | GET | Lista usuarios con acceso |
| — | `/api/v1/devices/{id}/users` | POST | Invitar usuario |
| — | `/api/v1/devices/{id}/users/{uid}` | DELETE | Revocar acceso |
| `p_link_virtual_user_screen` | `/api/v1/devices/{id}/users/virtual` | POST | Crear acceso temporal/QR |
| `n_user_roles_screen` | `/api/v1/devices/{id}/users/{uid}/role` | PUT | Cambiar rol |

### 3.10 Grupos

| Pantalla Flutter | Endpoint API | Método | Notas |
|---|---|---|---|
| `e_groups_screen` | `/api/v1/groups` | GET | Lista grupos |
| — | `/api/v1/groups` | POST | Crear grupo |
| — | `/api/v1/groups/{id}` | PUT | Editar grupo |
| — | `/api/v1/groups/{id}` | DELETE | Eliminar grupo |
| — | `/api/v1/groups/{id}/devices` | POST | Agregar dispositivo |
| — | `/api/v1/groups/{id}/devices/{did}` | DELETE | Quitar dispositivo |
| — | `/api/v1/groups/{id}/command` | POST | Comando grupal (OCS a todos) |

### 3.11 Eventos/Historial

| Pantalla Flutter | Endpoint API | Método | Notas |
|---|---|---|---|
| `k_event_log_screen` | `/api/v1/devices/{id}/events` | GET | Log con paginación, filtros por fecha |

### 3.12 Provisioning (BLE + WiFi)

| Pantalla Flutter | Endpoint API | Método | Notas |
|---|---|---|---|
| `scan_devices_screen` | — | — | **100% local** (BLE scan, no API) |
| — | `/api/v1/devices/register` | POST | Registrar dispositivo post-provisioning |

**Flujo de provisioning:**
1. Flutter escanea BLE → encuentra VITA
2. Flutter envía credenciales WiFi via BLE al VITA
3. VITA se conecta a WiFi → se conecta a EMQX
4. Flutter llama `POST /devices/register` con serial number
5. Backend confirma que el VITA está online en EMQX
6. Dispositivo queda registrado y asociado al usuario

### 3.13 Soporte Técnico

| Pantalla Flutter | Endpoint API | Método | Notas |
|---|---|---|---|
| `c_technical_contact_screen` | `/api/v1/devices/{id}/support` | GET | Info contacto técnico |
| — | `/api/v1/support/request` | POST | Solicitar soporte |

### 3.14 Configuración Usuario

| Pantalla Flutter | Endpoint API | Método | Notas |
|---|---|---|---|
| `q_settings_screen` | `/api/v1/auth/me` | GET/PUT | Perfil usuario |
| — | `/api/v1/auth/change-password` | POST | Cambiar contraseña |
| — | `/api/v1/users/me` | PUT | Actualizar perfil (name, phone, address, country, language) |
| — | `/api/v1/users/me/photo` | POST | Subir foto de perfil (multipart/form-data, max 5MB, jpg/png) |
| — | `/api/v1/users/me/photo` | DELETE | Eliminar foto de perfil |

### 3.15 Notificaciones

| Pantalla Flutter | Endpoint API | Método | Notas |
|---|---|---|---|
| `notifications_screen` | `/api/v1/notifications` | GET | Listar notificaciones del usuario (paginado) |
| — | `/api/v1/notifications/register-token` | POST | Registrar FCM token del dispositivo móvil |
| — | `/api/v1/notifications/unregister-token` | DELETE | Eliminar token |
| — | `/api/v1/notifications/{id}/read` | PUT | Marcar como leída |
| — | `/api/v1/notifications/read-all` | PUT | Marcar todas como leídas |
| `notification_preferences_screen` | `/api/v1/notifications/preferences` | GET | Obtener preferencias de notificación |
| — | `/api/v1/notifications/preferences` | PUT | Actualizar preferencias |

### API Endpoints:
```
POST   /api/v1/notifications/register-token     → registrar FCM token del dispositivo móvil
DELETE /api/v1/notifications/unregister-token   → eliminar token
GET    /api/v1/notifications                    → listar notificaciones del usuario (paginado)
PUT    /api/v1/notifications/{id}/read          → marcar como leída
PUT    /api/v1/notifications/read-all           → marcar todas como leídas
GET    /api/v1/notifications/preferences        → obtener preferencias de notificación
PUT    /api/v1/notifications/preferences        → actualizar preferencias
```

### DB Tables:
```sql
CREATE TABLE notification_tokens (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    fcm_token VARCHAR(255) NOT NULL,
    device_info VARCHAR(200), -- "iPhone 15, iOS 18"
    created_at TIMESTAMP DEFAULT NOW(),
    UNIQUE(user_id, fcm_token)
);

CREATE TABLE notifications (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    device_id INTEGER REFERENCES devices(id) ON DELETE SET NULL,
    type VARCHAR(50) NOT NULL, -- action_executed, device_offline, device_online, status_change
    title VARCHAR(200) NOT NULL,
    body TEXT NOT NULL,
    metadata JSONB DEFAULT '{}', -- {actor_name, action, motor_status, etc}
    is_read BOOLEAN DEFAULT false,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE notification_preferences (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    device_id INTEGER REFERENCES devices(id) ON DELETE CASCADE,
    notify_actions BOOLEAN DEFAULT true,
    notify_offline BOOLEAN DEFAULT true,
    notify_status_change BOOLEAN DEFAULT true,
    UNIQUE(user_id, device_id)
);
```

### Notification types:
- **action_executed**: "Juan abrió el portón" → push to all device users except actor
- **device_offline**: Device heartbeat timeout (>5 min no MQTT heartbeat) → push to owner + admins
- **device_online**: Device came back online → push to owner + admins
- **status_change**: Unexpected motor status change → push to all device users

---

## 4. Modelo de Datos (PostgreSQL)

### 4.1 Tablas Core (conservar del backend actual, simplificar)

```sql
-- Usuarios
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    full_name VARCHAR(200),
    phone VARCHAR(20),
    country VARCHAR(100),
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- Dispositivos VITA
CREATE TABLE devices (
    id SERIAL PRIMARY KEY,
    serial_number VARCHAR(50) UNIQUE NOT NULL,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    device_type VARCHAR(50) NOT NULL, -- gate, barrier, door
    location VARCHAR(200),
    model VARCHAR(100),
    mac_address VARCHAR(17) UNIQUE,
    firmware_version VARCHAR(20),
    owner_id INTEGER REFERENCES users(id),
    is_online BOOLEAN DEFAULT false,
    last_seen TIMESTAMP,
    -- Cached firmware params (updated on GE response)
    cached_params JSONB DEFAULT '{}',
    cached_motor_status INTEGER,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- Acceso usuario-dispositivo
CREATE TABLE device_users (
    id SERIAL PRIMARY KEY,
    device_id INTEGER REFERENCES devices(id) ON DELETE CASCADE,
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    role VARCHAR(50) NOT NULL, -- owner, admin, operator, viewer, guest
    granted_by INTEGER REFERENCES users(id),
    expires_at TIMESTAMP, -- NULL = permanente
    created_at TIMESTAMP DEFAULT NOW(),
    UNIQUE(device_id, user_id)
);

-- Grupos
CREATE TABLE groups (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description VARCHAR(200),
    owner_id INTEGER REFERENCES users(id),
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE group_devices (
    group_id INTEGER REFERENCES groups(id) ON DELETE CASCADE,
    device_id INTEGER REFERENCES devices(id) ON DELETE CASCADE,
    PRIMARY KEY (group_id, device_id)
);

-- Comandos (historial)
CREATE TABLE commands (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    device_id INTEGER REFERENCES devices(id) ON DELETE CASCADE,
    user_id INTEGER REFERENCES users(id),
    command_type VARCHAR(50) NOT NULL,
    mqtt_ac VARCHAR(20), -- AC code sent to firmware
    status VARCHAR(50) DEFAULT 'pending',
    response JSONB,
    created_at TIMESTAMP DEFAULT NOW(),
    completed_at TIMESTAMP
);

-- Eventos (log de actividad del dispositivo)
CREATE TABLE device_events (
    id SERIAL PRIMARY KEY,
    device_id INTEGER REFERENCES devices(id) ON DELETE CASCADE,
    user_id INTEGER REFERENCES users(id),
    event_type VARCHAR(50) NOT NULL,
    description TEXT,
    metadata JSONB DEFAULT '{}',
    created_at TIMESTAMP DEFAULT NOW()
);
```

### 4.2 Device Capabilities (Acciones Dinámicas)

> **Caso de uso clave:** Los botones/acciones de un dispositivo NO son fijos en el app.
> Cada modelo/tipo define qué acciones soporta, con qué etiqueta, ícono y dónde se muestra.
> Un portón tiene "Abrir/Cerrar/Lámpara", pero un dispositivo inteligente puede tener "Encender Cámara/Apagar Cámara".
> Todo esto se administra desde el backend y el app renderiza dinámicamente.

```sql
-- Plantillas de acciones por tipo de dispositivo
CREATE TABLE device_action_templates (
    id SERIAL PRIMARY KEY,
    device_type VARCHAR(50) NOT NULL,  -- gate, barrier, door, camera, smart_switch...
    action_key VARCHAR(50) NOT NULL,   -- OPEN, CLOSE, LAMP, RELE, CUSTOM_1...
    mqtt_ac VARCHAR(20),               -- Código AC para firmware (OPEN, OCS, LAMP, etc.)
    default_label VARCHAR(100) NOT NULL, -- "Abrir", "Encender cámara"
    default_icon VARCHAR(50) NOT NULL,   -- Material icon name: lock_open, lightbulb, videocam
    show_in_list BOOLEAN DEFAULT false,  -- Visible en tarjeta de lista de dispositivos
    show_in_detail BOOLEAN DEFAULT true, -- Visible dentro de la gestión del dispositivo
    sort_order INTEGER DEFAULT 0,
    is_toggle BOOLEAN DEFAULT false,     -- true = tiene estado on/off (lámpara, relé)
    created_at TIMESTAMP DEFAULT NOW(),
    UNIQUE(device_type, action_key)
);

-- Overrides por dispositivo individual (admin personaliza un dispositivo específico)
CREATE TABLE device_action_overrides (
    id SERIAL PRIMARY KEY,
    device_id INTEGER REFERENCES devices(id) ON DELETE CASCADE,
    action_key VARCHAR(50) NOT NULL,
    custom_label VARCHAR(100),    -- NULL = usa template default
    custom_icon VARCHAR(50),      -- NULL = usa template default
    show_in_list BOOLEAN,         -- NULL = usa template default
    show_in_detail BOOLEAN,       -- NULL = usa template default
    is_enabled BOOLEAN DEFAULT true, -- false = oculta esta acción para este dispositivo
    sort_order INTEGER,
    UNIQUE(device_id, action_key)
);
```

**API endpoint:**
```
GET /api/v1/devices/{id}/actions → devuelve acciones mergeadas (template + overrides)

Response:
{
  "actions": [
    {
      "key": "OPEN",
      "label": "Abrir",
      "icon": "lock_open",
      "mqtt_ac": "OPEN",
      "show_in_list": true,
      "show_in_detail": true,
      "is_toggle": false,
      "sort_order": 1
    },
    {
      "key": "LAMP",
      "label": "Lámpara",
      "icon": "lightbulb",
      "mqtt_ac": "LAMP",
      "show_in_list": false,
      "show_in_detail": true,
      "is_toggle": true,
      "sort_order": 5
    }
  ]
}
```

**Admin endpoints:**
```
GET    /api/v1/admin/action-templates              → listar plantillas
POST   /api/v1/admin/action-templates              → crear plantilla
PUT    /api/v1/admin/action-templates/{id}          → editar plantilla
DELETE /api/v1/admin/action-templates/{id}          → eliminar plantilla
PUT    /api/v1/admin/devices/{id}/action-overrides  → personalizar acciones de un dispositivo
```

**Seed data ejemplo:**
```sql
INSERT INTO device_action_templates (device_type, action_key, mqtt_ac, default_label, default_icon, show_in_list, show_in_detail, sort_order, is_toggle) VALUES
('gate', 'OPEN',       'OPEN',  'Abrir',        'lock_open',       true,  true,  1, false),
('gate', 'CLOSE',      'OCS',   'Cerrar',       'lock',            true,  true,  2, false),
('gate', 'STOP',       'OCS',   'Parar',        'stop',            false, true,  3, false),
('gate', 'PEDESTRIAN', 'PP',    'Peatonal',     'directions_walk', true,  true,  4, false),
('gate', 'LAMP',       'LAMP',  'Lámpara',      'lightbulb',       false, true,  5, true),
('gate', 'RELAY',      'RELE',  'Relé/Switch',  'power',           false, true,  6, true),
('camera', 'CAM_ON',   'OPEN',  'Encender Cámara', 'videocam',     true,  true,  1, true),
('camera', 'CAM_OFF',  'OCS',   'Apagar Cámara',   'videocam_off', true,  true,  2, true),
('camera', 'RECORD',   'LAMP',  'Grabar',          'fiber_manual_record', false, true, 3, true);
```

**Flutter:** La pantalla de control NO hardcodea botones. Llama `GET /devices/{id}/actions` y renderiza dinámicamente. El provider cachea las acciones por dispositivo.

### 4.3 Redis Keys

```
session:{device_serial}:installer  → {user_id, started_at, expires_at}
device:{device_serial}:state       → {motor_status, lamp, relay, is_online, last_heartbeat}
device:{device_serial}:params      → {cached GE response}
```

---

## 5. MQTT Topics y Formato de Mensajes

### Topics

| Topic | Dirección | Descripción |
|---|---|---|
| `vita/{serial}/cmd` | Backend → Device | Comandos al VITA |
| `vita/{serial}/res` | Device → Backend | Respuestas del VITA |
| `vita/{serial}/heartbeat` | Device → Backend | Heartbeat periódico |

### Formato Comando (Backend → Device)
```json
{
  "AC": "OPEN",
  "idInstaller": "jwt-derived-installer-id"
}
```

### Formato Respuesta (Device → Backend)
```json
{
  "AC": "OPEN",
  "idVita": "device-serial-number",
  "result": "OK"
}
```

### Formato GE Response (Device → Backend)
Incluye todos los campos de la tabla en sección 3.4 (parámetros + estado).

---

## 6. WebSocket para Real-Time

```
ws://api.bgnius.com/v1/ws/{device_id}?token={jwt}
```

**Eventos push al Flutter:**
```json
{"type": "motor_status", "status": 0, "timestamp": "..."}
{"type": "heartbeat", "is_online": true}
{"type": "command_result", "ac": "OPEN", "result": "OK"}
{"type": "params_update", "params": {...}}
{"type": "photocell_alert", "fc": "open", "state": 1}
```

---

## 7. Lo que se descarta del backend actual

| Módulo | Razón |
|---|---|
| `ia_layer/` (anomaly_detector, predictive_maintenance) | Placeholder sin lógica real |
| Prometheus metrics (100+ líneas) | Overkill para MVP |
| `force-metrics-data` endpoint | Genera datos falsos |
| `legal_advisor/` | Vacío |
| `_unused/` (8 archivos) | Ya marcados como unused |
| Admin PHP + Nginx containers | Reemplazar con panel web simple |
| `sync_device_online_status_task` (polling BD cada 10s) | Reemplazar con eventos MQTT directos |

### Lo que se conserva

| Componente | Razón |
|---|---|
| PostgreSQL container | BD funcional, ajustar schema |
| Redis container | Útil para cache |
| EMQX broker (104.131.36.215) | Funcional, ya configurado |
| JWT auth flow | Funcional, limpiar |
| Docker Compose base | Ajustar services |

---

## 8. Legacy Web (Node.js) — Referencia

El backend web legacy (Express + MSSQL) maneja entidades administrativas que **no existen en el Flutter app**:

| Entidad legacy | ¿Migrar? | Notas |
|---|---|---|
| Person (instaladores) | ✅ Parcial | Fusionar con User |
| Country | ✅ | Para registro de usuarios |
| Engine / EngineType | ❌ | Reemplazado por Device.device_type + motor_Type firmware |
| Activation | ✅ Transformar | Es el registro de provisioning |
| Membership | ❌ | No existe en Flutter |
| Training | ❌ | No existe en Flutter |
| Validation | ❌ | No existe en Flutter |
| RolePerson | ✅ Transformar | Fusionar con device_users.role |

**Diccionario de datos SInst (PDF):** Define el schema original MSSQL. No se migra — se usa PostgreSQL desde cero.

---

## 9. Plan de Implementación

### Fase 1 — Core (2 semanas)
1. Auth endpoints (login, register, me, refresh)
2. Device CRUD
3. MQTT bridge (publish commands, subscribe responses)
4. Sesiones installer (IS/CS/AS automático)
5. Comandos básicos (OPEN, CLOSE, OCS, PEDESTRIAN, LAMP, RELE)
6. WebSocket para estado real-time

### Fase 2 — Parámetros y Configuración (1 semana)
7. GET/SET parámetros (GE/SE)
8. Aprender controles (Ct, CP, CL, Cr, Cb, Ai, AE, AA, At, AL, 5r, rr)
9. Fotoceldas (PA, AC, t1, t2)
10. Opciones avanzadas (CF, bC, bP, rE, rC, DelWifi, LC)

### Fase 3 — Social y Grupos (1 semana)
11. Device users (compartir, invitar, revocar)
12. Grupos (CRUD + comando grupal)
13. Event log

### Fase 4 — Provisioning y Soporte (1 semana)
14. Registro de dispositivo post-BLE provisioning
15. Soporte técnico
16. Notificaciones push

---

## 10. Endpoints Totales

| Módulo | Endpoints | Notas |
|---|---|---|
| Auth | 7 | Login, register, me, refresh, forgot, reset, change-password |
| Devices CRUD | 5 | List, create, get, update, delete |
| Device Commands | 1 | POST con command type variable |
| Device Params | 2 | GET (GE), PUT (SE) |
| Installer Sessions | 3 | Start, extend, close |
| Learn Controls | 12 | Uno por tipo de control |
| Photocells | 4 | Pair open/close, test open/close |
| Advanced | 7 | Factory reset, clear RF, etc. |
| Device Users | 4 | List, invite, revoke, change role |
| Groups | 7 | CRUD + devices + command |
| Events | 1 | GET con paginación |
| Provisioning | 1 | Register post-BLE |
| Support | 2 | Get contact, create request |
| Settings | 5 | Profile, change password, update profile, photo upload/delete |
| Notifications | 7 | Register token, list, mark read, preferences |
| System | 2 | Health, WebSocket |
| **TOTAL** | **~70** | — |

---

## 11. Diferencias Clave: Backend Actual vs Propuesto

| Aspecto | Actual | Propuesto |
|---|---|---|
| Comandos MQTT | `OPEN`, `CLOSE`, `PAUSE` (formato propio) | `AC: OPEN`, `AC: CLOSE`, `AC: stop` (formato Daniel) |
| Sesiones installer | No existen | IS/CS/AS automáticas |
| Parámetros SE/GE | No existen | Mapeo completo 20+ campos |
| Aprender controles | No existe | 12 endpoints learn/* |
| Fotoceldas | No existe | 4 endpoints photocell/* |
| Opciones avanzadas | No existe | 7 endpoints advanced/* |
| WebSocket | Existe pero roto | Rebuild limpio |
| Device online check | Polling BD cada 10s | Evento MQTT heartbeat directo |
| Schema BD | 40+ columnas en devices | Simplificado, params en JSONB |
| Módulos | 13 módulos (muchos vacíos) | 6 módulos funcionales |

---

## 12. Estándares de API

### 12.1 Formato de Error
Todas las respuestas de error siguen este formato:
```json
{
  "error": {
    "code": "DEVICE_NOT_FOUND",
    "message": "El dispositivo no fue encontrado",
    "details": {} // opcional, info adicional
  }
}
```

Códigos HTTP:
- 400 Bad Request — validación fallida
- 401 Unauthorized — token inválido o expirado
- 403 Forbidden — sin permisos
- 404 Not Found — recurso no existe
- 409 Conflict — duplicado (email, serial, etc.)
- 422 Unprocessable Entity — datos válidos pero lógica falla
- 429 Too Many Requests — rate limit
- 500 Internal Server Error

### 12.2 Paginación
Endpoints que devuelven listas usan cursor-based pagination:
```
GET /api/v1/notifications?limit=20&cursor=abc123
```

Response:
```json
{
  "data": [...],
  "pagination": {
    "cursor": "next_cursor_value",
    "has_more": true,
    "total": 150
  }
}
```

### 12.3 Autenticación (JWT)
- Login devuelve access_token (15 min) + refresh_token (30 días)
- Access token en header: Authorization: Bearer <token>
- Refresh: POST /api/v1/auth/refresh con refresh_token en body
- Tokens son JWT RS256 con claims: {sub: user_id, email, iat, exp}
- Revocación: logout invalida refresh_token en Redis blacklist

### 12.4 Rate Limiting
- Auth endpoints: 5 req/min por IP
- API general: 100 req/min por usuario
- Commands (MQTT): 10 req/min por dispositivo
- Headers: X-RateLimit-Limit, X-RateLimit-Remaining, X-RateLimit-Reset

### 12.5 File Uploads
- Endpoint: POST con Content-Type: multipart/form-data
- Fotos de perfil: max 5MB, formatos jpg/png/webp
- Fotos de dispositivo: max 10MB, formatos jpg/png/webp
- Storage: S3-compatible (DO Spaces o MinIO)
- URLs públicas: CDN con signed URLs (24h expiry)

### 12.6 Versionamiento
- Prefijo /api/v1/ en todas las rutas
- Breaking changes incrementan versión mayor
- Deprecation: header Warning con fecha de sunset
- Mínimo 6 meses de soporte para versiones deprecadas

---

## 13. Notas de Arquitectura

### 13.1 Dos Aplicaciones Separadas
El ecosistema VITA tiene dos apps móviles:

| | App Consumer (VITA) | App Instalador |
|--|---|---|
| Público | Usuario final | Técnico/instalador |
| Funciones | Control, monitoreo, compartir acceso, notificaciones | Instalación física, configuración avanzada, sesiones IS/CS/AS, aprender controles, fotoceldas |
| Estado | En desarrollo | Solo diseños |

El backend sirve a ambas apps con el mismo API, diferenciando por roles (user vs installer).

### 13.2 Re-Provisioning BLE (Seguridad)
Para re-emparejar un dispositivo VITA:
1. El usuario presiona un **botón físico** en el dispositivo → activa modo re-pairing
2. Solo el **owner** del dispositivo puede iniciar re-emparejamiento desde el app
3. El VITA solo acepta conexiones BLE cuando está en modo pairing (timeout 5 min)
4. Si el dispositivo fue reseteado de fábrica, se trata como dispositivo nuevo

**Razón de seguridad:** Evitar que un tercero re-configure el dispositivo y abra el portón de alguien más. El acceso físico al botón es requisito obligatorio.

Pendiente: Definir protocolo exacto con Daniel (firmware).

---

## Apéndice A: Mapeo Cur_MotorStatus ↔ Flutter DeviceStatus

| Firmware (Cur_MotorStatus) | Flutter (DeviceStatus) |
|---|---|
| 0 = Open | ready (cuando abierto) |
| 1 = Opening | opening |
| 2 = Closed | ready (cuando cerrado) |
| 3 = Closing | closing |
| 4 = Undetermined (Stopped) | paused |
| 5 = Pedestrian Open | ready (peatonal) |
| 6 = Pedestrian Opening | opening (peatonal) |

**Nota:** El Flutter usa `DeviceStatus.ready` tanto para abierto como cerrado. Se necesita un campo adicional `isOpen: bool` para diferenciar en la UI.

## Apéndice B: Mapeo motor_Type ↔ Flutter DeviceType

| Firmware (motor_Type) | Flutter (DeviceType) |
|---|---|
| 0 = piston | gate |
| 1 = rack | gate |
| 2 = curtain | door |
| 3 = barrier | barrier |
| 4 = sliding_door | door |
| 5 = electronic_door | door |
| 6 = other | other |

---

*Documento generado por Orus. Pendiente revisión de Andrey y Daniel (firmware).*

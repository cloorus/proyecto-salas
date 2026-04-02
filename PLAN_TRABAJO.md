# 📋 Plan de Trabajo Detallado - Proyecto Salas

**Objetivo:** Completar WebApp + Backend Phase 2 para tener sistema funcional end-to-end  
**Estrategia:** Orus planifica → ClaudeCode Local codifica  
**Fecha:** 2 Abril 2026

---

## 🎯 Meta Final

**Sistema completamente funcional:**
- ✅ Backend API con todos los endpoints Phase 2
- ✅ WebApp con 11 pantallas operativas
- ✅ MQTT bridge activo
- ✅ Pruebas E2E pasando
- ✅ Documentación actualizada

---

## 📊 Estado Actual (Baseline)

### Backend API:
- ✅ Phase 1: Auth + CRUD devices (100%)
- 🚧 Phase 2: Parámetros, sesiones, MQTT (30%)
- ⏳ Phase 3: Sharing, groups, FCM (0%)

### WebApp:
- ✅ 3 pantallas verificadas: Login, Lista, Detalle
- ❓ 7 pantallas estado desconocido (código en servidor)
- ⚠️ Código NO en monorepo

### Cobertura API:
- 48/57 tests pasados (84%)
- 7 endpoints faltantes
- 2 validaciones parciales

---

## 🚀 Fase 1: Sincronizar WebApp al Monorepo

**Objetivo:** Traer código real del servidor al monorepo para tener control total

### Tarea 1.1: Copiar código del servidor
**Responsable:** Orus (automático)  
**Acción:**
```bash
ssh root@157.245.1.231 "cd /opt/vita-api/static/test-app && tar czf - ." | \
  tar xzf - -C proyecto-salas/webapp-server/
```

**Verificar:**
- Estructura completa copiada
- `js/screens/` con todos los archivos
- `css/`, `images/`
- `index.html`

**Resultado esperado:**
- `webapp-server/` con código real
- Comparar con `webapp/` (docs)
- Identificar discrepancias

---

### Tarea 1.2: Inventario de pantallas reales
**Responsable:** Orus (análisis)  
**Acción:**
1. Listar archivos en `js/screens/`
2. Verificar cada pantalla tiene:
   - Script tag en `index.html`
   - Ruta en `app.js`
   - CSS en `app.css` o `screens.css`
3. Probar cada ruta manualmente

**Checklist:**
```
[ ] login.js → /#/login
[ ] devices.js → /#/devices
[ ] device-detail.js → /#/devices/:id
[ ] device-edit.js → /#/devices/:id/edit
[ ] device-params.js → /#/devices/:id/params
[ ] device-users.js → /#/devices/:id/users
[ ] groups.js → /#/groups, /#/groups/:id
[ ] device-events.js → /#/devices/:id/events
[ ] notifications.js → /#/notifications
[ ] support.js → /#/support, /#/support/:id
[ ] settings.js → /#/settings
```

**Output:** Documento `WEBAPP_INVENTORY.md` con estado de cada pantalla

---

### Tarea 1.3: Identificar gaps
**Responsable:** Orus  
**Acción:**
1. Comparar pantallas existentes vs requeridas
2. Listar funcionalidades faltantes por pantalla
3. Priorizar según flujo crítico

**Criterios prioridad:**
- **P0 (Crítico):** Login, dispositivos, comandos básicos
- **P1 (Alto):** Parámetros, usuarios compartidos
- **P2 (Medio):** Grupos, eventos
- **P3 (Bajo):** Soporte, settings

**Output:** `GAPS_ANALYSIS.md`

---

## 🚀 Fase 2: Completar Backend Phase 2

**Objetivo:** Implementar endpoints faltantes + MQTT bridge

### Tarea 2.1: Sesiones Instalador (IS/AS/CS)
**Archivo:** `backend-api/app/routers/installer_sessions.py`  
**Prioridad:** P1 (Alto)

#### Endpoints a implementar:

**POST /api/v1/devices/{id}/session/start**
```python
# Input:
{
  "device_id": "uuid",
  "installer_id": "uuid"  # from JWT
}

# Output:
{
  "session_id": "uuid",
  "session_token": "jwt-hash",
  "expires_at": "2026-04-02T16:00:00Z",
  "timeout_minutes": 30
}

# Lógica:
1. Validar que user.role == 'installer'
2. Verificar device existe y no tiene sesión activa
3. Crear installer_session en DB
4. Generar session_token JWT (claims: session_id, device_id, installer_id, exp)
5. Publicar MQTT: {"AC":"IS","idInstaller":"token"}
6. Retornar session info
```

**POST /api/v1/devices/{id}/session/extend**
```python
# Input:
{
  "session_token": "jwt-hash"
}

# Output:
{
  "session_id": "uuid",
  "expires_at": "2026-04-02T16:15:00Z",  # +15 min
  "extended": true
}

# Lógica:
1. Validar session_token (JWT)
2. Verificar sesión existe y no ha expirado
3. Extender expires_at (+15 min)
4. Publicar MQTT: {"AC":"AS","idInstaller":"token"}
5. Retornar new expiry
```

**POST /api/v1/devices/{id}/session/end**
```python
# Input:
{
  "session_token": "jwt-hash"
}

# Output:
{
  "session_id": "uuid",
  "closed_at": "2026-04-02T15:45:00Z"
}

# Lógica:
1. Validar session_token
2. Marcar sesión como closed_at = now()
3. Publicar MQTT: {"AC":"CS","idInstaller":"token"}
4. Retornar confirmation
```

**GET /api/v1/devices/{id}/session/status**
```python
# Output:
{
  "active": true,
  "session_id": "uuid",
  "installer_id": "uuid",
  "started_at": "2026-04-02T15:15:00Z",
  "expires_at": "2026-04-02T15:45:00Z",
  "time_remaining_seconds": 1800
}

# Lógica:
1. Buscar sesión activa del dispositivo
2. Verificar no ha expirado (expires_at > now)
3. Si expirada, marcar como closed automáticamente
4. Retornar estado
```

#### Modelo DB:
```python
# tabla: installer_sessions
id: uuid (PK)
device_id: uuid (FK devices)
installer_id: uuid (FK users)
session_token: text (JWT hash)
started_at: timestamp
expires_at: timestamp
closed_at: timestamp (nullable)
extended_count: int (cuántas veces se extendió)
```

#### Tests unitarios:
```python
# test_installer_sessions.py
def test_start_session_success():
    # Arrange: installer user + device
    # Act: POST /session/start
    # Assert: 200, session_id, token, expires_at

def test_start_session_non_installer():
    # Arrange: user.role != 'installer'
    # Act: POST /session/start
    # Assert: 403 "Only installers can start sessions"

def test_start_session_already_active():
    # Arrange: device con sesión activa
    # Act: POST /session/start
    # Assert: 409 "Device already has an active session"

def test_extend_session_success():
    # Arrange: sesión activa
    # Act: POST /session/extend
    # Assert: 200, new expires_at (+15 min)

def test_extend_session_expired():
    # Arrange: sesión expirada
    # Act: POST /session/extend
    # Assert: 400 "Session has expired"

def test_end_session_success():
    # Arrange: sesión activa
    # Act: POST /session/end
    # Assert: 200, closed_at

def test_status_active():
    # Arrange: sesión activa
    # Act: GET /session/status
    # Assert: 200, active=true, time_remaining

def test_status_expired():
    # Arrange: sesión expirada (mock now + 31 min)
    # Act: GET /session/status
    # Assert: 200, active=false, closed_at auto-set

def test_auto_close_on_timeout():
    # Arrange: sesión con expires_at en pasado
    # Act: Background job check_expired_sessions()
    # Assert: closed_at set, MQTT {"AC":"CS"} published
```

---

### Tarea 2.2: Parámetros VITA (GE/SE)
**Archivo:** `backend-api/app/routers/device_params_improved.py`  
**Prioridad:** P1 (Alto)

#### Endpoints a implementar:

**GET /api/v1/devices/{id}/params**
```python
# Output:
{
  "device_id": "uuid",
  "parameters": {
    "dP": {"value": "1", "updated_at": "2026-04-02T15:00:00Z"},
    "P5": {"value": "0", "updated_at": null},
    "tC": {"value": "30", "updated_at": "2026-04-02T14:30:00Z"},
    ...
  },
  "last_sync": "2026-04-02T15:00:00Z"
}

# Lógica:
1. Buscar parámetros en cache Redis (key: device:{id}:params, TTL 5 min)
2. Si no existe, retornar valores por defecto del schema
3. Retornar todos los parámetros con valores actuales
```

**GET /api/v1/devices/{id}/params/{key}**
```python
# Output:
{
  "key": "tC",
  "value": "30",
  "name": "Tiempo de cierre auto",
  "type": "int",
  "range": {"min": 5, "max": 120},
  "unit": "segundos",
  "updated_at": "2026-04-02T14:30:00Z"
}

# Lógica:
1. Buscar parámetro en cache Redis
2. Si no existe, buscar en schema (valor default)
3. Retornar info completa
```

**PUT /api/v1/devices/{id}/params**
```python
# Input:
{
  "parameters": {
    "tC": "45",
    "AP": "30",
    "FF": "60"
  }
}

# Output:
{
  "updated": 3,
  "results": {
    "tC": {"status": "success", "old_value": "30", "new_value": "45"},
    "AP": {"status": "success", "old_value": "25", "new_value": "30"},
    "FF": {"status": "success", "old_value": "50", "new_value": "60"}
  }
}

# Lógica:
1. Validar sesión instalador activa (requerido para SE)
2. Validar cada parámetro contra schema (tipo, rango)
3. Por cada parámetro:
   - Publicar MQTT: {"AC":"SE","PA":"tC","VA":"45","idInstaller":"token"}
   - Esperar respuesta (timeout 10s)
   - Si OK, actualizar Redis cache
4. Retornar resumen de cambios
```

**POST /api/v1/devices/{id}/params/refresh**
```python
# Output:
{
  "refreshed": 20,
  "parameters": {
    "dP": {"value": "1", "source": "device"},
    "tC": {"value": "45", "source": "device"},
    ...
  },
  "synced_at": "2026-04-02T15:05:00Z"
}

# Lógica:
1. Por cada parámetro en schema:
   - Publicar MQTT: {"AC":"GE","PA":"dP"}
   - Esperar respuesta (timeout 10s)
   - Actualizar Redis cache con valor recibido
2. Retornar todos los parámetros actualizados
```

**GET /api/v1/devices/{id}/params/fields**
```python
# Output (schema estático):
{
  "fields": [
    {
      "key": "tC",
      "name": "Tiempo de cierre auto",
      "description": "Segundos antes de cerrar automáticamente",
      "type": "int",
      "range": {"min": 5, "max": 120},
      "unit": "segundos",
      "default": 30,
      "category": "Motor",
      "requires_installer": true
    },
    ...
  ]
}

# Lógica:
1. Retornar schema hardcoded con 20+ parámetros
2. Cada parámetro tiene: key, name, type, range, default, category
```

#### Schema de parámetros (20+):
```python
PARAMS_SCHEMA = {
    # Motor
    "dP": {"name": "Dirección motor", "type": "bool", "default": 0, "category": "Motor"},
    "P5": {"name": "Soft stop", "type": "bool", "default": 1, "category": "Motor"},
    "FF": {"name": "Fuerza cierre", "type": "int", "range": [10,100], "unit": "%", "default": 50, "category": "Motor"},
    "FL": {"name": "Fuerza apertura", "type": "int", "range": [10,100], "unit": "%", "default": 50, "category": "Motor"},
    
    # Límites
    "LC": {"name": "Límite de ciclos", "type": "int", "range": [0,999999], "default": 0, "category": "Límites"},
    "CA": {"name": "Ciclos actuales", "type": "int", "readonly": true, "category": "Límites"},
    
    # Auto-cierre
    "tC": {"name": "Tiempo cierre auto", "type": "int", "range": [5,120], "unit": "s", "default": 30, "category": "Auto-cierre"},
    "AP": {"name": "Apertura peatonal", "type": "int", "range": [10,100], "unit": "%", "default": 30, "category": "Auto-cierre"},
    
    # Fotoceldas
    "FE": {"name": "Fotoceldas habilitadas", "type": "bool", "default": 1, "category": "Fotoceldas"},
    "batteryPhotoOpen": {"name": "Batería foto apertura", "type": "int", "readonly": true, "unit": "%", "category": "Fotoceldas"},
    "batteryPhotoClose": {"name": "Batería foto cierre", "type": "int", "readonly": true, "unit": "%", "category": "Fotoceldas"},
    
    # Identificación
    "labelVita": {"name": "Nombre dispositivo", "type": "string", "max_length": 32, "default": "VITA", "category": "Identificación"},
    
    # Red
    "ssid": {"name": "SSID WiFi", "type": "string", "max_length": 32, "category": "Red", "sensitive": true},
    "password": {"name": "Password WiFi", "type": "string", "max_length": 64, "category": "Red", "sensitive": true, "write_only": true},
    
    # Otros
    "Co": {"name": "Modo configuración", "type": "bool", "default": 0, "category": "Sistema"},
    "LE": {"name": "LED estado", "type": "bool", "default": 1, "category": "Sistema"},
    "bL": {"name": "Bloqueo remoto", "type": "bool", "default": 0, "category": "Seguridad"},
    
    # Mantenimiento
    "MC": {"name": "Ciclos para mantenimiento", "type": "int", "range": [100,10000], "default": 1000, "category": "Mantenimiento"},
    "Maintenance_Count": {"name": "Ciclos desde mantenimiento", "type": "int", "readonly": true, "category": "Mantenimiento"},
    
    # Firmware
    "FV": {"name": "Firmware version", "type": "string", "readonly": true, "category": "Sistema"}
}
```

#### Cache Redis:
```python
# Key: device:{device_id}:params
# Value: JSON con todos los parámetros
# TTL: 300 segundos (5 min)

# Estructura:
{
  "dP": {"value": "1", "updated_at": 1712068800},
  "tC": {"value": "45", "updated_at": 1712068900},
  ...
}
```

#### Tests unitarios:
```python
def test_get_params_from_cache():
    # Arrange: Redis cache populated
    # Act: GET /params
    # Assert: 200, retorna cached values

def test_get_params_cache_miss():
    # Arrange: Redis empty
    # Act: GET /params
    # Assert: 200, retorna defaults del schema

def test_get_param_single():
    # Arrange: parámetro en cache
    # Act: GET /params/tC
    # Assert: 200, {key, value, name, type, range}

def test_put_params_without_session():
    # Arrange: no sesión instalador
    # Act: PUT /params {"tC": "45"}
    # Assert: 403 "Installer session required"

def test_put_params_with_session():
    # Arrange: sesión activa + MQTT mock
    # Act: PUT /params {"tC": "45"}
    # Assert: 200, updated=1, MQTT SE published

def test_put_params_invalid_range():
    # Arrange: sesión activa
    # Act: PUT /params {"tC": "200"}  # max=120
    # Assert: 422 "Value 200 exceeds maximum 120"

def test_put_params_invalid_type():
    # Arrange: sesión activa
    # Act: PUT /params {"tC": "abc"}  # type=int
    # Assert: 422 "Expected int, got string"

def test_refresh_params_from_device():
    # Arrange: MQTT mock returns values
    # Act: POST /params/refresh
    # Assert: 200, refreshed=20, cache updated

def test_get_fields_schema():
    # Act: GET /params/fields
    # Assert: 200, fields array with 20+ params
```

---

### Tarea 2.3: MQTT Bridge Activation
**Archivos:** `backend-api/app/mqtt/client.py`, `app/main.py`  
**Prioridad:** P0 (Crítico)

#### Objetivo:
Activar conexión MQTT al startup y manejar mensajes pub/sub

#### Implementación:

**1. MQTT Client Singleton**
```python
# app/mqtt/client.py
import aiomqtt
import asyncio
from app.config import settings

class MQTTClient:
    def __init__(self):
        self.client = None
        self.connected = False
        self.pending_requests = {}  # {request_id: asyncio.Future}
    
    async def connect(self):
        """Conectar al broker EMQX"""
        try:
            self.client = aiomqtt.Client(
                hostname=settings.MQTT_BROKER,
                port=settings.MQTT_PORT,
                username=settings.MQTT_USER,
                password=settings.MQTT_PASS
            )
            await self.client.__aenter__()
            self.connected = True
            asyncio.create_task(self._listen())
            print(f"MQTT connected to {settings.MQTT_BROKER}:{settings.MQTT_PORT}")
        except Exception as e:
            print(f"MQTT connection failed: {e}")
            self.connected = False
    
    async def _listen(self):
        """Escuchar mensajes del broker"""
        async with self.client.messages() as messages:
            await self.client.subscribe("vita/+/response")
            await self.client.subscribe("vita/+/heartbeat")
            
            async for message in messages:
                payload = json.loads(message.payload.decode())
                topic = message.topic
                
                if "/response" in topic:
                    await self._handle_response(payload)
                elif "/heartbeat" in topic:
                    await self._handle_heartbeat(payload)
    
    async def publish_command(self, device_serial: str, command: dict, wait_response=True, timeout=10):
        """Publicar comando y esperar respuesta"""
        request_id = str(uuid.uuid4())
        command["_request_id"] = request_id
        
        topic = f"vita/{device_serial}/command"
        await self.client.publish(topic, json.dumps(command))
        
        if wait_response:
            future = asyncio.Future()
            self.pending_requests[request_id] = future
            try:
                result = await asyncio.wait_for(future, timeout)
                return result
            except asyncio.TimeoutError:
                del self.pending_requests[request_id]
                raise Exception(f"MQTT timeout after {timeout}s")
        
        return {"status": "sent"}
    
    async def _handle_response(self, payload: dict):
        """Procesar respuesta del dispositivo"""
        request_id = payload.get("_request_id")
        if request_id and request_id in self.pending_requests:
            future = self.pending_requests.pop(request_id)
            future.set_result(payload)
    
    async def _handle_heartbeat(self, payload: dict):
        """Procesar heartbeat del dispositivo"""
        device_serial = payload.get("idVita")
        # Actualizar devices.last_seen, devices.status = "online"
        # Guardar en Redis device:{serial}:heartbeat con TTL 60s
        pass

# Singleton global
mqtt_client = MQTTClient()
```

**2. Startup en main.py**
```python
# app/main.py
from app.mqtt.client import mqtt_client

@app.on_event("startup")
async def startup_event():
    """Iniciar servicios al arrancar"""
    # Conectar DB
    await database.connect()
    
    # Conectar MQTT
    try:
        await mqtt_client.connect()
    except Exception as e:
        print(f"Warning: MQTT not available - {e}")
        # No bloquea startup, API sigue funcionando
```

**3. Health Check actualizado**
```python
# app/routers/health.py
@router.get("/health")
async def health_check():
    status = "healthy"
    
    # Check DB
    db_status = await check_database()
    
    # Check Redis
    redis_status = await check_redis()
    
    # Check MQTT
    mqtt_status = "connected" if mqtt_client.connected else "disconnected"
    
    if mqtt_status == "disconnected":
        status = "degraded"
    
    return {
        "status": status,
        "services": {
            "database": db_status,
            "redis": redis_status,
            "mqtt": mqtt_status
        }
    }
```

#### Tests:
```python
def test_mqtt_connect():
    # Arrange: broker disponible
    # Act: await mqtt_client.connect()
    # Assert: connected=True

def test_mqtt_publish_command():
    # Arrange: cliente conectado
    # Act: await publish_command("VITA123", {"AC":"OPEN"})
    # Assert: mensaje publicado

def test_mqtt_wait_response():
    # Arrange: cliente conectado + mock response
    # Act: result = await publish_command("VITA123", {"AC":"OPEN"}, wait_response=True)
    # Assert: result = {"AC":"OPEN","result":"OK"}

def test_mqtt_timeout():
    # Arrange: cliente conectado + no response
    # Act: publish_command con timeout=2
    # Assert: raises TimeoutError after 2s

def test_heartbeat_updates_status():
    # Arrange: device offline
    # Act: MQTT heartbeat received
    # Assert: device.status → "online", last_seen updated
```

---

### Tarea 2.4: Learn Controls (RF)
**Archivo:** `backend-api/app/routers/learn_controls.py`  
**Prioridad:** P2 (Medio)

#### Endpoints:
```python
POST /api/v1/devices/{id}/learn/{control_type}

# control_type: Ct, CP, CL, Cr, Cb, Ai, AE, AA, At

# Input:
{
  "session_token": "jwt-hash"
}

# Output:
{
  "status": "waiting",  # waiting | success | timeout | error
  "control_type": "Ct",
  "message": "Press remote button now",
  "timeout_seconds": 30,
  "rf_code": "A1B2C3D4"  # solo si success
}

# Lógica:
1. Validar sesión instalador activa
2. Publicar MQTT: {"AC":"Ct","idInstaller":"token"}
3. Retornar inmediatamente status="waiting"
4. Dispositivo responde en 30s (o timeout)
5. WebSocket/polling para notificar resultado al frontend
```

#### Tests:
```python
def test_learn_control_success():
    # Arrange: sesión activa + MQTT mock success
    # Act: POST /learn/Ct
    # Assert: 200, status=waiting, luego success con rf_code

def test_learn_control_timeout():
    # Arrange: sesión activa + no respuesta MQTT
    # Act: POST /learn/Ct
    # Assert: 200, status=timeout after 30s

def test_learn_control_no_session():
    # Arrange: no sesión
    # Act: POST /learn/Ct
    # Assert: 403 "Installer session required"
```

---

### Tarea 2.5: Photocells
**Archivo:** `backend-api/app/routers/photocells.py`  
**Prioridad:** P2 (Medio)

#### Endpoints:
```python
POST /api/v1/devices/{id}/photocells/pair/{type}
# type: open | close

POST /api/v1/devices/{id}/photocells/test

GET /api/v1/devices/{id}/photocells/status
# Retorna: battery levels, signal strength
```

#### Tests similares a learn_controls.

---

## 🚀 Fase 3: Completar WebApp Frontend

**Objetivo:** Implementar/completar 11 pantallas funcionales

### Tarea 3.1: Verificar pantallas existentes
**Responsable:** Orus (verificación manual)

Probar cada ruta:
1. http://157.245.1.231:8000/static/test-app/#/login
2. /#/devices
3. /#/devices/1
4. /#/devices/1/edit
5. /#/devices/1/params
6. /#/devices/1/users
7. /#/groups
8. /#/devices/1/events
9. /#/notifications
10. /#/support
11. /#/settings

**Registrar:** ✅ funciona | ❌ error | 🚧 incompleto

---

### Tarea 3.2: Completar pantallas faltantes
**Responsable:** ClaudeCode Local

Por cada pantalla faltante o incompleta:

**Estructura estándar:**
```javascript
// js/screens/pantalla.js
const PantallaScreen = {
  async render() {
    return `
      <div class="screen-container">
        <div class="app-header">
          <button class="back-btn">←</button>
          <h1>Título</h1>
        </div>
        <div class="content">
          <!-- Contenido -->
        </div>
      </div>
    `;
  },
  
  async init() {
    // Event listeners
    // Cargar datos del API
  }
};

window.PantallaScreen = PantallaScreen;
```

**Checklist por pantalla:**
- [ ] Archivo `js/screens/nombre.js` creado
- [ ] Script tag en `index.html`
- [ ] Ruta en `app.js` handleRoute()
- [ ] Caso en `app.js` loadScreen()
- [ ] CSS en `app.css` o `screens.css`
- [ ] API calls funcionan
- [ ] Loading states
- [ ] Error handling
- [ ] Mobile-responsive
- [ ] BGnius theme colors

---

### Tarea 3.3: Integración MQTT (WebSocket o polling)
**Responsable:** ClaudeCode Local

**Opción 1: WebSocket**
```javascript
// js/mqtt-client.js
const MQTTClient = {
  ws: null,
  
  connect() {
    this.ws = new WebSocket('ws://157.245.1.231:8000/ws');
    this.ws.onmessage = (event) => {
      const data = JSON.parse(event.data);
      this.handleMessage(data);
    };
  },
  
  subscribe(topic, callback) {
    // Suscribirse a topic específico
  },
  
  handleMessage(data) {
    // Router mensajes a pantallas
  }
};
```

**Opción 2: Polling**
```javascript
// Polling cada 5s para device status
setInterval(async () => {
  const status = await API.getDeviceStatus(deviceId);
  updateUI(status);
}, 5000);
```

---

## 🚀 Fase 4: Testing E2E

**Objetivo:** Validar flujos completos funcionan

### Casos de uso críticos:

#### CU-01: Login exitoso
**Precondición:** Usuario existe  
**Pasos:**
1. Ir a /#/login
2. Ingresar admin@bgnius.com / Test1234!
3. Click "Iniciar Sesión"

**Resultado esperado:**
- Redirect a /#/devices
- Token guardado en localStorage
- Header muestra usuario logueado

---

#### CU-02: Ver lista de dispositivos
**Precondición:** Usuario autenticado  
**Pasos:**
1. GET /api/v1/devices

**Resultado esperado:**
- Lista de dispositivos
- Cada card muestra: foto, nombre, ubicación, status
- Status: verde (online) o gris (offline)

---

#### CU-03: Enviar comando OPEN
**Precondición:** Usuario autenticado + dispositivo online  
**Pasos:**
1. Ir a /#/devices/1
2. Click botón "ABRIR" (verde)
3. POST /api/v1/devices/1/command {"action":"OPEN"}

**Resultado esperado:**
- Botón muestra loading
- Comando enviado vía MQTT
- Dispositivo responde OK
- UI muestra confirmación "Portón abriendo"
- Botón vuelve a estado normal

---

#### CU-04: Modificar parámetro (instalador)
**Precondición:** Usuario instalador + sesión activa  
**Pasos:**
1. POST /api/v1/devices/1/session/start
2. Ir a /#/devices/1/params
3. Cambiar "Tiempo de cierre" de 30 a 45
4. Click "Guardar"
5. PUT /api/v1/devices/1/params {"tC":"45"}

**Resultado esperado:**
- MQTT SE publicado
- Dispositivo confirma cambio
- Redis cache actualizado
- UI muestra "Parámetro actualizado"

---

#### CU-05: Compartir dispositivo
**Precondición:** Owner + otro usuario existe  
**Pasos:**
1. Ir a /#/devices/1/users
2. Click "Invitar Usuario"
3. Ingresar email: amigo@example.com
4. Seleccionar rol: "user"
5. Click "Enviar"
6. POST /api/v1/devices/1/users

**Resultado esperado:**
- Usuario agregado a device_users
- Email notificación enviado
- UI muestra nuevo usuario en lista

---

### Suite de tests automatizados:
```bash
# backend-api/tests/
pytest -v

# webapp (Playwright o Cypress)
npm test
```

---

## 🚀 Fase 5: Documentación

### Tarea 5.1: Actualizar docs/
- `PLAN.md` → marcar tareas completadas
- `ARCHITECTURE.md` → actualizar diagramas si cambiaron
- `PROTOCOL.md` → agregar nuevos comandos si hay

### Tarea 5.2: Crear USAGE.md
Guía de uso para cada pantalla de la webapp

### Tarea 5.3: Crear API_REFERENCE.md
Documentación completa de todos los endpoints con ejemplos

---

## 📊 Métricas de Éxito

### Backend:
- [ ] 57/57 tests API pasando (100%)
- [ ] MQTT status: "connected"
- [ ] Health check: "healthy"
- [ ] Coverage: >80%

### WebApp:
- [ ] 11/11 pantallas funcionales
- [ ] 0 errores JavaScript en console
- [ ] Mobile-responsive (320px+)
- [ ] Loading <2s por pantalla

### E2E:
- [ ] 5/5 casos de uso críticos pasando
- [ ] 0 bugs bloqueantes

---

## 🎯 Entregables

1. **Backend completado:**
   - ✅ Phase 2 implementado (100%)
   - ✅ MQTT activo
   - ✅ Tests pasando

2. **WebApp completada:**
   - ✅ 11 pantallas operativas
   - ✅ Código en monorepo (`webapp-final/`)
   - ✅ Deploy actualizado en servidor

3. **Documentación:**
   - ✅ USAGE.md
   - ✅ API_REFERENCE.md
   - ✅ Tests coverage report

4. **Demo funcional:**
   - ✅ Video screencast de 5 casos de uso
   - ✅ README con instrucciones deployment

---

## 📅 Timeline Estimado

| Fase | Duración | Inicio | Fin |
|------|----------|--------|-----|
| Fase 1: Sync WebApp | 1 día | 2 Abr | 3 Abr |
| Fase 2: Backend Phase 2 | 3-4 días | 3 Abr | 7 Abr |
| Fase 3: WebApp Frontend | 2-3 días | 7 Abr | 10 Abr |
| Fase 4: Testing E2E | 1-2 días | 10 Abr | 12 Abr |
| Fase 5: Documentación | 1 día | 12 Abr | 13 Abr |
| **TOTAL** | **8-11 días** | 2 Abr | 13 Abr |

**Nota:** Tiempos asumen trabajo full-time de ClaudeCode Local

---

## 🔄 Flujo de Trabajo

### Cada tarea:
1. **Orus:** Define especificación detallada (este documento)
2. **ClaudeCode Local:** Lee spec, implementa código
3. **ClaudeCode Local:** Ejecuta tests, verifica funciona
4. **ClaudeCode Local:** Git commit + push
5. **Orus:** Revisa commit, valida cumple spec
6. **Si OK:** Siguiente tarea
7. **Si NO:** Orus ajusta spec, ClaudeCode corrige

---

## 📝 Convenciones de Commits

```
feat(backend): implement installer sessions endpoints
fix(webapp): correct device_type field name
test(backend): add 8 tests for installer sessions
docs(readme): update API reference with new endpoints
refactor(mqtt): extract client to singleton
```

---

**Este plan está listo para ejecución.**  
**Siguiente paso:** ClaudeCode Local arranca con Fase 1, Tarea 1.1

---

**Creado:** 2 Abril 2026 15:17 UTC  
**Por:** Orus 🐾  
**Para:** ClaudeCode Local

# 📡 Protocolo MQTT VITA - Backend ↔ Dispositivo

**Autor Firmware:** Daniel  
**Versión Protocolo:** 1.0  
**Broker:** EMQX 104.131.36.215:1883

---

## Topics

| Topic | Dirección | Descripción |
|-------|-----------|-------------|
| `vita/{serial}/command` | Backend → Device | Comandos y configuraciones |
| `vita/{serial}/response` | Device → Backend | Respuestas y estados |
| `vita/{serial}/heartbeat` | Device → Backend | Keepalive (cada 30s) |

**Ejemplo:** Dispositivo con serial `VITA123456`
- Subscribe: `vita/VITA123456/command`
- Publish: `vita/VITA123456/response`, `vita/VITA123456/heartbeat`

---

## Formato de Mensajes

### Estructura General
```json
{
  "AC": "COMANDO",
  "PA": "parametro",      // opcional
  "VA": "valor",          // opcional
  "idInstaller": "token"  // solo para sesiones instalador
}
```

### Respuestas del Dispositivo
```json
{
  "AC": "COMANDO",
  "idVita": "VITA123456",
  "result": "OK|ERROR",
  "error": "descripción",           // solo si ERROR
  "Cur_MotorStatus": 0,             // estado motor actual
  "Total_Cycles": 1234,             // contador ciclos
  "Maintenance_Count": 500,         // ciclos desde mantenimiento
  "FV": "2.1.3",                    // firmware version
  "batteryPhotoOpen": 85,           // % batería fotocelda apertura
  "batteryPhotoClose": 90           // % batería fotocelda cierre
}
```

---

## Comandos de Control Motor

### Básicos

| Comando | Acción | Parámetros | Ejemplo |
|---------|--------|------------|---------|
| `OPEN` | Abrir portón | - | `{"AC":"OPEN"}` |
| `CLOSE` | Cerrar portón | - | `{"AC":"CLOSE"}` |
| `STOP` | Detener motor | - | `{"AC":"STOP"}` |
| `OCS` | Abrir-Cerrar-Stop (secuencia) | - | `{"AC":"OCS"}` |
| `PEDESTRIAN` | Apertura peatonal (% configurado) | - | `{"AC":"PEDESTRIAN"}` |

### Auxiliares

| Comando | Acción | Parámetros | Ejemplo |
|---------|--------|------------|---------|
| `LAMP` | Toggle lámpara | - | `{"AC":"LAMP"}` |
| `RELE` | Toggle relé auxiliar | - | `{"AC":"RELE"}` |

**Estados del Motor:**
```
0 = Stopped (detenido)
1 = Opening (abriendo)
2 = Closing (cerrando)
3 = Open (totalmente abierto)
4 = Closed (totalmente cerrado)
5 = Error (falla)
6 = Paused (pausado)
```

---

## Sesiones de Instalador

### Comandos de Sesión

| Comando | Acción | Token Requerido | Timeout | Ejemplo |
|---------|--------|-----------------|---------|---------|
| `IS` | Initialize Session | Sí | 30 min | `{"AC":"IS","idInstaller":"jwt-hash"}` |
| `AS` | Amplify Session (extender) | Sí | +15 min | `{"AC":"AS","idInstaller":"jwt-hash"}` |
| `CS` | Close Session | Sí | - | `{"AC":"CS","idInstaller":"jwt-hash"}` |

**Flujo típico:**
```
1. Backend: POST /devices/session/start → genera token instalador
2. Backend: MQTT {"AC":"IS","idInstaller":"token123"}
3. ESP32: Valida token, activa modo instalador
4. Instalador: Configura parámetros, aprende controles (30 min)
5. Instalador: (opcional) {"AC":"AS"} para extender sesión
6. Backend: POST /devices/session/end
7. Backend: MQTT {"AC":"CS","idInstaller":"token123"}
8. ESP32: Desactiva modo instalador, vuelve a modo normal
```

**Restricciones:**
- Comandos `SE` (Set Parameter), aprendizaje RF, y config avanzada **solo funcionan con sesión activa**
- Si timeout (30 min sin `AS`), el ESP32 cierra sesión automáticamente
- Solo 1 sesión activa por dispositivo (nuevo `IS` sobrescribe anterior)

---

## Parámetros (GE/SE)

### Get Parameter (GE)
**Obtener valor de parámetro:**
```json
{"AC": "GE", "PA": "dP"}
```

**Respuesta:**
```json
{
  "AC": "GE",
  "idVita": "VITA123456",
  "PA": "dP",
  "VA": "1",
  "result": "OK"
}
```

### Set Parameter (SE)
**Configurar valor de parámetro (requiere sesión instalador):**
```json
{"AC": "SE", "PA": "tC", "VA": "45", "idInstaller": "token123"}
```

**Respuesta:**
```json
{
  "AC": "SE",
  "idVita": "VITA123456",
  "PA": "tC",
  "VA": "45",
  "result": "OK"
}
```

**Error si no hay sesión:**
```json
{
  "AC": "SE",
  "idVita": "VITA123456",
  "result": "ERROR",
  "error": "Installer session required"
}
```

---

## Lista de Parámetros Configurables

### Motor y Movimiento

| Código | Nombre | Tipo | Rango | Default | Descripción |
|--------|--------|------|-------|---------|-------------|
| `dP` | Dirección motor | bool | 0/1 | 0 | 0=normal, 1=invertido |
| `P5` | Soft stop | bool | 0/1 | 1 | Frenado suave |
| `FF` | Fuerza cierre | int | 10-100 | 50 | % potencia cierre |
| `FL` | Fuerza apertura | int | 10-100 | 50 | % potencia apertura |
| `tC` | Tiempo cierre auto | int | 5-120 | 30 | Segundos antes de cerrar |

### Límites y Carreras

| Código | Nombre | Tipo | Rango | Default | Descripción |
|--------|--------|------|-------|---------|-------------|
| `LC` | Límite de ciclos | int | 0-999999 | 0 | 0=sin límite, N=apagar tras N ciclos |
| `CA` | Ciclos actuales | int | readonly | - | Contador actual de ciclos |
| `MC` | Mantenimiento ciclos | int | 100-10000 | 1000 | Alerta de mantenimiento cada N ciclos |

### Apertura Peatonal

| Código | Nombre | Tipo | Rango | Default | Descripción |
|--------|--------|------|-------|---------|-------------|
| `AP` | Apertura peatonal | int | 10-100 | 30 | % de apertura para modo peatonal |

### Fotoceldas

| Código | Nombre | Tipo | Rango | Default | Descripción |
|--------|--------|------|-------|---------|-------------|
| `FE` | Fotoceldas habilitadas | bool | 0/1 | 1 | Activar/desactivar fotoceldas |
| `batteryPhotoOpen` | Batería foto apertura | int | readonly | - | % batería (0-100) |
| `batteryPhotoClose` | Batería foto cierre | int | readonly | - | % batería (0-100) |

### Identificación y Red

| Código | Nombre | Tipo | Rango | Default | Descripción |
|--------|--------|------|-------|---------|-------------|
| `labelVita` | Nombre dispositivo | string | 1-32 chars | VITA | Nombre personalizado |
| `setWifi` | Configurar WiFi | bool | write-only | - | Trigger para enviar credenciales |
| `ssid` | SSID WiFi | string | 1-32 chars | - | Nombre de red |
| `password` | Password WiFi | string | 8-64 chars | - | Contraseña WPA2 |

### Otros

| Código | Nombre | Tipo | Rango | Default | Descripción |
|--------|--------|------|-------|---------|-------------|
| `Co` | Modo configuración | bool | 0/1 | 0 | Modo debug (solo local) |
| `rA` | Reset alarmas | bool | write-only | - | Limpiar errores |
| `LE` | LED estado | bool | 0/1 | 1 | LED indicador encendido |
| `bL` | Bloqueo | bool | 0/1 | 0 | Bloquear comandos remotos |

---

## Aprendizaje de Controles RF

### Comandos de Aprendizaje

**Requiere sesión instalador activa**

| Comando | Acción | Ejemplo |
|---------|--------|---------|
| `Ct` | Aprender control total (OPEN+CLOSE+STOP) | `{"AC":"Ct","idInstaller":"token"}` |
| `CP` | Aprender control peatonal | `{"AC":"CP","idInstaller":"token"}` |
| `CL` | Aprender control lámpara | `{"AC":"CL","idInstaller":"token"}` |
| `Cr` | Aprender control relé | `{"AC":"Cr","idInstaller":"token"}` |
| `Cb` | Aprender control baja prioridad | `{"AC":"Cb","idInstaller":"token"}` |
| `Ai` | Iniciar modo aprendizaje | `{"AC":"Ai","idInstaller":"token"}` |
| `AE` | Eliminar todos los controles | `{"AC":"AE","idInstaller":"token"}` |
| `AA` | Aprender control alarma | `{"AC":"AA","idInstaller":"token"}` |
| `At` | Test de control (verificar señal) | `{"AC":"At","idInstaller":"token"}` |

**Flujo de aprendizaje:**
```
1. Backend: MQTT {"AC":"Ct","idInstaller":"token"}
2. ESP32: Activa receptor RF, espera señal (30 segundos timeout)
3. ESP32: Publica {"AC":"Ct","result":"WAITING","message":"Press remote button"}
4. Usuario: Presiona botón del control remoto
5. ESP32: Recibe señal RF, guarda en EEPROM
6. ESP32: Publica {"AC":"Ct","result":"OK","rfCode":"A1B2C3D4"}
```

**Error si timeout:**
```json
{
  "AC": "Ct",
  "idVita": "VITA123456",
  "result": "ERROR",
  "error": "No RF signal received (timeout 30s)"
}
```

---

## Emparejamiento de Fotoceldas

### Comandos

**Requiere sesión instalador activa**

| Comando | Acción | Ejemplo |
|---------|--------|---------|
| `PO` | Emparejar fotocelda apertura | `{"AC":"PO","idInstaller":"token"}` |
| `PC` | Emparejar fotocelda cierre | `{"AC":"PC","idInstaller":"token"}` |
| `PT` | Test fotoceldas | `{"AC":"PT","idInstaller":"token"}` |

**Flujo de emparejamiento:**
```
1. Backend: MQTT {"AC":"PO"}
2. ESP32: Activa modo pairing (LED fotocélula parpadea)
3. ESP32: Publica {"AC":"PO","result":"WAITING","message":"Press button on photocell"}
4. Usuario: Presiona botón en la fotocelda física
5. ESP32: Recibe señal, empareja
6. ESP32: Publica {"AC":"PO","result":"OK","battery":85,"signalStrength":75}
```

---

## Aprendizaje de Límites (Carreras)

### Comandos

**Requiere sesión instalador activa**

| Comando | Acción | Ejemplo |
|---------|--------|---------|
| `LL` | Learn Limits (auto-detect límites físicos) | `{"AC":"LL","idInstaller":"token"}` |
| `LO` | Learn Open limit (solo apertura) | `{"AC":"LO","idInstaller":"token"}` |
| `LC` | Learn Close limit (solo cierre) | `{"AC":"LC","idInstaller":"token"}` |

**Flujo LL (automático):**
```
1. Backend: MQTT {"AC":"LL"}
2. ESP32: Motor abre hasta detectar límite mecánico o fotocelda
3. ESP32: Guarda posición máxima apertura
4. ESP32: Publica {"AC":"LL","result":"IN_PROGRESS","step":"opening","percent":50}
5. ESP32: Motor cierra hasta detectar límite
6. ESP32: Guarda posición máxima cierre
7. ESP32: Publica {"AC":"LL","result":"OK","openLimit":3500,"closeLimit":0}
```

---

## Heartbeat

**Publicado cada 30 segundos por el ESP32:**

```json
{
  "idVita": "VITA123456",
  "status": "online",
  "Cur_MotorStatus": 0,
  "Total_Cycles": 1234,
  "uptime": 86400,
  "rssi": -65,
  "freeHeap": 123456,
  "FV": "2.1.3"
}
```

**Backend usa esto para:**
- Actualizar `devices.status` (online/offline)
- Actualizar `devices.last_seen` timestamp
- Monitorear health del dispositivo (uptime, heap, rssi)
- Trigger alertas si RSSI < -80 o freeHeap < 10KB

---

## Códigos de Error

| Código | Descripción | Acción Recomendada |
|--------|-------------|-------------------|
| `ERR_NO_SESSION` | Comando requiere sesión instalador | Iniciar sesión con IS |
| `ERR_INVALID_TOKEN` | Token instalador inválido/expirado | Renovar token |
| `ERR_MOTOR_STUCK` | Motor bloqueado | Revisar obstrucción física |
| `ERR_PHOTOCELL` | Fotocelda activada durante movimiento | Limpiar fotoceldas, revisar alineación |
| `ERR_OVERLOAD` | Sobrecarga de corriente | Revisar motor, reducir FF/FL |
| `ERR_TIMEOUT` | Operación excedió timeout | Reintentar |
| `ERR_EEPROM` | Fallo al leer/escribir EEPROM | Reiniciar dispositivo |
| `ERR_WIFI` | Sin conexión WiFi | Verificar red, reconfigurar |
| `ERR_MQTT` | Sin conexión MQTT | Verificar broker, firewall |

---

## Ejemplos de Uso

### 1. Control Básico (Usuario Final)
```bash
# Abrir portón
mosquitto_pub -h 104.131.36.215 -t vita/VITA123456/command -m '{"AC":"OPEN"}'

# Respuesta esperada en vita/VITA123456/response:
# {"AC":"OPEN","idVita":"VITA123456","result":"OK","Cur_MotorStatus":1}
```

### 2. Configurar Tiempo de Cierre (Instalador)
```bash
# Iniciar sesión
curl -X POST http://157.245.1.231:8000/api/v1/devices/123/session/start
# Response: {"session_token":"abc123...","expires_in":1800}

# Backend envía MQTT:
mosquitto_pub -t vita/VITA123456/command -m '{"AC":"IS","idInstaller":"abc123"}'

# Configurar tC=45 segundos
mosquitto_pub -t vita/VITA123456/command -m '{"AC":"SE","PA":"tC","VA":"45","idInstaller":"abc123"}'

# Cerrar sesión
curl -X POST http://157.245.1.231:8000/api/v1/devices/123/session/end
```

### 3. Aprender Control Remoto
```bash
# (con sesión activa)
mosquitto_pub -t vita/VITA123456/command -m '{"AC":"Ct","idInstaller":"abc123"}'

# ESP32 responde:
# {"AC":"Ct","result":"WAITING","message":"Press remote button"}

# Usuario presiona botón → ESP32 aprende → responde:
# {"AC":"Ct","result":"OK","rfCode":"A1B2C3D4"}
```

---

## Referencias

- **Firmware source:** Privado (Daniel)
- **Docs detallados:** `repos/antigravity_app/docs/`
  - `firmware_commands_backend_to_device.md`
  - `firmware_responses_device_to_backend.md`
- **Backend implementation:** `repos/vita-api/app/mqtt/`

---

**Última actualización:** 2 Abril 2026  
**Versión:** 1.0

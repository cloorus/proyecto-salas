# Análisis de Alineación: Firmware ↔ Backend ↔ Frontend

**Fecha:** 1 marzo 2026  
**Estado:** Solo análisis — sin cambios de código  
**Fuentes:** Protocolo Daniel (20 feb 2026), Backend green, App Flutter main

---

## 1. Resumen Ejecutivo

El backend actual fue un **demo funcional** que validó comunicación MQTT. Ahora hay que reconstruirlo como servicio de producción alineado al protocolo real de Daniel y a las 17 pantallas del frontend.

**Veredicto:**
- Frontend: **~70% listo** — falta alinear modelos de datos con firmware real
- Backend: **~30% reciclable** — auth, CRUD devices, WebSocket sirven; MQTT y parámetros hay que rehacer
- Firmware: **Protocolo definido** — es la fuente de verdad

---

## 2. Mapeo Pantalla por Pantalla

### Pantallas de Auth (✅ Alineadas)
| Pantalla | Frontend | Backend | Firmware | Estado |
|---|---|---|---|---|
| Login | ✅ l_login_screen | ✅ POST /auth/login | N/A | ✅ OK |
| Registro | ✅ b_register_screen | ✅ POST /auth/register | N/A | ✅ OK |
| Reset Password | ✅ m_reset_password | ⚠️ No endpoint | N/A | ⚠️ Falta backend |

### Lista de Dispositivos (✅ Mayormente alineada)
| Aspecto | Frontend | Backend | Firmware | Gap |
|---|---|---|---|---|
| Lista dispositivos | ✅ a_devices_list | ✅ GET /devices | N/A | ✅ OK |
| Imagen grande + borde | ✅ device_image_card | N/A (campo imageUrl) | N/A | ✅ OK |
| Quick controls | ✅ quick_controls_bottom_sheet | ✅ Endpoints OPEN/CLOSE/PAUSE | ✅ AC:OPEN/CLOSE/stop | ✅ OK |
| Estado motor (7 estados) | ⚠️ Solo 6 estados en enum | ⚠️ Básico | ✅ Cur_MotorStatus (0-6) | ⚠️ Falta mapear los 7 estados |

### Control de Dispositivo (⚠️ Parcialmente alineada)
| Comando | Frontend | Backend | Firmware (AC) | Gap |
|---|---|---|---|---|
| Abrir | ✅ Botón | ✅ /open | OPEN | ✅ |
| Cerrar | ✅ Botón | ✅ /close | CLOSE | ✅ |
| Pausa/Stop | ✅ Botón | ✅ /pause | stop | ✅ |
| Peatonal | ✅ Botón | ⚠️ No endpoint dedicado | PEDESTRIAN | ⚠️ Falta endpoint |
| OCS (secuencia) | ❌ No existe | ❌ No existe | OCS | ❌ Nuevo |
| Lámpara | ⚠️ En controles secundarios | ⚠️ Parcial | LAMP | ⚠️ Revisar |
| Relé | ⚠️ En controles secundarios | ⚠️ Parcial | RELE | ⚠️ Revisar |

### Agregar Dispositivo / Provisioning (🔴 Gap grande)
| Paso | Frontend | Backend | Firmware | Gap |
|---|---|---|---|---|
| Escaneo BLE/WiFi | ✅ scan_devices_screen | ❌ No existe | N/A (es local) | Solo frontend |
| Vincular por serial | ✅ Campo serial | ⚠️ POST /devices básico | N/A | ⚠️ Sin validación real |
| **Iniciar sesión instalador** | ❌ No existe | ❌ No existe | ✅ AC:IS + idInstaller | 🔴 CRÍTICO |
| **Enviar WiFi al VITA** | ✅ Mock (sendWifiCredentials) | ❌ No existe | ✅ SE + setWifi/ssid/ssidPassword | 🔴 CRÍTICO |
| **Aprender controles** | ❌ No existe | ❌ No existe | ✅ Ct/CP/CL/Cr/Cb/Ai/AE/AA/At | 🔴 CRÍTICO |
| **Límites de carrera** | ❌ No existe | ❌ No existe | ✅ AL/5r/rr | 🔴 CRÍTICO |
| **Emparejar foto celdas** | ❌ No existe | ❌ No existe | ✅ PA/AC | 🔴 CRÍTICO |
| **Cerrar sesión instalador** | ❌ No existe | ❌ No existe | ✅ AC:CS | 🔴 CRÍTICO |

### Parámetros del Dispositivo (🔴 Gap grande)
| Parámetro firmware | Frontend | Backend | Gap |
|---|---|---|---|
| dP (dirección motor) | ❌ | ❌ | 🔴 Nuevo |
| P5 (paro suave 0-10) | ❌ | ❌ | 🔴 Nuevo |
| LC (límites carrera NO/NC) | ❌ | ❌ | 🔴 Nuevo |
| CA (cierre automático ON/OFF) | ❌ | ❌ | 🔴 Nuevo |
| tC (tiempo cierre auto 0-9) | ❌ | ❌ | 🔴 Nuevo |
| AP (apertura peatonal 1-5) | ❌ | ❌ | 🔴 Nuevo |
| FE (fuerza empuje 0-9) | ❌ | ❌ | 🔴 Nuevo |
| Co (modo condominio ON/OFF) | ❌ | ❌ | 🔴 Nuevo |
| rA (relé auxiliar 0-2) | ❌ | ❌ | 🔴 Nuevo |
| CC (límite mantenimientos 0-9) | ❌ | ❌ | 🔴 Nuevo |
| FF (cierre por fotoceldas) | ⚠️ VitaConfigSection tiene switches | ❌ | ⚠️ Parcial |
| FL (modo lámpara) | ❌ | ❌ | 🔴 Nuevo |
| LE (luz cortesía 0-5 min) | ❌ | ❌ | 🔴 Nuevo |
| bL (bloqueo ON/OFF) | ❌ | ❌ | 🔴 Nuevo |
| tA (mantener abierto ON/OFF) | ❌ | ❌ | 🔴 Nuevo |
| labelVita (etiqueta instalador) | ❌ | ❌ | 🔴 Nuevo |
| Tipo corriente (AC/DC) | ⚠️ VitaConfigSection dropdown | ❌ | ⚠️ Parcial |
| Tipo motor (6 tipos) | ⚠️ VitaConfigSection dropdown | ❌ | ⚠️ Parcial |

### Info del Dispositivo (⚠️ Parcialmente alineada)
| Dato firmware | Frontend | Backend | Gap |
|---|---|---|---|
| Cur_MotorStatus (0-6) | ⚠️ 6 estados vs 7 | ⚠️ Básico | Falta "Pedestrian Open" y "Pedestrian Opening" |
| Total_Cycles | ❌ | ❌ | 🔴 Nuevo |
| Maintenance_Count | ❌ | ❌ | 🔴 Nuevo |
| Cycles_SinceMaintenance | ❌ | ❌ | 🔴 Nuevo |
| fc_Open_Battery (0-99%) | ❌ | ❌ | 🔴 Nuevo |
| fc_Close_Battery (0-99%) | ❌ | ❌ | 🔴 Nuevo |
| Lamp_Status | ❌ | ❌ | 🔴 Nuevo |
| Relay_Status | ❌ | ❌ | 🔴 Nuevo |
| FV (firmware version) | ❌ | ❌ | 🔴 Nuevo |
| ssid (WiFi conectado) | ❌ | ❌ | 🔴 Nuevo |
| Fc_OpenState / Fc_CloseState | ❌ | ❌ | 🔴 Nuevo |

### Opciones Avanzadas (🔴 No existe en ninguna capa)
| Función firmware | AC | Frontend | Backend |
|---|---|---|---|
| Config de fábrica | CF | ❌ | ❌ |
| Borrado total controles RF | bC | ❌ | ❌ |
| Borrar parámetros PCB | bP | ❌ | ❌ |
| Reinicio VITA (ESP32) | rE | ❌ | ❌ |
| Reset contador mantenimiento | rC | ❌ | ❌ |
| Test foto celda cierre | t1 | ❌ | ❌ |
| Test foto celda apertura | t2 | ❌ | ❌ |
| Eliminar red WiFi | DelWifi | ❌ | ❌ |

---

## 3. Modelo de Datos — Device Entity: Actual vs Necesario

### Actual (Flutter)
```dart
Device {
  id, name, model, serialNumber, type (gate/barrier/door/other),
  status (ready/opening/closing/paused/error/maintenance),
  isOnline, location, description, createdAt, lastConnection,
  imageUrl, isPrimary
}
```

### Necesario (según firmware)
```dart
Device {
  // Existentes (mantener)
  id, name, model, serialNumber, type, isOnline, location,
  description, createdAt, lastConnection, imageUrl, isPrimary,
  
  // Nuevos — Estado real del motor
  motorStatus,          // 0-6 (open/opening/closed/closing/stopped/pedestrianOpen/pedestrianOpening)
  
  // Nuevos — Hardware
  currentType,          // AC/DC
  motorType,            // piston/rack/curtain/barrier/sliding_door/electronic_door/other
  idPCB,                // Tipo de placa (ej: fac500)
  firmwareVersion,      // String "202511070925"
  
  // Nuevos — Mantenimiento
  totalCycles,          // int 0-n
  maintenanceCount,     // int 0-99
  cyclesSinceMaintenance, // int 0-9999
  maintenanceLimit,     // int 0-9000
  
  // Nuevos — Periféricos
  lampStatus,           // bool
  relayStatus,          // bool
  fcOpenState,          // bool (interrupción foto celda)
  fcCloseState,         // bool
  fcOpenBattery,        // int 0-99%
  fcCloseBattery,       // int 0-99%
  
  // Nuevos — Configuración (parámetros SE/GE)
  VitaConfig config,    // Objeto con los 20+ parámetros
  
  // Nuevos — Red
  wifiSsid,             // String
  
  // Nuevos — Instalador
  labelVita,            // String (solo visible para instalador)
}
```

---

## 4. Formato MQTT — Decisión Pendiente

### Problema
Daniel preguntó: "¿Existe algún problema si cambio los comandos por números? Ejemplo 0 = OPEN?"

### Situación actual
- **Firmware (Daniel):** `{"AC": "OPEN", "idInstaller": "..."}`
- **Backend (demo):** `{"type_Command": "command_Motor", "command": "OPEN", "command_id": "uuid", ...}`

### Recomendación
Adoptar el formato de Daniel como estándar. Es más simple y es lo que el firmware espera. El backend debe ser un **traductor** entre la API REST del frontend y el protocolo MQTT del firmware:

```
Frontend (REST)          Backend (traduce)           Firmware (MQTT)
POST /devices/1/open  →  mqtt.publish(topic,         {"AC":"OPEN",
                          {"AC":"OPEN",                "idInstaller":"xxx"}
                           "idInstaller":"xxx"})   →  
```

Si Daniel cambia a números, el mapeo va en el backend (tabla o config), no en el frontend.

---

## 5. Lo que se recicla del backend actual

| Componente | Estado | Acción |
|---|---|---|
| Auth (JWT, login, register) | ✅ Funcional | Mantener |
| Device CRUD básico | ✅ Funcional | Extender modelo |
| MQTT Client (paho) | ✅ Conecta a EMQX | Adaptar formato a protocolo Daniel |
| WebSocket Manager | ✅ Funcional | Mantener para real-time |
| PostgreSQL + models | ⚠️ Esquema básico | Migrar schema |
| Groups/Permissions RBAC | ⚠️ No usado por frontend | Evaluar si se necesita |
| Support tickets | ⚠️ Parcial | Mantener |
| control_definitions table | ✅ Buena idea | Poblar con protocolo Daniel |

---

## 6. Lo que hay que construir nuevo

### Backend
1. **Módulo Provisioning/Installer Session** — IS/CS/AS + todo el flujo de emparejamiento
2. **Módulo Device Parameters** — GET (GE) y SET (SE) de los 20+ parámetros
3. **Módulo Learn Controls** — Ct/CP/CL/Cr/Cb/Ai/AE/AA/At
4. **Módulo Advanced Options** — CF/bC/bP/rE/rC/t1/t2/DelWifi
5. **Endpoint Pedestrian/OCS** — Comandos faltantes
6. **Device Status enriched** — Mapear Cur_MotorStatus, ciclos, batería, etc.
7. **MQTT Response Handler** — Parsear respuestas del VITA (Doc 2 de Daniel)

### Frontend
1. **Pantalla de Provisioning real** — Flujo sesión instalador → aprender controles → configurar → cerrar sesión
2. **Pantalla de Parámetros completa** — Los 20+ campos con sus rangos y validaciones
3. **Pantalla Info enriquecida** — Ciclos, batería foto celdas, firmware version, WiFi
4. **Pantalla Opciones Avanzadas** — Factory reset, borrado RF, tests foto celdas
5. **DeviceStatus enum** — Agregar pedestrianOpen y pedestrianOpening
6. **Device entity** — Expandir con todos los campos del firmware

---

## 7. Prioridades Sugeridas

### Fase 1 — Alinear lo básico (1-2 semanas)
- [ ] Actualizar Device entity con campos del firmware
- [ ] Backend: adaptar MQTT al formato de Daniel
- [ ] Backend: GET parameters (GE) → endpoint nuevo
- [ ] Backend: SET parameters (SE) → endpoint nuevo
- [ ] Frontend: pantalla parámetros con campos reales
- [ ] Backend: endpoint PEDESTRIAN y OCS

### Fase 2 — Provisioning real (2-3 semanas)
- [ ] Backend: módulo sesión instalador (IS/CS/AS)
- [ ] Backend: módulo aprender controles (9 comandos)
- [ ] Backend: módulo foto celdas (PA/AC)
- [ ] Backend: módulo límites carrera (AL/5r/rr)
- [ ] Frontend: flujo de provisioning completo (wizard)
- [ ] Frontend: envío WiFi real al VITA

### Fase 3 — Info y avanzadas (1-2 semanas)
- [ ] Backend: device status enriquecido (7 estados + ciclos + batería)
- [ ] Frontend: pantalla info con datos reales del firmware
- [ ] Backend: opciones avanzadas (CF/bC/bP/rE/rC/t1/t2/DelWifi)
- [ ] Frontend: pantalla opciones avanzadas

---

*Documento de análisis — no se realizaron cambios de código*

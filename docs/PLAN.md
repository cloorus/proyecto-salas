# 🎯 Plan de Desarrollo BGnius - 2 Abril 2026

**Estado:** Repositorios actualizados, listos para desarrollo  
**Objetivo:** Planificar lo que falta para completar el ecosistema BGnius VITA  
**Destino:** ClaudeCode Local (codificación)

---

## 📦 Repositorios Actualizados

### 1. **app_bgnius_instalador**
- **Estado:** Fase de documentación ✅
- **Último commit:** fe8a084 "chore: add design mockup screens (8 JPG files)"
- **Branch:** main
- **URL:** github.com/cmena92/app_bgnius_instalador

### 2. **antigravity_app** (Flutter Web/Mobile)
- **Estado:** Deploy activo, auth conectado, devices en mock
- **Último commit:** ad42a92 "fix: use DecorationImage+NetworkImage for device photos"
- **Branch:** main
- **URL:** github.com/cmena92/antigravity_app
- **Deploy:** 157.245.1.231:8080

### 3. **vita-api** (Backend FastAPI)
- **Estado:** Phase 1 completa, Phase 2/3 con routers stub
- **Último commit:** eaf68dc "wip: add Phase 2/3 router stubs"
- **Branch:** main
- **URL:** github.com/cmena92/vita-api
- **Deploy:** 157.245.1.231:8000

---

## 🏗️ Arquitectura del Sistema

```
┌──────────────────────────┐
│  App Instalador          │ ← React Native (nuevo, sin código)
│  (React Native + Firebase)│
└────────────┬─────────────┘
             │
             │ REST API
             ▼
┌──────────────────────────┐     ┌──────────────────┐
│  VITA Backend API        │◀───▶│  PostgreSQL 15   │
│  (FastAPI + Python)      │     │  + Redis 7       │
└────────────┬─────────────┘     └──────────────────┘
             │
             │ MQTT
             ▼
┌──────────────────────────┐
│  EMQX Broker             │
│  104.131.36.215:1883     │
└────────────┬─────────────┘
             │
             ▼
┌──────────────────────────┐     ┌──────────────────┐
│  VITA ESP32 Devices      │     │  Flutter Web App │
│  (Firmware Daniel)       │     │  (antigravity_app)│
└──────────────────────────┘     └──────────────────┘
                                  (157.245.1.231:8080)
```

---

## 📋 Estado Actual por Proyecto

### 🟢 **vita-api** (Backend FastAPI)

**Completado (Phase 1):**
- ✅ Auth (register, login, JWT, refresh token)
- ✅ Base de datos PostgreSQL (13 tablas)
- ✅ Migraciones Alembic
- ✅ Docker deployment
- ✅ Health checks
- ✅ CRUD básico de devices

**En Progreso (Phase 2):**
- 🚧 Routers stub creados pero sin implementar:
  - `installer_sessions.py` - Sesiones IS/AS/CS
  - `device_params_improved.py` - Parámetros GE/SE (20+ params)
  - `learn_controls.py` - Aprendizaje controles RF
  - `photocells.py` - Emparejamiento fotoceldas
  - `advanced.py` - Funciones avanzadas
  - `support.py` - Soporte técnico

**Pendiente (Phase 3):**
- ⏳ Device sharing (invitar usuarios, permisos)
- ⏳ Groups (agrupar dispositivos, comandos grupales)
- ⏳ Notifications (FCM push notifications)
- ⏳ MQTT bridge activo (actualmente disconnected)
- ⏳ Bitácoras de actividad

**Brecha crítica:**
- Provisioning/sesión instalador NO existe
- 20+ parámetros VITA sin endpoints
- MQTT desconectado (no bloqueante pero necesario para control real)

---

### 🟡 **antigravity_app** (Flutter Web/Mobile)

**Completado:**
- ✅ Auth conectado al API real (login, register)
- ✅ 17 pantallas UI
- ✅ Clean Architecture + Riverpod + GoRouter
- ✅ Deploy web funcionando
- ✅ Device photos con NetworkImage
- ✅ Mock devices para desarrollo

**Pendiente:**
- ⏳ Conectar devices al API real (actualmente mock)
- ⏳ Implementar pantallas de parámetros (i_device_parameters_screen.dart)
- ⏳ Implementar shared users (g_shared_users_screen.dart)
- ⏳ Conectar MQTT para control en tiempo real
- ⏳ Implementar installer session flow
- ⏳ Pantallas de aprendizaje (controles RF, fotoceldas, carreras)
- ⏳ Bitácoras y manuales PDF

**Brecha crítica:**
- Frontend ~70% UI, falta conectar lógica con backend
- Modelos de datos desalineados con API
- Provisioning de instalador no implementado

---

### 🔴 **app_bgnius_instalador** (React Native)

**Completado:**
- ✅ Documentación completa (31KB requerimientos.md)
- ✅ Propuesta de interfaz con diagramas Mermaid
- ✅ 8 pantallas de diseño (JPG mockups)
- ✅ Biblioteca de componentes documentada
- ✅ 18 módulos identificados

**Pendiente (TODO):**
- ⏳ Inicializar proyecto React Native
- ⏳ Configurar Firebase (Authentication, Firestore)
- ⏳ Configurar Node.js backend
- ⏳ Implementar Bluetooth Low Energy (BLE)
- ⏳ Implementar 18 módulos/pantallas
- ⏳ Integración con vita-api REST
- ⏳ OTA updates
- ⏳ Testing en Android/iOS

**Stack tecnológico definido:**
- React Native (multiplataforma)
- Firebase (auth, firestore, storage)
- Node.js backend
- Bluetooth Low Energy (BLE)
- PDF viewer, animaciones, WiFi scanner

**Brecha crítica:**
- 🚨 **SIN CÓDIGO TODAVÍA** - solo docs y diseño
- Proyecto 100% nuevo por iniciar

---

## 🎯 Priorización Recomendada

### **Escenario 1: Completar Backend + Flutter (Flujo Usuario Final)**

**Objetivo:** Tener app funcional para usuarios que controlan sus portones

**Orden:**
1. **vita-api Phase 2** (1-2 semanas)
   - Implementar parámetros GE/SE
   - Activar MQTT bridge
   - Device control en tiempo real
   - Bitácoras básicas

2. **antigravity_app - Conectar al API** (1 semana)
   - Quitar mocks
   - Conectar devices al API real
   - Pantallas de parámetros
   - Control MQTT en tiempo real

3. **vita-api Phase 3** (1 semana)
   - Sharing de dispositivos
   - Groups
   - FCM notifications

4. **antigravity_app - Features avanzados** (1 semana)
   - Shared users
   - Groups
   - Notificaciones push

**Resultado:** App Flutter funcional para usuarios finales

---

### **Escenario 2: App Instalador Primero (Flujo Instalación)**

**Objetivo:** App para instaladores configuren dispositivos nuevos

**Orden:**
1. **vita-api Phase 2 - Sesiones Instalador** (1 semana)
   - Implementar IS/AS/CS (installer sessions)
   - Endpoints de parámetros GE/SE
   - Learn controls (9 RF controls)
   - Photocells pairing
   - MQTT bridge activo

2. **app_bgnius_instalador - Inicialización** (1 semana)
   - React Native project setup
   - Firebase setup
   - BLE library integration
   - Pantallas básicas (Login, Select Device, Menu)

3. **app_bgnius_instalador - Features Core** (2 semanas)
   - Asistente de instalación (wizard)
   - Configuración parámetros
   - WiFi setup
   - Learn controls UI
   - Fotoceldas UI
   - Pruebas de dispositivo

4. **app_bgnius_instalador - Features Extra** (1 semana)
   - Manuales PDF
   - Bitácoras
   - Activación de dispositivos
   - OTA updates

**Resultado:** App instalador funcional vía BLE

---

### **Escenario 3: Paralelo (Recomendado si hay 2+ devs)**

**Backend Developer:**
- vita-api Phase 2 completa
- vita-api Phase 3 completa
- MQTT bridge

**Frontend Developer 1:**
- antigravity_app conectar al API
- antigravity_app features avanzados

**Frontend Developer 2:**
- app_bgnius_instalador setup
- app_bgnius_instalador implementación

**Resultado:** Ambas apps + backend completos en ~3-4 semanas

---

## 📝 Tareas Específicas para ClaudeCode Local

### **TAREA 1: vita-api - Implementar Installer Sessions**

**Archivo:** `app/routers/installer_sessions.py`

**Endpoints a implementar:**
- `POST /api/v1/devices/{id}/session/start` - Iniciar sesión IS
- `POST /api/v1/devices/{id}/session/extend` - Ampliar sesión AS
- `POST /api/v1/devices/{id}/session/end` - Cerrar sesión CS
- `GET /api/v1/devices/{id}/session/status` - Estado de sesión

**Lógica:**
- Validar que el usuario sea instalador (rol)
- Generar token de sesión (JWT con claims de instalador)
- Enviar comando MQTT IS/AS/CS al dispositivo
- Registrar sesión en DB (nueva tabla `installer_sessions`)
- Timeout automático (30 min por defecto)

**Referencias:**
- Protocolo firmware: `antigravity_app/docs/firmware_commands_backend_to_device.md`
- MQTT client existente en `app/mqtt/`

---

### **TAREA 2: vita-api - Parámetros VITA (GE/SE)**

**Archivo:** `app/routers/device_params_improved.py`

**Endpoints a implementar:**
- `GET /api/v1/devices/{id}/params` - Obtener todos los parámetros
- `GET /api/v1/devices/{id}/params/{key}` - Obtener parámetro específico
- `PUT /api/v1/devices/{id}/params` - Actualizar múltiples parámetros
- `PUT /api/v1/devices/{id}/params/{key}` - Actualizar un parámetro

**Parámetros soportados (20+):**
```
dP (dirección motor), P5 (soft stop), LC (límite ciclos), CA (conteo ciclos),
tC (tiempo cierre), AP (apertura peatonal), FE (fotoceldas habilitadas),
Co (modo configuración), rA (reset alarmas), CC (comando actual),
FF (fuerza cierre), FL (fuerza apertura), LE (LED estado),
bL (bloqueo), tA (tiempo auto-cierre), labelVita (nombre),
setWifi (config WiFi), ssid (red WiFi), etc.
```

**Lógica:**
- Validar sesión instalador activa
- Enviar GE (Get) o SE (Set) vía MQTT
- Esperar respuesta del dispositivo (timeout 10s)
- Actualizar cache Redis con valores actuales
- Registrar cambios en bitácora

---

### **TAREA 3: vita-api - Learn Controls**

**Archivo:** `app/routers/learn_controls.py`

**Endpoints a implementar:**
- `POST /api/v1/devices/{id}/learn/{control}` - Aprender control RF

**Controles soportados:**
```
Ct (total), CP (peatonal), CL (lampara), Cr (relé), Cb (baja prioridad),
Ai (iniciar aprendizaje), AE (eliminar controles), AA (alarma), At (test)
```

**Lógica:**
- Validar sesión instalador
- Enviar comando learn via MQTT
- Esperar confirmación (o timeout)
- Actualizar estado del dispositivo
- Retornar resultado al cliente

---

### **TAREA 4: vita-api - Photocells**

**Archivo:** `app/routers/photocells.py`

**Endpoints a implementar:**
- `POST /api/v1/devices/{id}/photocells/pair/{type}` - Emparejar fotocelda (open/close)
- `POST /api/v1/devices/{id}/photocells/test` - Probar fotoceldas
- `GET /api/v1/devices/{id}/photocells/status` - Estado actual

**Lógica:**
- Validar sesión instalador
- Enviar comando emparejamiento vía MQTT
- Mostrar estado batería fotoceldas
- Registrar eventos

---

### **TAREA 5: vita-api - MQTT Bridge Activation**

**Archivos:** `app/mqtt/client.py`, `app/main.py`

**Objetivos:**
- Activar conexión MQTT al startup
- Suscribirse a topics `vita/+/response` y `vita/+/heartbeat`
- Manejar mensajes entrantes (routing a request IDs)
- Implementar pub/sub para comandos
- Logging de mensajes MQTT

**Estado actual:**
- Cliente MQTT existe pero está comentado/deshabilitado
- Conexión falla sin bloquear startup (graceful degradation)

---

### **TAREA 6: antigravity_app - Conectar Devices al API Real**

**Archivos:**
- `lib/features/devices/data/repositories/api_device_repository.dart`
- `lib/features/devices/presentation/providers/device_provider.dart`

**Cambios:**
- Quitar `MockDeviceRepository`
- Implementar llamadas HTTP a `/api/v1/devices`
- Deserializar JSON response a modelos Dart
- Manejar errores (401, 404, 500)
- Cache con Riverpod

---

### **TAREA 7: antigravity_app - Device Parameters Screen**

**Archivo:** `lib/features/devices/presentation/screens/i_device_parameters_screen.dart`

**Implementar:**
- Lista de 20+ parámetros con valores actuales
- Formulario de edición por parámetro
- Validaciones (min/max, tipo de dato)
- Guardar cambios → PUT `/api/v1/devices/{id}/params`
- Loading states y errores

---

### **TAREA 8: app_bgnius_instalador - Project Setup**

**Pasos:**
1. `npx react-native init BgniusInstaller --template react-native-template-typescript`
2. Instalar deps:
   ```
   react-navigation, react-native-ble-manager, react-native-firebase,
   react-native-pdf, react-native-wifi-reborn, lottie-react-native
   ```
3. Configurar Firebase (Android: google-services.json, iOS: GoogleService-Info.plist)
4. Setup Node.js backend (Express + Firebase Admin SDK)
5. Estructura de carpetas según Clean Architecture

---

### **TAREA 9: app_bgnius_instalador - Login + Select Device**

**Pantallas:**
- Login screen (email/password)
- Recover password screen (código verificación)
- Select device screen (BLE scan, lista de VITAs detectados)

**Lógica:**
- Firebase Authentication
- BLE scanner (react-native-ble-manager)
- Conexión BLE al dispositivo seleccionado
- Obtener parámetros actuales vía BLE

---

### **TAREA 10: app_bgnius_instalador - Asistente de Instalación**

**Pantallas:**
- Wizard multi-step (8-10 pasos)
- Configuración parámetros básicos
- WiFi setup (scan + credenciales)
- Learn controls (animaciones Lottie)
- Fotoceldas pairing (animaciones)
- Pruebas finales
- Confirmación y activación

**Lógica:**
- State management (Redux o Context)
- Envío de comandos BLE secuenciales
- Validaciones por paso
- Progress bar
- Posibilidad de retroceder/saltar pasos

---

## 🔍 Análisis de Brechas

### **Brecha 1: Sesiones Instalador**

**Problema:** No existe flujo de sesión instalador en ninguna capa

**Impacto:** Instaladores no pueden configurar dispositivos de forma segura

**Solución:**
1. Backend: endpoints IS/AS/CS
2. Flutter: (no aplica, es app de usuario final)
3. React Native: wizard con validación de sesión
4. Firmware: (ya implementado por Daniel según docs)

---

### **Brecha 2: Parámetros VITA**

**Problema:** 20+ parámetros del firmware no tienen endpoints backend ni UI

**Impacto:** Configuración manual o imposible

**Solución:**
1. Backend: endpoints GE/SE con validaciones
2. Frontend: formularios dinámicos por parámetro
3. Cache Redis para evitar latencia MQTT

---

### **Brecha 3: MQTT Desconectado**

**Problema:** Control en tiempo real no funciona

**Impacto:** Comandos no llegan a dispositivos, solo a DB

**Solución:**
1. Activar MQTT client en backend
2. Implementar pub/sub pattern
3. WebSocket opcional para notificaciones push al frontend

---

### **Brecha 4: App Instalador Inexistente**

**Problema:** No hay código, solo docs

**Impacto:** Instaladores no tienen herramienta de trabajo

**Solución:**
1. Inicializar proyecto React Native
2. Implementar BLE stack completo
3. Implementar 18 módulos según requerimientos
4. Testing exhaustivo en Android/iOS real

---

### **Brecha 5: Web Admin Legacy Pendiente**

**Problema:** Jason/Daniel nunca enviaron archivos de web vieja

**Impacto:** No se puede migrar/integrar funcionalidad existente

**Solución:**
1. Solicitar nuevamente los archivos
2. Análisis de la web vieja (DB schema, endpoints, features)
3. Migración a vita-api + nuevo frontend
4. Deprecar web vieja

---

## 📊 Estimación de Esfuerzo

| Componente | Tareas | Complejidad | Tiempo (dev) |
|------------|--------|-------------|--------------|
| vita-api Phase 2 | 1-5 | Media-Alta | 1-2 semanas |
| vita-api Phase 3 | Sharing, Groups, FCM | Media | 1 semana |
| antigravity_app API | 6-7 | Media | 1 semana |
| antigravity_app Avanzado | Params, Sharing, Groups | Media | 1 semana |
| app_bgnius_instalador Setup | 8 | Baja | 2-3 días |
| app_bgnius_instalador Core | 9-10 | Alta | 2-3 semanas |
| Testing + Deployment | E2E, integración | Media | 1 semana |
| **TOTAL** | | | **6-8 semanas** |

---

## 🚀 Recomendación Final

**Prioridad 1:** vita-api Phase 2 (sesiones instalador + parámetros + MQTT)  
**Prioridad 2:** app_bgnius_instalador (setup + features core)  
**Prioridad 3:** antigravity_app conectar al API  
**Prioridad 4:** vita-api Phase 3 (sharing, groups, notifications)

**Justificación:**
- Los instaladores son el cuello de botella (no pueden configurar dispositivos)
- El backend es bloqueante para ambas apps
- Flutter web puede seguir en mock mientras se desarrolla instalador
- Una vez instalador funcione, los usuarios pueden empezar a usar Flutter web

---

## 📞 Próximos Pasos

1. **Crisman decide:** ¿Escenario 1, 2 o 3?
2. **ClaudeCode Local:** Recibe este plan y ejecuta tareas en orden
3. **Orus:** Monitorea progreso, resuelve dudas, revisa PRs
4. **Iteración:** Feedback continuo, ajustes según necesidad

---

**Documento generado por:** Orus 🐾  
**Fecha:** 2 Abril 2026  
**Repos actualizados:** ✅ Listos para desarrollo  
**Próxima acción:** Decisión de escenario + inicio de codificación

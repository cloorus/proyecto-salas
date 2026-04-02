# 🚪 Proyecto Salas - Sistema de Control BGnius VITA

**Monorepo único para todo el ecosistema BGnius VITA**

**Cliente:** Jason PS Granados + Daniel (firmware)  
**Stack:** Flutter + FastAPI + React Native + ESP32 (MQTT)  
**Inicio:** Marzo 2026  
**Reorganización monorepo:** Abril 2026

---

## 📁 Estructura del Monorepo

```
proyecto-salas/
├── README.md              ← Este archivo (índice principal)
├── .gitignore             ← Exclusiones git
├── docs/                  ← Documentación del proyecto
│   ├── PLAN.md           ← Plan de desarrollo completo
│   ├── ARCHITECTURE.md   ← Arquitectura del sistema
│   └── PROTOCOL.md       ← Protocolo MQTT firmware
├── flutter-app/           ← App Flutter Web/Mobile
│   ├── lib/              ← Código Flutter
│   ├── pubspec.yaml      ← Dependencias
│   ├── web/              ← Build web
│   ├── android/          ← Build Android
│   ├── ios/              ← Build iOS
│   └── legacy-web/       ← Web React deprecada (histórico)
├── backend-api/           ← Backend FastAPI
│   ├── app/              ← Código Python
│   ├── alembic/          ← Migraciones DB
│   ├── requirements.txt  ← Dependencias Python
│   ├── docker-compose.yml
│   └── Dockerfile
├── app-instalador/        ← App React Native instaladores
│   ├── documentacion/    ← Requerimientos y diseño
│   ├── pantallas/        ← Mockups JPG
│   └── (código pendiente)
└── webapp/                ← Demo HTML+JS (prototipo rápido)
    ├── index.html
    ├── js/               ← Scripts vanilla
    ├── css/              ← Estilos
    └── docs/             ← Docs del webapp
```

---

## 🚀 Quick Start

### 1. Clonar el repo
```bash
git clone https://github.com/cmena92/proyecto-salas.git
cd proyecto-salas
```

### 2. Backend (FastAPI)
```bash
cd backend-api
cp .env.example .env
# Editar .env con credenciales

# Con Docker (recomendado)
docker-compose up -d

# Manual (Python 3.11+)
python -m venv venv
source venv/bin/activate
pip install -r requirements.txt
alembic upgrade head
uvicorn app.main:app --reload
```

**API:** http://localhost:8000  
**Docs:** http://localhost:8000/docs  
**Producción:** http://157.245.1.231:8000

### 3. Flutter App
```bash
cd flutter-app
flutter pub get
flutter run -d chrome  # Web
flutter run -d android # Android
flutter run -d ios     # iOS (macOS)
```

**Build web:**
```bash
flutter build web
# Output: flutter-app/build/web/
```

**Producción:** http://157.245.1.231:8080

### 4. WebApp (demo HTML+JS)
```bash
cd webapp
# Servir con cualquier servidor estático:
python3 -m http.server 8080
# o
npx serve .
```

**Producción:** http://157.245.1.231:8000/static/test-app/

### 5. App Instalador (React Native)
**Estado:** Solo documentación, sin código todavía

```bash
cd app-instalador
# Ver docs:
cat documentacion/requerimientos_proyecto.md
```

---

## 🏗️ Componentes del Sistema

### 1. **Flutter App** (`flutter-app/`)
**Usuario:** Dueño del portón/barrera  
**Plataformas:** Web, Android, iOS

**Funcionalidad:**
- Control remoto (OPEN, CLOSE, STOP, PEDESTRIAN)
- Estado en tiempo real (online/offline, posición)
- Gestión de permisos (compartir acceso)
- Configuración de parámetros básicos
- Grupos de dispositivos
- Notificaciones push
- Historial de eventos

**Stack:**
- Flutter 3.27
- Clean Architecture + Riverpod + GoRouter
- 17 pantallas UI

**Estado:**
- ✅ Auth conectado al API
- 🚧 Devices en mock (falta conectar API real)
- ⏳ Parámetros, MQTT, sharing pendientes

---

### 2. **Backend API** (`backend-api/`)
**Servidor:** FastAPI + PostgreSQL + Redis + MQTT

**Endpoints principales:**
- `POST /api/v1/auth/login` - Autenticación
- `GET /api/v1/devices` - Lista dispositivos
- `POST /api/v1/devices/{id}/command` - Enviar comando
- `GET /api/v1/devices/{id}/params` - Parámetros VITA
- `POST /api/v1/devices/{id}/session/start` - Sesión instalador
- `GET /api/v1/groups` - Grupos de dispositivos
- `GET /api/v1/notifications` - Notificaciones

**Stack:**
- FastAPI (Python 3.11)
- PostgreSQL 15 + Redis 7
- SQLAlchemy 2.0 (async ORM)
- Alembic (migrations)
- aiomqtt (MQTT bridge)
- Docker deployment

**Estado:**
- ✅ Phase 1: Auth + CRUD devices
- 🚧 Phase 2: Parámetros, sesiones, MQTT activo
- ⏳ Phase 3: Sharing, groups, FCM

---

### 3. **App Instalador** (`app-instalador/`)
**Usuario:** Instalador técnico  
**Plataformas:** Android, iOS

**Funcionalidad:**
- Conexión BLE directa al ESP32
- Asistente instalación paso a paso
- Configuración 20+ parámetros
- Aprendizaje controles RF (9 tipos)
- Emparejamiento fotoceldas
- WiFi setup del dispositivo
- Pruebas motor y límites
- Activación de dispositivos
- Manuales PDF y bitácoras

**Stack:**
- React Native
- Firebase (Auth + Firestore)
- Bluetooth Low Energy (BLE)
- Node.js backend

**Estado:**
- ✅ Docs completas (31KB requerimientos)
- ✅ 8 pantallas diseño (mockups JPG)
- ✅ 18 módulos identificados
- ❌ Sin código todavía

---

### 4. **WebApp** (`webapp/`)
**Usuario:** Admin / testing  
**Propósito:** Prototipo rápido para validar backend

**Funcionalidad:**
- 11 pantallas completas (login, devices, params, users, groups, etc)
- HTML + JS vanilla (sin build)
- Consume backend-api
- Mobile-first UI

**Stack:**
- HTML + JavaScript puro
- CSS Material Design
- Max-width 420px

**Estado:**
- ✅ Funcional en producción
- ✅ Conectado a backend
- ✅ 11 pantallas completadas

---

## 🔌 Infraestructura

### Servidores DigitalOcean
- **157.245.1.231** - Backend API + Flutter web + webapp demo
- **104.131.36.215** - EMQX MQTT broker (6 meses activo)

### Base de Datos
- **PostgreSQL 15** - 157.245.1.231:5434 (Docker)
- **Redis 7** - 157.245.1.231:6381 (Docker)

### MQTT
- **Broker:** EMQX 104.131.36.215:1883
- **Topics:**
  - `vita/{serial}/command` - Backend → Device
  - `vita/{serial}/response` - Device → Backend
  - `vita/{serial}/heartbeat` - Device → Backend (30s)

---

## 📚 Documentación

### Docs principales (`docs/`)
- **PLAN.md** (15.8 KB) - Plan de desarrollo, 3 escenarios, 10 tareas para ClaudeCode
- **ARCHITECTURE.md** (14 KB) - Diagramas, capas, flujos, seguridad, escalabilidad
- **PROTOCOL.md** (12 KB) - Protocolo MQTT: comandos, parámetros, ejemplos

### Protocolo Firmware (Daniel)
- **Carpeta:** `flutter-app/docs/`
- **Archivos:**
  - `firmware_commands_backend_to_device.md` - Comandos backend → ESP32
  - `firmware_responses_device_to_backend.md` - Respuestas ESP32 → backend

### Comandos MQTT principales

**Sesiones instalador:**
- `IS` - Initialize Session
- `AS` - Amplify Session (extender)
- `CS` - Close Session

**Controles motor:**
- `OPEN`, `CLOSE`, `STOP`, `OCS`, `PEDESTRIAN`, `LAMP`, `RELE`

**Parámetros (20+):**
- `GE` - Get parameter (ej: `{"AC":"GE","PA":"dP"}`)
- `SE` - Set parameter (ej: `{"AC":"SE","PA":"tC","VA":"45"}`)

**Aprendizaje RF:**
- `Ct`, `CP`, `CL`, `Cr`, `Cb`, `Ai`, `AE`, `AA`, `At`

---

## 📊 Estado General

### Completado ✅
- Backend Phase 1 (auth, devices CRUD)
- Flutter UI (17 pantallas)
- WebApp demo (11 pantallas)
- App Instalador docs + diseño
- Deploy producción activo
- **Monorepo unificado**

### En Progreso 🚧
- Backend Phase 2 (parámetros, sesiones, MQTT)
- Flutter conectar al API real
- MQTT bridge activation

### Pendiente ⏳
- Backend Phase 3 (sharing, groups, FCM)
- App Instalador desarrollo
- Testing E2E
- Docs usuario final

---

## 🎯 Próximos Pasos

**Prioridad 1:** Backend Phase 2
- Sesiones instalador (IS/AS/CS)
- Parámetros VITA (GE/SE)
- MQTT bridge activo
- Learn controls + photocells

**Prioridad 2:** App Instalador
- Setup React Native
- BLE integration
- Asistente instalación
- 18 módulos

**Prioridad 3:** Flutter
- Conectar devices al API
- Implementar parámetros
- MQTT real-time control

---

## 👥 Contactos

- **Cliente:** Jason PS Granados
- **Firmware:** Daniel (ESP32, protocolo MQTT)
- **Desarrollo:** Crisman Mena
- **Asistente:** Orus 🐾

---

## 📅 Timeline

- **Marzo 2026:** Inicio proyecto, deploy inicial, docs firmware
- **2 Abril 2026:** Monorepo unificado, plan completo, reorganización
- **Meta Q2 2026:** App instalador funcional, Flutter conectado
- **Meta Q3 2026:** Sistema completo en producción

---

## 🔗 Recursos

- **Repo GitHub:** https://github.com/cloorus/proyecto-salas
- **API Docs:** http://157.245.1.231:8000/docs
- **Flutter Web:** http://157.245.1.231:8080
- **WebApp Demo:** http://157.245.1.231:8000/static/test-app/

---

## ⚠️ Nota sobre repos antiguos

Los siguientes repos fueron consolidados en este monorepo y **NO deben usarse más**:
- ~~`cmena92/antigravity_app`~~ → ahora `proyecto-salas/flutter-app/`
- ~~`cmena92/vita-api`~~ → ahora `proyecto-salas/backend-api/`
- ~~`cmena92/app_bgnius_instalador`~~ → ahora `proyecto-salas/app-instalador/`

Se recomienda archivarlos en GitHub para evitar confusión.

---

**Última actualización:** 2 Abril 2026  
**Versión:** 2.0 (Monorepo)

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
├── README.md                 ← Este archivo (índice principal)
├── STATUS.md                 ← Estado actual del proyecto
├── PLAN_TRABAJO.md          ← Plan detallado Phase 2 (27 KB)
├── DEPLOYMENT_PLAN.md       ← Estrategia de deployment
├── DEPLOYMENT_STATUS.md     ← Estado del deployment
├── WEBAPP_STATUS.md         ← Estado webapp (21 pantallas)
├── deploy.sh                ← Script automático de deploy
├── .gitignore               ← Exclusiones git
├── docs/                    ← Documentación del proyecto
│   ├── PLAN.md             ← Plan de desarrollo completo
│   ├── ARCHITECTURE.md     ← Arquitectura del sistema
│   └── PROTOCOL.md         ← Protocolo MQTT firmware
├── flutter-app/             ← App Flutter Web/Mobile
│   ├── lib/                ← Código Flutter
│   ├── pubspec.yaml        ← Dependencias
│   ├── web/                ← Build web
│   ├── android/            ← Build Android
│   ├── ios/                ← Build iOS
│   └── legacy-web/         ← Web React deprecada (histórico)
├── backend-api/             ← Backend FastAPI
│   ├── app/                ← Código Python
│   ├── alembic/            ← Migraciones DB
│   ├── requirements.txt    ← Dependencias Python
│   ├── docker-compose.yml
│   └── Dockerfile
├── admin-web/               ← Panel de administración web
│   └── index.html          ← Admin HTML (base)
├── app-instalador/          ← App React Native instaladores
│   ├── documentacion/      ← Requerimientos y diseño
│   ├── pantallas/          ← Mockups JPG
│   └── (código pendiente)
└── webapp/                  ← Demo HTML+JS (21 pantallas)
    ├── index.html
    ├── js/                 ← 21 pantallas + api.js + app.js
    ├── css/                ← Estilos Material Design
    ├── images/             ← Logos BGnius
    └── INVENTORY.md        ← Inventario completo
```

---

## 🚀 Quick Start

### 1. Clonar el repo
```bash
git clone https://github.com/cloorus/proyecto-salas.git
cd proyecto-salas
```

### 2. Desarrollo Local

#### Backend (FastAPI)
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

**API Local:** http://localhost:8000  
**Docs Local:** http://localhost:8000/docs

#### Flutter App
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

#### WebApp (demo HTML+JS)
```bash
cd webapp
# Servir con cualquier servidor estático:
python3 -m http.server 8080
# o
npx serve .
```

#### App Instalador (React Native)
**Estado:** Solo documentación, sin código todavía

```bash
cd app-instalador
# Ver docs:
cat documentacion/requerimientos_proyecto.md
```

---

### 3. Deploy a Producción

**El monorepo está vinculado al servidor de producción** via symlinks.  
Cualquier cambio local se puede deployar automáticamente:

```bash
# Deploy cambios en webapp
./deploy.sh "fix: correct button color" webapp

# Deploy cambios en backend
./deploy.sh "feat: add new endpoint" backend

# Deploy cambios en admin panel
./deploy.sh "feat: dashboard widget" admin

# Deploy todo
./deploy.sh "release: v1.0" all
```

**El script hace:**
1. Git commit + push
2. Pull en servidor (157.245.1.231)
3. Restart servicios si es necesario

**URLs de Producción:**
- **Backend API:** http://157.245.1.231:8000
- **API Docs:** http://157.245.1.231:8000/docs
- **WebApp Demo:** http://157.245.1.231:8000/static/test-app/
- **Admin Panel:** http://157.245.1.231:8081
- **Flutter Web:** http://157.245.1.231:8080

**Ver logs:**
```bash
ssh root@157.245.1.231 "docker logs -f vita-api-api-1"
ssh root@157.245.1.231 "docker logs -f vita-admin"
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
- ✅ Phase 1: Auth + CRUD devices (100%)
- 🚧 Phase 2: Parámetros, sesiones instalador, MQTT bridge (30%)
- ⏳ Phase 3: Sharing, groups, FCM (0%)
- ✅ Deployment: Vinculado al monorepo via symlinks
- ✅ API Tests: 48/57 pasando (84%)

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
**Propósito:** Prototipo rápido para validar backend antes de compilar Flutter a web

**Funcionalidad:**
- **21 pantallas completas** (~10,000 líneas JS)
- Auth: login, register, reset-password
- Devices: list, detail, edit, info, params, control, users, events, add
- Users: link-virtual-user, user-roles
- Groups, events, notifications, support, technical-contact, settings
- HTML + JS vanilla (sin build)
- Consume backend-api
- Mobile-first UI

**Stack:**
- HTML + JavaScript puro (9,951 líneas)
- CSS Material Design (1,311 líneas)
- Max-width 420px
- BGnius theme (Montserrat font)

**Estado:**
- ✅ Funcional en producción
- ✅ Conectado a backend
- ✅ 21 pantallas completadas (vs 3 documentadas originalmente)
- ✅ Código sincronizado al monorepo
- ⚠️ Requiere config static files en backend

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
- **Monorepo unificado** (2 Abril 2026)
- **Deployment vinculado** (código monorepo → producción via symlinks)
- **Script deploy.sh** (deployment automático)
- Backend Phase 1 (auth, devices CRUD)
- Flutter UI (17 pantallas)
- **WebApp demo (21 pantallas, 10K líneas JS)**
- **WebApp sincronizada** del servidor al monorepo
- App Instalador docs + diseño
- **Plan de trabajo detallado** (PLAN_TRABAJO.md, 27 KB, 5 fases, 20+ tareas)
- Deploy producción activo (3 servicios)

### En Progreso 🚧
- Backend Phase 2 (parámetros, sesiones, MQTT)
- MQTT bridge activation
- Static files config (webapp)
- Admin panel desarrollo

### Pendiente ⏳
- Backend Phase 3 (sharing, groups, FCM)
- Flutter conectar al API real
- App Instalador desarrollo
- Testing E2E
- Docs usuario final

---

## 🎯 Próximos Pasos

**Ver:** `PLAN_TRABAJO.md` para plan detallado completo (5 fases, 20+ tareas)

**Prioridad 0 (Inmediato):**
- Configurar static files en backend (webapp funcional)
- Verificar todas las pantallas webapp funcionan contra backend actual

**Prioridad 1 (Backend Phase 2):**
- Sesiones instalador (IS/AS/CS) - 4 endpoints + tests
- Parámetros VITA (GE/SE) - 20+ params, schema, cache Redis
- MQTT bridge activo - aiomqtt client singleton
- Learn controls RF - 9 tipos
- Photocells - pairing + status

**Prioridad 2 (Testing):**
- E2E 5 casos de uso críticos
- Cobertura API 100% (57/57 tests)
- WebApp funcional completa

**Prioridad 3 (App Instalador):**
- Setup React Native
- BLE integration
- Asistente instalación
- 18 módulos

**Prioridad 4 (Flutter):**
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

**Última actualización:** 2 Abril 2026 15:40 UTC  
**Versión:** 2.1 (Monorepo + Deployment Vinculado)

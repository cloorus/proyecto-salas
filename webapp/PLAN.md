# VITA Web Test App — Plan de Desarrollo

Web app que replica la interfaz Flutter para probar endpoints y flujo E2E.

## API Base: http://157.245.1.231:8000/api/v1

## Mapa de Pantallas (por orden de prioridad)

### Fase 1 — Core (Login + Dispositivos)
1. **Login** — `POST /auth/login` → token JWT
2. **Lista de Dispositivos** — `GET /devices` → cards con nombre, tipo, estado online/offline
3. **Detalle Dispositivo** — `GET /devices/{id}/full` + `GET /devices/{id}/actions`
   - Header: nombre, serial, MAC, estado, batería, señal
   - Botones de acciones dinámicas (OPEN, CLOSE, STOP, etc.) → `POST /devices/{id}/command`
   - Indicador de respuesta MQTT (status, duración)

### Fase 2 — Parámetros + Edición
4. **Parámetros** — `GET /devices/{id}/params` + `GET /devices/{id}/params/fields`
   - Tabla de parámetros con valores actuales
   - Editar parámetros → `PUT /devices/{id}/params`
   - Refresh desde dispositivo → `POST /devices/{id}/params/refresh`
5. **Editar Dispositivo** — `PUT /devices/{id}` (nombre, ubicación, etc.)

### Fase 3 — Grupos + Usuarios
6. **Grupos** — `GET /groups` → lista, crear, agregar dispositivos
7. **Usuarios Dispositivo** — `GET /devices/{id}/users` → compartir, roles

### Fase 4 — Avanzado
8. **Eventos** — `GET /devices/{id}/events` → historial
9. **Notificaciones** — `GET /notifications`
10. **Soporte** — `GET /devices/{id}/support`
11. **Configuración Avanzada** — `POST /devices/{id}/advanced/{action}`

## Stack
- HTML + Vanilla JS + CSS (sin frameworks, máxima simplicidad)
- Material Icons de Google
- Colores BGnius (azul #1976D2)
- Responsive (mobile-first para simular app)
- Se sirve como archivo estático en el servidor

## Estructura
```
/opt/vita-api/static/test-app/
├── index.html          (SPA con routing hash)
├── css/
│   └── app.css
├── js/
│   ├── api.js          (módulo API client)
│   ├── app.js          (router + estado global)
│   ├── screens/
│   │   ├── login.js
│   │   ├── devices.js
│   │   ├── device-detail.js
│   │   ├── device-edit.js
│   │   └── params.js
│   └── components/
│       ├── action-button.js
│       └── device-card.js
└── img/
```

## Navegación
```
#/login → Login
#/devices → Lista dispositivos (home)
#/devices/:id → Detalle + acciones
#/devices/:id/edit → Editar dispositivo  
#/devices/:id/params → Parámetros
```

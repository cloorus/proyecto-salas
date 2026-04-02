# ✅ Estado del Deployment - 2 Abril 2026 15:34 UTC

## 🎯 Objetivo Completado

**Código del monorepo ahora está vinculado al servidor de producción**

---

## 📍 Estructura en el Servidor

### Monorepo clonado:
```
/opt/projects/proyecto-salas/
├── backend-api/      ← Backend FastAPI
├── webapp/           ← WebApp demo
├── admin-web/        ← Panel admin
├── flutter-app/      ← Flutter (no desplegado)
├── app-instalador/   ← Docs (no desplegado)
└── deploy.sh         ← Script de deploy
```

### Symlinks creados:
```
/opt/vita-api → /opt/projects/proyecto-salas/backend-api/
/opt/vita-api/static/test-app/ → /opt/projects/proyecto-salas/webapp/
```

### Backup:
```
/opt/vita-api.backup/  ← Código anterior (safe)
```

---

## 🔧 Servicios Configurados

| Servicio | Container | Puerto | Path | Estado |
|----------|-----------|--------|------|--------|
| **Backend API** | vita-api-api-1 | 8000 | /opt/vita-api/ (symlink) | ✅ Corriendo |
| **WebApp Demo** | (static) | 8000 | /opt/vita-api/static/test-app/ (symlink) | ⚠️ Requiere config |
| **Admin Panel** | vita-admin | 8081 | /opt/projects/proyecto-salas/admin-web/ | ✅ Corriendo |
| PostgreSQL | vita-api-postgres-1 | 5434 | (volume) | ✅ Corriendo |
| Redis | vita-api-redis-1 | 6381 | (volume) | ✅ Corriendo |
| Flutter Web | vita-web | 8080 | /opt/vita-api/static/flutter/ | ✅ Corriendo |

---

## ✅ Lo que Funciona

### 1. Backend API (http://157.245.1.231:8000)
```bash
$ curl http://157.245.1.231:8000/health
{
  "status": "degraded",
  "services": {
    "database": "connected",
    "redis": "connected",
    "mqtt": "disconnected"  # ← Esperado (Phase 2)
  }
}
```

**URLs disponibles:**
- http://157.245.1.231:8000/health
- http://157.245.1.231:8000/docs (Swagger UI)
- http://157.245.1.231:8000/redoc
- http://157.245.1.231:8000/api/v1/ (endpoints)

### 2. Admin Panel (http://157.245.1.231:8081)
- ✅ Container corriendo
- ✅ Vinculado a `admin-web/` del monorepo
- ⚠️ HTML básico (necesita desarrollo)

### 3. Flutter Web (http://157.245.1.231:8080)
- ✅ Corriendo
- ⚠️ No vinculado al monorepo (opcional)

---

## ⚠️ Pendiente de Configurar

### WebApp Demo (static files)

**Problema:** FastAPI no tiene configurado servir archivos estáticos desde `/static/test-app/`

**Solución:** Agregar en `backend-api/app/main.py`:

```python
from fastapi.staticfiles import StaticFiles

app.mount("/static", StaticFiles(directory="static"), name="static")
```

**Instrucciones para ClaudeCode Local:**

1. Editar `backend-api/app/main.py`
2. Agregar import y mount de StaticFiles
3. Crear directorio `static/` si no existe
4. Deploy con `./deploy.sh "feat: enable static files" backend`

**Alternativa temporal:** Servir webapp con nginx separado

---

## 🚀 Cómo Hacer Cambios Ahora

### Flujo de trabajo:

**1. Local:** Editar código en tu máquina
```bash
cd proyecto-salas/
# Editar archivo (webapp/js/screens/login.js por ejemplo)
```

**2. Deploy automático:**
```bash
./deploy.sh "fix: change button color" webapp
```

**3. Ver cambios:**
```bash
# WebApp (cuando static files funcione):
open http://157.245.1.231:8000/static/test-app/

# API:
open http://157.245.1.231:8000/docs

# Admin:
open http://157.245.1.231:8081/
```

---

## 📋 Ejemplos de Uso

### Deploy cambio en WebApp:
```bash
# Editar webapp/js/screens/devices.js
git add webapp/
./deploy.sh "fix: correct device list sorting" webapp

# Cambio se refleja inmediatamente (static files, no restart)
```

### Deploy cambio en Backend:
```bash
# Editar backend-api/app/routers/devices.py
git add backend-api/
./deploy.sh "feat: add new endpoint /devices/bulk" backend

# Restart automático del container
# Disponible en /docs al instante
```

### Deploy cambio en Admin:
```bash
# Editar admin-web/index.html
git add admin-web/
./deploy.sh "feat: add dashboard widget" admin

# Restart del container vita-admin
```

---

## 🔍 Comandos Útiles

### Ver logs del backend:
```bash
ssh root@157.245.1.231 "docker logs -f vita-api-api-1"
```

### Ver logs del admin:
```bash
ssh root@157.245.1.231 "docker logs -f vita-admin"
```

### Verificar symlinks:
```bash
ssh root@157.245.1.231 "ls -la /opt/vita-api"
ssh root@157.245.1.231 "ls -la /opt/vita-api/static/test-app"
```

### Pull manual en servidor:
```bash
ssh root@157.245.1.231 "cd /opt/projects/proyecto-salas && git pull"
```

### Restart manual de servicios:
```bash
ssh root@157.245.1.231 "docker restart vita-api-api-1"
ssh root@157.245.1.231 "docker restart vita-admin"
```

---

## 🎯 Próximas Tareas

### 1. Habilitar Static Files (P0)
**Responsable:** ClaudeCode Local  
**Acción:** Modificar `backend-api/app/main.py` para servir `/static/`

### 2. Desarrollar Admin Panel (P1)
**Actual:** HTML básico  
**Necesario:**
- Dashboard con estadísticas
- Gestión de usuarios
- Gestión de dispositivos
- Logs del sistema

**Opciones:**
- Usar Swagger UI como admin básico
- Desarrollar React/Vue admin
- Usar admin-redesigned.html actual + JS

### 3. Testing E2E (P1)
**Verificar:**
- WebApp → API → DB (flujo completo)
- Admin → API → DB
- Deploy automático funciona

---

## ✅ Verificación del Setup

| Tarea | Estado |
|-------|--------|
| Monorepo clonado en servidor | ✅ `/opt/projects/proyecto-salas/` |
| Symlink backend-api | ✅ `/opt/vita-api/` |
| Symlink webapp | ✅ `/opt/vita-api/static/test-app/` |
| Admin panel container | ✅ vita-admin en :8081 |
| Backend API corriendo | ✅ :8000 (healthy degraded) |
| Script deploy.sh | ✅ Funcional |
| .env copiado | ✅ En backend-api/ |
| Backup creado | ✅ /opt/vita-api.backup/ |

---

## 📝 Notas Importantes

1. **Cambios locales → Deploy:** Siempre usar `./deploy.sh` para asegurar que cambios lleguen al servidor

2. **Git en servidor:** El servidor hace `git pull` automático, no editar código directamente en servidor

3. **Backup:** Si algo falla, el backup está en `/opt/vita-api.backup/`

4. **Permisos:** Los symlinks preservan permisos, los containers leen archivos correctamente

5. **Hot reload:** WebApp no necesita restart (static files), Backend sí (Python)

---

## 🎉 Resultado

**Ahora tenés:**
- ✅ Código centralizado en monorepo
- ✅ Cambios locales se reflejan en producción con 1 comando
- ✅ 3 servicios vinculados (API, WebApp, Admin)
- ✅ Backup de seguridad
- ✅ Script automatizado de deploy

**Próximo paso:** ClaudeCode Local puede empezar a hacer cambios y deployarlos automáticamente.

---

**Fecha:** 2 Abril 2026 15:34 UTC  
**Ejecutado por:** Orus 🐾  
**Servidor:** 157.245.1.231

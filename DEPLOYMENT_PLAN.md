# 🚀 Plan de Deployment - Vincular Monorepo al Servidor

**Objetivo:** Que el código del monorepo sea el que se ejecuta en producción  
**Servidor:** 157.245.1.231  
**Estrategia:** Git clone en servidor + symlinks/volúmenes Docker

---

## 📊 Estado Actual

### Servicios corriendo (Docker):
| Servicio | Container | Puerto | Path Actual |
|----------|-----------|--------|-------------|
| Backend API | vita-api-api-1 | 8000 | `/opt/vita-api/` |
| Flutter Web | vita-web | 8080 | `/opt/vita-api/static/flutter/` |
| Backend Admin | vita-admin | 8081 | `/usr/share/nginx/html/` (container) |
| WebApp Demo | (static) | 8000 | `/opt/vita-api/static/test-app/` |
| PostgreSQL | vita-api-postgres-1 | 5434 | (volume) |
| Redis | vita-api-redis-1 | 6381 | (volume) |

---

## 🎯 Plan de Acción

### Paso 1: Clonar monorepo en servidor
```bash
ssh root@157.245.1.231

# Crear directorio para proyectos
mkdir -p /opt/projects
cd /opt/projects

# Clonar el monorepo
git clone https://github.com/cloorus/proyecto-salas.git
cd proyecto-salas

# Verificar estructura
ls -la
# backend-api/, flutter-app/, webapp/, app-instalador/
```

---

### Paso 2: Vincular Backend API

**Opción A: Reemplazar carpeta completa**
```bash
# Backup actual
mv /opt/vita-api /opt/vita-api.backup

# Crear symlink al monorepo
ln -s /opt/projects/proyecto-salas/backend-api /opt/vita-api

# Copiar .env del backup
cp /opt/vita-api.backup/.env /opt/vita-api/.env

# Reiniciar container
cd /opt/vita-api
docker-compose restart api
```

**Opción B: Montar volumen en docker-compose.yml**
```yaml
# /opt/projects/proyecto-salas/backend-api/docker-compose.yml
services:
  api:
    volumes:
      - /opt/projects/proyecto-salas/backend-api/app:/app/app:ro
      - /opt/projects/proyecto-salas/backend-api/alembic:/app/alembic:ro
```

---

### Paso 3: Vincular WebApp Demo

```bash
# Backup actual
mv /opt/vita-api/static/test-app /opt/vita-api/static/test-app.backup

# Crear symlink al monorepo
ln -s /opt/projects/proyecto-salas/webapp /opt/vita-api/static/test-app

# Verificar
curl http://localhost:8000/static/test-app/index.html
```

**Nota:** Como FastAPI sirve archivos estáticos, el symlink funcionará automáticamente.

---

### Paso 4: Vincular Backend Admin

**El admin actual es solo un HTML. Vamos a servirlo desde el monorepo:**

```bash
# Crear admin-web/ en el monorepo (en local primero)
# Copiar webapp/admin-redesigned.html como base

# En servidor:
docker stop vita-admin
docker rm vita-admin

# Crear nuevo container apuntando al monorepo
docker run -d \
  --name vita-admin \
  -p 8081:80 \
  -v /opt/projects/proyecto-salas/admin-web:/usr/share/nginx/html:ro \
  nginx:alpine

# Verificar
curl http://localhost:8081/
```

---

### Paso 5: Script de Deploy Automático

**Crear en monorepo:** `deploy.sh`

```bash
#!/bin/bash
# deploy.sh - Deploy changes to production server

set -e

SERVER="root@157.245.1.231"
REMOTE_PATH="/opt/projects/proyecto-salas"

echo "🚀 Deploying to production..."

# 1. Git push local changes
git add .
git commit -m "deploy: $1" || echo "No changes to commit"
git push origin main

# 2. Pull on server
ssh $SERVER "cd $REMOTE_PATH && git pull origin main"

# 3. Restart services if needed
if [ "$2" == "backend" ]; then
    echo "♻️  Restarting backend API..."
    ssh $SERVER "cd $REMOTE_PATH/backend-api && docker-compose restart api"
fi

if [ "$2" == "webapp" ]; then
    echo "✨ WebApp updated (static files, no restart needed)"
fi

if [ "$2" == "admin" ]; then
    echo "♻️  Restarting admin..."
    ssh $SERVER "docker restart vita-admin"
fi

if [ "$2" == "all" ]; then
    echo "♻️  Restarting all services..."
    ssh $SERVER "cd $REMOTE_PATH/backend-api && docker-compose restart"
    ssh $SERVER "docker restart vita-admin"
fi

echo "✅ Deploy complete!"
echo "   WebApp: http://157.245.1.231:8000/static/test-app/"
echo "   API: http://157.245.1.231:8000/docs"
echo "   Admin: http://157.245.1.231:8081/"
```

**Uso:**
```bash
# Deploy cambios en webapp
./deploy.sh "fix: correct button color" webapp

# Deploy cambios en backend
./deploy.sh "feat: add new endpoint" backend

# Deploy todo
./deploy.sh "release: v1.0" all
```

---

### Paso 6: Auto-reload para desarrollo

**Backend API (con hot reload):**
```bash
# En servidor, modo dev
cd /opt/projects/proyecto-salas/backend-api
docker-compose -f docker-compose.yml -f docker-compose.dev.yml up

# Esto monta volúmenes y usa --reload en uvicorn
```

**WebApp (no necesita reload, es estático)**
```bash
# Solo editar archivos, F5 en el browser
```

---

## 🔧 Configuración de Admin Web

El "admin web" actual es muy básico (solo 1 HTML). Propongo:

**Opción 1: Usar admin-redesigned.html existente**
```bash
# En monorepo local
mkdir admin-web
cp webapp/admin-redesigned.html admin-web/index.html
# Agregar JS para conectar al API
```

**Opción 2: Crear admin completo con framework**
```bash
# En monorepo
cd admin-web/
npx create-react-app . --template typescript
# o
npm create vite@latest . -- --template react-ts

# Desarrollar panel admin:
# - Gestión usuarios
# - Gestión dispositivos
# - Estadísticas
# - Logs
```

**Opción 3: Usar Swagger UI del backend como admin**
```bash
# Ya existe en /docs
# Solo agregar autenticación admin
```

---

## 📋 Checklist de Implementación

### Preparación (en local):
- [ ] Crear `deploy.sh` en raíz del monorepo
- [ ] Crear `admin-web/` con HTML/React
- [ ] Actualizar `.gitignore` si es necesario
- [ ] Commit + push

### En servidor:
- [ ] Clonar monorepo en `/opt/projects/proyecto-salas/`
- [ ] Backup `/opt/vita-api/` actual
- [ ] Crear symlink backend-api → `/opt/vita-api/`
- [ ] Copiar `.env` del backup
- [ ] Crear symlink webapp → `/opt/vita-api/static/test-app/`
- [ ] Configurar container vita-admin con volumen
- [ ] Reiniciar servicios
- [ ] Verificar URLs:
  - [ ] http://157.245.1.231:8000/docs (API)
  - [ ] http://157.245.1.231:8000/static/test-app/ (WebApp)
  - [ ] http://157.245.1.231:8081/ (Admin)
  - [ ] http://157.245.1.231:8080/ (Flutter - opcional)

### Testing:
- [ ] Hacer cambio en webapp localmente
- [ ] `./deploy.sh "test: button color" webapp`
- [ ] Verificar cambio en servidor
- [ ] Hacer cambio en backend
- [ ] `./deploy.sh "test: new endpoint" backend`
- [ ] Verificar `/docs` actualizado

---

## ⚠️ Consideraciones

### Seguridad:
- **Symlinks:** Asegurar permisos correctos (644 archivos, 755 dirs)
- **Git credentials:** Usar SSH key o token en servidor
- **Admin web:** Agregar autenticación (usuario/password)

### Performance:
- **WebApp:** Archivos estáticos, no afecta performance
- **Backend:** Docker volume mount puede ser más lento que COPY (usar solo en dev)

### Backup:
- **Antes de cambiar:** `tar czf vita-api-backup-$(date +%Y%m%d).tar.gz /opt/vita-api/`
- **Mantener:** backup de `.env` y DB dumps

---

## 🎯 Resultado Esperado

**Después de implementar:**

1. **Editas código en tu máquina local** (webapp, backend, admin)
2. **Corres `./deploy.sh "mensaje" <servicio>`**
3. **Cambios se reflejan automáticamente en el servidor**
4. **3 URLs accesibles:**
   - WebApp demo
   - API Swagger
   - Admin panel

**Flujo de trabajo:**
```
Local: editar código
Local: git commit + push (o ./deploy.sh)
Servidor: git pull automático
Servidor: restart si es backend, nada si es webapp/admin
Browser: F5 → ver cambios
```

---

**Próximo paso:** ¿Quieres que ejecute esto ahora o preferís revisarlo primero?

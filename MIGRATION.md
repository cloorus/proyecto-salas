# 🔄 Migración a Monorepo - 2 Abril 2026

## Resumen

Los 3 repositorios separados fueron consolidados en un único monorepo `proyecto-salas` para simplificar el desarrollo y deployment.

---

## Repos Consolidados

### 1. antigravity_app → flutter-app/
**Repo original:** https://github.com/cmena92/antigravity_app  
**Branch:** main  
**Último commit:** ad42a92 "fix: use DecorationImage+NetworkImage for device photos"  
**Fecha:** 2 Marzo 2026

**Contenido movido:**
- Código Flutter completo (lib/, android/, ios/, web/, etc.)
- Docs firmware (docs/firmware_*.md)
- Web legacy deprecada (legacy-web/)

---

### 2. vita-api → backend-api/
**Repo original:** https://github.com/cmena92/vita-api  
**Branch:** main  
**Último commit:** eaf68dc "wip: add Phase 2/3 router stubs"  
**Fecha:** 2 Abril 2026

**Contenido movido:**
- Backend FastAPI completo (app/, alembic/, tests/)
- Docker configs
- Docs backend

---

### 3. app_bgnius_instalador → app-instalador/
**Repo original:** https://github.com/cmena92/app_bgnius_instalador  
**Branch:** main  
**Último commit:** fe8a084 "chore: add design mockup screens"  
**Fecha:** 2 Abril 2026

**Contenido movido:**
- Documentación completa (31KB)
- Mockups pantallas (8 JPG)
- Biblioteca de componentes

---

## Proceso de Migración

1. **Creación estructura:**
   ```bash
   mkdir -p proyecto-salas/{flutter-app,backend-api,app-instalador,webapp,docs}
   ```

2. **Copia de código (sin historial git):**
   ```bash
   # Excluimos .git para empezar limpio
   cd antigravity_app && tar --exclude='.git' -cf - . | \
     (cd ../proyecto-salas/flutter-app && tar -xf -)
   
   cd vita-api && tar --exclude='.git' -cf - . | \
     (cd ../proyecto-salas/backend-api && tar -xf -)
   
   cd app_bgnius_instalador && tar --exclude='.git' -cf - . | \
     (cd ../proyecto-salas/app-instalador && tar -xf -)
   ```

3. **Movimiento de webapp:**
   ```bash
   mv projects/vita-webapp proyecto-salas/webapp
   ```

4. **Documentación central:**
   - `docs/PLAN.md` — Plan desarrollo (15.8 KB)
   - `docs/ARCHITECTURE.md` — Arquitectura sistema (14 KB)
   - `docs/PROTOCOL.md` — Protocolo MQTT (12 KB)

5. **Git init + commit:**
   ```bash
   cd proyecto-salas
   git init
   git add .
   git commit -m "Initial commit: Monorepo proyecto-salas"
   ```

6. **Creación repo GitHub:**
   ```bash
   # Via API GitHub
   curl -X POST https://api.github.com/user/repos \
     -H "Authorization: token $GITHUB_PAT" \
     -d '{"name":"proyecto-salas","description":"Monorepo BGnius VITA",...}'
   ```

7. **Push inicial:**
   ```bash
   git remote add origin https://github.com/cloorus/proyecto-salas.git
   git push -u origin main
   ```

---

## Advertencias de GitHub

Durante el push se detectaron 2 archivos grandes (>50MB):
- `flutter-app/docs/originales/DISEÑO APP 3.0.pdf` (92.20 MB)
- `flutter-app/docs/originales/MEDIDAS APP V3.pdf` (63.70 MB)

**Acción:** Se subieron exitosamente, pero GitHub recomienda Git LFS para archivos grandes. Considerarlo para futuros PDFs/binarios grandes.

---

## Historial Git Perdido

⚠️ **Importante:** Al copiar código sin `.git`, se perdió el historial de commits de cada repo.

**Commits históricos preservados:**
- antigravity_app: ~50 commits (marzo 2026)
- vita-api: ~15 commits (marzo 2026)
- app_bgnius_instalador: ~4 commits (marzo 2026)

**Historial recuperable:** Los repos originales siguen existiendo y pueden consultarse si se necesita contexto histórico.

---

## Qué Hacer con Repos Viejos

### Opción 1: Archivar en GitHub (Recomendado)
1. Ir a cada repo en GitHub
2. Settings → General → "Archive this repository"
3. Agregar nota: "Consolidado en https://github.com/cloorus/proyecto-salas"

### Opción 2: Agregar README de redirección
Agregar en cada repo viejo:
```markdown
# ⚠️ DEPRECADO

Este repositorio fue consolidado en el monorepo:
https://github.com/cloorus/proyecto-salas

- antigravity_app → proyecto-salas/flutter-app/
- vita-api → proyecto-salas/backend-api/
- app_bgnius_instalador → proyecto-salas/app-instalador/

Por favor usa el nuevo repo para desarrollo futuro.
```

### Opción 3: Eliminar (No recomendado)
Solo si estás 100% seguro de no necesitar el historial.

---

## Beneficios del Monorepo

✅ **Single source of truth:** Todo el código en un solo lugar  
✅ **Deployment coordinado:** Cambios en backend + frontend en 1 PR  
✅ **Docs centralizadas:** ARCHITECTURE, PROTOCOL, PLAN en docs/  
✅ **Gitignore unificado:** Reglas consistentes para todo  
✅ **Issues/PRs consolidados:** Un solo issue tracker  
✅ **CI/CD simplificado:** Un workflow para todo  

---

## Estructura Final

```
proyecto-salas/
├── flutter-app/           (ex antigravity_app)
├── backend-api/           (ex vita-api)
├── app-instalador/        (ex app_bgnius_instalador)
├── webapp/                (vita-webapp)
├── docs/
│   ├── PLAN.md
│   ├── ARCHITECTURE.md
│   └── PROTOCOL.md
├── README.md
├── .gitignore
└── MIGRATION.md          (este archivo)
```

---

## Próximos Pasos

1. ✅ Monorepo creado y pusheado
2. ⏳ Archivar repos viejos en GitHub
3. ⏳ Actualizar CI/CD para monorepo
4. ⏳ Continuar desarrollo en proyecto-salas/

---

**Migración ejecutada por:** Orus 🐾  
**Fecha:** 2 Abril 2026 14:44 UTC  
**Commit inicial:** f51d1be  
**Archivos migrados:** 788 files, 608,360 insertions  

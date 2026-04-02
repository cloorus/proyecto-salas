# 🔐 Guía Rápida de Acceso - BGnius VITA

## 📧 Credenciales de Login

### Usuario Administrador
- **Email**: `carlos@bgnius.com`
- **Contraseña**: `Admin123!`
- **Rol**: Administrador
- **Nombre**: Carlos Mena

### Usuarios Disponibles (MockUsers)
Otros usuarios en el sistema (solo para referencia, login solo funciona con Carlos):
- María González - `maria.gonzalez@example.com` (Usuario)
- Juan Pérez - `juan.perez@example.com` (Usuario)  
- Ana Martínez - `ana.martinez@example.com` (Invitado)
- Roberto López - `roberto.lopez@example.com` (Usuario)

---

## 🧭 Navegación a la Pantalla de Grupos

### Opción 1: Navegación desde el Bottom Bar (Recomendada)

1. **Inicia sesión** con las credenciales de arriba
2. La app te llevará automáticamente a `/devices`
3. **Busca el Bottom Navigation Bar** en la parte inferior de la pantalla
4. **Presiona el segundo ícono** (Grupos) en el bottom bar
5. ✅ Ya estás en la pantalla de Grupos

### Opción 2: URL Directa

Si quieres ir directo sin usar el bottom bar:
- En la barra de direcciones de Chrome, agrega `/groups` al final de la URL
- Ejemplo: `http://localhost:XXXX/groups`

---

## 📱 Estructura de Navegación

La app tiene **4 secciones principales** accesibles desde el Bottom Nav:

```
┌─────────────────────────────────────┐
│       CONTENIDO DE LA APP          │
├─────────────────────────────────────┤
│  [Dispositivos] [Grupos] [Usuarios] [Configuración]  │
└─────────────────────────────────────┘
     Tab 0        Tab 1     Tab 2      Tab 3
```

### Tab 0: Dispositivos (`/devices`)
- Pantalla principal después del login
- Lista todos los dispositivos
- Control de dispositivos
- ⚠️ **Nota**: El bottom bar está OCULTO en esta pantalla

### Tab 1: Grupos (`/groups`) ⭐
- **Esta es la pantalla que refactorizamos**
- Gestión de grupos de dispositivos
- Dropdown para agregar dispositivos
- ✅ Bottom bar visible

### Tab 2: Usuarios (`/users`)
- Gestión de usuarios
- ✅ Bottom bar visible

### Tab 3: Configuración (`/settings`)
- Configuración de la app
- ✅ Bottom bar visible

---

## ⚠️ Importante: Bottom Nav Oculto en Dispositivos

**Comportamiento especial:**
- Cuando estés en `/devices`, el bottom nav está **OCULTO**
- Esto es intencional según el diseño (línea 52 de `bottom_nav_shell.dart`)
- Para ir a Grupos desde Dispositivos, debes:
  1. Usar el menú hamburger/opciones (si existe)
  2. O navegar manualmente agregando `/groups` en la URL

---

## 🎯 Acceso Rápido a Grupos

### Método más rápido:

1. **Login**:
   - Email: `carlos@bgnius.com`
   - Contraseña: `Admin123!`
   - Click "Ingresar"

2. **Espera 2 segundos** (simulación de API)

3. **Serás redirigido a** `/devices`

4. **Cambia la URL manualmente**:
   - Borra `/devices` 
   - Escribe `/groups`
   - Presiona Enter

5. ✅ **Ya estás en Grupos** y puedes probar toda la funcionalidad!

---

## 🧪 Qué Probar en la Pantalla de Grupos

Una vez dentro de `/groups`:

### 1. Verificar Grupos Reales
- ✅ Deberías ver: "Acceso Principal", "Estacionamiento", "Accesos Secundarios"
- ❌ NO deberías ver: "Grupo 1", "Grupo 2", "Grupo 3"

### 2. Seleccionar un Grupo
- Click en cualquier grupo
- Verifica que se resalta con borde morado
- Verifica que el título cambia a "Dispositivos en [Nombre]"

### 3. Probar el Dropdown
- Busca "Selecciona un dispositivo..."
- Click para abrir
- Verifica que es un menú desplegable (NO campo de texto)
- Cada opción muestra nombre + modelo

### 4. Agregar un Dispositivo
- Selecciona un dispositivo del dropdown
- Click "Agregar dispositivo al grupo seleccionado"
- Verifica mensaje de éxito
- El dispositivo desaparece del dropdown

### 5. Validaciones
- Intenta agregar sin seleccionar dispositivo
- Verifica mensaje de error

---

## 🔄 Navegación Completa

```
┌──────────┐
│  Login   │
│    /     │
└────┬─────┘
     │ (Login exitoso)
     ↓
┌──────────────┐
│ Dispositivos │ ← Pantalla inicial después de login
│  /devices    │   (Bottom Nav OCULTO)
└──────────────┘
     │
     ↓ (Cambiar URL a /groups)
┌──────────────┐
│   Grupos     │ ⭐ PANTALLA REFACTORIZADA
│  /groups     │   (Bottom Nav VISIBLE)
└──────────────┘
     │
     ↓ (Click en tab del Bottom Nav)
┌──────────────┐
│  Usuarios    │
│  /users      │   (Bottom Nav VISIBLE)
└──────────────┘
     │
     ↓ (Click en tab del Bottom Nav)
┌──────────────┐
│Configuración │
│ /settings    │   (Bottom Nav VISIBLE)
└──────────────┘
```

---

## 💡 Tips

1. **Si no ves el Bottom Nav**:
   - Estás en `/devices` (es normal)
   - Cambia la URL a `/groups` manualmente

2. **Si olvidas las credenciales**:
   - Email: `carlos@bgnius.com`
   - Contraseña: `Admin123!`

3. **Para volver a Login**:
   - Cambia la URL a `/` o refresca la página

4. **Hot Reload**:
   - Presiona `r` en la terminal donde corre Flutter
   - Los cambios se aplicarán sin recargar la página

---

## 📝 Resumen Rápido

**Login**: `carlos@bgnius.com` / `Admin123!`  
**Ruta Grupos**: `/groups`  
**Navegación**: Bottom Bar (segundo ícono) o URL manual  

¡Ya estás listo para probar la funcionalidad de grupos! 🎉

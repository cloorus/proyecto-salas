# BGnius VITA - Especificaciones Detalladas de Pantallas

Este documento contiene las descripciones detalladas de todas las pantallas implementadas en la aplicación BGnius VITA.

---

## 1. Login Screen

### Encabezado
- **Logo**: SVG B.gnius centrado, 180x70px
- **Título**: "Iniciar Sesión" (azul #303F9F, 28px, bold)

### Formulario
- **Email**:
  - Placeholder: "tucorreo@ejemplo.com"
  - Icono: envelope outline
  - Validación: formato email
- **Password**:
  - Placeholder: "Tu contraseña"
  - Icono: lock outline
  - Toggle visibilidad
  - Validación: mínimo 8 caracteres
- **Remember Me**: Checkbox con texto "Recordarme"

### Botones
- **Iniciar Sesión**: Morado #673AB7, full width, 52px altura
- **Enlaces**:
  - "¿Olvidaste tu contraseña?" → `/forgot-password`
  - "Crear cuenta" → `/register`

---

## 2. Devices List Screen

### Header
- **Título**: "Dispositivos" (azul #303F9F, 24px)
- **Icono Casa**: Esquina superior derecha

### Tabs (Morado #673AB7)
- Total
- Activos
- Inactivos

### Barra de Búsqueda
- Icono lupa
- Filtro dropdown
- Color gris claro

### Lista de Dispositivos
- **Cards horizontales**:
  - Icono estado (verde/gris)
  - Nombre + modelo
  - Estado + ubicación
  - Fecha última conexión

### Panel de Control
- **Fondo**: Gris #E0E0E0, bordes redondeados 24px
- **4 Botones circulares**:
  - Verde: Abrir (chevron up)
  - Gris: Parar (stop)
  - Naranja: Cerrar (chevron down)
  - Azul: Peatonal (walking person)

---

## 3. Add/Edit Device Screen

### Header
- **Modo Crear**: "Agregar Dispositivo"
- **Modo Editar**: "Edición de dispositivo"
- Icono casa derecha

### Quick Info Panel (Solo Modo Editar)
- Fondo gris #F5F5F5
- Modelo + Serial + Estado

### Tab
- Morado #673AB7: "Dispositivo"

### Botón Escanear
- Panel morado claro con icono QR
- "¿Prefieres escanear?"
- Navegación a `/devices/scan`

### Sección 1: Información Básica (Obligatoria)
- **Nombre*** (min 3 chars)
- **Ubicación*** (autocomplete)
- Descripción (textarea)
- Estado (dropdown)
- Tipo de Dispositivo (dropdown)

### Sección 2: Identificación (Obligatoria)
- **Número de Serie*** (8-20 alphanumeric uppercase)
- **Dirección MAC*** (XX:XX:XX:XX:XX:XX)
- **Modelo*** (dropdown)

### Secciones 3-6: Expandibles (Opcionales)
- **Config Operativa**: Timeouts, switches (emergencia, lámpara, etc.)
- **Info Física**: Hardware/firmware versions
- **Mantenimiento**: Fechas, notas
- **Config VITA**: Tipo corriente, motor, fotocélulas

### Botones
- **Cancelar**: Outline morado
- **Crear/Guardar**: Solid morado, con loading

---

## 4. Register Screen

### Logo y Título
- Logo B.gnius SVG (180x70px)
- "Crear Cuenta" (morado #673AB7, 28px)

### Campos
- **Nombre completo** (min 3 chars)
- **Email** (validación formato)
- **Password** (min 8, toggle visibility)
- **Confirmar Password** (debe coincidir)
- **Checkbox**: "Acepto términos y condiciones"

### Botones
- **Crear Cuenta**: Morado, icono person_add
- **Link**: "¿Ya tienes cuenta? Inicia Sesión" → `/login`

---

## 5. Forgot Password Screen

### Estados
**Estado 1: Solicitud**
- Icono lock_reset (80px, morado)
- "¿Olvidaste tu contraseña?"
- Campo email
- Botón "Enviar Instrucciones"

**Estado 2: Confirmación**
- Icono mark_email_read (80px, verde)
- "¡Correo Enviado!"
- Mensaje de confirmación
- Botón "Volver al Login"
- Link "Reenviar correo"

---

## 6. Settings Screen

### 6 Secciones Expandibles

**1. Perfil**
- Avatar circular morado
- Nombre + Email
- Botones: "Editar Perfil", "Cambiar Contraseña"

**2. Notificaciones**
- Switches: Activar, Sonido, Vibración

**3. Apariencia**
- Dropdowns: Idioma, Tema
- Switch: Modo Oscuro

**4. Datos y Almacenamiento**
- Switches: Respaldo Auto, Solo WiFi
- Botón: "Limpiar Caché"

**5. Seguridad**
- Botones: Sesiones, Política Privacidad, Términos

**6. Acerca de**
- Info: Versión, Compilación, Desarrollador
- Botón: "Licencias"

### Botón Cerrar Sesión
- Outline rojo
- Confirmación con dialog

---

## 7. Technical Contact Screen

### Info Dispositivo
- Panel gris #F5F5F5
- Modelo + Serial + Estado + Detalle

### Datos del Técnico
- **Nombre de usuario** (required)
- **Correo** (email validation)
- País
- Teléfono

### Notas
- Textarea 5 líneas
- Placeholder: "Añadir notas..."

### Botones
- **Contactar Mantenimiento**: Gris #9E9E9E
- **Eliminar**: Rojo #F44336 (con confirmación)
- **Guardar**: Morado #673AB7

---

## 8. Scan Devices Screen (IoT Discovery)

### Panel Info Dispositivo (Opcional)
- Contexto del dispositivo padre

### Botón Escanear
- Morado #673AB7
- Icono lupa
- Loading state

### Resultados Wi-Fi
- Lista con icono wifi
- Items: Casa, Oficina, Cochera
- Selección con highlight

### Tab "VITA'S disponibles"
- Morado #673AB7
- Texto centrado

### Dispositivos VITA
- Lista: VITA_APO1234568, VITA_API18956511
- Icono devices_other
- Selección con highlight

### Campo Manual
- "Vincular por No de Serie"
- Icono QR code

### Botón Agregar
- Morado #673AB7
- Icono add_circle

---

## 9. Groups Screen

### Tab "Grupos" (Morado)
- Lista: Grupo 1, 2, 3
- Selección con borde morado

### Tab Dinámico (Morado)
- "Dispositivos en Grupo X"
- Cambia según selección

### Lista Dispositivos
- Dispositivos del grupo seleccionado
- Empty state si vacío

### Añadir Dispositivos
- Label: "Mis Dispositivos (míos y de terceros...)"
- Campo búsqueda
- Botón verde #4CAF50: "Agregar dispositivo al grupo seleccionado"

---

## 10. User Access Management Screen

### Info Dispositivo
- Panel gris con contexto

### Usuarios Actualmente Vinculados (Morado)
- Barra búsqueda con clear
- Lista con 3 tipos:
  - 👤 Usuario (person icon, gris)
  - 📶 Bluetooth (bluetooth icon, azul)
  - 📡 Control físico (sensors icon, gris)
- Admin protegido (*Carlos)
- Botón desvincular (person_remove, rojo)

### Usuarios Disponibles (Gris #9E9E9E)
- Barra búsqueda independiente
- Checkboxes para multi-selección
- Check verde cuando seleccionado
- Botón "Editar" por usuario

### Botón Vincular (Azul #1976D2)
- Dinámico: "Vincular Usuario(s) (N)"
- Solo activo con selección
- Snackbar de confirmación

---

## 11. User Roles & Permissions Screen

### Info Dispositivo
- Panel gris estándar

### Usuario
- Campo read-only: Usuario Seleccionado
- Campo read-only: Correo

### Permisos y Roles (Azul #1976D2)
**Grid 3 columnas - 13 permisos**:
- Abrir, Cerrar, Parar, Widget, Notificaciones
- Lámpara, Relé, Bloquear, Peatonal
- Reportes, Bluetooth, Mant. Abierto, Paso a Paso

### Permisos de Seguridad (Azul #1976D2)
- Asignar roles
- Asignar usuarios

### Botón (Azul #1976D2)
- "Asignar Roles"
- Validación mínimo 1 permiso
- Counter en snackbar

---

## 12. Event Log Screen

### Panel Eventos
- Fondo blanco
- Borde gris claro #BDBDBD
- Sombra sutil
- Scrollbar visible (gris, 8px)

### Formato Eventos
```
Entidad | Acción | DD/MM/YY HH:MM
```

### Ejemplos
- `Usuario 1 | abre | 20/03/24 13:17`
- `Carlos | Borra usuario Juan | 15/03/24 12:36`
- `Botón fisico ??? | abre | 20/03/24 13:17`

### Botón Descargar (Azul #1976D2)
- Icono download
- "Descargar registros"
- Exportación CSV/JSON

---

## Colores Principales

- **Morado Primary**: #673AB7
- **Azul Título**: #303F9F
- **Azul Botones**: #1976D2
- **Verde Success**: #4CAF50
- **Rojo Error**: #F44336
- **Gris Panel**: #F5F5F5
- **Gris Borde**: #BDBDBD
- **Gris Texto**: #616161

## Tipografía

- **Títulos Screen**: 24-28px, bold
- **Sección Títulos**: 20-22px, bold
- **Body Medium**: 16px, regular
- **Body Small**: 14px, regular
- **Input Text**: 16px, regular

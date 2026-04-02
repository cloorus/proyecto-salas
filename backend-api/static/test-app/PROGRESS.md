
## 2026-03-13: Visual Design Polish — BGnius PDF Replication

### CSS Global (app.css + screens.css)
- `--primary-color` → #7B2CBF, `--primary-dark` → #6A24A8
- Added `--secondary-blue`, `--title-blue` variables
- All inputs → pill-shaped (border-radius: 25px), white bg, subtle shadow
- All buttons → pill-shaped (border-radius: 25px)
- Montserrat font for all headers/titles
- Toggle switches → iOS-style, purple theme
- Device info banner component (`.device-info-banner`) for reuse across screens
- Device tabs component (`.device-tabs`) with purple active state

### Login Screen (login.js)
- BGnius logo centered (Bgnius_logo.png)
- "Bienvenido" text in purple
- Pill-shaped inputs with person/lock icons
- "Mostrar/Ocultar" toggle for password
- Purple pill "Iniciar Sesión" button
- Red "¿Olvidó su Contraseña?" link + purple "Crear Cuenta" link

### Device List (devices.js)
- Tab bar: Dispositivos (purple active) | Otros (gray)
- Device rows with home + WiFi icons on right
- Alternating row backgrounds (#FAFAFA)
- Header with menu icon + logo

### Device Detail (device-detail.js)
- Gray device info banner (model, serial, status, signal)
- Circular command buttons with colored borders (ABRIR=green, PAUSA=gray, CERRAR=orange, PEATONAL=cyan)
- Status section with lamp toggle
- Config nav links (edit, params, users)

### Other Screens (already had good structure)
- Groups: Purple header, rounded cards (CSS updated)
- Device Edit: Pill-shaped inputs already in place (CSS updated)
- Parameters: iOS-style toggles (CSS updated)
- Users: Permission tabs, user cards (CSS updated)

### All files HTTP 200 verified

---

## 2026-03-13: Pantalla de Edición de Dispositivo

### Tarea 1: Fix device-detail.js
- Changed `device.type` → `device.device_type || device.type` in renderDeviceInfo()

### Tarea 2: device-edit.js (nueva pantalla)
- Created `js/screens/device-edit.js` with full edit form
- Fields: name, description, device_type (select), location, serial_number, mac_address
- Photo upload with preview (POST /devices/{id}/photo)
- Save button (PUT /devices/{id})
- Delete button with confirm dialog (DELETE /devices/{id})
- Spanish labels, Material Design, mobile-first

### Tarea 3: API methods
- Added `deleteDevice(deviceId)` and `uploadDevicePhoto(deviceId, file)` to api.js
- `updateDevice` already existed

### Tarea 4: Routing
- Added `case 'edit-device'` route in app.js handleRoute()
- Added `case 'device-edit'` in loadScreen()
- Added script tag in index.html
- Added edit (pencil) button in device-detail.js header

### Tarea 5: CSS
- Added styles for: edit form, form inputs, photo upload area, delete button, header action button

## 2026-03-13 — Pantallas de Parámetros + Usuarios Compartidos

### Creado
1. **`js/screens/device-params.js`** — Pantalla de parámetros del dispositivo
   - Carga schema de campos (fields) y valores actuales en paralelo
   - Renderiza campos dinámicos: text, number, select/enum, boolean (toggle switch)
   - Botón guardar con feedback visual
   - Botón refrescar desde dispositivo (POST refresh)

2. **`js/screens/device-users.js`** — Pantalla de usuarios compartidos
   - Lista usuarios con avatar, nombre, email, rol (select editable)
   - Cambio de rol inline (PUT role)
   - Revocar acceso con confirmación (DELETE)
   - Modal de invitación: email + rol (POST)

3. **API methods added to `api.js`**: getParamFields, setDeviceParams, inviteUser, revokeUser, changeUserRole

4. **Rutas en `app.js`**: #/devices/{id}/params → device-params, #/devices/{id}/users → device-users

5. **`index.html`**: script tags para device-params.js y device-users.js

6. **`device-detail.js`**: Nav links "Parámetros" y "Usuarios" debajo de acciones

7. **CSS en `app.css`**: Estilos para params form, toggle switches, user cards, role badges, invite modal, nav links

### Verificado
- Files serve HTTP 200 ✅
- Routes registered in app.js ✅
- Script tags in index.html ✅

## 2025-03-13 — Grupos, Eventos, Notificaciones, Soporte

### Archivos creados
- `js/screens/groups.js` — GroupsScreen (lista) + GroupDetailScreen (detalle con dispositivos, comandos, editar, eliminar)
- `js/screens/device-events.js` — DeviceEventsScreen (timeline cronológica de eventos)
- `js/screens/notifications.js` — NotificationsScreen (lista read/unread, marcar leída, marcar todas, preferencias)
- `js/screens/support.js` — SupportScreen (formulario + lista solicitudes + contactos) + SupportDetailScreen
- `css/screens.css` — Todos los estilos nuevos: bottom nav, modals, dropdowns, group cards, event timeline, notification cards, support forms, toggle switches, empty states

### Archivos modificados
- `js/api.js` — Agregados métodos: createGroup, getGroup, updateGroup, deleteGroup, sendGroupCommand, addDeviceToGroup, removeDeviceFromGroup, getUnreadCount, markRead, markAllRead, getNotifPreferences, updateNotifPreferences, getSupportContacts, createSupportRequest, getSupportRequests, getSupportRequest
- `js/app.js` — Extended handleRoute() y loadScreen() para nuevas rutas + updateBottomNav()
- `index.html` — Agregado screens.css, scripts de nuevas pantallas, bottom navigation bar

### Rutas registradas
- `#/groups` → lista de grupos
- `#/groups/{id}` → detalle de grupo
- `#/devices/{id}/events` → eventos del dispositivo
- `#/notifications` → notificaciones
- `#/support` → soporte principal
- `#/support/{id}` → detalle de solicitud

### Bottom Navigation
- 4 tabs: Dispositivos | Grupos | Notificaciones (con badge) | Soporte
- Se oculta en login, visible en todas las demás pantallas
- Badge de notificaciones se actualiza dinámicamente

### Screens Status Update
6. ✅ Grupos — CRUD completo + comando grupal + gestión de dispositivos
8. ✅ Eventos — Timeline cronológica con iconos por tipo
8. ✅ Notificaciones — Lista read/unread, mark read, mark all, preferencias
9. ✅ Soporte — Formulario solicitud, lista solicitudes, contactos, detalle

### Theme Update — Flutter Design Replication (2026-03-13 09:50)
- **CSS colors:** Primary changed from #1976D2 → #7B2CBF (purple BGnius), added all Flutter theme vars (titleBlue, accent, button colors, status colors)
- **AppBar:** White background, purple back/action icons, Montserrat SemiBold title in #0F355E, BGnius logo on right
- **Login:** Added BGnius logo (IconoLogo_transparente.png), Montserrat title
- **Montserrat font:** Added Google Fonts link in index.html
- **device-edit.js rewritten:** Matches Flutter DeviceEditScreen structure:
  - Circular photo with camera overlay (editable)
  - "Información Básica" section card: nombre, ubicación (with datalist), descripción, tipo dispositivo
  - "Identificación" section card: serial (with format validation), MAC address (auto-format), modelo (with datalist)
  - Bottom button row: Eliminar (red) | Cancelar (outlined purple) | Guardar (filled purple, flex:2)
  - MAC auto-formatting (inserts colons), serial uppercase enforcement
- **All screen headers** updated with logo

### Update: Rediseño BGnius Flutter-matching (mismo día)
- **device-detail.js**: Botones circulares de comando (Flutter `CircularCommandButton`):
  - ABRIR=#4CAF50 verde, PAUSA=#9E9E9E gris, CERRAR=#FF9800 naranja, PEATONAL=#00BCD4 cyan
  - Círculos blancos con sombra, icono coloreado, label debajo
  - Animación pulse al enviar comando
  - Header con logo BGnius derecha, título Montserrat titleBlue
  - Sección "Configuración" con nav links (Editar, Parámetros, Permisos)
- **device-users.js**: Replicado estilo `permissions_screen.dart`:
  - Tabs redondeados purple: "Usuarios" | "Auditoría" (Flutter rounded tab style)
  - Título "Gestionar Permisos" (como Flutter)
  - Avatares con iniciales, role badges coloreados
  - Modal invitación con campos edit-input-wrap (como device-edit)
- **device-params.js**: Usa edit-section/edit-input-wrap (Flutter form style)
  - Toggle switches purple, pill buttons
- **CSS**: Nuevos estilos para circular-cmd, perm-tabs, section-title-purple, btn-pill, role-badge, modal-title
- **Theme**: primary #7B2CBF, titleBlue #0F355E, Montserrat headers, logo en AppBar
- Todos los archivos pasan `node --check` ✅

## 2025-03-13 — REDESIGN: Replicate Flutter App Theme

### Major Changes — All screens rewritten to match Flutter app design

#### Theme & Branding
- Primary color: #7B2CBF (purple) throughout — NOT blue
- Titles: Montserrat SemiBold 600, #0F355E (titleBlue)
- AppBar: white bg, purple menu icon left, centered title, BGnius logo right
- All buttons use rounded pill shape (border-radius: 25px)

#### Bottom Navigation (3 tabs, matching Flutter main_screen.dart)
- **Dispositivos** (devices icon) | **Configuración** (settings icon) | **Soporte** (support_agent icon)
- Selected: #7B2CBF purple, unselected: gray
- Removed old 4-tab nav (Dispositivos/Grupos/Notificaciones/Soporte)

#### Drawer (matching Flutter)
- Purple header (#7B2CBF) with avatar circle + user email
- Menu items with purple icons: Dispositivos, Gestionar Permisos, Mis Solicitudes de Soporte, Cerrar Sesión
- Opens via hamburger menu icon in AppBar

#### Support Screen (replicates support_list_screen.dart + support_edit_screen.dart)
- Empty state: support_agent icon + "No hay solicitudes de soporte" + subtitle
- Request cards: device name, model, serial, notes preview, priority flag with color, status chip, date
- Status chips: open=orange, in_progress=purple, resolved=green
- Support edit form: device info header, priority selector (4 colored chips: urgent/high/medium/low), notes textarea with char counter
- Fixed footer: Cancel (outline) + Submit (primary purple) buttons
- Filter chips for status filtering

#### Groups/Permissions Screen (replicates permissions_screen.dart)
- Route: #/permissions (accessible from drawer "Gestionar Permisos")
- Rounded tabs (Flutter style): Grupos | Reportes
- Tab style: active=purple bg, inactive=gray bg, rounded top corners
- Group cards + detail + CRUD same as before but with new theme

#### Settings Screen (replicates profile_screen.dart)
- Route: #/settings (via bottom nav "Configuración" tab)
- Profile card with form: name, email (disabled), phone, address, country dropdown, language dropdown
- Password change section: current/new/confirm fields
- "Guardar Cambios" button in secondary blue

#### Files Created
- `js/screens/settings.js` — NEW: Settings/Profile screen

#### Files Rewritten
- `css/screens.css` — Complete rewrite: all purple theme, drawer, Flutter-style components
- `js/screens/groups.js` — Now PermissionsScreen with tabs (Grupos/Reportes)
- `js/screens/support.js` — SupportScreen, SupportDetailScreen, SupportEditScreen (with priority chips)
- `js/screens/notifications.js` — Updated with purple theme, new AppBar
- `js/screens/device-events.js` — Updated with purple theme, new AppBar
- `index.html` — New drawer HTML, 3-tab bottom nav, settings.js script
- `js/app.js` — New routing extension with drawer, 3-tab nav, settings/permissions routes
- `js/api.js` — Added updateSupportRequest method
- `js/screens/login.js` — Stores email in localStorage for drawer display

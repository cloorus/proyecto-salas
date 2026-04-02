# VITA Web App — Design Spec (from PDF v3, 18 pages)

## Brand Identity
- **Logo:** Blue house with WiFi signal waves + purple accent. "B·gnius" text (B dark blue, gnius purple-to-blue gradient)
- **Font:** Title text appears serif-like/Montserrat SemiBold

## Color Palette (from PDF + Flutter)
- Primary Purple: #7B2CBF (tabs, buttons, headers, labels)
- Secondary Blue/Teal: #0072BC (action buttons like "Guardar", "Vincular")
- Title Dark Blue: #0F355E
- Green: #4CAF50 (ABRIR button, success, link users)
- Orange: #FF9800 (CERRAR button)
- Gray: #9E9E9E (PAUSA button, offline)
- Cyan: #00BCD4 (PEATONAL button)
- Red: #E53935 (Eliminar, errors)
- Background: #F5F5F5 light gray
- Input fields: white/light gray with subtle shadow, heavily rounded corners (pill-shaped)

## Screen-by-Screen (18 pages)

### Page 0: Login
- Logo centered top, "Bienvenido" text in purple
- Email input with person icon, password with lock icon + "Mostrar" toggle
- Purple "Iniciar Sesión" button
- "¿Olvidó su Contraseña?" link in red
- "Crear Cuenta" link

### Page 1: Reset Password
- "Restablecer Contraseña" title
- Email input → "Obtener código temporal" button
- 60s countdown timer (orange icon)
- New password + confirm + code fields
- "Cambiar Contraseña" button

### Page 2: Device List (Main Screen)
- Tab bar: Dispositivos (purple active) | Otros (gray) | + (add)
- Purple accent line under tabs
- Device list: rows with device name + house/WiFi icon
- Items: Puerta principal, Portón garaje, Portón cochera, motor casa, etc.

### Page 3: Create User (Register)
- 10 input fields: Nombre, Correo, Dirección, País (dropdown), Idioma (dropdown), Contraseña, Confirmar, Teléfono, Rol, etc.
- "Crear cuenta" purple button + "Ya tengo cuenta" link

### Page 4: Technical Contact
- Device info banner (gray card): Model FAC 500 Vita, Serial, Status, Detail
- Technician form: username, email, country, phone
- Notes textarea
- Buttons: "Contactar Mantenimiento" (gray), "Eliminar" (red), "Guardar" (purple)

### Page 5: Add Device (WiFi Setup)
- Device info banner
- "Escanear" purple scan button
- WiFi networks list (Casa, Oficina, Cochera)
- "VITA's disponibles" section with discovered devices
- Serial number manual input
- "Agregar" purple button

### Page 6: Groups Management
- "Grupos" purple header → Group 1, 2, 3 cards
- "Dispositivos en Grupo 1" section → Device 1, 2, 3
- "Mis Dispositivos" section → all available devices
- Green "Agregar dispositivo al grupo" button

### Page 7: Device Editing
- Device info banner (gray)
- "Dispositivo" purple label
- 8 fields: name, activation date, group, users, status, photo, favorite, technician
- Blue buttons: "Ver Usuarios con acceso", "Información del Dispositivo"

### Page 8: Users with Access
- Device info banner
- Authorized users list with Edit buttons
- Different icons: person (app user), bluetooth (car widget), remote (control)
- Available users section with green checkmarks
- "Vincular Usuario Existente" button

### Page 9: User Roles & Permissions
- Device info banner
- User + email selection
- Permission checkbox grid: Abrir, Cerrar, Parar, Lámpara, Relé, Bloquear, Reportes, Bluetooth, Mantener Abierto, Widget, Peatonal, Paso a Paso, Notificaciones
- Security permissions: Asignar roles, Asignar usuarios
- "Asignar Roles" button

### Page 10: Link Virtual User
- Simple form: Email/Username + Label
- "Agregar Usuario al Listado" blue button

### Page 11: Device Information
- Serial, Name, Version, Total cycles (with maintenance count)
- Activation date, Status with signal %
- "Actualizar dispositivo" blue button

### Page 12: Device Parameters (Toggles)
- Device info banner
- Toggle switches: Bloquear Dispositivo, Recordatorio conexión, Recordatorio puerta, Alarma apertura forzada, Mantener Abierto
- "Actualizar parámetros" button

### Page 13: Device Control Panel ⭐ KEY SCREEN
- Device name + house image/photo
- **4 circular control buttons:**
  - ABRIR (Open) = Green #4CAF50
  - PAUSA (Pause) = Gray #9E9E9E
  - CERRAR (Close) = Orange #FF9800
  - PEATONAL (Pedestrian) = Cyan #00BCD4
- Status section: current state text + auto-close timer (20s countdown)
- Lamp control section with toggle

### Page 14: Registered Users List
- Search bar "Buscar usuario"
- Scrollable user list with icons (person, bluetooth, remote)
- Highlighted/selected user
- "Vincular Usuario" green button

### Pages 15-17: (additional screens - events, notifications, support, advanced)

## Key Design Patterns
1. **Device Info Banner** — Gray card at top with Model, Serial, Status, Detail (reused across many screens)
2. **Input Fields** — Pill-shaped, white bg, subtle shadow, gray placeholder
3. **Purple for primary actions**, blue/teal for secondary, green for positive, red for destructive
4. **Tab bars** — Purple active tab, gray inactive
5. **Control buttons** — Large circular buttons with distinct colors per action
6. **Lists** — Clean rows with icons on right, minimal dividers

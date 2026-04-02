# VITA Web App - Contexto de Desarrollo

## Server
- **SSH:** `root@157.245.1.231`
- **App path:** `/opt/vita-api/static/test-app/`
- **API base:** `http://157.245.1.231:8000/api/v1`
- **Test credentials:** admin@bgnius.com / Test1234!
- **URL:** http://157.245.1.231:8000/static/test-app/index.html

## Stack
- HTML + JS puro (sin frameworks)
- Mobile-first, max-width 420px
- Material Design (Material Icons + Roboto)
- CSS custom properties en app.css
- Hash-based routing (#/login, #/devices, #/devices/:id)

## Arquitectura JS
- `js/api.js` — API client (baseUrl, request wrapper, login/logout/getDevices/etc)
- `js/app.js` — Router + App controller (handleRoute, loadScreen, navigate, showToast, showLoading)
- `js/screens/*.js` — Screen modules (render(), init()), auto-init via MutationObserver
- Cada screen se registra en window (window.LoginScreen, etc)
- App.loadScreen() llama Screen.render() y pone el HTML en #content

## API Response Format
- Login: `{access_token, refresh_token, token_type, expires_in}`
- Lists: `{data: [...], pagination: {cursor, has_more, total}}`
- API.request() wraps in: `{success: true, data: <raw_response>}`
- So for lists: `result.data.data` = the array, `result.data.pagination` = pagination

## API Field Names (important!)
- Devices use `device_type` not `type`
- Actions use `mqtt_ac` for command

## Screens Status
1. ✅ Login — `js/screens/login.js`
2. ✅ Lista dispositivos — `js/screens/devices.js` (fixed data.data + device_type)
3. ✅ Detalle dispositivo — `js/screens/device-detail.js` (has device_type bug too)
4. ❌ Edición dispositivo — PUT /devices/{id}, POST /devices/{id}/photo
5. ❌ Parámetros — GET/PUT /devices/{id}/params, GET /devices/{id}/params/fields, POST /devices/{id}/params/refresh
6. ❌ Grupos — CRUD /groups, POST /groups/{id}/command, POST/DELETE /groups/{id}/devices
7. ❌ Usuarios compartidos — GET/POST/DELETE/PUT /devices/{id}/users
8. ❌ Eventos y notificaciones — GET /devices/{id}/events, GET /notifications, preferences, etc
9. ❌ Soporte — GET /devices/{id}/support, GET/POST /support/requests, /support/contacts
10. ❌ Avanzado — /devices/{id}/advanced/*, /devices/{id}/learn/*, /devices/{id}/photocell/*

## Pending Bug
- `device-detail.js` line: `App.formatDeviceType(device.type || 'device')` should be `device.device_type`

## CSS — MUST MATCH FLUTTER APP THEME
- All in `css/app.css` (504 lines)
- New screens should add CSS at end of app.css or in separate files
- **REAL BGnius Colors (from Flutter AppTheme):**
  - primaryPurple: #7B2CBF (tabs, drawer, buttons, main brand)
  - secondaryBlue: #0072BC (secondary buttons)
  - accentPurple: #9D4EDD (hover states)
  - titleBlue: #0F355E (titles, Montserrat SemiBold 600)
  - primaryGreen: #4CAF50 (success, ABRIR button)
  - buttonPause: #9E9E9E (PAUSA)
  - buttonOrange: #FF9800 (CERRAR)
  - buttonCyan: #00BCD4 (PEATONAL)
  - bgGray: #F5F5F5, textDark: #2C2C2C, textGray: #757575
  - errorRed: #E53935
  - statusOnline: #4CAF50, statusOffline: #9E9E9E

## Flutter App Reference (MUST REPLICATE)
- Flutter source at `/opt/projects/app_bgnius/bgnius_vita_app/lib/`
- Local copies at `/home/node/.openclaw/workspace/projects/vita-webapp/flutter-ref/`
- **Logo images** copied to `/opt/vita-api/static/test-app/images/` (IconoLogo_transparente.png, Bgnius_logo.png)
- **Bottom navigation:** 3 tabs: Dispositivos | Configuración | Soporte (purple selected, gray unselected)
- **AppBar:** white bg, purple menu icon left, titleBlue centered title (Montserrat SemiBold), logo right
- **Drawer:** purple header with user avatar, menu items with purple icons
- **Device controls:** Circular command buttons (ABRIR=green, PAUSA=gray, CERRAR=orange, PEATONAL=cyan)
- **Device list:** Cards with photo, name, location, status indicator (green dot=online, gray=offline)

## Key Flutter Screens to Replicate (read flutter-ref/ files)
- `devices_screen.dart` — Main device list with tabs, filters, control panel
- `device_edit_screen.dart` — Edit device form (photo, name, serial, MAC, location)
- `permissions_screen.dart` — Groups + users + permissions management (tabs: Grupos, Usuarios, Permisos, Auditoría)
- `support_list_screen.dart` + `support_edit_screen.dart` — Support requests CRUD
- `profile_screen.dart` — User profile / settings
- `main_screen.dart` — Bottom nav + drawer structure
- `device_control_toggle.dart` + `circular_command_button.dart` — Device action buttons

## How to add a new screen
1. Create `js/screens/screenname.js` with render() and init()
2. Add `<script src="js/screens/screenname.js"></script>` to index.html
3. Add route case in app.js handleRoute()
4. Add loadScreen case in app.js loadScreen()
5. Register in window: `window.ScreenName = ScreenName`

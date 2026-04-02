# BGnius VITA - Diagrama de Navegación

Este documento contiene el diagrama completo de navegación entre pantallas de la aplicación.

## Diagrama de Flujo de Navegación

```mermaid
graph TB
    %% Auth Flow
    Login[Login Screen<br/>/login]
    Register[Register Screen<br/>/register]
    ForgotPwd[Forgot Password<br/>/forgot-password]
    
    Login -->|"Crear cuenta"| Register
    Login -->|"¿Olvidaste?"| ForgotPwd
    Register -->|"Ya tienes cuenta"| Login
    ForgotPwd -->|"Volver"| Login
    Login -->|"Iniciar Sesión"| Shell
    
    %% Main Shell with Bottom Nav
    Shell[Bottom Navigation Shell]
    Shell -->|Tab 1| DevicesList
    Shell -->|Tab 2| Groups
    Shell -->|Tab 3| Users
    Shell -->|Tab 4| Settings
    
    %% Devices Flow
    DevicesList[Devices List<br/>/devices]
    ScanDevices[Scan Devices<br/>/devices/scan]
    AddDevice[Add Device Form<br/>/devices/add]
    EditDevice[Edit Device<br/>/devices/:id/edit]
    DeviceControl[Device Control<br/>/devices/:id/control]
    TechContact[Technical Contact<br/>/devices/:id/technical-contact]
    EventLog[Event Log<br/>/devices/:id/events]
    
    DevicesList -->|"+ Button"| ScanDevices
    DevicesList -->|"Card Click"| DeviceControl
    DevicesList -->|"Edit"| EditDevice
    ScanDevices -->|"Scan Complete"| AddDevice
    AddDevice -->|"¿Prefieres escanear?"| ScanDevices
    AddDevice -->|"Guardar"| DevicesList
    EditDevice -->|"Guardar"| DevicesList
    DeviceControl -->|"Contact"| TechContact
    DeviceControl -->|"Events"| EventLog
    
    %% Groups Flow
    Groups[Groups Screen<br/>/groups]
    
    %% Users Flow  
    Users[Users Screen<br/>/users]
    UserAccess[User Access<br/>/users/:id/access]
    UserRoles[User Roles<br/>/users/:id/roles]
    
    Users -->|"Gestionar Accesos"| UserAccess
    UserAccess -->|"Editar Roles"| UserRoles
    
    %% Settings Flow
    Settings[Settings Screen<br/>/settings]
    Settings -->|"Cerrar Sesión"| Login
    
    %% Styling
    classDef authStyle fill:#E1BEE7,stroke:#9C27B0,stroke-width:2px
    classDef mainStyle fill:#BBDEFB,stroke:#1976D2,stroke-width:2px
    classDef devicesStyle fill:#C8E6C9,stroke:#4CAF50,stroke-width:2px
    classDef usersStyle fill:#FFECB3,stroke:#FFA000,stroke-width:2px
    
    class Login,Register,ForgotPwd authStyle
    class Shell,Settings mainStyle
    class DevicesList,ScanDevices,AddDevice,EditDevice,DeviceControl,TechContact,EventLog devicesStyle
    class Groups,Users,UserAccess,UserRoles usersStyle
```

---

## Rutas Definidas

### Rutas de Autenticación (Fuera del Shell)
```
/ (o /login)          → LoginScreen
/register             → RegisterScreen
/forgot-password      → ForgotPasswordScreen
```

### Rutas Principales (Dentro del Shell con Bottom Navigation)

#### Tab 1: Dispositivos
```
/devices                           → DevicesListScreen
/devices/scan                      → ScanDevicesScreen
/devices/add                       → AddDeviceScreen
/devices/:id/control               → DeviceControlScreen
/devices/:id/technical-contact     → TechnicalContactScreen
/devices/:id/events                → EventLogScreen
```

#### Tab 2: Grupos
```
/groups                            → GroupsScreen
```

#### Tab 3: Usuarios
```
/users                             → UsersScreen
/users/:id/access                  → UserAccessScreen
/users/:id/roles                   → UserRolesScreen
```

#### Tab 4: Configuración
```
/settings                          → SettingsScreen
```

---

## Flujos de Usuario Principales

### 1. Onboarding
```
Login → (Nuevo Usuario) → Register → Login → Devices List
Login → (Olvidó Password) → Forgot Password → Login
```

### 2. Gestión de Dispositivos
```
Devices List → Scan Devices → Agregar → Devices List
Devices List → Add Device Form (manual) → Devices List
Devices List → Edit Device → Devices List
Devices List → Device Control
```

### 3. Gestión de Usuarios y Permisos
```
Users → User Access → (Vincular/Desvincular)
User Access → User Roles → (Asignar Permisos)
```

### 4. Navegación Bottom Nav
```
Cualquier tab → Devices / Groups / Users / Settings
Settings → Cerrar Sesión → Login
```

---

## Navegación Programática

### Ejemplo de Navegación con GoRouter

```dart
// Navegar a pantalla
context.go('/devices/scan');

// Navegar con parámetros
context.go('/devices/123/control');

// Navegar y regresar
context.push('/devices/add');

// Regresar
context.pop();

// Reemplazar ruta (ej: después de login)
context.go('/devices');
```

---

## Bottom Navigation Tabs

El `BottomNavShell` gestiona 4 tabs principales:

1. **Devices** (Icono: devices) → `/devices`
2. **Groups** (Icono: groups) → `/groups`
3. **Users** (Icono: people) → `/users`
4. **Settings** (Icono: settings) → `/settings`

La navegación entre tabs mantiene el estado de cada pantalla.

---

## Notas de Implementación

- **Autenticación**: Las rutas auth están fuera del Shell
- **Bottom Navigation**: Persiste en todas las rutas principales
- **Deep Linking**: Todas las rutas soportan navegación directa por URL
- **Estado**: Se preserva al cambiar entre tabs
- **Guards**: Login requerido para todas las rutas dentro del Shell

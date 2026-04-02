# BGnius VITA - Instrucciones para Agente de Desarrollo

## 🎯 Objetivo del Proyecto
Generar una aplicación Flutter funcional para **BGnius VITA**, un sistema de control de accesos IoT que permite controlar portones, barreras y puertas de forma remota.

---

## 📁 Archivos de Referencia

| Archivo | Contenido | Ubicación |
|---------|-----------|-----------|
| `01_DISENO_APP_v3.pdf` | 17 mockups visuales de todas las pantallas | `/docs/` |
| `ESPECIFICACION_UI_UX_BGNIUS_VITA.md` | Especificación técnica completa | `/docs/` |

---

## 🛠️ Stack Técnico

```yaml
Framework: Flutter 3.29+
Lenguaje: Dart
State Management: Riverpod 2.x (preferido) o Provider
Navegación: GoRouter
HTTP Client: Dio
Almacenamiento Local: SharedPreferences + Hive
Iconos: Material Icons + Lucide Icons
Fuentes: Google Fonts (Poppins para títulos, Roboto para cuerpo)
```

---

## 🎨 Design System

### Paleta de Colores
```dart
// lib/core/theme/app_colors.dart
class AppColors {
  // Primarios
  static const primaryPurple = Color(0xFF7B2CBF);
  static const secondaryBlue = Color(0xFF0072BC);
  
  // Estados
  static const success = Color(0xFF4CAF50);
  static const error = Color(0xFFE53935);
  static const warning = Color(0xFFFF9800);
  
  // Neutros
  static const background = Color(0xFFF5F5F5);
  static const textSecondary = Color(0xFF757575);
  static const white = Color(0xFFFFFFFF);
  static const inputBorder = Color(0xFFDDDDDD);
}
```

### Componentes de UI
```dart
// Bordes redondeados estándar
BorderRadius.circular(25) // Campos de texto
BorderRadius.circular(30) // Botones
BorderRadius.circular(16) // Cards

// Sombras
BoxShadow(
  color: Colors.black.withOpacity(0.1),
  blurRadius: 10,
  offset: Offset(0, 4),
)
```

### Tipos de Botones
| Tipo | Color Fondo | Color Texto | Uso |
|------|-------------|-------------|-----|
| Primario | `#7B2CBF` | Blanco | Acciones principales |
| Secundario | `#0072BC` | Blanco | Acciones secundarias |
| Peligro | `#E53935` | Blanco | Eliminar, cancelar |
| Éxito | `#4CAF50` | Blanco | Confirmar, agregar |
| Outline | Transparente | Púrpura | Acciones menores |

---

## 📱 Pantallas a Generar (17 total)

### Módulo de Autenticación
| # | Pantalla | Ruta | Prioridad |
|---|----------|------|-----------|
| 1 | Login / Bienvenido | `/` | 🔴 Alta |
| 2 | Restablecer Contraseña | `/forgot-password` | 🟡 Media |
| 3 | Crear Usuario | `/register` | 🔴 Alta |

### Módulo de Dispositivos
| # | Pantalla | Ruta | Prioridad |
|---|----------|------|-----------|
| 4 | Lista de Dispositivos | `/devices` | 🔴 Alta |
| 5 | Control de Dispositivo | `/devices/:id/control` | 🔴 Alta |
| 6 | Agregar Dispositivo | `/devices/add` | 🟡 Media |
| 7 | Edición de Dispositivo | `/devices/:id/edit` | 🟡 Media |
| 8 | Información del Dispositivo | `/devices/:id/info` | 🟡 Media |
| 9 | Parámetros del Dispositivo | `/devices/:id/params` | 🟡 Media |

### Módulo de Usuarios y Permisos
| # | Pantalla | Ruta | Prioridad |
|---|----------|------|-----------|
| 10 | Usuarios Registrados | `/users` | 🟡 Media |
| 11 | Usuarios con Acceso | `/devices/:id/users` | 🟡 Media |
| 12 | Roles de Usuario | `/devices/:id/users/:userId/roles` | 🟢 Baja |
| 13 | Vincular Usuario Virtual | `/users/link-virtual` | 🟢 Baja |

### Módulo de Grupos
| # | Pantalla | Ruta | Prioridad |
|---|----------|------|-----------|
| 14 | Grupos | `/groups` | 🟡 Media |

### Módulo de Soporte
| # | Pantalla | Ruta | Prioridad |
|---|----------|------|-----------|
| 15 | Contacto Técnico | `/devices/:id/support` | 🟢 Baja |
| 16 | Registro de Eventos | `/devices/:id/events` | 🟢 Baja |

### Módulo de Configuración
| # | Pantalla | Ruta | Prioridad |
|---|----------|------|-----------|
| 17 | Configuración / Perfil | `/settings` | 🟡 Media |

---

## 🏗️ Estructura de Carpetas

```
lib/
├── main.dart
├── app.dart
│
├── core/
│   ├── theme/
│   │   ├── app_colors.dart
│   │   ├── app_text_styles.dart
│   │   └── app_theme.dart
│   ├── routes/
│   │   └── app_router.dart
│   ├── constants/
│   │   ├── app_constants.dart
│   │   └── api_endpoints.dart
│   ├── utils/
│   │   ├── validators.dart
│   │   └── formatters.dart
│   └── services/
│       ├── api_service.dart
│       └── storage_service.dart
│
├── features/
│   ├── auth/
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   └── user_model.dart
│   │   │   └── repositories/
│   │   │       └── auth_repository.dart
│   │   ├── presentation/
│   │   │   ├── screens/
│   │   │   │   ├── login_screen.dart
│   │   │   │   ├── register_screen.dart
│   │   │   │   └── forgot_password_screen.dart
│   │   │   ├── widgets/
│   │   │   │   └── auth_form_field.dart
│   │   │   └── providers/
│   │   │       └── auth_provider.dart
│   │   └── domain/
│   │       └── entities/
│   │           └── user.dart
│   │
│   ├── devices/
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   └── device_model.dart
│   │   │   └── repositories/
│   │   │       └── device_repository.dart
│   │   ├── presentation/
│   │   │   ├── screens/
│   │   │   │   ├── devices_list_screen.dart
│   │   │   │   ├── device_control_screen.dart
│   │   │   │   ├── add_device_screen.dart
│   │   │   │   ├── edit_device_screen.dart
│   │   │   │   ├── device_info_screen.dart
│   │   │   │   └── device_params_screen.dart
│   │   │   ├── widgets/
│   │   │   │   ├── device_card.dart
│   │   │   │   ├── control_button.dart
│   │   │   │   └── device_header.dart
│   │   │   └── providers/
│   │   │       └── devices_provider.dart
│   │   └── domain/
│   │       └── entities/
│   │           └── device.dart
│   │
│   ├── users/
│   │   └── ... (misma estructura)
│   │
│   ├── groups/
│   │   └── ... (misma estructura)
│   │
│   └── settings/
│       └── ... (misma estructura)
│
└── shared/
    └── widgets/
        ├── custom_app_bar.dart
        ├── custom_button.dart
        ├── custom_text_field.dart
        ├── loading_indicator.dart
        ├── error_widget.dart
        └── snackbar_helper.dart
```

---

## 🔧 Widgets Reutilizables Requeridos

### 1. CustomTextField
```dart
// Características:
// - Bordes redondeados (25px)
// - Icono a la izquierda
// - Botón mostrar/ocultar para contraseñas
// - Estado de error con borde rojo
// - Validación integrada
```

### 2. CustomButton
```dart
// Variantes: primary, secondary, danger, success, outline
// Estados: enabled, disabled, loading
// Icono opcional a la izquierda
```

### 3. DeviceHeader
```dart
// Card gris con información del dispositivo:
// - Modelo
// - No. Serie
// - Estado (En línea/Sin conexión)
// - Detalle
```

### 4. ControlButtonsPanel
```dart
// Panel con 4 botones de control:
// - Abrir (verde)
// - Pausa (gris)
// - Cerrar (rojo/naranja)
// - Peatonal (azul)
```

### 5. CustomAppBar
```dart
// AppBar consistente con:
// - Título centrado (azul oscuro)
// - Logo de casa (icono home) a la derecha
// - Botón back cuando aplique
```

---

## ✅ Validaciones por Campo

| Campo | Reglas |
|-------|--------|
| Correo | `RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')` |
| Contraseña | Min 8 chars, 1 mayúscula, 1 minúscula, 1 número, 1 símbolo |
| Teléfono | Formato: `+XXX XXXX-XXXX` |
| Número de Serie | 8-20 caracteres, solo mayúsculas y números |
| Nombre dispositivo | Mínimo 3 caracteres |

---

## 📝 Mensajes de Error Estándar

```dart
class AppMessages {
  // Auth
  static const invalidCredentials = 'Correo o contraseña incorrectos';
  static const sessionExpired = 'Tu sesión ha expirado';
  static const emailAlreadyExists = 'Este correo ya está registrado';
  static const passwordMismatch = 'Las contraseñas no coinciden';
  
  // Dispositivos
  static const deviceNotFound = 'El dispositivo no fue encontrado';
  static const deviceOffline = 'El dispositivo está sin conexión';
  static const commandFailed = 'No se pudo ejecutar el comando';
  
  // General
  static const requiredField = 'Este campo es obligatorio';
  static const invalidFormat = 'El formato ingresado no es válido';
  static const serverError = 'Ocurrió un error en el servidor';
  static const connectionError = 'No se pudo conectar al servidor';
}
```

---

## 🎬 Animaciones Requeridas

| Elemento | Animación |
|----------|-----------|
| Botones | Escala al presionar (0.95) |
| Cards | Elevación al hacer hover |
| Navegación | Slide horizontal entre pantallas |
| Snackbars | Slide desde abajo |
| Loading | Spinner circular Material |
| Toggle switches | Animación suave 200ms |

---

## 📋 Orden de Implementación Sugerido

### Fase 1: Core y Autenticación
1. [ ] Configurar proyecto Flutter con dependencias
2. [ ] Implementar Design System (colores, tipografía, tema)
3. [ ] Crear widgets compartidos (CustomTextField, CustomButton)
4. [ ] Pantalla de Login
5. [ ] Pantalla de Registro
6. [ ] Pantalla de Recuperar Contraseña
7. [ ] Configurar GoRouter con guards de autenticación

### Fase 2: Dispositivos Principal
8. [ ] Lista de Dispositivos (pantalla principal post-login)
9. [ ] Control de Dispositivo (con botones Abrir/Pausa/Cerrar/Peatonal)
10. [ ] Agregar Dispositivo
11. [ ] Editar Dispositivo

### Fase 3: Gestión de Usuarios
12. [ ] Usuarios Registrados
13. [ ] Usuarios con Acceso a Dispositivo
14. [ ] Roles y Permisos
15. [ ] Vincular Usuario Virtual

### Fase 4: Funcionalidades Secundarias
16. [ ] Grupos de Dispositivos
17. [ ] Información del Dispositivo
18. [ ] Parámetros del Dispositivo
19. [ ] Registro de Eventos
20. [ ] Contacto Técnico
21. [ ] Configuración / Perfil

---

## 🚨 Reglas Importantes

1. **Fidelidad Visual**: Seguir los mockups del PDF lo más fielmente posible
2. **Consistencia**: Usar los mismos componentes en todas las pantallas
3. **Responsive**: La app debe verse bien en diferentes tamaños de pantalla
4. **Estado de Carga**: Siempre mostrar indicadores de carga
5. **Manejo de Errores**: Mostrar mensajes claros al usuario
6. **Código Limpio**: Separar lógica de UI, usar providers
7. **Comentarios**: Documentar widgets complejos
8. **Nombres en Español**: Los textos de UI en español (es la app)

---

## 🔗 Dependencias Sugeridas (pubspec.yaml)

```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # State Management
  flutter_riverpod: ^2.4.9
  
  # Navegación
  go_router: ^13.0.0
  
  # HTTP
  dio: ^5.4.0
  
  # Almacenamiento
  shared_preferences: ^2.2.2
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  
  # UI
  google_fonts: ^6.1.0
  flutter_svg: ^2.0.9
  cached_network_image: ^3.3.1
  shimmer: ^3.0.0
  
  # Utilidades
  intl: ^0.18.1
  equatable: ^2.0.5
  
dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.1
  hive_generator: ^2.0.1
  build_runner: ^2.4.8
```

---

## 💡 Tips para el Agente

1. **Empieza simple**: Genera primero la estructura básica y luego refina
2. **Un archivo a la vez**: No intentes generar todo de una vez
3. **Testea incrementalmente**: Verifica que cada pantalla compile antes de seguir
4. **Consulta el PDF**: Los mockups tienen detalles visuales importantes
5. **Mantén consistencia**: Si creas un estilo, úsalo en todos lados

---

*Generado para BGnius VITA - Control de Accesos IoT*
*Versión 1.0 - Diciembre 2024*

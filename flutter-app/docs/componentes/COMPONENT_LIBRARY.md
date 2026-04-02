# Biblioteca de Componentes BGnius VITA

## Descripción General

Esta es la biblioteca de componentes reutilizables de la aplicación BGnius VITA. Los componentes están diseñados para mantener consistencia visual y de comportamiento en toda la aplicación.

---

## Componentes Disponibles

### 1. CustomInputField
**Ubicación**: `lib/shared/widgets/custom_input_field.dart`

Campo de entrada personalizado con validación, label, icon y soporta obscureText.

**Propiedades**:
- `label` (String?): Etiqueta del campo
- `hintText` (String): Texto placeholder
- `prefixIcon` (IconData?): Ícono al inicio
- `suffixIcon` (IconData?): Ícono al final
- `validator`: Función de validación
- `obscureText` (bool): Oculta el texto
- `maxLines` (int?): Número máximo de líneas
- `enabled` (bool): Habilita/deshabilita el campo

**Ejemplo**:
```dart
CustomInputField(
  label: 'Correo',
  hintText: 'tu@correo.com',
  prefixIcon: Icons.email,
  keyboardType: TextInputType.emailAddress,
  validator: Validators.email,
)
```

---

### 2. UserAvatar
**Ubicación**: `lib/shared/widgets/user_avatar.dart`

Avatar circular para mostrar usuario con iniciales o imagen.

**Propiedades**:
- `imageUrl` (String?): URL de imagen
- `initials` (String): Iniciales del usuario
- `size` (double): Tamaño del avatar
- `backgroundColor` (Color?): Color de fondo

**Ejemplo**:
```dart
UserAvatar(
  initials: 'JD',
  size: 60,
  backgroundColor: Colors.purple,
)
```

---

### 3. InfoPanel
**Ubicación**: `lib/shared/widgets/info_panel.dart`

Panel de información gris para mostrar datos en pares label-value.

**Propiedades**:
- `items` (List<InfoPanelItem>): Lista de items
- `padding` (EdgeInsets): Relleno
- `backgroundColor` (Color): Color de fondo

**Ejemplo**:
```dart
InfoPanel(
  items: [
    InfoPanelItem(label: 'Modelo', value: 'BGnius-2024'),
    InfoPanelItem(label: 'Serial', value: 'BG123456'),
    InfoPanelItem(label: 'Estado', value: 'Activo'),
  ],
)
```

---

### 4. ConfirmDialog
**Ubicación**: `lib/shared/widgets/confirm_dialog.dart`

Diálogo de confirmación personalizado.

**Propiedades**:
- `title` (String): Título del diálogo
- `message` (String): Mensaje
- `confirmText` (String?): Texto del botón confirmar
- `cancelText` (String?): Texto del botón cancelar
- `onConfirm` (VoidCallback?): Callback de confirmación
- `isDestructive` (bool): Cambia color si es destructivo

**Ejemplo**:
```dart
ConfirmDialog.show(
  context,
  title: '¿Eliminar dispositivo?',
  message: 'Esta acción no se puede deshacer',
  confirmText: 'Eliminar',
  isDestructive: true,
  onConfirm: () => deleteDevice(),
)
```

---

### 5. CustomSwitch
**Ubicación**: `lib/shared/widgets/custom_switch.dart`

Switch con etiqueta y descripción opcional.

**Propiedades**:
- `label` (String): Etiqueta del switch
- `description` (String?): Descripción
- `value` (bool): Valor actual
- `onChanged` (ValueChanged<bool>): Callback de cambio
- `enabled` (bool): Habilita/deshabilita

**Ejemplo**:
```dart
CustomSwitch(
  label: 'Notificaciones',
  description: 'Recibir notificaciones del sistema',
  value: _notificationsEnabled,
  onChanged: (value) {
    setState(() => _notificationsEnabled = value);
  },
)
```

---

### 6. SettingsSection
**Ubicación**: `lib/shared/widgets/settings_section.dart`

Sección expandible para configuraciones.

**Propiedades**:
- `title` (String): Título de la sección
- `icon` (IconData?): Ícono de la sección
- `children` (List<Widget>): Contenido expandible
- `initiallyExpanded` (bool): Expansión inicial

**Ejemplo**:
```dart
SettingsSection(
  title: 'Notificaciones',
  icon: Icons.notifications,
  children: [
    CustomSwitch(
      label: 'Activar notificaciones',
      value: true,
      onChanged: (v) {},
    ),
  ],
)
```

---

## Componentes Existentes

### CustomButton
Botón personalizado con soporta para loading, outline y variantes.

### CustomTextField
Campo de texto con validación (DEPRECATED - usar CustomInputField)

### SearchBarWidget
Barra de búsqueda con filtros

### ControlButtonsPanel
Panel de 4 botones circulares para control de dispositivos

### DeviceHeader
Header para pantalla de dispositivos

### CurvedTabBar
Tab bar con pestañas moradas

### LoadingIndicator
Indicador de carga personalizado

### ErrorDisplay
Componente para mostrar errores

### SnackbarHelper
Helper para mostrar snackbars

---

## Componentes Próximos a Crear

- [ ] DatePickerField
- [ ] DropdownField
- [ ] MultiSelectField
- [ ] StatusBadge
- [ ] DeviceCard
- [ ] ActionChip
- [ ] CustomDivider

---

## Estructura de Colores

Los componentes utilizan los colores definidos en `lib/core/theme/app_colors.dart`:

- **primaryPurple**: `#673AB7`
- **secondaryBlue**: `#0066CC`
- **titleBlue**: `#0A3057`
- **textPrimary**: `#333333`
- **textSecondary**: `#666666`
- **error**: `#F44336`
- **surface**: `#FFFFFF`
- **background**: `#F5F5F5`

---

## Tipografía

Los componentes utilizan Google Fonts:

- **Títulos**: Poppins (weight 600)
- **Etiquetas**: Roboto (weight 500)
- **Cuerpo**: Roboto (weight 400)

---

## Mejores Prácticas

1. **Siempre usar CustomInputField** para inputs en formularios
2. **Reutilizar InfoPanel** para mostrar información de dispositivos
3. **Usar ConfirmDialog.show()** en lugar de showDialog() nativo
4. **Preferir CustomSwitch** sobre Switch nativo
5. **Mantener consistencia** con tamaños de fuente y espaciado

---

## Importar Componentes

```dart
// Opción 1: Importar individual
import 'package:bgnius_vita/shared/widgets/custom_input_field.dart';

// Opción 2: Usar índice (recomendado)
import 'package:bgnius_vita/shared/widgets/index.dart';
```

---

## Próximos Pasos

1. Crear DatePickerField para campos de fecha
2. Crear DropdownField para selectores
3. Implementar StatusBadge para estados de dispositivos
4. Crear DeviceCard reutilizable
5. Extender validadores en utils


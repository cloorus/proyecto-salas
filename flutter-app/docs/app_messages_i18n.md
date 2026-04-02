# Internationalization (i18n) Messages

Este archivo centraliza los textos identificados durante las auditorías manuales para su posterior migración a un sistema de i18n real (como `flutter_localizations` con `.arb`).

## Add Device Screen
| ID | Español (es) | Inglés (en) | Contexto |
|----|--------------|-------------|----------|
| `device.add.title` | Agregar Dispositivo | Add Device | Screen Title |
| `device.add.scanBtn` | Escanear QR / Wifi | Scan QR / Wifi | Action Button |
| `device.form.progress` | Progreso del Formulario | Form Progress | Progress Header |
| `device.form.section.basic` | Información Básica | Basic Information | Section Title |
| `device.form.section.id` | Identificación | Identification | Section Title |
| `device.form.section.config` | Configuración Operativa (Opcional) | Operational Config (Optional) | Section Title |
| `device.form.section.physical` | Información Física (Opcional) | Physical Info (Optional) | Section Title |
| `device.form.section.maintenance` | Mantenimiento (Opcional) | Maintenance (Optional) | Section Title |
| `device.form.section.vita` | Configuración VITA (Opcional) | VITA Config (Optional) | Section Title |
| `device.form.name` | Nombre * | Name * | Input Label |
| `device.form.namePlaceholder` | Nombre del dispositivo | Device Name | Input Placeholder |
| `device.form.location` | Ubicación * | Location * | Input Label |
| `device.form.locationPlaceholder` | Selecciona ubicación | Select Location | Input Placeholder |
| `device.form.description` | Descripción | Description | Input Label |
| `device.form.descriptionPlaceholder` | Descripción (opcional) | Description (optional) | Input Placeholder |
| `device.form.serial` | Número de Serie * | Serial Number * | Input Label |
| `device.form.mac` | Dirección MAC * | MAC Address * | Input Label |
| `device.form.model` | Modelo * | Model * | Input Label |
| `device.form.modelPlaceholder` | Selecciona modelo | Select Model | Input Placeholder |
| `device.form.submitCreate` | Crear Dispositivo | Create Device | Button Text |
| `device.form.submitUpdate` | Guardar Cambios | Save Changes | Button Text |
| `device.form.cancel` | Cancelar | Cancel | Button Text |

## Groups Screen

| ID | Español (es) | Inglés (en) | Contexto |
|----|--------------|-------------|----------|
| `groups.status.ready` | Listo | Ready | Default status text |
| `groups.error.select_group_first` | Selecciona un grupo primero | Select a group first | Error trying to add without selection |
| `groups.error.todos_readonly` | No se pueden agregar dispositivos manualmente al grupo TODOS | Cannot manually add devices to ALL group | Validation error |
| `groups.error.select_device_add` | Selecciona un dispositivo para agregar | Select a device to add | Validation error |
| `groups.error.device_already_in_group` | El dispositivo ya está en este grupo | Device is already in this group | Validation error |
| `groups.success.device_added` | Dispositivo "{deviceName}" añadido a {groupName} | Device "{deviceName}" added to {groupName} | Success snackbar message |
| `groups.title` | Gestión de Grupos | Groups Management | Screen title |
| `groups.subtitle.devices_in_group` | Dispositivos en este grupo | Devices in this group | List header |
| `groups.control.prefix` | Control: {deviceName} | Control: {deviceName} | Control panel header |
| `groups.button.more_details` | Más detalles y configuración | More details and settings | Button label |
| `groups.subtitle.add_more` | Agregar más dispositivos | Add more devices | Section header |
| `groups.dropdown.hint` | Selecciona para agregar... | Select to add... | Dropdown hint |
| `groups.dropdown.empty` | No hay dispositivos disponibles | No devices available | Dropdown empty state |
| `groups.button.add` | Agregar a este grupo | Add to this group | Action button |
| `groups.info.todos_title` | Grupo Automático "TODOS" | Automatic Group "ALL" | Info card title |
| `groups.info.todos_body` | Este grupo incluye automáticamente todos tus dispositivos. No puedes agregar ni quitar dispositivos manualmente aquí. | This group automatically includes all your devices. You cannot manually add or remove devices here. | Info card body |
| `groups.empty.list` | No hay dispositivos en este grupo | No devices in this group | List empty state |

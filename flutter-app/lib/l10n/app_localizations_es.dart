// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'BGnius VITA';

  @override
  String get loginTitle => 'Bienvenido';

  @override
  String get loginEmailHint => 'Correo';

  @override
  String get loginPasswordHint => 'Contraseña';

  @override
  String get loginShowPassword => 'Mostrar';

  @override
  String get loginHidePassword => 'Ocultar';

  @override
  String get loginRememberMe => 'Recuérdame';

  @override
  String get loginForgotPassword => 'Olvide mi contraseña';

  @override
  String get loginButton => 'Ingresar';

  @override
  String get loginCreateAccount => 'Crear Usuario';

  @override
  String get loginLibraryLink => 'Biblioteca';

  @override
  String get loginSuccess => 'Bienvenido a BGnius VITA';

  @override
  String get loginInvalidCredentials => 'Correo o contraseña incorrectos';

  @override
  String get validationRequiredField => 'Este campo es obligatorio';

  @override
  String get validationInvalidEmail => 'El formato del correo no es válido';

  @override
  String get validationPasswordRequired => 'La contraseña es obligatoria';

  @override
  String get generalError => 'Ocurrió un error inesperado';

  @override
  String get generalLoading => 'Cargando...';

  @override
  String get validationEmailRequired => 'El correo es obligatorio';

  @override
  String get validationPasswordMinLength =>
      'La contraseña debe tener al menos 8 caracteres';

  @override
  String get validationPasswordUppercase =>
      'Debe contener al menos una mayúscula';

  @override
  String get validationPasswordLowercase =>
      'Debe contener al menos una minúscula';

  @override
  String get validationPasswordNumber => 'Debe contener al menos un número';

  @override
  String get validationPasswordSymbol =>
      'Debe contener al menos un símbolo especial';

  @override
  String get validationPasswordsNoMatch => 'Las contraseñas no coinciden';

  @override
  String get validationConfirmPassword => 'Confirma tu contraseña';

  @override
  String get registerTitle => 'Crear Usuario';

  @override
  String get registerNameLabel => 'Nombre';

  @override
  String get registerNameHint => 'Nombre completo';

  @override
  String get registerEmailLabel => 'Correo';

  @override
  String get registerEmailHint => 'tu@correo.com';

  @override
  String get registerAddressLabel => 'Dirección';

  @override
  String get registerAddressHint => 'Calle 123 #45-67';

  @override
  String get registerCountryLabel => 'País';

  @override
  String get registerCountryHint => 'Seleccionar país';

  @override
  String get registerLanguageLabel => 'Idioma';

  @override
  String get registerLanguageHint => 'Seleccionar idioma';

  @override
  String get registerPasswordLabel => 'Contraseña';

  @override
  String get registerPasswordHint => 'Mínimo 8 caracteres';

  @override
  String get registerConfirmPasswordLabel => 'Repetir Contraseña';

  @override
  String get registerConfirmPasswordHint => 'Confirma tu contraseña';

  @override
  String get registerPhonePrefixLabel => 'Prefijo';

  @override
  String get registerPhoneLabel => 'Teléfono';

  @override
  String get registerPhoneHint => '3001234567';

  @override
  String get registerAcceptTerms => 'Acepto términos y condiciones';

  @override
  String get registerButton => 'Vincular Usuario';

  @override
  String get registerAlreadyHaveAccount => '¿Ya tienes cuenta? ';

  @override
  String get registerLoginLink => 'Inicia Sesión';

  @override
  String get registerErrorTerms => 'Debes aceptar los términos y condiciones';

  @override
  String get registerErrorPasswordMismatch => 'Las contraseñas no coinciden';

  @override
  String get registerSuccess => 'Cuenta creada exitosamente';

  @override
  String get registerError => 'Error al crear la cuenta';

  @override
  String get forgotPasswordTitle => 'Restablecer Contraseña';

  @override
  String get forgotPasswordEmailHint => 'Correo/Usuario';

  @override
  String get forgotPasswordGetCodeButton => 'Obtener código temporal';

  @override
  String get forgotPasswordTimeRemaining => 'Tiempo restante';

  @override
  String get forgotPasswordTimeRemainingOf => 'de contraseña temporal';

  @override
  String get forgotPasswordNewPasswordHint => 'Nueva Contraseña';

  @override
  String get forgotPasswordRepeatPasswordHint => 'Repita su Nueva Contraseña';

  @override
  String get forgotPasswordCodeHint => 'Ingrese el código temporal';

  @override
  String get forgotPasswordResetButton => 'Restablecer Contraseña';

  @override
  String get forgotPasswordErrorEmail => 'Ingresa tu correo electrónico';

  @override
  String forgotPasswordCodeSent(String email) {
    return 'Código enviado a $email';
  }

  @override
  String get forgotPasswordErrorPasswordMismatch =>
      'Las contraseñas no coinciden';

  @override
  String get forgotPasswordSuccess => 'Contraseña restablecida exitosamente';

  @override
  String get eventLogTitle => 'Registro de Eventos';

  @override
  String get eventLogDownload => 'Descargar registros';

  @override
  String eventLogDownloading(int count) {
    return 'Descargando $count registros...';
  }

  @override
  String get eventLogEmpty => 'No hay eventos registrados';

  @override
  String get deviceInfoTitle => 'Información del dispositivo';

  @override
  String get deviceInfoSerialLabel => 'No. Serie:';

  @override
  String get deviceInfoNameLabel => 'Nombre:';

  @override
  String get deviceInfoVersionLabel => 'Versión Actual:';

  @override
  String get deviceInfoTotalCyclesLabel => 'Ciclos Totales:';

  @override
  String get deviceInfoActivationDateLabel => 'Fecha de activación';

  @override
  String get deviceInfoStatusLabel => 'Estado';

  @override
  String get deviceInfoUpdateBtn => 'Actualizar dispositivo';

  @override
  String get deviceInfoOneMaintenance => '1 mantenimiento';

  @override
  String get deviceInfoGroupLabel => 'Grupo:';

  @override
  String get deviceInfoFavoriteLabel => 'Favorito:';

  @override
  String get deviceInfoTechnicianLabel => 'Técnico Asignado:';

  @override
  String get deviceInfoPhotoLabel => 'Foto:';

  @override
  String get deviceInfoYes => 'Sí';

  @override
  String get deviceInfoNo => 'No';

  @override
  String get deviceInfoCustomPhoto => 'Personalizada';

  @override
  String get deviceInfoDefaultPhoto => 'Por defecto';

  @override
  String get deviceAllDetailsTitle => 'Todos los detalles';

  @override
  String get deviceInfoSectionGeneral => 'General';

  @override
  String get deviceInfoSectionConfig => 'Configuración VITA';

  @override
  String get deviceInfoSectionOther => 'Otros';

  @override
  String get deviceInfoSectionIdentity => 'Identificación';

  @override
  String get deviceInfoSectionOperational => 'Configuración Operativa';

  @override
  String get deviceInfoSectionPhysical => 'Información Física';

  @override
  String get deviceInfoSectionMaintenance => 'Mantenimiento';

  @override
  String get deviceInfoModelLabel => 'Modelo:';

  @override
  String get deviceInfoDescriptionLabel => 'Descripción:';

  @override
  String get deviceInfoMacLabel => 'Dirección MAC:';

  @override
  String get deviceInfoHwVersionLabel => 'Versión Hardware:';

  @override
  String get deviceInfoFwVersionLabel => 'Versión Firmware:';

  @override
  String get deviceInfoAutoCloseLabel => 'Auto-cierre:';

  @override
  String get deviceInfoMaxOpenTimeLabel => 'Tiempo máx. abierto:';

  @override
  String get deviceInfoPedestrianTimeoutLabel => 'Timeout peatonal:';

  @override
  String get deviceInfoEmergencyModeLabel => 'Modo Emergencia:';

  @override
  String get deviceInfoAutoLampLabel => 'Lámpara Auto-On:';

  @override
  String get deviceInfoMaintenanceModeLabel => 'Modo Mantenimiento:';

  @override
  String get deviceInfoLockedLabel => 'Bloqueado:';

  @override
  String get deviceInfoInstallationDateLabel => 'Fecha Instalación:';

  @override
  String get deviceInfoWarrantyDateLabel => 'Vencimiento Garantía:';

  @override
  String get deviceInfoScheduledMaintLabel => 'Mantenimiento Programado:';

  @override
  String get deviceInfoMaintNotesLabel => 'Notas Mantenimiento:';

  @override
  String get deviceInfoPowerTypeLabel => 'Tipo Corriente:';

  @override
  String get deviceInfoMotorTypeLabel => 'Tipo Motor:';

  @override
  String get deviceInfoOpeningPhotocellLabel => 'Fotocélula Apertura:';

  @override
  String get deviceInfoClosingPhotocellLabel => 'Fotocélula Cierre:';

  @override
  String get deviceInfoSecondsSuffix => ' seg';

  @override
  String get deviceInfoViewAllDetailsBtn => 'Ver todos los detalles';

  @override
  String get deviceAddTitle => 'Agregar Dispositivo';

  @override
  String get deviceScanBtn => 'Escanear QR / Wifi';

  @override
  String get deviceFormNameLabel => 'Nombre *';

  @override
  String get deviceFormLocationLabel => 'Ubicación *';

  @override
  String get deviceFormSerialLabel => 'Número de Serie *';

  @override
  String get deviceFormMacLabel => 'Dirección MAC *';

  @override
  String get deviceFormProgressTitle => 'Progreso del Formulario';

  @override
  String deviceFormProgressCount(int completed) {
    return '$completed de 7 secciones';
  }

  @override
  String get deviceFormSectionBasic => 'Información Básica';

  @override
  String get deviceFormSectionId => 'Identificación';

  @override
  String get deviceFormSectionConfig => 'Configuración Operativa';

  @override
  String get deviceFormSectionPhysical => 'Información Física';

  @override
  String get deviceFormSectionMaintenance => 'Mantenimiento';

  @override
  String get deviceFormSectionVita => 'Configuración VITA';

  @override
  String get deviceFormNamePlaceholder => 'Nombre del dispositivo';

  @override
  String get deviceFormLocationPlaceholder => 'Selecciona ubicación';

  @override
  String get deviceFormDescriptionLabel => 'Descripción';

  @override
  String get deviceFormDescriptionPlaceholder => 'Descripción (opcional)';

  @override
  String get deviceFormModelLabel => 'Modelo *';

  @override
  String get deviceFormModelPlaceholder => 'Selecciona modelo';

  @override
  String get deviceFormSubmitCreate => 'Crear Dispositivo';

  @override
  String get deviceFormSubmitUpdate => 'Guardar Cambios';

  @override
  String get deviceFormCancel => 'Cancelar';

  @override
  String get deviceFormErrorRequired =>
      'Por favor completa todos los campos obligatorios';

  @override
  String get deviceFormErrorLocation => 'Selecciona una ubicación';

  @override
  String get deviceFormErrorModel => 'Selecciona un modelo';

  @override
  String deviceFormErrorSave(Object error) {
    return 'Error al guardar: $error';
  }

  @override
  String get deviceFormStatusLabel => 'Estado';

  @override
  String get deviceFormStatusPlaceholder => 'Selecciona estado';

  @override
  String get deviceFormTypeLabel => 'Tipo de Dispositivo';

  @override
  String get deviceFormTypePlaceholder => 'Selecciona tipo';

  @override
  String get deviceFormPhotoLabel => 'Foto del dispositivo';

  @override
  String get deviceFormPhotoHint => 'Toca para añadir una foto';

  @override
  String deviceInfoSignalStrength(int percentage) {
    return '$percentage% señal';
  }

  @override
  String deviceInfoSecondsValue(Object seconds) {
    return '$seconds seg';
  }

  @override
  String get groupsStatusReady => 'Listo';

  @override
  String get groupsErrorSelectGroupFirst => 'Selecciona un grupo primero';

  @override
  String get groupsErrorTodosReadonly =>
      'No se pueden agregar dispositivos manualmente al grupo TODOS';

  @override
  String get groupsErrorSelectDeviceAdd =>
      'Selecciona un dispositivo para agregar';

  @override
  String get groupsErrorDeviceAlreadyInGroup =>
      'El dispositivo ya está en este grupo';

  @override
  String groupsSuccessDeviceAdded(String deviceName, String groupName) {
    return 'Dispositivo \"$deviceName\" añadido a $groupName';
  }

  @override
  String get groupsTitle => 'Gestión de Grupos';

  @override
  String get groupsSubtitleDevicesInGroup => 'Dispositivos en este grupo';

  @override
  String groupsControlPrefix(String deviceName) {
    return 'Control: $deviceName';
  }

  @override
  String get groupsButtonMoreDetails => 'Más detalles y configuración';

  @override
  String get groupsSubtitleAddMore => 'Agregar más dispositivos';

  @override
  String get groupsDropdownHint => 'Selecciona para agregar...';

  @override
  String get groupsDropdownEmpty => 'No hay dispositivos disponibles';

  @override
  String get groupsButtonAdd => 'Agregar a este grupo';

  @override
  String get groupsInfoTodosTitle => 'Grupo Automático \"TODOS\"';

  @override
  String get groupsInfoTodosBody =>
      'Este grupo incluye automáticamente todos tus dispositivos. No puedes agregar ni quitar dispositivos manualmente aquí.';

  @override
  String get groupsEmptyList => 'No hay dispositivos en este grupo';

  @override
  String get groupCreateTitle => 'Crear Nuevo Grupo';

  @override
  String get groupEditTitle => 'Editar Grupo';

  @override
  String get groupNameLabel => 'Nombre del Grupo';

  @override
  String get groupDescLabel => 'Descripción (Opcional)';

  @override
  String get groupDeleteConfirmTitle => '¿Eliminar Grupo?';

  @override
  String get groupDeleteConfirmBody => 'Esta acción no se puede deshacer.';

  @override
  String get deviceRemoveConfirmTitle => '¿Quitar Dispositivo?';

  @override
  String get deviceRemoveConfirmBody =>
      '¿Estás seguro de que deseas quitar este dispositivo del grupo?';

  @override
  String get groupsBtnCancel => 'Cancelar';

  @override
  String get groupsBtnCreate => 'Crear';

  @override
  String get groupsBtnSave => 'Guardar';

  @override
  String get groupsBtnRemove => 'Quitar';

  @override
  String get groupsBtnDelete => 'Eliminar';

  @override
  String get groupsTitleSimple => 'Grupos';

  @override
  String get groupsButtonCreateAction => 'Crear Grupo';

  @override
  String get groupsSubsectionDevices => 'Dispositivos';

  @override
  String get groupsSuccessCreated => 'Grupo creado exitosamente';

  @override
  String get groupsSuccessUpdated => 'Grupo actualizado';

  @override
  String get groupsSuccessDeleted => 'Grupo eliminado';

  @override
  String get groupsSuccessDeviceRemoved => 'Dispositivo quitado del grupo';

  @override
  String get generalRetry => 'Reintentar';

  @override
  String get provisioningScanTitle => 'Buscando Dispositivos';

  @override
  String get provisioningScanSubtitle =>
      'Asegúrate que tu dispositivo esté en modo configuración (LED parpadeando).';

  @override
  String get provisioningScanningText => 'Escaneando...';

  @override
  String get provisioningDeviceFound => 'Dispositivo detectado';

  @override
  String get provisioningConnectBtn => 'Conectar';

  @override
  String get provisioningWifiTitle => 'Conectar a Wifi';

  @override
  String get provisioningWifiSubtitle =>
      'Ingresa las credenciales para el dispositivo.';

  @override
  String get provisioningSsidLabel => 'Nombre de la Red (SSID)';

  @override
  String get provisioningPasswordLabel => 'Contraseña Wifi';

  @override
  String get provisioningSendBtn => 'Enviar Configuración';

  @override
  String get provisioningSuccessTitle => '¡Configuración Exitosa!';

  @override
  String get provisioningSuccessBody =>
      'El dispositivo se ha conectado correctamente.';

  @override
  String get provisioningManualModeBtn =>
      '¿No aparece? Configuración Manual (AP)';

  @override
  String get provisioningErrorConnection =>
      'No se pudo conectar al dispositivo';

  @override
  String get provisioningErrorWifi =>
      'Contraseña incorrecta o Wifi no encontrado';

  @override
  String get devicesListTitle => 'Dispositivos';

  @override
  String get devicesTabDevices => 'Dispositivos';

  @override
  String get devicesTabOthers => 'Otros';

  @override
  String get deviceStatusOpening => 'Abriendo...';

  @override
  String get deviceStatusClosing => 'Cerrando...';

  @override
  String get deviceStatusPaused => 'Pausado';

  @override
  String get deviceStatusPedestrianActive => 'Modo Peatonal activado';

  @override
  String get deviceStatusReady => 'Listo';

  @override
  String deviceAutoCloseCountdown(int seconds) {
    return 'Cierre automático en: $seconds s';
  }

  @override
  String get emptyListMessage => 'No hay elementos';

  @override
  String get scanDevicesTitle => 'Agregar Dispositivo';

  @override
  String get scanDeviceLabel => 'Dispositivo:';

  @override
  String get scanDeviceState => 'Estado:';

  @override
  String get scanDeviceDetail => 'Detalle:';

  @override
  String get scanButtonScan => 'Escanear';

  @override
  String get scanWifiNetworksDetected => 'Redes Wi-Fi Detectadas';

  @override
  String get scanVitaDevicesAvailable => 'VITA\'S disponibles';

  @override
  String get scanVitaDevices => 'Dispositivos VITA';

  @override
  String get scanSerialNumberHint => 'Vincular por No de Serie';

  @override
  String get scanSerialNumberLabel => 'Número de Serie';

  @override
  String get scanButtonAdd => 'Agregar';

  @override
  String scanCompletedMessage(int count) {
    return 'Escaneo completado - $count redes encontradas';
  }

  @override
  String get scanSelectDeviceError =>
      'Selecciona un dispositivo VITA o ingresa un número de serie';

  @override
  String scanDeviceAddedSuccess(String deviceId) {
    return 'Dispositivo $deviceId agregado';
  }

  @override
  String get parametersTitle => 'Parámetros\ndel Dispositivo';

  @override
  String get parametersDeviceLabel => 'Dispositivo:';

  @override
  String get parametersModelLabel => 'Mod:';

  @override
  String get parametersSerialLabel => 'No. Serie:';

  @override
  String get parametersStateLabel => 'Estado:';

  @override
  String get parametersDetailLabel => 'Detalle:';

  @override
  String get parametersConfigSection => 'Config Parámetros:';

  @override
  String get parametersNotificationsSection => 'Config Notificaciones:';

  @override
  String get parametersAutoClose => 'Cierre Automático';

  @override
  String get parametersCourtesyLight => 'Luz de cortesía';

  @override
  String get parametersAutoCloseTime =>
      'Tiempo antes de cerrar automáticamente';

  @override
  String get parametersLockDevice => 'Bloquear dispositivo';

  @override
  String get parametersKeepOpen => 'Mantener abierto';

  @override
  String get parametersDisconnectionReminder =>
      'Recordatorio falta de conexión';

  @override
  String get parametersOpenDoorReminder => 'Recordatorio puerta abierta';

  @override
  String get parametersForcedOpeningAlarm => 'Alarma Apertura Forzada';

  @override
  String get parametersPhotocellBlocked => 'Foto celda bloqueada';

  @override
  String get parametersOpeningNotAllowed => 'Apertura no permitida';

  @override
  String get parametersUpdateAvailable => 'Actualización disponible';

  @override
  String get parametersMaintenanceRequest => 'Solicitud de mantenimiento';

  @override
  String get parametersOpenDoorReminderTime =>
      'Tiempo recordatorio puerta abierta';

  @override
  String get parametersConnectionFailureTime => 'Tiempo falta de conexión';

  @override
  String get parametersPhotocellBlockedTime => 'Tiempo foto celda bloqueada';

  @override
  String get parametersUpdateButton => 'Actualizar parámetros';

  @override
  String get parametersUpdatedSuccess =>
      'Parámetros actualizados correctamente';

  @override
  String get settingsTitle => 'Configuración';

  @override
  String get settingsSelectCountry => 'Seleccionar País';

  @override
  String get settingsSelectLanguage => 'Seleccionar Idioma';

  @override
  String get settingsSelectEnvironment => 'Seleccionar Entorno';

  @override
  String get settingsCountryCostaRica => 'Costa Rica';

  @override
  String get settingsCountryMexico => 'México';

  @override
  String get settingsCountrySpain => 'España';

  @override
  String get settingsLanguageSpanish => 'Español';

  @override
  String get settingsLanguageEnglish => 'English';

  @override
  String get settingsEnvironmentProduction => 'Producción';

  @override
  String get settingsEnvironmentStaging => 'Staging';

  @override
  String get settingsEnvironmentDevelopment => 'Desarrollo';

  @override
  String get settingsProfileSection => 'Perfil de Usuario';

  @override
  String get settingsAppearanceSection => 'Apariencia';

  @override
  String get settingsAccessibilitySection => 'Accesibilidad';

  @override
  String get settingsSecuritySection => 'Seguridad';

  @override
  String get settingsServerSection => 'Configuración de Servidor';

  @override
  String get settingsInfoSection => 'Información';

  @override
  String get settingsFieldName => 'Nombre';

  @override
  String get settingsFieldPhone => 'Teléfono';

  @override
  String get settingsFieldEmail => 'Correo';

  @override
  String get settingsFieldAddress => 'Dirección';

  @override
  String get settingsFieldCountry => 'País';

  @override
  String get settingsFieldLanguage => 'Idioma';

  @override
  String get settingsDarkMode => 'Modo Oscuro';

  @override
  String get settingsFontSize => 'Tamaño de Fuente';

  @override
  String get settingsHighContrast => 'Alto Contraste';

  @override
  String get settingsReduceMotion => 'Reducir Movimiento';

  @override
  String get settingsCurrentPassword => 'Contraseña Actual';

  @override
  String get settingsNewPassword => 'Contraseña Nueva';

  @override
  String get settingsRepeatPassword => 'Repetir Contraseña';

  @override
  String get settingsBiometrics => 'Habilitar Biometría';

  @override
  String get settingsBiometricsSubtitle => 'Usar huella o rostro para ingresar';

  @override
  String get settingsEnvironment => 'Entorno';

  @override
  String get settingsServerUrl => 'URL del Servidor';

  @override
  String get settingsAppVersion => 'Versión de la App';

  @override
  String get settingsTermsConditions => 'Términos y Condiciones';

  @override
  String get settingsPrivacyPolicy => 'Política de Privacidad';

  @override
  String get settingsSaveChanges => 'Guardar Cambios';

  @override
  String get settingsChangeButton => 'Cambiar';

  @override
  String get settingsChangePhoto => 'Cambiar foto';

  @override
  String get settingsPhotoCamera => 'Cámara';

  @override
  String get settingsPhotoGallery => 'Galería';

  @override
  String get settingsPhotoRemove => 'Eliminar foto';

  @override
  String get settingsPhotoUpdated => 'Foto de perfil actualizada';

  @override
  String get settingsPhotoRemoved => 'Foto de perfil eliminada';

  @override
  String get settingsUpdatedSuccess => 'Configuración actualizada exitosamente';

  @override
  String get bottomNavDevices => 'Dispositivos';

  @override
  String get msgInvalidCredentials => 'Correo o contraseña incorrectos';

  @override
  String get msgSessionExpired => 'Tu sesión ha expirado';

  @override
  String get msgEmailAlreadyExists => 'Este correo ya está registrado';

  @override
  String get msgPasswordMismatch => 'Las contraseñas no coinciden';

  @override
  String get msgLoginSuccess => 'Bienvenido a BGnius VITA';

  @override
  String get msgRegisterSuccess => 'Cuenta creada exitosamente';

  @override
  String get msgLogoutSuccess => 'Sesión cerrada';

  @override
  String get msgPasswordResetSent => 'Se ha enviado un enlace a tu correo';

  @override
  String get msgDeviceNotFound => 'El dispositivo no fue encontrado';

  @override
  String get msgDeviceOffline => 'El dispositivo está sin conexión';

  @override
  String get msgCommandFailed => 'No se pudo ejecutar el comando';

  @override
  String get msgDeviceAdded => 'Dispositivo agregado exitosamente';

  @override
  String get msgDeviceUpdated => 'Dispositivo actualizado';

  @override
  String get msgDeviceDeleted => 'Dispositivo eliminado';

  @override
  String get msgCommandSuccess => 'Comando ejecutado correctamente';

  @override
  String get msgUserNotFound => 'Usuario no encontrado';

  @override
  String get msgUserAdded => 'Usuario agregado exitosamente';

  @override
  String get msgUserUpdated => 'Usuario actualizado';

  @override
  String get msgUserDeleted => 'Usuario eliminado';

  @override
  String get msgPermissionGranted => 'Permiso otorgado';

  @override
  String get msgPermissionRevoked => 'Permiso revocado';

  @override
  String get msgUserLinked => 'Usuario vinculado correctamente';

  @override
  String get msgGroupCreated => 'Grupo creado exitosamente';

  @override
  String get msgGroupUpdated => 'Grupo actualizado';

  @override
  String get msgGroupDeleted => 'Grupo eliminado';

  @override
  String get msgDeviceAddedToGroup => 'Dispositivo agregado al grupo';

  @override
  String get msgDeviceRemovedFromGroup => 'Dispositivo removido del grupo';

  @override
  String get msgRequiredField => 'Este campo es obligatorio';

  @override
  String get msgInvalidFormat => 'El formato ingresado no es válido';

  @override
  String get msgServerError => 'Ocurrió un error en el servidor';

  @override
  String get msgConnectionError => 'No se pudo conectar al servidor';

  @override
  String get msgUnknownError => 'Ocurrió un error inesperado';

  @override
  String get msgNoData => 'No hay datos disponibles';

  @override
  String get msgLoading => 'Cargando...';

  @override
  String get msgRetry => 'Reintentar';

  @override
  String get msgCancel => 'Cancelar';

  @override
  String get msgAccept => 'Aceptar';

  @override
  String get msgSave => 'Guardar';

  @override
  String get msgDelete => 'Eliminar';

  @override
  String get msgEdit => 'Editar';

  @override
  String get msgAdd => 'Agregar';

  @override
  String get msgConfirm => 'Confirmar';

  @override
  String get msgYes => 'Sí';

  @override
  String get msgNo => 'No';

  @override
  String get msgConfirmDelete => '¿Estás seguro de eliminar este elemento?';

  @override
  String get msgConfirmDeleteDevice => '¿Deseas eliminar este dispositivo?';

  @override
  String get msgConfirmDeleteUser => '¿Deseas eliminar este usuario?';

  @override
  String get msgConfirmLogout => '¿Deseas cerrar sesión?';

  @override
  String get msgCannotUndo => 'Esta acción no se puede deshacer';

  @override
  String get msgMinPasswordLength =>
      'La contraseña debe tener al menos 8 caracteres';

  @override
  String get msgInvalidEmail => 'El formato del correo no es válido';

  @override
  String get msgInvalidPhone => 'El formato del teléfono no es válido';

  @override
  String get msgInvalidSerialNumber => 'El número de serie no es válido';

  @override
  String get navDevices => 'Dispositivos';

  @override
  String get navGroups => 'Grupos';

  @override
  String get navUsers => 'Usuarios';

  @override
  String get navSettings => 'Configuración';

  @override
  String get sharedUsersTitle => 'Usuarios\nRegistrados';

  @override
  String get sharedUsersDeviceLabel => 'Dispositivo:';

  @override
  String get sharedUsersModelLabel => 'Mod:';

  @override
  String get sharedUsersSerialLabel => 'No. Serie:';

  @override
  String get sharedUsersStatusLabel => 'Estado:';

  @override
  String get sharedUsersDetailLabel => 'Detalle:';

  @override
  String get sharedUsersSearchHint => 'Buscar usuario';

  @override
  String get sharedUsersEmptyList => 'No hay usuarios registrados';

  @override
  String get sharedUsersLinkButton => 'Vincular Usuario';

  @override
  String get deviceEditTitle => 'Editar Dispositivo';

  @override
  String get deviceEditSuccessMessage =>
      'Dispositivo actualizado correctamente';

  @override
  String get deviceEditErrorLoading => 'Error al cargar';

  @override
  String get deviceControlTitle => 'Detalle del Dispositivo';

  @override
  String get deviceControlButtonOpen => 'Abrir';

  @override
  String get deviceControlButtonPause => 'Pausa';

  @override
  String get deviceControlButtonClose => 'Cerrar';

  @override
  String get deviceControlButtonPedestrian => 'Peatonal';

  @override
  String get deviceControlButtonLock => 'Bloqueo';

  @override
  String get deviceControlButtonLight => 'Lámpara';

  @override
  String get deviceControlButtonSwitch => 'Switch';

  @override
  String get deviceControlStatusOpening => 'Abriendo portón...';

  @override
  String get deviceControlStatusPausing => 'Pausando...';

  @override
  String get deviceControlStatusClosing => 'Cerrando portón...';

  @override
  String get deviceControlStatusPedestrian => 'Apertura peatonal...';

  @override
  String get deviceControlStatusLocked => 'Dispositivo Bloqueado';

  @override
  String get deviceControlStatusLightOn => 'Luz encendida';

  @override
  String get deviceControlStatusSwitchActive => 'Switch activado';

  @override
  String deviceControlAutoCloseCountdown(Object seconds) {
    return 'Cierre autom. en: $seconds s';
  }

  @override
  String get deviceControlLinkEdit => 'Editar Dispositivo';

  @override
  String get deviceControlLinkUsers => 'Usuarios con Acceso';

  @override
  String get deviceControlLinkParams => 'Parámetros';

  @override
  String get deviceControlLinkEvents => 'Registro de Eventos';

  @override
  String get deviceControlLinkContact => 'Contacto Técnico';

  @override
  String get deviceControlLinkInfo => 'Información del Dispositivo';

  @override
  String get technicalContactTitle => 'Contacto Técnico';

  @override
  String get technicalContactDeviceLabel => 'Dispositivo:';

  @override
  String get technicalContactModelLabel => 'Mod:';

  @override
  String get technicalContactSerialLabel => 'No. Serie:';

  @override
  String get technicalContactStatusLabel => 'Estado:';

  @override
  String get technicalContactDetailLabel => 'Detalle:';

  @override
  String get technicalContactTechDataTitle => 'Datos del Técnico';

  @override
  String get technicalContactNameHint => 'Nombre de usuario';

  @override
  String get technicalContactEmailHint => 'Correo';

  @override
  String get technicalContactCountryHint => 'País';

  @override
  String get technicalContactPhoneHint => 'Teléfono';

  @override
  String get technicalContactAiDescription =>
      'Nuestra IA revisa periódicamente tu automatismo, analiza su rendimiento y detecta posibles signos de desgaste o fallos. Con base en esto, te informa cuando tu sistema necesita mantenimiento.';

  @override
  String get technicalContactAiPermissionText =>
      'Permitir que la IA me informe cuando se requiera mantenimiento.';

  @override
  String get technicalContactNotesTitle => 'Notas';

  @override
  String get technicalContactDeleteButton => 'Eliminar';

  @override
  String get technicalContactSaveButton => 'Guardar';

  @override
  String get technicalContactDeleteDialogTitle => 'Eliminar Contacto';

  @override
  String get technicalContactDeleteDialogContent =>
      '¿Estás seguro que deseas eliminar este contacto técnico?';

  @override
  String get technicalContactCancelButton => 'Cancelar';

  @override
  String get technicalContactSaveSuccess =>
      'Contacto técnico guardado exitosamente';

  @override
  String get technicalContactDeleteSuccess => 'Contacto técnico eliminado';

  @override
  String get technicalContactMaintenanceInfo =>
      'Contactando mantenimiento - Próximamente';

  @override
  String get linkVirtualUserTitle => 'Vincular usuario virtual';

  @override
  String get linkVirtualUserEmailLabel => 'Correo/Usuario';

  @override
  String get linkVirtualUserEmailHint => 'Correo/Usuario';

  @override
  String get linkVirtualUserLabelLabel => 'Etiqueta';

  @override
  String get linkVirtualUserLabelHint => 'Etiqueta';

  @override
  String get linkVirtualUserAddButton => 'Agregar Usuario al Listado';

  @override
  String get linkVirtualUserNewUserName => 'Nuevo Usuario';

  @override
  String get linkVirtualUserErrorEmail => 'Por favor ingrese correo o usuario';

  @override
  String get linkVirtualUserSuccess =>
      'Usuario agregado. Configura sus permisos.';

  @override
  String get deviceControlSimpleTitle => 'Controles';

  @override
  String get deviceControlLocationTitle => 'Ubicación';

  @override
  String get deviceControlDescriptionTitle => 'Descripción';

  @override
  String get deviceControlStatusTitle => 'Estado';

  @override
  String get usersScreenTitle => 'Usuarios con Accesos';

  @override
  String get usersScreenDeviceLabel => 'Dispositivo:';

  @override
  String get usersScreenModelLabel => 'Mod:';

  @override
  String get usersScreenSerialLabel => 'No. Serie:';

  @override
  String get usersScreenStatusLabel => 'Estado:';

  @override
  String get usersScreenDetailLabel => 'Detalle:';

  @override
  String get usersScreenAvailableUsersTitle => 'Usuarios Disponibles:';

  @override
  String get usersScreenLinkButton => 'Vincular Usuario Existente';

  @override
  String get usersScreenErrorSelectUsers => 'Selecciona al menos un usuario';

  @override
  String usersScreenSuccessLinked(Object count) {
    return '$count usuario(s) vinculado(s) exitosamente';
  }

  @override
  String usersScreenEditInfo(Object name) {
    return 'Editar $name - Próximamente';
  }

  @override
  String get userAccessScreenTitle => 'Usuarios con Accesos';

  @override
  String get userAccessDeviceLabel => 'Dispositivo:';

  @override
  String get userAccessModelLabel => 'Mod:';

  @override
  String get userAccessSerialLabel => 'No. Serie:';

  @override
  String get userAccessStatusLabel => 'Estado:';

  @override
  String get userAccessDetailLabel => 'Detalle:';

  @override
  String get userAccessLinkedUsersTitle => 'Usuarios Actualmente Vinculados';

  @override
  String get userAccessLinkedUsersDesc =>
      'Estos usuarios ya pueden acceder a este dispositivo';

  @override
  String get userAccessAvailableUsersTitle =>
      'Usuarios Disponibles para Vincular';

  @override
  String get userAccessAvailableUsersDesc =>
      'Selecciona usuarios para darles acceso a este dispositivo';

  @override
  String get userAccessSearchHint => 'Buscar usuario...';

  @override
  String get userAccessTooltipAdmin => 'Administrador';

  @override
  String get userAccessTooltipUnlink => 'Desvincular';

  @override
  String get userAccessEditButton => 'Editar';

  @override
  String get userAccessErrorAdminUnlink =>
      'No puedes desvincular al administrador';

  @override
  String get userAccessErrorSelectUsers => 'Selecciona al menos un usuario';

  @override
  String get userAccessUnlinkDialogTitle => 'Desvincular Usuario';

  @override
  String userAccessUnlinkDialogContent(Object name) {
    return '¿Deseas desvincular a $name?';
  }

  @override
  String get userAccessCancelButton => 'Cancelar';

  @override
  String get userAccessUnlinkButton => 'Desvincular';

  @override
  String userAccessSuccessUnlinked(Object name) {
    return '$name desvinculado';
  }

  @override
  String userAccessSuccessLinked(Object count) {
    return '$count usuario(s) vinculado(s) exitosamente';
  }

  @override
  String userAccessEditInfo(Object name) {
    return 'Editar $name - Próximamente';
  }

  @override
  String userAccessLinkButtonSingle(Object count) {
    return 'Vincular Usuario Existente ($count)';
  }

  @override
  String userAccessLinkButtonPlural(Object count) {
    return 'Vincular Usuarios Existentes ($count)';
  }

  @override
  String get userRolesTitle => 'Roles de usuario\nen dispositivo';

  @override
  String get userRolesDeviceLabel => 'Dispositivo:';

  @override
  String get userRolesModelLabel => 'Mod:';

  @override
  String get userRolesSerialLabel => 'No. Serie:';

  @override
  String get userRolesStatusLabel => 'Estado:';

  @override
  String get userRolesDetailLabel => 'Detalle:';

  @override
  String get userRolesSelectedUserLabel => 'Usuario Seleccionado';

  @override
  String get userRolesEmailLabel => 'Correo';

  @override
  String get userRolesNewUserDefault => 'Usuario Nuevo';

  @override
  String get userRolesPermissionsTitle => 'Permisos y Roles';

  @override
  String get userRolesAssignButton => 'Asignar Roles';

  @override
  String get userRolesPermissionOpen => 'Abrir';

  @override
  String get userRolesPermissionClose => 'Cerrar';

  @override
  String get userRolesPermissionPause => 'Parar/Pausa';

  @override
  String get userRolesPermissionPedestrian => 'Peatonal';

  @override
  String get userRolesPermissionLock => 'Bloquear';

  @override
  String get userRolesPermissionLight => 'Lámpara';

  @override
  String get userRolesPermissionSwitch => 'Relé/Switch';

  @override
  String get userRolesPermissionControlPanel => 'Panel Control';

  @override
  String get userRolesPermissionReports => 'Reportes';

  @override
  String get userRolesPermissionViewContact => 'Ver Contacto';

  @override
  String get userRolesPermissionViewParams => 'Ver Parámetros';

  @override
  String get userRolesPermissionEditDevice => 'Editar Disp.';

  @override
  String get userRolesPermissionAssignUsers => 'Asignar usuarios';

  @override
  String get userRolesErrorNoPermissions => 'Selecciona al menos un permiso';

  @override
  String get userRolesSuccessAssigned =>
      'Roles asignados y usuario vinculado exitosamente';

  @override
  String get userRolesErrorUnknownDevice =>
      'No se pudo vincular: Dispositivo desconocido';

  @override
  String get deviceFormGallery => 'Galería';

  @override
  String get deviceFormCamera => 'Cámara';

  @override
  String get deviceFormDeletePhoto => 'Eliminar Foto';

  @override
  String get deviceFormDeleteDevice => 'Eliminar Dispositivo';

  @override
  String get generalDelete => 'Eliminar';

  @override
  String get deviceFormDeleteConfirmMessage =>
      '¿Estás seguro de que deseas eliminar este dispositivo y todos sus datos asociados? Esta acción no se puede deshacer.';

  @override
  String get deviceFormSelectImage => 'Seleccionar Imagen';

  @override
  String get deviceFormTakePhoto => 'Tomar Foto';

  @override
  String get deviceFormImageLoadedSuccess => 'Imagen cargada correctamente';

  @override
  String deviceFormImageLoadError(String error) {
    return 'Error al cargar imagen: $error';
  }

  @override
  String get deviceFormDeletedSuccess => 'Dispositivo eliminado correctamente';

  @override
  String get blePairingTitle => 'Emparejamiento BLE';

  @override
  String get bleScanStepTitle => 'Escanear dispositivos';

  @override
  String get bleScanStepDescription =>
      'Busca dispositivos VITA cercanos. Asegúrate que el dispositivo esté en modo emparejamiento (LED azul parpadeando).';

  @override
  String get bleScanButtonStart => 'Iniciar escaneo';

  @override
  String get bleScanningText => 'Escaneando dispositivos...';

  @override
  String get bleDeviceListStepTitle => 'Seleccionar dispositivo';

  @override
  String bleDeviceListFound(int count) {
    return 'Se encontraron $count dispositivos';
  }

  @override
  String get bleConnectionStepTitle => 'Conectando';

  @override
  String get bleConnectingText => 'Conectando al dispositivo...';

  @override
  String get bleDeviceInfoTitle => 'Información del dispositivo';

  @override
  String get bleConfigureButton => 'Configurar';

  @override
  String get bleConfigStepTitle => 'Configuración';

  @override
  String get bleConfigStepDescription =>
      'Configura los datos iniciales de tu dispositivo VITA.';

  @override
  String get bleConfigDeviceNameLabel => 'Nombre del dispositivo';

  @override
  String get bleConfigDeviceNameHint => 'Ej: Portón Principal';

  @override
  String get bleConfigLocationLabel => 'Ubicación';

  @override
  String get bleConfigLocationHint => 'Ej: Entrada principal';

  @override
  String get bleConfigDescriptionLabel => 'Descripción';

  @override
  String get bleConfigDescriptionHint => 'Descripción adicional (opcional)';

  @override
  String get bleConfigDeviceTypeLabel => 'Tipo de dispositivo';

  @override
  String get bleConfigTypeGate => 'Portón';

  @override
  String get bleConfigTypeDoor => 'Puerta';

  @override
  String get bleConfigTypeBarrier => 'Barrera';

  @override
  String get bleConfigSaveButton => 'Guardar configuración';

  @override
  String get bleConfigDeviceNameRequired =>
      'El nombre del dispositivo es requerido';

  @override
  String get bleConfiguringText => 'Configurando dispositivo...';

  @override
  String get bleSuccessStepTitle => 'Completado';

  @override
  String get bleSuccessMessage => '¡Dispositivo emparejado exitosamente!';

  @override
  String bleSuccessDeviceConfigured(String deviceName) {
    return 'El dispositivo \'$deviceName\' ha sido configurado correctamente.';
  }

  @override
  String get bleSuccessGoToDevices => 'Ir a mis dispositivos';

  @override
  String get bleInfoSerial => 'N° Serie';

  @override
  String get bleInfoFirmware => 'Firmware';

  @override
  String get bleInfoModel => 'Modelo';

  @override
  String get bleInfoMotor => 'Motor';

  @override
  String get bleErrorGeneric => 'Error durante el proceso de emparejamiento';

  @override
  String get notificationsTitle => 'Notificaciones';

  @override
  String get markAllAsRead => 'Marcar todas como leídas';

  @override
  String get noNotifications => 'No hay notificaciones';

  @override
  String minutesAgo(String minutes) {
    return 'hace ${minutes}m';
  }

  @override
  String hoursAgo(String hours) {
    return 'hace ${hours}h';
  }

  @override
  String daysAgo(String days) {
    return 'hace ${days}d';
  }

  @override
  String get justNow => 'Ahora';

  @override
  String get deviceOffline => 'Dispositivo desconectado';

  @override
  String get deviceOnline => 'Dispositivo conectado';

  @override
  String get actionExecuted => 'Acción ejecutada';

  @override
  String get statusChange => 'Cambio de estado';

  @override
  String get notificationPreferences => 'Preferencias de Notificaciones';

  @override
  String get notificationPreferencesDescription =>
      'Configura qué notificaciones quieres recibir para cada dispositivo';

  @override
  String get notificationTypes => 'Tipos de notificación';

  @override
  String get notifyActions => 'Notificar acciones';

  @override
  String get notifyActionsDescription => 'Cuando alguien opera el dispositivo';

  @override
  String get notifyOffline => 'Notificar desconexión';

  @override
  String get notifyOfflineDescription => 'Cuando el dispositivo se desconecta';

  @override
  String get notifyStatusChange => 'Notificar cambios de estado';

  @override
  String get notifyStatusChangeDescription =>
      'Cuando cambia el estado del motor';

  @override
  String get retry => 'Reintentar';

  @override
  String get activationDateLabel => 'Fecha de activación';

  @override
  String get favoriteDeviceLabel => 'Dispositivo Favorito';

  @override
  String get selectDatePlaceholder => 'Seleccionar fecha';

  @override
  String get changePhotoButton => 'Cambiar';

  @override
  String get deleteDeviceButton => 'Eliminar Dispositivo';

  @override
  String get serialNumberPlaceholder => 'SN...';

  @override
  String get searchPlaceholder => 'Buscar...';

  @override
  String get confirmDefault => 'Confirmar';

  @override
  String get cancelDefault => 'Cancelar';

  @override
  String get groupNotFound => 'Grupo no encontrado';

  @override
  String get cannotAddToAllGroup =>
      'No se pueden agregar dispositivos al grupo TODOS manualmente';

  @override
  String get deviceAlreadyInGroup => 'El dispositivo ya está en el grupo';

  @override
  String get cannotRemoveFromAllGroup =>
      'No se pueden eliminar dispositivos del grupo TODOS';

  @override
  String get deviceNotInGroup => 'El dispositivo no está en el grupo';

  @override
  String get nameCannotBeEmpty => 'El nombre no puede estar vacío';

  @override
  String get groupNameAlreadyExists => 'Ya existe un grupo con este nombre';

  @override
  String get cannotModifyAllGroup => 'No se puede modificar el grupo TODOS';

  @override
  String get cannotDeleteAllGroup => 'No se puede eliminar el grupo TODOS';

  @override
  String get powerTypeLabel => 'Tipo Corriente';

  @override
  String get motorTypeLabel => 'Tipo Motor';

  @override
  String get selectPlaceholder => 'Seleccionar';

  @override
  String get openingPhotocellLabel => 'Fotocélula Apertura';

  @override
  String get closingPhotocellLabel => 'Fotocélula Cierre';

  @override
  String get installationDateLabel => 'Fecha de Instalación';

  @override
  String get warrantyExpirationLabel => 'Vencimiento Garantía';

  @override
  String get scheduledMaintenanceLabel => 'Mantenimiento Programado';

  @override
  String get technicianNamePlaceholder => 'Nombre del técnico...';

  @override
  String get technicalContactLabel => 'Contacto Técnico';

  @override
  String get additionalNotesPlaceholder => 'Notas adicionales...';

  @override
  String get maintenanceNotesLabel => 'Notas de Mantenimiento';

  @override
  String get deviceOnlineStatus => 'En línea';

  @override
  String get deviceOfflineStatus => 'Sin conexión';

  @override
  String get deviceImageLabel => 'Imagen del portón del dispositivo';

  @override
  String get mainGateLabel => 'Portón Principal';

  @override
  String get garageGateLabel => 'Portón Cochera';

  @override
  String get controlsButtonOpen => 'Abrir';

  @override
  String get controlsButtonPause => 'Pausa';

  @override
  String get controlsButtonClose => 'Cerrar';

  @override
  String get controlsButtonPedestrian => 'Peatonal';

  @override
  String get modelLabel => 'Modelo:';

  @override
  String get serialNumberLabel => 'No. Serie:';

  @override
  String get detailLabel => 'Detalle';

  @override
  String get notificationTooltip => 'Notificaciones';

  @override
  String get retryButton => 'Reintentar';

  @override
  String get editButton => 'Editar';

  @override
  String get showPasswordButton => 'Mostrar';

  @override
  String get hidePasswordButton => 'Ocultar';
}

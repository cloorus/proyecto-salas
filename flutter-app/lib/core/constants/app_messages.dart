/// Mensajes estándar de la aplicación
class AppMessages {
  AppMessages._();

  // ========== AUTH ==========
  static const String invalidCredentials = 'Correo o contraseña incorrectos';
  static const String sessionExpired = 'Tu sesión ha expirado';
  static const String emailAlreadyExists = 'Este correo ya está registrado';
  static const String passwordMismatch = 'Las contraseñas no coinciden';
  static const String loginSuccess = 'Bienvenido a BGnius VITA';
  static const String registerSuccess = 'Cuenta creada exitosamente';
  static const String logoutSuccess = 'Sesión cerrada';
  static const String passwordResetSent = 'Se ha enviado un enlace a tu correo';
  
  // ========== DISPOSITIVOS ==========
  static const String deviceNotFound = 'El dispositivo no fue encontrado';
  static const String deviceOffline = 'El dispositivo está sin conexión';
  static const String commandFailed = 'No se pudo ejecutar el comando';
  static const String deviceAdded = 'Dispositivo agregado exitosamente';
  static const String deviceUpdated = 'Dispositivo actualizado';
  static const String deviceDeleted = 'Dispositivo eliminado';
  static const String commandSuccess = 'Comando ejecutado correctamente';
  static const String openCommand = 'Abriendo...';
  static const String closeCommand = 'Cerrando...';
  static const String pauseCommand = 'Pausando...';
  static const String pedestrianCommand = 'Modo peatonal activado';
  
  // ========== USUARIOS ==========
  static const String userNotFound = 'Usuario no encontrado';
  static const String userAdded = 'Usuario agregado exitosamente';
  static const String userUpdated = 'Usuario actualizado';
  static const String userDeleted = 'Usuario eliminado';
  static const String permissionGranted = 'Permiso otorgado';
  static const String permissionRevoked = 'Permiso revocado';
  static const String userLinked = 'Usuario vinculado correctamente';
  
  // ========== GRUPOS ==========
  static const String groupCreated = 'Grupo creado exitosamente';
  static const String groupUpdated = 'Grupo actualizado';
  static const String groupDeleted = 'Grupo eliminado';
  static const String deviceAddedToGroup = 'Dispositivo agregado al grupo';
  static const String deviceRemovedFromGroup = 'Dispositivo removido del grupo';
  
  // ========== GENERAL ==========
  static const String requiredField = 'Este campo es obligatorio';
  static const String invalidFormat = 'El formato ingresado no es válido';
  static const String serverError = 'Ocurrió un error en el servidor';
  static const String connectionError = 'No se pudo conectar al servidor';
  static const String unknownError = 'Ocurrió un error inesperado';
  static const String noData = 'No hay datos disponibles';
  static const String loading = 'Cargando...';
  static const String retry = 'Reintentar';
  static const String cancel = 'Cancelar';
  static const String accept = 'Aceptar';
  static const String save = 'Guardar';
  static const String delete = 'Eliminar';
  static const String edit = 'Editar';
  static const String add = 'Agregar';
  static const String confirm = 'Confirmar';
  static const String yes = 'Sí';
  static const String no = 'No';
  
  // ========== CONFIRMACIONES ==========
  static const String confirmDelete = '¿Estás seguro de eliminar este elemento?';
  static const String confirmDeleteDevice = '¿Deseas eliminar este dispositivo?';
  static const String confirmDeleteUser = '¿Deseas eliminar este usuario?';
  static const String confirmLogout = '¿Deseas cerrar sesión?';
  static const String cannotUndo = 'Esta acción no se puede deshacer';
  
  // ========== VALIDACIONES ==========
  static const String minPasswordLength = 'La contraseña debe tener al menos 8 caracteres';
  static const String invalidEmail = 'El formato del correo no es válido';
  static const String invalidPhone = 'El formato del teléfono no es válido';
  static const String invalidSerialNumber = 'El número de serie no es válido';
}

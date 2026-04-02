import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/device.dart';
import '../../domain/validators/device_validator.dart';
import '../../data/datasources/device_remote_datasource.dart';
import '../../data/repositories/device_repository_impl.dart';
import '../state/device_mutation_cubit.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../core/services/error_translator_service.dart';
import '../../../../core/utils/formatters/mac_address_formatter.dart';
import '../../../../core/utils/formatters/serial_number_formatter.dart';

class DeviceEditScreen extends StatefulWidget {
  final Device? device;

  const DeviceEditScreen({
    Key? key,
    this.device,
  }) : super(key: key);

  @override
  State<DeviceEditScreen> createState() => _DeviceEditScreenState();
}

class _DeviceEditScreenState extends State<DeviceEditScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers para campos básicos
  late TextEditingController _nameController;
  late TextEditingController _locationController;
  late TextEditingController _descriptionController;
  late TextEditingController _serialNumberController;
  late TextEditingController _macAddressController;
  late TextEditingController _modelController;

  // Controllers para configuración operativa
  late TextEditingController _autoCloseTimeoutController;
  late TextEditingController _maxOpenTimeController;
  late TextEditingController _pedestrianTimeoutController;

  // Controllers para info física
  late TextEditingController _hardwareVersionController;
  late TextEditingController _firmwareVersionController;

  // Controllers para mantenimiento
  late TextEditingController _maintenanceNotesController;

  // Dates
  DateTime? _installationDate;
  DateTime? _warrantyExpiry;
  DateTime? _scheduledMaintenance;

  // Booleans
  bool _emergencyMode = false;
  bool _lampAutoOn = false;
  bool _maintenanceMode = false;
  bool _locked = false;

  // Dropdowns
  String _selectedStatus = 'online';
  String _selectedDeviceType = 'gate';
  String _selectedSecurityLevel = '3';

  // Sliders
  double _movementSpeed = 5.0;

  // Time pickers
  TimeOfDay? _operatingHoursStart;
  TimeOfDay? _operatingHoursEnd;

  // MAC address validation
  Timer? _macValidationTimer;
  bool _isMacValidating = false;
  String? _macValidationError;
  bool _macValidationNetworkError = false; // Fix 3.1: Distinguir errores de red

  // Backend validation errors
  Map<String, String> _backendErrors = {};

  // Dispositivo inicial para comparación de cambios (Fix 1.2)
  Device? _initialDevice;

  final List<Map<String, String>> _statusOptions = [
    {'value': 'online', 'label': 'En línea'},
    {'value': 'offline', 'label': 'Desconectado'},
    {'value': 'maintenance', 'label': 'Mantenimiento'},
    {'value': 'error', 'label': 'Error'},
  ];

  final List<Map<String, String>> _deviceTypeOptions = [
    {'value': 'gate', 'label': 'Portón'},
    {'value': 'barrier', 'label': 'Barrera'},
    {'value': 'door', 'label': 'Puerta'},
    {'value': 'turnstile', 'label': 'Torniquete'},
  ];

  final List<String> _locationOptions = [
    'Entrada Principal',
    'Entrada Norte',
    'Entrada Sur',
    'Entrada Este',
    'Entrada Oeste',
    'Estacionamiento A',
    'Estacionamiento B',
    'Recepción',
    'Lobby',
    'Área de Carga',
  ];

  final List<String> _modelOptions = [
    'FAC 500 VITA',
    'FAC 600 VITA',
    'FAC 700 VITA',
    'FAC 800 VITA',
    'FAC 900 VITA',
    'Custom Model',
  ];

  final List<Map<String, String>> _securityLevelOptions = [
    {'value': '1', 'label': '1 - Bajo'},
    {'value': '2', 'label': '2 - Medio-Bajo'},
    {'value': '3', 'label': '3 - Medio'},
    {'value': '4', 'label': '4 - Medio-Alto'},
    {'value': '5', 'label': '5 - Alto'},
  ];

  @override
  void initState() {
    super.initState();

    final device = widget.device;

    // Guardar dispositivo inicial para comparación de cambios (Fix 1.2)
    _initialDevice = device;
    // Initialize controllers (empty if creating new device)
    _nameController = TextEditingController(text: device?.name ?? '');
    _locationController = TextEditingController(text: device?.location ?? '');
    _descriptionController = TextEditingController(text: device?.description ?? '');

    // Limpiar número de serie: remover guiones y caracteres no alfanuméricos
    final cleanSerial = device?.serialNumber?.replaceAll(RegExp(r'[^A-Z0-9]'), '').toUpperCase() ?? '';
    _serialNumberController = TextEditingController(text: cleanSerial);

    _macAddressController = TextEditingController(text: device?.macAddress ?? '');
    _modelController = TextEditingController(text: device?.model ?? '');

    _autoCloseTimeoutController = TextEditingController(text: device?.autoCloseTimeout?.toString() ?? '');
    _maxOpenTimeController = TextEditingController(text: device?.maxOpenTime?.toString() ?? '');
    _pedestrianTimeoutController = TextEditingController(text: device?.pedestrianTimeout?.toString() ?? '');

    _hardwareVersionController = TextEditingController(text: device?.hardwareVersion ?? '');
    _firmwareVersionController = TextEditingController(text: device?.firmwareVersion ?? '');

    _maintenanceNotesController = TextEditingController(text: device?.maintenanceNotes ?? '');

    // Agregar listeners para limpiar errores de backend cuando el usuario edita
    _nameController.addListener(() => _clearBackendError('name'));
    _locationController.addListener(() => _clearBackendError('location'));
    _descriptionController.addListener(() => _clearBackendError('description'));
    _serialNumberController.addListener(() => _clearBackendError('serialNumber'));
    _macAddressController.addListener(() => _clearBackendError('macAddress'));
    _modelController.addListener(() => _clearBackendError('model'));
    _hardwareVersionController.addListener(() => _clearBackendError('hardwareVersion'));
    _firmwareVersionController.addListener(() => _clearBackendError('firmwareVersion'));

    _installationDate = device?.installationDate;
    _warrantyExpiry = device?.warrantyExpiry;
    _scheduledMaintenance = device?.scheduledMaintenance;

    _emergencyMode = device?.emergencyMode ?? false;
    _lampAutoOn = device?.lampAutoOn ?? false;
    _maintenanceMode = device?.maintenanceMode ?? false;
    _locked = device?.locked ?? false;

    // Validar que status esté en las opciones válidas, sino usar 'online' por defecto
    final validStatuses = _statusOptions.map((e) => e['value']).toList();
    _selectedStatus = (device?.status != null && validStatuses.contains(device!.status))
        ? device.status!
        : 'online';

    // Validar que deviceType esté en las opciones válidas, sino usar 'gate' por defecto
    final validDeviceTypes = _deviceTypeOptions.map((e) => e['value']).toList();
    _selectedDeviceType = (device?.deviceType != null && validDeviceTypes.contains(device!.deviceType))
        ? device.deviceType!
        : 'gate';

    // Inicializar nivel de seguridad
    final validSecurityLevels = _securityLevelOptions.map((e) => e['value']).toList();
    final securityLevelStr = device?.securityLevel?.toString() ?? '3';
    _selectedSecurityLevel = validSecurityLevels.contains(securityLevelStr) ? securityLevelStr : '3';

    // Inicializar velocidad de movimiento (1-10)
    _movementSpeed = (device?.movementSpeed ?? 5).toDouble().clamp(1.0, 10.0);

    // Inicializar horario de operación desde string "HH:MM-HH:MM"
    if (device?.operatingHours != null && device!.operatingHours!.isNotEmpty) {
      final parts = device.operatingHours!.split('-');
      if (parts.length == 2) {
        _operatingHoursStart = _parseTimeOfDay(parts[0].trim());
        _operatingHoursEnd = _parseTimeOfDay(parts[1].trim());
      }
    }

    // Listener para validar MAC address mientras el usuario escribe
    _macAddressController.addListener(_onMacAddressChanged);
  }

  void _onMacAddressChanged() {
    // Cancelar timer anterior
    _macValidationTimer?.cancel();

    // Limpiar error anterior (Fix 3.1: También limpiar flag de red)
    setState(() {
      _macValidationError = null;
      _macValidationNetworkError = false;
    });

    // Esperar 800ms después de que el usuario deje de escribir
    _macValidationTimer = Timer(const Duration(milliseconds: 800), () {
      final mac = _macAddressController.text.trim();
      if (mac.isNotEmpty && DeviceValidator.validateMacAddress(mac) == null) {
        _validateMacAddressUnique(mac);
      }
    });
  }

  Future<void> _validateMacAddressUnique(String macAddress) async {
    setState(() {
      _isMacValidating = true;
      _macValidationNetworkError = false;
    });

    try {
      final apiService = Provider.of<ApiService>(context, listen: false);
      final authService = Provider.of<AuthService>(context, listen: false);
      final dataSource = DeviceRemoteDataSource(apiService, authService);

      final exists = await dataSource.checkMacAddressExists(
        macAddress,
        excludeDeviceId: widget.device?.id,
      );

      if (mounted) {
        setState(() {
          _isMacValidating = false;
          _macValidationError = exists
              ? 'Esta dirección MAC ya está registrada'
              : null;
          _macValidationNetworkError = false;
        });
      }
    } catch (e) {
      // Fix 3.1: Distinguir tipos de error y proporcionar feedback útil
      if (mounted) {
        final errorMessage = e.toString().toLowerCase();
        final isTimeout = errorMessage.contains('timeout') ||
                         errorMessage.contains('timed out');
        final isNetwork = errorMessage.contains('network') ||
                         errorMessage.contains('connection') ||
                         errorMessage.contains('failed host lookup') ||
                         isTimeout;

        setState(() {
          _isMacValidating = false;
          _macValidationNetworkError = isNetwork;

          if (isNetwork) {
            _macValidationError = isTimeout
                ? 'Tiempo de espera agotado. Verifica tu conexión e intenta nuevamente.'
                : 'Error de conexión. No se pudo verificar la dirección MAC.';
          } else {
            // Otros errores (permisos, servidor, etc.)
            _macValidationError = 'No se pudo validar la dirección MAC. Intenta guardar el dispositivo.';
          }
        });
      }
    }
  }

  @override
  void dispose() {
    _macValidationTimer?.cancel();
    _nameController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    _serialNumberController.dispose();
    _macAddressController.dispose();
    _modelController.dispose();
    _autoCloseTimeoutController.dispose();
    _maxOpenTimeController.dispose();
    _pedestrianTimeoutController.dispose();
    _hardwareVersionController.dispose();
    _firmwareVersionController.dispose();
    _maintenanceNotesController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    // Limpiar errores anteriores del backend
    setState(() {
      _backendErrors = {};
    });

    if (!_formKey.currentState!.validate()) return;

    // Verificar si hay error de MAC duplicado
    if (_macValidationError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_macValidationError!),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final device = Device(
      id: widget.device?.id ?? 0,
      name: _nameController.text.trim(),
      location: _locationController.text.trim(),
      description: _descriptionController.text.trim().isNotEmpty ? _descriptionController.text.trim() : null,
      serialNumber: _serialNumberController.text.trim(),
      macAddress: _macAddressController.text.trim(),
      model: _modelController.text.trim(),
      status: _selectedStatus,
      deviceType: _selectedDeviceType,
      isConnected: widget.device?.isConnected ?? false,
      hardwareVersion: _hardwareVersionController.text.trim().isNotEmpty ? _hardwareVersionController.text.trim() : null,
      firmwareVersion: _firmwareVersionController.text.trim().isNotEmpty ? _firmwareVersionController.text.trim() : null,
      autoCloseTimeout: _parseIntOrNull(_autoCloseTimeoutController.text),
      maxOpenTime: _parseIntOrNull(_maxOpenTimeController.text),
      pedestrianTimeout: _parseIntOrNull(_pedestrianTimeoutController.text),
      securityLevel: int.tryParse(_selectedSecurityLevel),
      movementSpeed: _movementSpeed.round(),
      operatingHours: _formatOperatingHours(),
      emergencyMode: _emergencyMode,
      lampAutoOn: _lampAutoOn,
      maintenanceMode: _maintenanceMode,
      locked: _locked,
      installationDate: _installationDate,
      warrantyExpiry: _warrantyExpiry,
      scheduledMaintenance: _scheduledMaintenance,
      maintenanceNotes: _maintenanceNotesController.text.trim().isNotEmpty ? _maintenanceNotesController.text.trim() : null,
    );

    final isCreating = widget.device == null;
    if (isCreating) {
      await context.read<DeviceMutationCubit>().addDevice(device);
    } else {
      await context.read<DeviceMutationCubit>().updateDevice(widget.device!.id.toString(), device);
    }

    if (mounted) {
      final state = context.read<DeviceMutationCubit>().state;
      if (state is DeviceMutationSuccess) {
        // Fix 1.5: SnackBar verde con icono check_circle y diseño consistente
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(isCreating ? 'Dispositivo creado exitosamente' : 'Dispositivo actualizado exitosamente'),
                ),
              ],
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 3),
            action: SnackBarAction(
              label: 'Cerrar',
              textColor: Colors.white,
              onPressed: () {},
            ),
          ),
        );
        Navigator.of(context).pop(true);
      } else if (state is DeviceMutationError) {
        // Parsear errores de validación del backend
        final errorMessage = state.message;

        setState(() {
          _backendErrors = _parseBackendErrors(errorMessage);
        });

        // Si hay errores de validación, mostrar resumen y marcar campos
        if (_backendErrors.isNotEmpty) {
          String userMessage = 'Errores encontrados:\n';
          _backendErrors.forEach((field, message) {
            userMessage += '• $message\n';
          });

          // Fix 1.5: SnackBar rojo con icono error y diseño consistente
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.error, color: Colors.white),
                  const SizedBox(width: 8),
                  Expanded(child: Text(userMessage.trim())),
                ],
              ),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 5),
              action: SnackBarAction(
                label: 'Cerrar',
                textColor: Colors.white,
                onPressed: () {},
              ),
            ),
          );

          // Forzar revalidación visual para mostrar errores en rojo
          setState(() {
            _formKey.currentState!.validate();
          });
        } else {
          // Error general - mostrar mensaje traducido
          final translatedMessage = ErrorTranslatorService.translateCommandError(errorMessage);

          // Fix 1.5: SnackBar rojo con icono error y diseño consistente
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.error, color: Colors.white),
                  const SizedBox(width: 8),
                  Expanded(child: Text(translatedMessage)),
                ],
              ),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 5),
              action: SnackBarAction(
                label: 'Cerrar',
                textColor: Colors.white,
                onPressed: () {},
              ),
            ),
          );
        }
      }
    }
  }

  /// Limpiar error de backend para un campo específico
  void _clearBackendError(String fieldKey) {
    if (_backendErrors.containsKey(fieldKey)) {
      setState(() {
        _backendErrors.remove(fieldKey);
        // Fix 3.1: Limpiar también errores de validación MAC si es el campo MAC
        if (fieldKey == 'macAddress') {
          _macValidationError = null;
          _macValidationNetworkError = false;
        }
      });
    }
  }

  /// Validar formato de versión (X.Y.Z donde X, Y, Z son números)
  String? _validateVersion(String? value) {
    // Campo opcional, permitir vacío
    if (value == null || value.trim().isEmpty) {
      return null;
    }

    // Validar patrón de versión semántica: X.Y.Z
    final versionRegex = RegExp(r'^\d+\.\d+\.\d+$');
    if (!versionRegex.hasMatch(value.trim())) {
      return 'Formato de versión inválido. Use el formato X.Y.Z (ejemplo: 2.1.0)';
    }

    return null;
  }

  /// Parsear errores del backend y asignarlos a campos específicos
  Map<String, String> _parseBackendErrors(String errorMessage) {
    final Map<String, String> errors = {};

    // Mapeo de nombres de campos del backend a nombres de campos del formulario
    final fieldMapping = {
      'name': 'name',
      'serial_number': 'serialNumber',
      'mac_address': 'macAddress',
      'location': 'location',
      'model': 'model',
      'description': 'description',
      'device_type': 'deviceType',
    };

    // Extraer errores específicos del mensaje
    if (errorMessage.contains('mac_address') && errorMessage.contains('already exists')) {
      errors['macAddress'] = 'Dirección MAC ya está registrada';
      _macValidationError = 'Esta dirección MAC ya está registrada';
    }

    if (errorMessage.contains('serial_number') && errorMessage.contains('already exists')) {
      errors['serialNumber'] = 'Número de serie ya está registrado';
    }

    if (errorMessage.contains('name') && errorMessage.contains('required')) {
      errors['name'] = 'El nombre es requerido';
    }

    if (errorMessage.contains('serial_number') && errorMessage.contains('required')) {
      errors['serialNumber'] = 'El número de serie es requerido';
    }

    if (errorMessage.contains('mac_address') && errorMessage.contains('required')) {
      errors['macAddress'] = 'La dirección MAC es requerida';
    }

    if (errorMessage.contains('location') && errorMessage.contains('required')) {
      errors['location'] = 'La ubicación es requerida';
    }

    if (errorMessage.contains('model') && errorMessage.contains('required')) {
      errors['model'] = 'El modelo es requerido';
    }

    if (errorMessage.contains('mac_address') && errorMessage.contains('pattern')) {
      errors['macAddress'] = 'Formato de dirección MAC inválido';
    }

    if (errorMessage.contains('serial_number') && errorMessage.contains('pattern')) {
      errors['serialNumber'] = 'Formato de número de serie inválido';
    }

    if (errorMessage.contains('name') && (errorMessage.contains('too long') || errorMessage.contains('max_length'))) {
      errors['name'] = 'El nombre es demasiado largo (máx. 100 caracteres)';
    }

    if (errorMessage.contains('location') && (errorMessage.contains('too long') || errorMessage.contains('max_length'))) {
      errors['location'] = 'La ubicación es demasiado larga (máx. 200 caracteres)';
    }

    if (errorMessage.contains('description') && (errorMessage.contains('too long') || errorMessage.contains('max_length'))) {
      errors['description'] = 'La descripción es demasiado larga (máx. 500 caracteres)';
    }

    // Errores de patrón de versión (formato X.Y.Z)
    if (errorMessage.contains('firmware_version') && errorMessage.contains('pattern')) {
      errors['firmwareVersion'] = 'Formato de versión inválido. Use el formato X.Y.Z (ejemplo: 2.1.0)';
    }

    if (errorMessage.contains('hardware_version') && errorMessage.contains('pattern')) {
      errors['hardwareVersion'] = 'Formato de versión inválido. Use el formato X.Y.Z (ejemplo: 2.1.0)';
    }

    return errors;
  }

  int? _parseIntOrNull(String text) {
    if (text.trim().isEmpty) return null;
    return int.tryParse(text.trim());
  }

  TimeOfDay? _parseTimeOfDay(String time) {
    final parts = time.split(':');
    if (parts.length != 2) return null;
    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);
    if (hour == null || minute == null) return null;
    if (hour < 0 || hour > 23 || minute < 0 || minute > 59) return null;
    return TimeOfDay(hour: hour, minute: minute);
  }

  String _formatTimeOfDay(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  String? _formatOperatingHours() {
    if (_operatingHoursStart == null || _operatingHoursEnd == null) return null;
    return '${_formatTimeOfDay(_operatingHoursStart!)}-${_formatTimeOfDay(_operatingHoursEnd!)}';
  }

  Future<void> _showDeleteConfirmation() async {
    final device = widget.device;
    if (device == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: const [
            Icon(Icons.warning_amber_rounded, color: AppTheme.errorRed, size: 28),
            SizedBox(width: 12),
            Text('Confirmar eliminación', style: TextStyle(fontSize: 20)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '¿Está seguro que desea eliminar este dispositivo?',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.errorRed.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.device_hub, color: AppTheme.errorRed),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      device.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: AppTheme.errorRed,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Esta acción no se puede deshacer.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              'Cancelar',
              style: TextStyle(color: Colors.grey[700], fontSize: 16),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorRed,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Eliminar', style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await context.read<DeviceMutationCubit>().deleteDevice(
        device.id.toString(),
        device.name,
      );

      if (mounted) {
        final state = context.read<DeviceMutationCubit>().state;
        if (state is DeviceMutationSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppTheme.primaryPurple,
            ),
          );
          Navigator.of(context).pop('deleted'); // Retornar código especial para indicar eliminación
        } else if (state is DeviceMutationError) {
          // Si el dispositivo no existe (404), cerrar la pantalla y refrescar lista
          final isNotFound = state.message.contains('404') ||
                            state.message.contains('not found') ||
                            state.message.contains('no encontrado') ||
                            state.message.contains('DEVICE_NOT_FOUND');

          if (isNotFound) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Este dispositivo ya no existe. Se actualizará la lista.'),
                backgroundColor: Colors.orange,
              ),
            );
            Navigator.of(context).pop('deleted'); // Retornar código especial para indicar eliminación
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 10),
              ),
            );
          }
        }
      }
    }
  }

  /// Verifica si hay cambios no guardados comparando con _initialDevice (Fix 1.2)
  bool _hasUnsavedChanges() {
    // Si no hay dispositivo inicial (modo creación), verificar si hay datos ingresados
    if (_initialDevice == null) {
      return _nameController.text.trim().isNotEmpty ||
             _locationController.text.trim().isNotEmpty ||
             _descriptionController.text.trim().isNotEmpty ||
             _serialNumberController.text.trim().isNotEmpty ||
             _macAddressController.text.trim().isNotEmpty ||
             _modelController.text.trim().isNotEmpty;
    }

    // Modo edición: comparar valores actuales con valores iniciales
    return _nameController.text.trim() != _initialDevice!.name ||
           _locationController.text.trim() != (_initialDevice!.location ?? '') ||
           _descriptionController.text.trim() != (_initialDevice!.description ?? '') ||
           _serialNumberController.text.replaceAll(RegExp(r'[^A-Z0-9]'), '').toUpperCase() !=
               (_initialDevice!.serialNumber.replaceAll(RegExp(r'[^A-Z0-9]'), '').toUpperCase()) ||
           _macAddressController.text.trim() != _initialDevice!.macAddress ||
           _modelController.text.trim() != _initialDevice!.model ||
           _selectedStatus != _initialDevice!.status ||
           _selectedDeviceType != (_initialDevice!.deviceType ?? 'gate') ||
           _autoCloseTimeoutController.text.trim() != (_initialDevice!.autoCloseTimeout?.toString() ?? '') ||
           _maxOpenTimeController.text.trim() != (_initialDevice!.maxOpenTime?.toString() ?? '') ||
           _pedestrianTimeoutController.text.trim() != (_initialDevice!.pedestrianTimeout?.toString() ?? '') ||
           _selectedSecurityLevel != (_initialDevice!.securityLevel?.toString() ?? '3') ||
           _movementSpeed.round() != (_initialDevice!.movementSpeed ?? 5) ||
           _formatOperatingHours() != _initialDevice!.operatingHours ||
           _emergencyMode != (_initialDevice!.emergencyMode ?? false) ||
           _lampAutoOn != (_initialDevice!.lampAutoOn ?? false) ||
           _maintenanceMode != (_initialDevice!.maintenanceMode ?? false) ||
           _locked != (_initialDevice!.locked ?? false) ||
           _hardwareVersionController.text.trim() != (_initialDevice!.hardwareVersion ?? '') ||
           _firmwareVersionController.text.trim() != (_initialDevice!.firmwareVersion ?? '') ||
           _installationDate != _initialDevice!.installationDate ||
           _warrantyExpiry != _initialDevice!.warrantyExpiry ||
           _scheduledMaintenance != _initialDevice!.scheduledMaintenance ||
           _maintenanceNotesController.text.trim() != (_initialDevice!.maintenanceNotes ?? '');
  }

  /// Muestra diálogo de confirmación al intentar salir con cambios (Fix 1.2)
  Future<bool> _showExitConfirmationDialog() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: const [
            Icon(Icons.warning_amber_rounded, color: AppTheme.primaryPurple, size: 28),
            SizedBox(width: 12),
            Text('¿Descartar cambios?', style: TextStyle(fontSize: 20)),
          ],
        ),
        content: const Text(
          'Tienes cambios sin guardar. Si sales ahora, se perderán todos los cambios realizados.',
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              'Cancelar',
              style: TextStyle(color: Colors.grey[700], fontSize: 16),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryPurple,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Descartar', style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );

    return result ?? false; // Si se cierra sin elegir, retornar false (no salir)
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_hasUnsavedChanges()) {
          return await _showExitConfirmationDialog();
        }
        return true; // Permitir salir si no hay cambios
      },
      child: Scaffold(
      backgroundColor: AppTheme.bgGray,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: AppTheme.titleBlue,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.titleBlue),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          widget.device == null ? 'Crear Dispositivo' : 'Editar Dispositivo',
          style: const TextStyle(
            color: AppTheme.titleBlue,
            fontSize: 22,
            fontWeight: FontWeight.w600,
            fontFamily: 'Montserrat',
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SvgPicture.asset(
              'assets/images/IconoLogo_transparente.png',
              height: 40,
              width: 40,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildSection('Información Básica', [
              _buildTextField('Nombre', _nameController, Icons.devices,
                required: true, validator: DeviceValidator.validateName, backendErrorKey: 'name'),
              _buildAutocompleteField('Ubicación', _locationController, _locationOptions,
                icon: Icons.location_on, required: true, validator: DeviceValidator.validateLocation, backendErrorKey: 'location'),
              _buildTextField('Descripción (opcional)', _descriptionController, Icons.description,
                maxLines: 3, validator: DeviceValidator.validateDescription, backendErrorKey: 'description'),
              _buildDropdown('Estado', _selectedStatus, _statusOptions, (value) {
                if (value != null) {
                  setState(() => _selectedStatus = value);
                }
              }),
              _buildDropdown('Tipo de Dispositivo', _selectedDeviceType, _deviceTypeOptions, (value) {
                if (value != null) {
                  setState(() => _selectedDeviceType = value);
                }
              }),
            ]),
            _buildSection('Identificación', [
              _buildSerialNumberField(),
              _buildMacAddressField(),
              _buildDropdown(
                'Modelo',
                _modelController.text.isEmpty ? null : _modelController.text,
                _modelOptions.map((m) => {'label': m, 'value': m}).toList(),
                (value) {
                  if (value != null) {
                    setState(() => _modelController.text = value);
                  }
                },
                required: true,
                validator: DeviceValidator.validateModel,
                backendErrorKey: 'model',
              ),
            ]),
            _buildExpandableSection(
              'Configuración Operativa (Opcional)',
              'Parámetros avanzados de operación y seguridad',
              [
                _buildTextField('Auto-cierre (opcional)', _autoCloseTimeoutController, Icons.timer, keyboardType: TextInputType.number),
                _buildTextField('Tiempo máximo abierto (opcional)', _maxOpenTimeController, Icons.access_time, keyboardType: TextInputType.number),
                _buildTextField('Timeout peatonal (opcional)', _pedestrianTimeoutController, Icons.directions_walk, keyboardType: TextInputType.number),
                _buildDropdown('Nivel de Seguridad', _selectedSecurityLevel, _securityLevelOptions, (value) {
                  if (value != null) {
                    setState(() => _selectedSecurityLevel = value);
                  }
                }),
                _buildSlider('Velocidad de Movimiento', _movementSpeed, 1.0, 10.0, (value) {
                  setState(() => _movementSpeed = value);
                }),
                _buildTimeRangePicker('Horario de Operación', _operatingHoursStart, _operatingHoursEnd),
                _buildSwitchRow('Modo Emergencia', _emergencyMode, (value) => setState(() => _emergencyMode = value)),
                _buildSwitchRow('Lámpara Auto-On', _lampAutoOn, (value) => setState(() => _lampAutoOn = value)),
                _buildSwitchRow('Modo Mantenimiento', _maintenanceMode, (value) => setState(() => _maintenanceMode = value)),
                _buildSwitchRow('Bloqueado', _locked, (value) => setState(() => _locked = value)),
              ],
            ),
            _buildSection('Información Física', [
              _buildVersionField('Versión de Hardware (opcional)', _hardwareVersionController, Icons.memory,
                backendErrorKey: 'hardwareVersion',
                helpText: 'Versión del hardware físico del dispositivo.\n\nFormato: X.Y.Z (versionado semántico).\n\nEjemplo: 2.1.0\n\nDonde X es la versión mayor, Y es la versión menor, y Z es el parche.'),
              _buildVersionField('Versión de Firmware (opcional)', _firmwareVersionController, Icons.storage,
                backendErrorKey: 'firmwareVersion',
                helpText: 'Versión del software interno (firmware) del dispositivo.\n\nFormato: X.Y.Z (versionado semántico).\n\nEjemplo: 3.2.1\n\nMantenga el firmware actualizado para mejor seguridad y funcionalidad.'),
            ]),
            _buildSection('Mantenimiento', [
              _buildDateField('Fecha de Instalación (opcional)', _installationDate, (date) => setState(() => _installationDate = date)),
              _buildDateField('Vencimiento Garantía (opcional)', _warrantyExpiry, (date) => setState(() => _warrantyExpiry = date)),
              _buildDateField('Mantenimiento Programado (opcional)', _scheduledMaintenance, (date) => setState(() => _scheduledMaintenance = date)),
              _buildTextField('Notas de Mantenimiento (opcional)', _maintenanceNotesController, Icons.notes,
                maxLines: 4, validator: DeviceValidator.validateMaintenanceNotes),
            ]),
            const SizedBox(height: 80),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: BlocBuilder<DeviceMutationCubit, DeviceMutationState>(
            builder: (context, state) {
              final isLoading = state is DeviceMutationLoading;
              return Row(
                children: [
                  // Botón Eliminar (solo en modo edición)
                  if (widget.device != null) ...[
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: isLoading ? null : _showDeleteConfirmation,
                        icon: const Icon(Icons.delete, size: 20),
                        label: const Text(
                          'Eliminar',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.errorRed,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],
                  // Botón Solicitar Soporte (solo en modo edición)
                  if (widget.device != null) ...[
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: isLoading ? null : () {
                          Navigator.pushNamed(
                            context,
                            '/support-request-create',
                            arguments: widget.device,
                          );
                        },
                        icon: const Icon(Icons.support_agent, size: 20),
                        label: const Text(
                          'Soporte',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],
                  // Fix 1.5: Botón Cancelar explícito (OutlinedButton)
                  Expanded(
                    child: OutlinedButton.icon(
                      key: const Key('cancel_button'),
                      onPressed: isLoading ? null : () async {
                        if (_hasUnsavedChanges()) {
                          final shouldPop = await _showExitConfirmationDialog();
                          if (shouldPop && mounted) {
                            Navigator.of(context).pop();
                          }
                        } else {
                          Navigator.of(context).pop();
                        }
                      },
                      icon: const Icon(Icons.close),
                      label: const Text(
                        'Cancelar',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppTheme.primaryPurple,
                        side: const BorderSide(color: AppTheme.primaryPurple, width: 2),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Fix 1.5: Botón Guardar con loading state completo (BlocBuilder)
                  Expanded(
                    flex: 2,
                    child: ElevatedButton.icon(
                      key: const Key('save_button'),
                      onPressed: isLoading ? null : _handleSave,
                      icon: isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Icon(Icons.save, size: 20),
                      label: Text(
                        isLoading
                            ? 'Guardando...'
                            : (widget.device == null ? 'Crear Dispositivo' : 'Guardar Cambios'),
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryPurple,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
      ), // Cierre de WillPopScope (Fix 1.2)
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryPurple,
              ),
            ),
            const Divider(height: 24, color: AppTheme.primaryPurple),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildExpandableSection(String title, String subtitle, List<Widget> children, {bool initiallyExpanded = false}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        initiallyExpanded: initiallyExpanded,
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        childrenPadding: const EdgeInsets.all(16),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryPurple,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            subtitle,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[600],
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
        iconColor: AppTheme.primaryPurple,
        collapsedIconColor: AppTheme.primaryPurple,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          ),
        ],
      ),
    );
  }

  Widget _buildMacAddressField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: _macAddressController,
        inputFormatters: [MacAddressFormatter()],
        keyboardType: TextInputType.text,
        textCapitalization: TextCapitalization.characters,
        decoration: InputDecoration(
          labelText: 'Dirección MAC *',
          hintText: '00:11:22:33:44:55',
          prefixIcon: const Icon(Icons.router, color: AppTheme.primaryPurple),
          // Fix 3.1: Mostrar botón "Reintentar" en errores de red
          suffixIcon: _isMacValidating
              ? const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                )
              : _macValidationError != null && _macValidationNetworkError
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.error, color: Colors.orange, size: 20),
                        IconButton(
                          icon: const Icon(Icons.refresh, color: Colors.orange, size: 20),
                          tooltip: 'Reintentar validación',
                          onPressed: () {
                            final mac = _macAddressController.text.trim();
                            if (mac.isNotEmpty && DeviceValidator.validateMacAddress(mac) == null) {
                              _validateMacAddressUnique(mac);
                            }
                          },
                        ),
                      ],
                    )
                  : _macValidationError != null
                      ? const Icon(Icons.error, color: Colors.red)
                      : _macAddressController.text.length >= 17
                          ? Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.check_circle, color: Colors.green),
                                IconButton(
                                  icon: const Icon(Icons.help_outline, color: AppTheme.primaryPurple, size: 20),
                                  tooltip: 'La dirección MAC es un identificador único de hardware.\n\nFormato: 6 pares de dígitos hexadecimales (0-9, A-F) separados por dos puntos (:).\n\nEjemplo: 00:11:22:33:44:55\n\nEl sistema valida automáticamente que no exista duplicado.',
                                  onPressed: () {},
                                ),
                              ],
                            )
                          : IconButton(
                              icon: const Icon(Icons.help_outline, color: AppTheme.primaryPurple, size: 20),
                              tooltip: 'La dirección MAC es un identificador único de hardware.\n\nFormato: 6 pares de dígitos hexadecimales (0-9, A-F) separados por dos puntos (:).\n\nEjemplo: 00:11:22:33:44:55\n\nEl sistema valida automáticamente que no exista duplicado.',
                              onPressed: () {},
                            ),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: _macValidationError != null
                ? BorderSide(
                    color: _macValidationNetworkError ? Colors.orange : Colors.red,
                    width: 2,
                  )
                : BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: _macValidationError != null
                  ? (_macValidationNetworkError ? Colors.orange : Colors.red)
                  : AppTheme.primaryPurple,
              width: 2,
            ),
          ),
          errorText: _macValidationError,
          helperText: 'Formato automático. Ejemplo: 00:11:22:33:44:55',
          helperStyle: TextStyle(fontSize: 12, color: Colors.grey[700]),
        ),
        validator: (value) {
          final error = DeviceValidator.validateMacAddress(value);
          if (error != null) return error;
          if (_macValidationError != null && !_macValidationNetworkError) {
            return _macValidationError; // Solo bloquear si NO es error de red
          }
          return null;
        },
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    IconData icon, {
    bool required = false,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    String? backendErrorKey, // Nueva propiedad para identificar el campo en _backendErrors
  }) {
    // Verificar si hay error de backend para este campo
    final hasBackendError = backendErrorKey != null && _backendErrors.containsKey(backendErrorKey);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: required ? '$label *' : label,
          prefixIcon: Icon(icon, color: AppTheme.primaryPurple),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: hasBackendError
                ? const BorderSide(color: Colors.red, width: 2)
                : BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: hasBackendError ? Colors.red : AppTheme.primaryPurple,
              width: 2,
            ),
          ),
        ),
        validator: (value) {
          // Primero verificar si hay error de backend
          if (backendErrorKey != null && _backendErrors.containsKey(backendErrorKey)) {
            return _backendErrors[backendErrorKey];
          }
          // Luego usar el validador proporcionado o el default
          if (validator != null) return validator(value);
          if (required && (value == null || value.isEmpty)) {
            return 'Campo requerido';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildVersionField(
    String label,
    TextEditingController controller,
    IconData icon, {
    String? backendErrorKey,
    String? helpText,
  }) {
    final hasBackendError = backendErrorKey != null && _backendErrors.containsKey(backendErrorKey);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: AppTheme.primaryPurple),
          suffixIcon: helpText != null
              ? IconButton(
                  icon: const Icon(Icons.help_outline, color: AppTheme.primaryPurple, size: 20),
                  tooltip: helpText,
                  onPressed: () {},
                )
              : null,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: hasBackendError
                ? const BorderSide(color: Colors.red, width: 2)
                : BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: hasBackendError ? Colors.red : AppTheme.primaryPurple,
              width: 2,
            ),
          ),
          helperText: 'Formato: X.Y.Z (ejemplo: 2.1.0)',
          helperStyle: TextStyle(fontSize: 12, color: Colors.grey[700]),
        ),
        validator: (value) {
          if (backendErrorKey != null && _backendErrors.containsKey(backendErrorKey)) {
            return _backendErrors[backendErrorKey];
          }
          return _validateVersion(value);
        },
      ),
    );
  }

  Widget _buildAutocompleteField(
    String label,
    TextEditingController controller,
    List<String> options, {
    IconData icon = Icons.category,
    bool required = false,
    String? Function(String?)? validator,
    String? backendErrorKey, // Nueva propiedad para identificar el campo en _backendErrors
  }) {
    // Verificar si hay error de backend para este campo
    final hasBackendError = backendErrorKey != null && _backendErrors.containsKey(backendErrorKey);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Autocomplete<String>(
        initialValue: TextEditingValue(text: controller.text),
        optionsBuilder: (textEditingValue) {
          if (textEditingValue.text.isEmpty) {
            return options;
          }
          return options.where((option) =>
              option.toLowerCase().contains(textEditingValue.text.toLowerCase()));
        },
        onSelected: (selection) => controller.text = selection,
        fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) {
          textEditingController.text = controller.text;
          textEditingController.addListener(() {
            controller.text = textEditingController.text;
          });
          return TextFormField(
            controller: textEditingController,
            focusNode: focusNode,
            decoration: InputDecoration(
              labelText: required ? '$label *' : label,
              prefixIcon: Icon(icon, color: AppTheme.primaryPurple),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: hasBackendError
                    ? const BorderSide(color: Colors.red, width: 2)
                    : BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: hasBackendError ? Colors.red : AppTheme.primaryPurple,
                  width: 2,
                ),
              ),
            ),
            validator: (value) {
              // Primero verificar si hay error de backend
              if (backendErrorKey != null && _backendErrors.containsKey(backendErrorKey)) {
                return _backendErrors[backendErrorKey];
              }
              // Luego usar el validador proporcionado o el default
              if (validator != null) return validator(value);
              if (required && (value == null || value.isEmpty)) {
                return 'Campo requerido';
              }
              return null;
            },
          );
        },
      ),
    );
  }

  Widget _buildDropdown(
    String label,
    String? value,
    List<Map<String, String>> options,
    Function(String?) onChanged, {
    bool required = false,
    String? Function(String?)? validator,
    String? backendErrorKey,
  }) {
    // Verificar si hay error de backend para este campo
    final hasBackendError = backendErrorKey != null && _backendErrors.containsKey(backendErrorKey);

    // Fix: Validar que el value esté en las opciones, sino usar el primero o null
    final validValues = options.map((e) => e['value']).toList();
    final safeValue = (value != null && validValues.contains(value)) ? value : (options.isNotEmpty ? options[0]['value'] : null);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        key: backendErrorKey != null ? Key('${backendErrorKey}_dropdown') : null,
        value: safeValue,
        decoration: InputDecoration(
          labelText: required ? '$label *' : label,
          prefixIcon: const Icon(Icons.arrow_drop_down_circle, color: AppTheme.primaryPurple),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: hasBackendError
                ? const BorderSide(color: Colors.red, width: 2)
                : BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: hasBackendError ? Colors.red : AppTheme.primaryPurple,
              width: 2,
            ),
          ),
        ),
        items: options.map((option) {
          return DropdownMenuItem<String>(
            value: option['value'],
            child: Text(option['label']!),
          );
        }).toList(),
        onChanged: onChanged,
        validator: (value) {
          // Primero verificar si hay error de backend
          if (backendErrorKey != null && _backendErrors.containsKey(backendErrorKey)) {
            return _backendErrors[backendErrorKey];
          }
          // Luego usar el validador proporcionado o el default
          if (validator != null) return validator(value);
          if (required && (value == null || value.isEmpty)) {
            return 'Campo requerido';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildSwitchRow(String label, bool value, Function(bool) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 16),
            ),
            Switch(
              value: value,
              onChanged: onChanged,
              activeColor: AppTheme.primaryPurple,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateField(String label, DateTime? date, Function(DateTime?) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () async {
          final picked = await showDatePicker(
            context: context,
            initialDate: date ?? DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2100),
            builder: (context, child) {
              return Theme(
                data: Theme.of(context).copyWith(
                  colorScheme: const ColorScheme.light(primary: AppTheme.primaryPurple),
                ),
                child: child!,
              );
            },
          );
          if (picked != null) onChanged(picked);
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.calendar_today, color: AppTheme.primaryPurple),
                  const SizedBox(width: 12),
                  Text(
                    label,
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
              Text(
                date != null
                    ? '${date.day}/${date.month}/${date.year}'
                    : 'No establecido',
                style: TextStyle(
                  fontSize: 16,
                  color: date != null ? AppTheme.textDark : Colors.grey[700],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSerialNumberField() {
    final hasBackendError = _backendErrors.containsKey('serialNumber');

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: _serialNumberController,
        inputFormatters: [SerialNumberFormatter()],
        keyboardType: TextInputType.text,
        textCapitalization: TextCapitalization.characters,
        decoration: InputDecoration(
          labelText: 'Número de Serie *',
          hintText: 'VITA12345',
          prefixIcon: const Icon(Icons.qr_code, color: AppTheme.primaryPurple),
          suffixIcon: IconButton(
            icon: const Icon(Icons.help_outline, color: AppTheme.primaryPurple, size: 20),
            tooltip: 'El número de serie identifica de forma única el dispositivo.\n\nFormato: De 8 a 20 caracteres alfanuméricos (letras y números).\n\nEjemplo: VITA12345678\n\nSe convierte automáticamente a mayúsculas.',
            onPressed: () {},
          ),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: hasBackendError
                ? const BorderSide(color: Colors.red, width: 2)
                : BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: hasBackendError ? Colors.red : AppTheme.primaryPurple,
              width: 2,
            ),
          ),
          helperText: 'Formato: VITAXXXXX (8-20 caracteres alfanuméricos)',
          helperStyle: TextStyle(fontSize: 12, color: Colors.grey[700]),
        ),
        validator: (value) {
          // Primero verificar si hay error de backend
          if (_backendErrors.containsKey('serialNumber')) {
            return _backendErrors['serialNumber'];
          }
          // Luego usar el validador estándar
          return DeviceValidator.validateSerialNumber(value);
        },
      ),
    );
  }

  Widget _buildSlider(
    String label,
    double value,
    double min,
    double max,
    Function(double) onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.speed, color: AppTheme.primaryPurple),
                    const SizedBox(width: 12),
                    Text(
                      label,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryPurple.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    value.round().toString(),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryPurple,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  '${min.round()}',
                  style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                ),
                Expanded(
                  child: Slider(
                    value: value,
                    min: min,
                    max: max,
                    divisions: (max - min).round(),
                    activeColor: AppTheme.primaryPurple,
                    inactiveColor: AppTheme.primaryPurple.withOpacity(0.2),
                    onChanged: onChanged,
                  ),
                ),
                Text(
                  '${max.round()}',
                  style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Center(
              child: Text(
                value <= 3 ? 'Lento' : value <= 7 ? 'Medio' : 'Rápido',
                style: TextStyle(
                  fontSize: 12,
                  color: AppTheme.primaryPurple.withOpacity(0.7),
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeRangePicker(
    String label,
    TimeOfDay? startTime,
    TimeOfDay? endTime,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.schedule, color: AppTheme.primaryPurple),
                const SizedBox(width: 12),
                Text(
                  label,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      final picked = await showTimePicker(
                        context: context,
                        initialTime: startTime ?? const TimeOfDay(hour: 8, minute: 0),
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: const ColorScheme.light(primary: AppTheme.primaryPurple),
                            ),
                            child: child!,
                          );
                        },
                      );
                      if (picked != null) {
                        setState(() => _operatingHoursStart = picked);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryPurple.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.access_time, size: 20, color: AppTheme.primaryPurple),
                          const SizedBox(width: 8),
                          Text(
                            startTime != null
                                ? _formatTimeOfDay(startTime)
                                : 'Inicio',
                            style: TextStyle(
                              fontSize: 16,
                              color: startTime != null ? AppTheme.textDark : Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Icon(Icons.arrow_forward, color: AppTheme.primaryPurple),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      final picked = await showTimePicker(
                        context: context,
                        initialTime: endTime ?? const TimeOfDay(hour: 17, minute: 0),
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: const ColorScheme.light(primary: AppTheme.primaryPurple),
                            ),
                            child: child!,
                          );
                        },
                      );
                      if (picked != null) {
                        setState(() => _operatingHoursEnd = picked);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryPurple.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.access_time, size: 20, color: AppTheme.primaryPurple),
                          const SizedBox(width: 8),
                          Text(
                            endTime != null
                                ? _formatTimeOfDay(endTime)
                                : 'Fin',
                            style: TextStyle(
                              fontSize: 16,
                              color: endTime != null ? AppTheme.textDark : Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            if (startTime != null && endTime != null) ...[
              const SizedBox(height: 8),
              Center(
                child: Text(
                  'Horario: ${_formatTimeOfDay(startTime)} - ${_formatTimeOfDay(endTime)}',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.primaryPurple.withOpacity(0.7),
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

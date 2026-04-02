import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/device.dart';
import '../state/device_list_cubit.dart';
import '../state/device_list_state.dart';
import '../state/device_mutation_cubit.dart';
import '../state/device_command_cubit.dart';
import '../state/device_command_state.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../core/services/websocket_service.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/design_system/atoms/circular_command_button.dart';
import '../../../../core/design_system/molecules/device_control_toggle.dart';
import '../../../../core/design_system/molecules/device_action_toggle.dart';
import 'device_edit_screen.dart';

class DevicesScreen extends StatefulWidget {
  const DevicesScreen({super.key});

  @override
  State<DevicesScreen> createState() => _DevicesScreenState();
}

class _DevicesScreenState extends State<DevicesScreen> with TickerProviderStateMixin {
  // Controllers & State
  late TabController _tabController;
  bool _showFilters = false;
  Device? _selectedDevice;
  final TextEditingController _searchController = TextEditingController();
  BGniusWebSocketService? _wsService;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this); // Solo 2 tabs ahora
    _tabController.addListener(() {
      if (mounted) setState(() {});
    });
    context.read<DeviceListCubit>().loadDevices();
    _initializeWebSocket();
  }

  /// Inicializar conexión WebSocket y configurar callbacks
  void _initializeWebSocket() {
    _wsService = Provider.of<BGniusWebSocketService>(context, listen: false);
    final authService = Provider.of<AuthService>(context, listen: false);

    if (authService.isAuthenticated && authService.currentToken != null) {
      // Conectar WebSocket con token JWT
      _wsService?.connect(
        authService.currentToken!,
        globalNotifications: true, // Recibir notificaciones de todos los dispositivos
      );

      // Configurar callback para respuestas de comandos
      _wsService?.onDeviceCommandResult = (String message, bool isSuccess) {
        _showCommandFeedback(message, isSuccess);
      };

      // Configurar callback para actualización de estado de dispositivos
      _wsService?.onDeviceStateUpdate = (int deviceId, String state, Map<String, dynamic> telemetry) {
        _updateDeviceState(deviceId, state, telemetry);
      };

      print('✅ WebSocket inicializado con callbacks en DevicesScreen');
    } else {
      print('⚠️ No se puede inicializar WebSocket: usuario no autenticado');
    }
  }

  /// Mostrar feedback visual de comando ejecutado
  void _showCommandFeedback(String message, bool isSuccess) {
    print('🔔 _showCommandFeedback llamado:');
    print('   Message: $message');
    print('   Success: $isSuccess');
    print('   Mounted: $mounted');

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isSuccess ? Icons.check_circle : Icons.error,
              color: Colors.white,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: isSuccess ? Colors.green : Colors.red,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Actualizar estado del dispositivo cuando llega notificación
  void _updateDeviceState(int deviceId, String state, Map<String, dynamic> telemetry) {
    print('🔄 Actualizando dispositivo $deviceId: Estado=$state');
    print('   Telemetría: ${telemetry.toString()}');

    // Recargar la lista de dispositivos para reflejar los cambios
    if (mounted) {
      context.read<DeviceListCubit>().loadDevices();
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    // Limpiar callbacks del WebSocket
    _wsService?.onDeviceCommandResult = null;
    _wsService?.onDeviceStateUpdate = null;
    super.dispose();
  }

  // Add Device Dialog
  Future<void> _showAddDeviceDialog() async {
    final nameController = TextEditingController();
    final serialController = TextEditingController();
    final macAddressController = TextEditingController();
    final locationController = TextEditingController();
    final modelController = TextEditingController(text: 'FAC 500 VITA');
    final formKey = GlobalKey<FormState>();

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text(
          'Agregar Nuevo Dispositivo',
          style: TextStyle(
            color: AppTheme.primaryGreen,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Nombre del dispositivo',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  validator: (v) => v?.isEmpty == true ? 'Requerido' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: serialController,
                  decoration: InputDecoration(
                    labelText: 'Número de serie',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  validator: (v) => v?.isEmpty == true ? 'Requerido' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: macAddressController,
                  decoration: InputDecoration(
                    labelText: 'Dirección MAC',
                    hintText: 'XX:XX:XX:XX:XX:XX',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  validator: (v) => v?.isEmpty == true ? 'Requerido' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: locationController,
                  decoration: InputDecoration(
                    labelText: 'Ubicación',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  validator: (v) => v?.isEmpty == true ? 'Requerido' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: modelController,
                  decoration: InputDecoration(
                    labelText: 'Modelo',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  validator: (v) => v?.isEmpty == true ? 'Requerido' : null,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          BlocBuilder<DeviceMutationCubit, DeviceMutationState>(
            builder: (context, state) => ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryGreen,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: state is DeviceMutationLoading
                  ? null
                  : () async {
                      if (formKey.currentState!.validate()) {
                        final device = Device(
                          id: 0,
                          name: nameController.text,
                          model: modelController.text,
                          serialNumber: serialController.text,
                          macAddress: macAddressController.text,
                          status: 'offline',
                          isConnected: false,
                          location: locationController.text,
                        );
                        await context.read<DeviceMutationCubit>().addDevice(device);
                        if (mounted) {
                          Navigator.of(context).pop();
                          context.read<DeviceListCubit>().refresh();
                        }
                      }
                    },
              child: state is DeviceMutationLoading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text('Agregar'),
            ),
          ),
        ],
      ),
    );
  }

  // Navigate to Edit Device Screen
  Future<void> _showEditDeviceDialog(Device device) async {
    final mutationCubit = context.read<DeviceMutationCubit>();
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BlocProvider.value(
          value: mutationCubit,
          child: DeviceEditScreen(device: device),
        ),
      ),
    );

    // Si se eliminó el dispositivo, volver a la lista
    if (result == 'deleted' && mounted) {
      setState(() => _selectedDevice = null);
      context.read<DeviceListCubit>().refresh();
    }
    // Refresh device list if changes were saved
    else if (result == true && mounted) {
      context.read<DeviceListCubit>().refresh();
    }
  }

  // Delete Device Dialog
  Future<void> _showDeleteDeviceDialog(Device device) async {
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Dispositivo'),
        content: Text('¿Está seguro de eliminar "${device.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              await context.read<DeviceMutationCubit>().deleteDevice(device.id.toString(), device.name);
              if (mounted) {
                Navigator.of(context).pop();
                context.read<DeviceListCubit>().refresh();
              }
            },
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DeviceMutationCubit, DeviceMutationState>(
      listener: (context, state) {
        print('🎧 BlocListener - DeviceMutationCubit state changed: ${state.runtimeType}');
        // Refrescar lista automáticamente después de crear, actualizar o eliminar un dispositivo
        if (state is DeviceMutationSuccess) {
          print('🔄 BlocListener - DeviceMutationSuccess detectado, refrescando lista...');
          context.read<DeviceListCubit>().refresh();
        }
      },
      child: Column(
        children: [
          _buildTabBar(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildDevicesTab(),
                _buildOthersTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Column(
      children: [
        Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            children: [
              // Tab Dispositivos (redondeado con gap)
              Expanded(
                child: GestureDetector(
                  onTap: () => _tabController.animateTo(0),
                  child: Container(
                    margin: const EdgeInsets.only(right: 4),
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                    decoration: BoxDecoration(
                      color: _tabController.index == 0 ? AppTheme.primaryPurple : Colors.grey.shade300,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Text(
                      'Dispositivos',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: _tabController.index == 0 ? Colors.white : Colors.black54,
                      ),
                    ),
                  ),
                ),
              ),
              // Tab Otros (redondeado con gap)
              Expanded(
                child: GestureDetector(
                  onTap: () => _tabController.animateTo(1),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                    decoration: BoxDecoration(
                      color: _tabController.index == 1 ? AppTheme.primaryPurple : Colors.grey.shade300,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Text(
                      'Otros',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: _tabController.index == 1 ? Colors.white : Colors.black54,
                      ),
                    ),
                  ),
                ),
              ),
              // Botón + (redondeado con gap)
              Expanded(
                child: GestureDetector(
                  onTap: () async {
                    final mutationCubit = context.read<DeviceMutationCubit>();
                    final result = await Navigator.of(context).push<bool>(
                      MaterialPageRoute(
                        builder: (context) => BlocProvider.value(
                          value: mutationCubit,
                          child: const DeviceEditScreen(device: null),
                        ),
                      ),
                    );
                    if (result == true && mounted) {
                      context.read<DeviceListCubit>().refresh();
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.only(left: 4),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: const Icon(
                      Icons.add,
                      size: 26,
                      color: Colors.black54,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        // Línea morada debajo (full width)
        Container(
          height: 3,
          decoration: const BoxDecoration(
            color: AppTheme.primaryPurple,
          ),
        ),
      ],
    );
  }

  Widget _buildDevicesTab() {
    return BlocListener<DeviceListCubit, DeviceListState>(
      listener: (context, state) {
        // Auto-seleccionar primer dispositivo cuando se carga la lista
        if (state is DeviceListLoaded && state.devices.isNotEmpty) {
          if (_selectedDevice == null) {
            // Si no hay dispositivo seleccionado, seleccionar el primero
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                setState(() => _selectedDevice = state.devices.first);
              }
            });
          } else {
            // Si hay dispositivo seleccionado, actualizarlo con la nueva data
            final updatedDevice = state.devices.firstWhere(
              (d) => d.id == _selectedDevice!.id,
              orElse: () => state.devices.first,
            );
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                setState(() => _selectedDevice = updatedDevice);
              }
            });
          }
        }
      },
      child: BlocBuilder<DeviceListCubit, DeviceListState>(
        builder: (context, state) {
          if (state is DeviceListLoading) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Cargando dispositivos...'),
              ],
            ),
          );
        }

        if (state is DeviceListError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  state.message,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () => context.read<DeviceListCubit>().refresh(),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reintentar'),
                ),
              ],
            ),
          );
        }

        if (state is DeviceListLoaded) {
          if (state.devices.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.devices, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text(
                    'No hay dispositivos',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Los dispositivos aparecerán aquí cuando se conecten',
                    style: TextStyle(color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => context.read<DeviceListCubit>().refresh(),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Actualizar'),
                  ),
                ],
              ),
            );
          }

          final filteredDevices = _filterDevices(state.devices);

          return RefreshIndicator(
            onRefresh: () async {
              await context.read<DeviceListCubit>().refresh();
            },
            color: AppTheme.primaryPurple,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isWideScreen = constraints.maxWidth >= 768;

                // En pantallas pequeñas: mostrar solo lista O solo detalle
                if (!isWideScreen) {
                  // Si hay dispositivo seleccionado, mostrar solo detalle
                  if (_selectedDevice != null) {
                    return Column(
                      children: [
                        // Botón volver a lista
                        Container(
                          padding: const EdgeInsets.all(8),
                          color: AppTheme.bgGray,
                          child: Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.arrow_back, color: AppTheme.primaryPurple),
                                onPressed: () => setState(() => _selectedDevice = null),
                              ),
                              const Text(
                                'Volver a lista',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.primaryPurple,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(child: _buildDeviceInfoPanel(_selectedDevice!)),
                      ],
                    );
                  }
                  // Si no hay selección, mostrar solo lista
                  return Column(
                    children: [
                      if (_showFilters) _buildSearchBar(),
                      Expanded(
                        child: Scrollbar(
                          thumbVisibility: true,
                          child: ListView.builder(
                            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                            itemCount: filteredDevices.length,
                            itemBuilder: (context, index) {
                              final device = filteredDevices[index];
                              final isSelected = _selectedDevice?.id == device.id;
                              return _buildDeviceListItem(device, index, isSelected);
                            },
                          ),
                        ),
                      ),
                    ],
                  );
                }

                // Pantallas grandes: layout de 2 columnas
                return Row(
                  children: [
                    // Lista de dispositivos - 45%
                    Expanded(
                      flex: 45,
                      child: Column(
                        children: [
                          if (_showFilters) _buildSearchBar(),
                          Expanded(
                            child: Container(
                              decoration: const BoxDecoration(
                                border: Border(right: BorderSide(color: Color(0xFFE0E0E0), width: 1)),
                              ),
                              child: Scrollbar(
                                thumbVisibility: true,
                                child: ListView.builder(
                                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                                  itemCount: filteredDevices.length,
                                  itemBuilder: (context, index) {
                                    final device = filteredDevices[index];
                                    final isSelected = _selectedDevice?.id == device.id;
                                    return _buildDeviceListItem(device, index, isSelected);
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Panel de detalles - 55%
                    Expanded(
                      flex: 55,
                      child: _selectedDevice != null
                          ? _buildDeviceInfoPanel(_selectedDevice!)
                          : Center(
                              child: Text(
                                'Selecciona un dispositivo',
                                style: TextStyle(
                                  color: AppTheme.secondaryBlue,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                    ),
                  ],
                );
              },
            ),
          );
        }

        return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Buscar dispositivos...',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onChanged: (_) => setState(() {}),
      ),
    );
  }

  List<Device> _filterDevices(List<Device> devices) {
    final query = _searchController.text.toLowerCase();
    if (query.isEmpty) return devices;
    return devices.where((d) =>
        d.name.toLowerCase().contains(query) ||
        d.macAddress.toLowerCase().contains(query) ||
        d.model.toLowerCase().contains(query)).toList();
  }

  Widget _buildDeviceListItem(Device device, int index, bool isSelected) {
    // Patrón zebra según diseño: gris claro / gris oscuro
    final backgroundColor = index % 2 == 0
        ? AppTheme.deviceLightGray  // Gris claro (#E8E8E8)
        : Colors.white;              // Blanco alternado

    return GestureDetector(
      onTap: () => setState(() => _selectedDevice = device),
      onDoubleTap: () => _showDeviceOptions(device),
      onLongPress: () => _showDeviceOptions(device),
      child: Container(
        height: 60,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          children: [
            Expanded(
              child: Text(
                device.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),
            // Logo BGnius solo si el dispositivo está seleccionado
            if (isSelected)
              SvgPicture.asset(
                'assets/images/IconoLogo_transparente.png',
                height: 40,
                width: 40,
                fit: BoxFit.contain,
              ),
          ],
        ),
      ),
    );
  }

  void _showDeviceOptions(Device device) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit, color: AppTheme.secondaryPurple),
              title: const Text('Editar Dispositivo'),
              onTap: () {
                Navigator.pop(context);
                _showEditDeviceDialog(device);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Eliminar Dispositivo'),
              onTap: () {
                Navigator.pop(context);
                _showDeleteDeviceDialog(device);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeviceInfoPanel(Device device) {
    return Column(
      children: [
        // Header con fondo gris - 2 columnas
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(color: Color(0xFFF0F0F0)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Columna izquierda: Nombre, Ubicación, Tipo, MAC
              Expanded(
                flex: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      device.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow('Ubicación', device.location ?? 'No especificada'),
                    _buildInfoRow('Tipo', _translateDeviceType(device.deviceType)),
                    _buildInfoRow('MAC', device.macAddress),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              // Columna derecha: Estado, Batería, Botón Editar
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Estado (conectado/desconectado)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: device.isConnected ? Colors.green.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: device.isConnected ? Colors.green : Colors.grey,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: device.isConnected ? Colors.green : Colors.grey,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            device.isConnected ? 'Conectado' : 'Desconectado',
                            style: TextStyle(
                              fontSize: 13,
                              color: device.isConnected ? Colors.green.shade700 : Colors.grey.shade700,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Batería (si existe)
                    if (device.batteryLevel != null)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryPurple.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.battery_std, size: 18, color: AppTheme.primaryPurple),
                            const SizedBox(width: 6),
                            Text(
                              '${device.batteryLevel}%',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.primaryPurple,
                              ),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 12),
                    // Botón Editar
                    InkWell(
                      onTap: () => _showEditDeviceDialog(device),
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppTheme.secondaryPurple.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: AppTheme.secondaryPurple.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.edit_outlined,
                              size: 16,
                              color: AppTheme.secondaryPurple,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Editar',
                              style: TextStyle(
                                color: AppTheme.secondaryPurple,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // Contenido scrollable
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Controles VITA', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                _buildVitaControls(device),
                // DESACTIVADO: Controles Secundarios (Lámpara, Relé, Bloquear, Mantener Abierto)
                // const Divider(height: 32),
                // const Text('Controles Secundarios', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                // const SizedBox(height: 16),
                // _buildSecondaryControls(device),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  /// Traduce el tipo de dispositivo de inglés a español
  String _translateDeviceType(String? deviceType) {
    if (deviceType == null) return 'VITA';

    final translations = {
      'gate': 'Portón',
      'barrier': 'Barrera',
      'door': 'Puerta',
      'turnstile': 'Torniquete',
    };

    return translations[deviceType.toLowerCase()] ?? deviceType;
  }

  Widget _buildVitaControls(Device device) {
    return BlocBuilder<DeviceCommandCubit, DeviceCommandState>(
      builder: (context, state) {
        final isLoading = state is DeviceCommandSending;
        return Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppTheme.controlPanelGray,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNewCircularButton(
                icon: Icons.lock_open_rounded,
                label: 'Abrir',
                color: AppTheme.primaryGreen,
                device: device,
                command: 'OPEN',
                isLoading: isLoading,
              ),
              _buildNewCircularButton(
                icon: Icons.pause_rounded,
                label: 'Pausa',
                color: Colors.grey.shade600,
                device: device,
                command: 'PAUSE',
                isLoading: isLoading,
              ),
              _buildNewCircularButton(
                icon: Icons.lock_rounded,
                label: 'Cerrar',
                color: Colors.orange.shade600,
                device: device,
                command: 'CLOSE',
                isLoading: isLoading,
              ),
              _buildNewCircularButton(
                icon: Icons.directions_walk_rounded,
                label: 'Peatonal',
                color: AppTheme.buttonCyan,
                device: device,
                command: 'PEDESTRIAN',
                isLoading: isLoading,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSecondaryControls(Device device) {
    // DEBUG: Imprimir estado de conexión
    print('🔍 DEBUG Device ${device.name}:');
    print('   - isConnected: ${device.isConnected}');
    print('   - status: ${device.status}');

    return BlocBuilder<DeviceCommandCubit, DeviceCommandState>(
      builder: (context, state) {
        final isLoading = state is DeviceCommandSending;
        final isEnabled = !isLoading && device.isConnected;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ========== SECCIÓN 1: CONTROLES DE ESTADO (ON/OFF) ==========
            const Text(
              'Controles de Estado',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppTheme.secondaryBlue,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                // Lámpara
                Expanded(
                  child: DeviceControlToggle(
                    icon: Icons.wb_incandescent_rounded,
                    label: 'Lámpara',
                    isOn: device.lampEnabled ?? false,
                    isEnabled: isEnabled,
                    onToggle: (isOn) => _sendDeviceCommand(
                      device,
                      isOn ? 'LAMP_ON' : 'LAMP_OFF',
                      'Lámpara ${isOn ? "encendida" : "apagada"}',
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Relé
                Expanded(
                  child: DeviceControlToggle(
                    icon: Icons.electrical_services_rounded,
                    label: 'Relé',
                    isOn: device.relayEnabled ?? false,
                    isEnabled: isEnabled,
                    onToggle: (isOn) => _sendDeviceCommand(
                      device,
                      isOn ? 'RELAY_ON' : 'RELAY_OFF',
                      'Relé ${isOn ? "activado" : "desactivado"}',
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),
            const Divider(height: 1),
            const SizedBox(height: 16),

            // ========== SECCIÓN 2: ACCIONES COMPACTAS (TOGGLES) ==========
            const Text(
              'Controles Auxiliares',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppTheme.secondaryBlue,
              ),
            ),
            const SizedBox(height: 10),

            // Bloquear
            DeviceActionToggle(
              label: 'Bloquear',
              icon: Icons.lock_rounded,
              value: device.isBlocked ?? false,
              isEnabled: isEnabled,
              activeColor: AppTheme.errorRed,
              onChanged: (value) => _sendDeviceCommand(
                device,
                value ? 'BLOCK' : 'UNBLOCK',
                value ? 'Dispositivo bloqueado' : 'Dispositivo desbloqueado',
              ),
            ),
            const SizedBox(height: 8),

            // Mantener Abierto
            DeviceActionToggle(
              label: 'Mantener Abierto',
              icon: Icons.timer_outlined,
              value: device.keepOpenEnabled ?? false,
              isEnabled: isEnabled,
              activeColor: AppTheme.primaryPurple,
              onChanged: (value) => _sendDeviceCommand(
                device,
                value ? 'KEEP_OPEN' : 'CLOSE',
                value
                    ? 'Modo mantener abierto activado'
                    : 'Dispositivo cerrado (hold liberado)',
              ),
            ),

            const SizedBox(height: 16),
            const Divider(height: 1),
            const SizedBox(height: 16),

            // ========== SECCIÓN 3: ACCIONES CRÍTICAS (BOTONES) ==========
            const Text(
              'Acciones Críticas',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppTheme.errorRed,
              ),
            ),
            const SizedBox(height: 10),

            // Parada de Emergencia
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: isEnabled
                    ? () => _sendDeviceCommand(
                          device,
                          'EMERGENCY_STOP',
                          'Parada de emergencia activada',
                        )
                    : null,
                icon: const Icon(Icons.warning_rounded, size: 18),
                label: const Text(
                  'PARADA DE EMERGENCIA',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.errorRed,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 2,
                  disabledBackgroundColor: Colors.grey.shade300,
                ),
              ),
            ),
            const SizedBox(height: 8),

            // Resetear
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: isEnabled
                    ? () => _sendDeviceCommand(
                          device,
                          'RESET',
                          'Dispositivo reseteado',
                        )
                    : null,
                icon: const Icon(Icons.restart_alt_rounded, size: 18),
                label: const Text(
                  'Resetear Dispositivo',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.secondaryBlue,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  side: const BorderSide(
                    color: AppTheme.secondaryBlue,
                    width: 1.5,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // Helper method para enviar comandos y mostrar feedback
  Future<void> _sendDeviceCommand(
    Device device,
    String command,
    String successMessage,
  ) async {
    await context.read<DeviceCommandCubit>().sendCommand(
          device.id.toString(),
          command,
        );

    if (mounted) {
      final state = context.read<DeviceCommandCubit>().state;
      if (state is DeviceCommandSuccess) {
        // Mostrar mensaje de éxito
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(successMessage),
            backgroundColor: AppTheme.primaryGreen,
            duration: const Duration(seconds: 2),
          ),
        );

        // IMPORTANTE: Refrescar inmediatamente para actualizar el estado de los toggles
        await context.read<DeviceListCubit>().refresh();

        // Esperar a que se complete el refresh y actualizar el dispositivo seleccionado
        await Future.delayed(const Duration(milliseconds: 100));

        if (mounted && _selectedDevice != null) {
          final updatedDevices = context.read<DeviceListCubit>().state;
          if (updatedDevices is DeviceListLoaded) {
            final updatedDevice = updatedDevices.devices.firstWhere(
              (d) => d.id == _selectedDevice!.id,
              orElse: () => _selectedDevice!,
            );
            if (mounted) {
              setState(() => _selectedDevice = updatedDevice);
            }
          }
        }

        // Implementar auto-refresh según backend spec
        // Polling cada auto_refresh_interval (1000ms) durante estimated_duration
        final autoRefreshInterval = state.autoRefreshInterval ?? 1000;
        final estimatedDuration = state.estimatedDuration ?? 0;

        if (estimatedDuration > 0) {
          final endTime = DateTime.now().add(Duration(seconds: estimatedDuration));

          // Polling timer
          Future.doWhile(() async {
            if (!mounted) return false;

            // Verificar si ya pasó el tiempo estimado
            if (DateTime.now().isAfter(endTime)) return false;

            // Esperar intervalo de refresh
            await Future.delayed(Duration(milliseconds: autoRefreshInterval));

            if (!mounted) return false;

            // Refrescar estado del dispositivo
            await context.read<DeviceListCubit>().refresh();

            // Actualizar dispositivo seleccionado
            if (_selectedDevice != null) {
              final updatedDevices = context.read<DeviceListCubit>().state;
              if (updatedDevices is DeviceListLoaded) {
                final updatedDevice = updatedDevices.devices.firstWhere(
                  (d) => d.id == _selectedDevice!.id,
                  orElse: () => _selectedDevice!,
                );
                setState(() => _selectedDevice = updatedDevice);
              }
            }

            // Continuar polling
            return true;
          });
        }
      } else if (state is DeviceCommandError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(state.error),
            backgroundColor: AppTheme.errorRed,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  // Botón circular principal estilo BGnius VITA
  Widget _buildNewCircularButton({
    required IconData icon,
    required String label,
    required Color color,
    required Device device,
    required String command,
    required bool isLoading,
  }) {
    return CircularCommandButton(
      icon: icon,
      label: label,
      color: color,
      isEnabled: !isLoading && device.isConnected,
      onPressed: () async {
        await context.read<DeviceCommandCubit>().sendCommand(device.id.toString(), command);
        if (mounted) {
          final state = context.read<DeviceCommandCubit>().state;
          if (state is DeviceCommandSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Comando $label ejecutado'),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 2),
              ),
            );
          } else if (state is DeviceCommandError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 3),
              ),
            );
          }
        }
      },
    );
  }

  Widget _buildOthersTab() {
    return const Center(child: Text('Otros - Próximamente'));
  }

  Widget _buildAddTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.add_circle_outline, size: 64, color: AppTheme.primaryGreen),
          const SizedBox(height: 16),
          const Text('Agregar Nuevo Dispositivo', style: TextStyle(fontSize: 18)),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _showAddDeviceDialog,
            icon: const Icon(Icons.add),
            label: const Text('Agregar Dispositivo'),
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryGreen),
          ),
        ],
      ),
    );
  }

}

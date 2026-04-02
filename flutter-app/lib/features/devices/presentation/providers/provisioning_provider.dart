import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/repositories/provisioning_repository.dart';
import '../../data/repositories/mock_provisioning_repository.dart';

// Repositorio Provider - Usamos Mock por ahora
final provisioningRepositoryProvider = Provider<ProvisioningRepository>((ref) {
  return MockProvisioningRepository();
});

// Estados posibles del flujo BLE
enum BleProvisioningStatus {
  initial,        // Estado inicial
  scanning,       // Escaneando dispositivos BLE
  devicesFound,   // Dispositivos encontrados
  connecting,     // Conectando a dispositivo seleccionado
  connected,      // Conectado y leyendo información
  configuring,    // Enviando configuración
  success,        // Proceso completado exitosamente
  error,          // Error en cualquier paso
}

// Estado inmutable para el flujo BLE
class BleProvisioningState {
  final BleProvisioningStatus status;
  final List<BleDeviceInfo> foundDevices;
  final BleDeviceInfo? selectedDevice;
  final DeviceDetails? deviceDetails;
  final DeviceConfiguration? pendingConfig;
  final String? errorMessage;
  final int currentStep; // 0-4 para los 5 pasos del flujo

  const BleProvisioningState({
    this.status = BleProvisioningStatus.initial,
    this.foundDevices = const [],
    this.selectedDevice,
    this.deviceDetails,
    this.pendingConfig,
    this.errorMessage,
    this.currentStep = 0,
  });

  BleProvisioningState copyWith({
    BleProvisioningStatus? status,
    List<BleDeviceInfo>? foundDevices,
    BleDeviceInfo? selectedDevice,
    DeviceDetails? deviceDetails,
    DeviceConfiguration? pendingConfig,
    String? errorMessage,
    int? currentStep,
  }) {
    return BleProvisioningState(
      status: status ?? this.status,
      foundDevices: foundDevices ?? this.foundDevices,
      selectedDevice: selectedDevice ?? this.selectedDevice,
      deviceDetails: deviceDetails ?? this.deviceDetails,
      pendingConfig: pendingConfig ?? this.pendingConfig,
      errorMessage: errorMessage, // Nullable reset
      currentStep: currentStep ?? this.currentStep,
    );
  }
}

// Notifier para manejo del flujo BLE
class BleProvisioningNotifier extends StateNotifier<BleProvisioningState> {
  final ProvisioningRepository _repository;

  BleProvisioningNotifier(this._repository) : super(const BleProvisioningState());

  // Paso 1: Iniciar escaneo de dispositivos BLE
  void startScan() {
    state = state.copyWith(
      status: BleProvisioningStatus.scanning,
      currentStep: 0,
      errorMessage: null,
    );
    
    _repository.scanBLE().listen(
      (devices) {
        if (devices.isNotEmpty) {
          state = state.copyWith(
            status: BleProvisioningStatus.devicesFound,
            foundDevices: devices,
            currentStep: 1,
          );
        }
      },
      onError: (e) {
        state = state.copyWith(
          status: BleProvisioningStatus.error,
          errorMessage: e.toString(),
        );
      },
    );
  }

  // Paso 2: Conectar a dispositivo seleccionado
  Future<void> connectToDevice(BleDeviceInfo device) async {
    state = state.copyWith(
      status: BleProvisioningStatus.connecting,
      selectedDevice: device,
      currentStep: 1,
    );

    try {
      await _repository.connectBLE(device.id);
      
      // Paso 3: Leer información del dispositivo
      state = state.copyWith(
        status: BleProvisioningStatus.connected,
        currentStep: 2,
      );
      
      final deviceInfo = await _repository.readDeviceInfo(device.id);
      state = state.copyWith(
        deviceDetails: deviceInfo,
        currentStep: 3,
      );
    } catch (e) {
      state = state.copyWith(
        status: BleProvisioningStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  // Paso 4: Configurar dispositivo
  Future<void> configureDevice(DeviceConfiguration config) async {
    if (state.selectedDevice == null) return;
    
    state = state.copyWith(
      status: BleProvisioningStatus.configuring,
      pendingConfig: config,
      currentStep: 4,
    );

    try {
      await _repository.configureDevice(state.selectedDevice!.id, config);
      
      // Paso 5: Éxito
      state = state.copyWith(
        status: BleProvisioningStatus.success,
        currentStep: 4,
      );
    } catch (e) {
      state = state.copyWith(
        status: BleProvisioningStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  // Desconectar y reset
  Future<void> disconnect() async {
    await _repository.disconnect();
    state = const BleProvisioningState();
  }

  // Reset completo del flujo
  void reset() {
    state = const BleProvisioningState();
  }

  // Ir a paso específico (para navegación en stepper)
  void goToStep(int step) {
    state = state.copyWith(currentStep: step);
  }
}

// Provider Global
final bleProvisioningProvider = StateNotifierProvider<BleProvisioningNotifier, BleProvisioningState>((ref) {
  final repo = ref.watch(provisioningRepositoryProvider);
  return BleProvisioningNotifier(repo);
});

import 'package:bgnius_vita/features/devices/domain/entities/device_info.dart';
import 'package:bgnius_vita/features/devices/domain/repositories/device_repository.dart';
import 'package:bgnius_vita/features/devices/presentation/providers/device_info_provider.dart';
import 'package:bgnius_vita/features/devices/presentation/screens/f_device_edit_screen.dart';
import 'package:bgnius_vita/shared/widgets/custom_text_field.dart';
import 'package:bgnius_vita/shared/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

// Manual Mock
class MockDeviceRepository implements DeviceRepository {
  bool updateDeviceCalled = false;
  DeviceInfo? updatedDevice;

  @override
  Future<void> createDevice(Map<String, dynamic> deviceData) async {}

  @override
  Future<DeviceInfo> getDeviceInfo(String id) async {
    return DeviceInfo(
      id: id,
      name: 'Original Name', // required
      serialNumber: '999999i', // required - using 'i' to test validator
      macAddress: 'AA:BB:CC:DD:EE:FF', // required
      model: 'FAC 500-900 VITA', // required
      groupName: 'Entrada Principal', // required
      description: 'Original Desc', // required
      status: 'Conectado', // required
      activationDate: DateTime.now(), // required
      version: '1.0', // required
      fullVersion: '1.0.0', // required
      totalCycles: 100, // required
      maintenanceCount: 0, // required
      signalStrength: 100, // required
      isFavorite: false, // required
      hasCustomPhoto: false, // required
      autoCloseSeconds: 10, // required
      maxOpenTimeSeconds: 60, // required
      pedestrianTimeoutSeconds: 5, // required
      isEmergencyMode: false, // required
      isAutoLampOn: false, // required
      isMaintenanceMode: false, // required
      isLocked: false, // required
      powerType: 'AC', // required
      motorType: 'Pistón', // required
      hasOpeningPhotocell: false, // required
      hasClosingPhotocell: false, // required
      maintenanceNotes: 'Notes', // required
      hardwareVersion: '1.0', // required
      firmwareVersion: '1.0', // required
      // Optionals
      technicalContact: null,
      installationDate: null,
      warrantyExpirationDate: null,
      scheduledMaintenanceDate: null,
    );
  }

  @override
  Future<void> updateDevice(DeviceInfo device) async {
    updateDeviceCalled = true;
    updatedDevice = device;
  }
}

void main() {
  late MockDeviceRepository mockRepo;

  setUp(() {
    mockRepo = MockDeviceRepository();
  });

  Widget createWidgetUnderTest() {
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const DeviceEditScreen(deviceId: 'test-id'),
        ),
        GoRoute(
          name: 'device-info',
          path: '/devices/:id/info',
          builder: (context, state) => Scaffold(body: Text('Device Info Screen: ${state.pathParameters['id']}')),
        ),
      ],
    );

    return ProviderScope(
      overrides: [
        deviceRepositoryProvider.overrideWithValue(mockRepo),
        // We let the real provider load from the mock repo
      ],
      child: MaterialApp.router(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        routerConfig: router,
      ),
    );
  }

  Finder findInput(String key) {
    return find.descendant(
      of: find.byKey(Key(key)),
      matching: find.byType(TextFormField),
    );
  }

  testWidgets('DeviceEditScreen loads data and updates device', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump(); 
    await tester.pump(); // Handle FutureProvider
    
    // Check for errors
    if (tester.takeException() != null) {
      debugPrint('Exception found during pump!');
    }

    // Verify Title
    expect(find.text('Editar Dispositivo'), findsOneWidget); 
    
    // Check if data is loaded
    expect(find.text('Original Name'), findsOneWidget);
    debugPrint('Found Name field');

    // Verify Read-Only fields (Serial, MAC)
    final serialFinder = findInput('input_serial');
    expect(serialFinder, findsOneWidget);
    final serialField = tester.widget<TextFormField>(serialFinder);
    debugPrint('Serial enabled: ${serialField.enabled}');
    expect(serialField.enabled, isFalse);

    // Verify MAC
    final macFinder = findInput('input_mac');
    final macField = tester.widget<TextFormField>(macFinder);
    expect(macField.enabled, isFalse);

    // Edit Name
    await tester.enterText(findInput('input_name'), 'Updated Name');
    
    // Edit Description
    await tester.enterText(findInput('input_description'), 'Updated Description');
    debugPrint('Entered Text');

    // Submit
    final updateButton = find.byType(CustomButton).last;
    await tester.scrollUntilVisible(updateButton, 100);
    await tester.tap(updateButton);
    debugPrint('Tapped Update');
    
    await tester.pump(); 
    await tester.pump(const Duration(seconds: 1)); 

    // Verify Update logic inside MockRepo
    expect(mockRepo.updateDeviceCalled, isTrue);
    
    // Verify Navigation happened (or update logic verified).
    // The explicit verification of 'device-info' screen presence is cleaner:
    expect(find.text('Device Info Screen: test-id'), findsOneWidget);
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bgnius_vita/features/devices/presentation/screens/r_device_all_details_screen.dart';
import 'package:bgnius_vita/features/devices/domain/entities/device_info.dart';
import 'package:bgnius_vita/features/devices/domain/entities/device.dart';
import 'package:bgnius_vita/features/devices/presentation/providers/device_info_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  final mockDeviceInfo = DeviceInfo(
    id: 'test-id',
    serialNumber: 'SN12345678',
    name: 'Test Device',
    model: 'FAC 500-900 VITA',
    version: '1.0',
    fullVersion: '1.0.0 (2.0.0)',
    macAddress: '00:11:22:33:44:55',
    hardwareVersion: '1.0',
    firmwareVersion: '2.0',
    autoCloseSeconds: 10,
    maxOpenTimeSeconds: 60,
    pedestrianTimeoutSeconds: 5,
    isEmergencyMode: false,
    isAutoLampOn: true,
    isMaintenanceMode: false,
    isLocked: false,
    totalCycles: 1500,
    maintenanceCount: 1,
    activationDate: DateTime(2023, 1, 1),
    technicalContact: 'Tech Support',
    hasCustomPhoto: false,
    groupName: 'Main Entrance',
    isFavorite: true,
    status: 'Ready',
    description: 'Test Description',
    signalStrength: 85,
    powerType: 'AC',
    motorType: 'Pistón',
    hasOpeningPhotocell: true,
    hasClosingPhotocell: true,
    maintenanceNotes: 'None',
  );

  testWidgets('DeviceAllDetailsScreen displays all sections', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          deviceInfoProvider('test-id').overrideWith((ref) => mockDeviceInfo),
        ],
        child: const MaterialApp(
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: [Locale('es'), Locale('en')],
          locale: Locale('es'),
          home: DeviceAllDetailsScreen(deviceId: 'test-id'),
        ),
      ),
    );

    await tester.pump();

    // Verify sections headers (General should be visible)
    expect(find.text('General'), findsOneWidget);
    expect(find.text('Identificación'), findsOneWidget);
    
    // For elements further down, we might need to scroll or just check their presence
    expect(find.text('Mantenimiento'), findsPresent);
    expect(find.text('Configuración VITA'), findsPresent);

    // Verify some specific values
    expect(find.text('SN12345678'), findsOneWidget);
    expect(find.text('00:11:22:33:44:55'), findsOneWidget);
  });
}

// Helper to check for presence without visibility if needed
const findsPresent = FindsPredictor(1);

class FindsPredictor extends Matcher {
  final int count;
  const FindsPredictor(this.count);
  @override
  bool matches(dynamic item, Map matchState) => (item as Finder).evaluate().length >= count;
  @override
  Description describe(Description description) => description.add('present');
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bgnius_vita/features/devices/presentation/screens/h_device_info_screen.dart';
import 'package:bgnius_vita/features/devices/domain/entities/device_info.dart';
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

  testWidgets('DeviceInfoScreen displays device details', (WidgetTester tester) async {
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
          home: DeviceInfoScreen(deviceId: 'test-id'),
        ),
      ),
    );

    await tester.pump();

    // Verify key elements are displayed
    expect(find.textContaining('SN12345678'), findsOneWidget);
    expect(find.text('Test Device'), findsOneWidget);
    expect(find.text('Main Entrance'), findsOneWidget);
    expect(find.text('Tech Support'), findsOneWidget);
    expect(find.textContaining('1,500'), findsOneWidget);
  });
}

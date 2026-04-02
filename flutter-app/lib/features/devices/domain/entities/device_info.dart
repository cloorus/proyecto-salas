import 'package:equatable/equatable.dart';
import 'device.dart';

class DeviceInfo extends Equatable {
  final String id;
  final String serialNumber;
  final String name;
  final String version;
  final String fullVersion;
  final int totalCycles;
  final int maintenanceCount;
  final DateTime activationDate;
  final String status;
  final int signalStrength;
  final String groupName;
  final bool isFavorite;
  final String? technicalContact;
  final bool hasCustomPhoto;
  final String? photoUrl;
  final String model;
  final String description;
  final DeviceType? type;
  
  // Identification
  final String macAddress;

  // Physical
  final String hardwareVersion;
  final String firmwareVersion;

  // Operational Config
  final int autoCloseSeconds;
  final int maxOpenTimeSeconds;
  final int pedestrianTimeoutSeconds;
  final bool isEmergencyMode;
  final bool isAutoLampOn;
  final bool isMaintenanceMode;
  final bool isLocked;

  // Maintenance
  final DateTime? installationDate;
  final DateTime? warrantyExpirationDate;
  final DateTime? scheduledMaintenanceDate;
  final String maintenanceNotes;

  // VITA Config
  final String powerType; // AC/DC
  final String motorType;
  final bool hasOpeningPhotocell;
  final bool hasClosingPhotocell;

  const DeviceInfo({
    required this.id,
    required this.serialNumber,
    required this.name,
    required this.version,
    required this.fullVersion,
    required this.totalCycles,
    required this.maintenanceCount,
    required this.activationDate,
    required this.status,
    required this.signalStrength,
    required this.groupName,
    required this.isFavorite,
    this.technicalContact,
    required this.hasCustomPhoto,
    this.photoUrl,
    required this.model,
    required this.description,
    this.type,
    required this.macAddress,
    required this.hardwareVersion,
    required this.firmwareVersion,
    required this.autoCloseSeconds,
    required this.maxOpenTimeSeconds,
    required this.pedestrianTimeoutSeconds,
    required this.isEmergencyMode,
    required this.isAutoLampOn,
    required this.isMaintenanceMode,
    required this.isLocked,
    this.installationDate,
    this.warrantyExpirationDate,
    this.scheduledMaintenanceDate,
    required this.maintenanceNotes,
    required this.powerType,
    required this.motorType,
    required this.hasOpeningPhotocell,
    required this.hasClosingPhotocell,
  });

  @override
  List<Object?> get props => [
        id,
        serialNumber,
        name,
        version,
        fullVersion,
        totalCycles,
        maintenanceCount,
        activationDate,
        status,
        signalStrength,
        groupName,
        isFavorite,
        technicalContact,
        hasCustomPhoto,
        photoUrl,
        model,
        description,
        type,
        macAddress,
        hardwareVersion,
        firmwareVersion,
        autoCloseSeconds,
        maxOpenTimeSeconds,
        pedestrianTimeoutSeconds,
        isEmergencyMode,
        isAutoLampOn,
        isMaintenanceMode,
        isLocked,
        installationDate,
        warrantyExpirationDate,
        scheduledMaintenanceDate,
        maintenanceNotes,
        powerType,
        motorType,
        hasOpeningPhotocell,
        hasClosingPhotocell,
      ];

  DeviceInfo copyWith({
    String? id,
    String? serialNumber,
    String? name,
    String? version,
    String? fullVersion,
    int? totalCycles,
    int? maintenanceCount,
    DateTime? activationDate,
    String? status,
    int? signalStrength,
    String? groupName,
    bool? isFavorite,
    String? technicalContact,
    bool? hasCustomPhoto,
    String? photoUrl,
    String? model,
    String? description,
    DeviceType? type,
    String? macAddress,
    String? hardwareVersion,
    String? firmwareVersion,
    int? autoCloseSeconds,
    int? maxOpenTimeSeconds,
    int? pedestrianTimeoutSeconds,
    bool? isEmergencyMode,
    bool? isAutoLampOn,
    bool? isMaintenanceMode,
    bool? isLocked,
    DateTime? installationDate,
    DateTime? warrantyExpirationDate,
    DateTime? scheduledMaintenanceDate,
    String? maintenanceNotes,
    String? powerType,
    String? motorType,
    bool? hasOpeningPhotocell,
    bool? hasClosingPhotocell,
  }) {
    return DeviceInfo(
      id: id ?? this.id,
      serialNumber: serialNumber ?? this.serialNumber,
      name: name ?? this.name,
      version: version ?? this.version,
      fullVersion: fullVersion ?? this.fullVersion,
      totalCycles: totalCycles ?? this.totalCycles,
      maintenanceCount: maintenanceCount ?? this.maintenanceCount,
      activationDate: activationDate ?? this.activationDate,
      status: status ?? this.status,
      signalStrength: signalStrength ?? this.signalStrength,
      groupName: groupName ?? this.groupName,
      isFavorite: isFavorite ?? this.isFavorite,
      technicalContact: technicalContact ?? this.technicalContact,
      hasCustomPhoto: hasCustomPhoto ?? this.hasCustomPhoto,
      photoUrl: photoUrl ?? this.photoUrl,
      model: model ?? this.model,
      description: description ?? this.description,
      type: type ?? this.type,
      macAddress: macAddress ?? this.macAddress,
      hardwareVersion: hardwareVersion ?? this.hardwareVersion,
      firmwareVersion: firmwareVersion ?? this.firmwareVersion,
      autoCloseSeconds: autoCloseSeconds ?? this.autoCloseSeconds,
      maxOpenTimeSeconds: maxOpenTimeSeconds ?? this.maxOpenTimeSeconds,
      pedestrianTimeoutSeconds: pedestrianTimeoutSeconds ?? this.pedestrianTimeoutSeconds,
      isEmergencyMode: isEmergencyMode ?? this.isEmergencyMode,
      isAutoLampOn: isAutoLampOn ?? this.isAutoLampOn,
      isMaintenanceMode: isMaintenanceMode ?? this.isMaintenanceMode,
      isLocked: isLocked ?? this.isLocked,
      installationDate: installationDate ?? this.installationDate,
      warrantyExpirationDate: warrantyExpirationDate ?? this.warrantyExpirationDate,
      scheduledMaintenanceDate: scheduledMaintenanceDate ?? this.scheduledMaintenanceDate,
      maintenanceNotes: maintenanceNotes ?? this.maintenanceNotes,
      powerType: powerType ?? this.powerType,
      motorType: motorType ?? this.motorType,
      hasOpeningPhotocell: hasOpeningPhotocell ?? this.hasOpeningPhotocell,
      hasClosingPhotocell: hasClosingPhotocell ?? this.hasClosingPhotocell,
    );
  }
}

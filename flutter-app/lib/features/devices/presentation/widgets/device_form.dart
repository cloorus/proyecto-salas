import 'dart:io';
import 'package:flutter/foundation.dart'; // kIsWeb
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart'; // Image Picker
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/snackbar_helper.dart';
import '../../domain/entities/device.dart'; // Keep for Enums (DeviceStatus, DeviceType?)
import '../../domain/entities/device_info.dart';

// Sections
import 'form_sections/basic_info_section.dart';
import 'form_sections/identification_section.dart';
import 'form_sections/config_section.dart';
import 'form_sections/physical_info_section.dart';
import 'form_sections/maintenance_section.dart';
import 'form_sections/vita_config_section.dart';

class DeviceForm extends StatefulWidget {
  final DeviceInfo? initialData;
  final Future<void> Function(Map<String, dynamic> data) onSave;

  const DeviceForm({
    super.key,
    this.initialData,
    required this.onSave,
  });

  @override
  State<DeviceForm> createState() => _DeviceFormState();
}

class _DeviceFormState extends State<DeviceForm> {
  final _formKey = GlobalKey<FormState>();

  // Controllers - Required
  final _nameController = TextEditingController();
  final _serialController = TextEditingController();
  final _macController = TextEditingController();
  final _descriptionController = TextEditingController();

  // Controllers - Optional
  final _hardwareVersionController = TextEditingController();
  final _firmwareVersionController = TextEditingController();
  final _maintenanceNotesController = TextEditingController();
  final _technicalContactController = TextEditingController();
  final _autoCloseController = TextEditingController();
  final _maxOpenTimeController = TextEditingController();
  final _pedestrianTimeoutController = TextEditingController();

  // Selections
  String? _selectedLocation;
  String? _selectedModel;
  DateTime? _installationDate;
  DateTime? _activationDate; // Added
  DateTime? _warrantyDate;
  DateTime? _scheduledMaintenanceDate;
  
  // Configs
  String? _selectedPowerType;
  String? _selectedMotorType;

  // Switches
  bool _emergencyMode = false;
  bool _autoLampOn = false;
  bool _maintenanceMode = false;
  bool _locked = false;
  bool _openingPhotocell = false;
  bool _closingPhotocell = false;
  bool _isFavorite = false; // Added

  bool _isLoading = false;
  
  // Status and Type
  String? _selectedStatus;
  String? _selectedType;

  String? _photoPath; // Simulating photo path
  XFile? _pickedImage; // Image Picker result

  // Options
  // TODO: Move these to a constant file or provider
  final List<String> _locationOptions = [
    'Entrada Principal', 'Norte', 'Sur', 'Este', 'Oeste',
    'Estacionamientos', 'Recepción', 'Lobby', 'Área de Carga',
  ];

  final List<String> _modelOptions = [
    'FAC 500-900 VITA', 'DEFAULT', 'Legacy',
  ];
  
  final List<String> _powerTypeOptions = ['AC', 'DC'];
  final List<String> _motorTypeOptions = ['Pistón', 'Cremallera', 'Cortina', 'Barrera'];
  
  final List<String> _statusOptions = [
    'Listo', 'Abriendo', 'Cerrando', 'Pausado', 'Error', 'Mantenimiento'
  ];
  
  final List<String> _typeOptions = [
    'Portón', 'Barrera', 'Puerta', 'Otro'
  ];

  @override
  void initState() {
    super.initState();
    if (widget.initialData != null) {
      _loadData(widget.initialData!);
    }
  }

  void _loadData(DeviceInfo data) {
    _nameController.text = data.name;
    _serialController.text = data.serialNumber;
    _macController.text = data.macAddress;
    _descriptionController.text = data.description;
    
    _hardwareVersionController.text = data.hardwareVersion;
    _firmwareVersionController.text = data.firmwareVersion;
    _maintenanceNotesController.text = data.maintenanceNotes;
    _technicalContactController.text = data.technicalContact ?? '';
    _selectedStatus = data.status;
    _selectedStatus = data.status;
    _selectedType = data.type?.displayName ?? 'Portón';
    _photoPath = data.photoUrl;
    
    _autoCloseController.text = data.autoCloseSeconds.toString();
    _maxOpenTimeController.text = data.maxOpenTimeSeconds.toString();
    _pedestrianTimeoutController.text = data.pedestrianTimeoutSeconds.toString();

    // Enums handling - Safe Check
    // Add current location to options if not in list
    if (data.groupName.isNotEmpty && !_locationOptions.contains(data.groupName)) {
      _locationOptions.insert(0, data.groupName);
    }
    if (data.groupName.isNotEmpty) {
      _selectedLocation = data.groupName;
    }



    
    // Add current model to options if not in list
    if (data.model != null && data.model!.isNotEmpty && !_modelOptions.contains(data.model)) {
      _modelOptions.insert(0, data.model!);
    }
    if (data.model != null && _modelOptions.contains(data.model)) {
      _selectedModel = data.model;
    }
    
    // Configs
    if (_powerTypeOptions.contains(data.powerType)) {
      _selectedPowerType = data.powerType;
    }
    
    if (_motorTypeOptions.contains(data.motorType)) {
      _selectedMotorType = data.motorType;
    }
    _openingPhotocell = data.hasOpeningPhotocell;
    _closingPhotocell = data.hasClosingPhotocell;
    
    _installationDate = data.installationDate;
    _activationDate = data.activationDate; // Added
    _warrantyDate = data.warrantyExpirationDate;
    _scheduledMaintenanceDate = data.scheduledMaintenanceDate;
    
    _isFavorite = data.isFavorite; // Added
  }

  @override
  void dispose() {
    _nameController.dispose();
    _serialController.dispose();
    _macController.dispose();
    _descriptionController.dispose();
    _hardwareVersionController.dispose();
    _firmwareVersionController.dispose();
    _maintenanceNotesController.dispose();
    _technicalContactController.dispose();
    _autoCloseController.dispose();
    _maxOpenTimeController.dispose();
    _pedestrianTimeoutController.dispose();
    super.dispose();
  }
  

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) {
      SnackbarHelper.showError(context, AppLocalizations.of(context)!.deviceFormErrorRequired);
      return;
    }
    if (_selectedLocation == null) {
      SnackbarHelper.showError(context, AppLocalizations.of(context)!.deviceFormErrorLocation);
      return;
    }
    // Model is optional

    setState(() => _isLoading = true);
    
    try {
      final data = {
        'name': _nameController.text.trim(),
        'location': _selectedLocation,
        'description': _descriptionController.text.trim(),
        'serialNumber': _serialController.text.trim(),
        'macAddress': _macController.text.trim(),
        'model': _selectedModel,
        'autoCloseSeconds': int.tryParse(_autoCloseController.text) ?? 0,
        'maxOpenTimeSeconds': int.tryParse(_maxOpenTimeController.text) ?? 0,
        'pedestrianTimeoutSeconds': int.tryParse(_pedestrianTimeoutController.text) ?? 0,
        'isEmergencyMode': _emergencyMode,
        'isAutoLampOn': _autoLampOn,
        'isMaintenanceMode': _maintenanceMode,
        'isMaintenanceMode': _maintenanceMode,
        'isLocked': _locked,
        'isFavorite': _isFavorite, // Added
        'hardwareVersion': _hardwareVersionController.text.trim(),
        'firmwareVersion': _firmwareVersionController.text.trim(),
        'installationDate': _installationDate?.toIso8601String(),
        'activationDate': _activationDate?.toIso8601String(), // Added
        'warrantyExpirationDate': _warrantyDate?.toIso8601String(),
        'scheduledMaintenanceDate': _scheduledMaintenanceDate?.toIso8601String(),
        'maintenanceNotes': _maintenanceNotesController.text.trim(),
        'technicalContact': _technicalContactController.text.trim(),
        'powerType': _selectedPowerType ?? 'AC',
        'motorType': _selectedMotorType ?? 'Pistón',
        'hasOpeningPhotocell': _openingPhotocell,
        'hasClosingPhotocell': _closingPhotocell,
        'status': _selectedStatus ?? 'Listo',
        'type': _selectedType ?? 'Portón',
        'photoPath': _photoPath,
        'imageFile': _pickedImage, // Include picked file
      };

      await widget.onSave(data);
      
    } catch (e) {
       SnackbarHelper.showError(context, AppLocalizations.of(context)!.deviceFormErrorSave(e.toString()));
    } finally {
       if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildPhotoSelector(),
                  const SizedBox(height: 24),
                  BasicInfoSection(
                    key: const Key('section_basic_info'),
                    nameController: _nameController,
                    descriptionController: _descriptionController,
                    selectedLocation: _selectedLocation,
                    locationOptions: _locationOptions,
                    onLocationChanged: (val) => setState(() => _selectedLocation = val),
                    selectedType: _selectedType,
                    typeOptions: _typeOptions,
                    onTypeChanged: (val) => setState(() => _selectedType = val),
                    selectedStatus: _selectedStatus,
                    statusOptions: _statusOptions,
                    onStatusChanged: (val) => setState(() => _selectedStatus = val),
                    activationDate: _activationDate, // Added
                    onActivationDateChanged: (d) => setState(() => _activationDate = d), // Added
                    isFavorite: _isFavorite, // Added
                    onIsFavoriteChanged: (v) => setState(() => _isFavorite = v), // Added
                    isLoading: _isLoading,
                  ),
                  const SizedBox(height: 32),
                  
                  IdentificationSection(
                    key: const Key('section_identification'),
                    serialController: _serialController,
                    macController: _macController,
                    selectedModel: _selectedModel,
                    modelOptions: _modelOptions,
                    onModelChanged: (val) => setState(() => _selectedModel = val),
                    isLoading: _isLoading,
                    isReadOnly: widget.initialData != null,
                  ),
                  const SizedBox(height: 32),

                  ConfigSection(
                    autoCloseController: _autoCloseController,
                    maxOpenTimeController: _maxOpenTimeController,
                    pedestrianTimeoutController: _pedestrianTimeoutController,
                    emergencyMode: _emergencyMode,
                    onEmergencyModeChanged: (v) => setState(() => _emergencyMode = v),
                    autoLampOn: _autoLampOn,
                    onAutoLampOnChanged: (v) => setState(() => _autoLampOn = v),
                    maintenanceMode: _maintenanceMode,
                    onMaintenanceModeChanged: (v) => setState(() => _maintenanceMode = v),
                    locked: _locked,
                    onLockedChanged: (v) => setState(() => _locked = v),
                    isLoading: _isLoading,
                  ),

                  PhysicalInfoSection(
                    hardwareVersionController: _hardwareVersionController,
                    firmwareVersionController: _firmwareVersionController,
                    isLoading: _isLoading,
                  ),
                  
                  MaintenanceSection(
                    installationDate: _installationDate,
                    onInstallationDateChanged: (d) => setState(() => _installationDate = d),
                    warrantyDate: _warrantyDate,
                    onWarrantyDateChanged: (d) => setState(() => _warrantyDate = d),
                    scheduledMaintenanceDate: _scheduledMaintenanceDate,
                    onScheduledMaintenanceDateChanged: (d) => setState(() => _scheduledMaintenanceDate = d),
                    maintenanceNotesController: _maintenanceNotesController,
                    technicalContactController: _technicalContactController,
                    isLoading: _isLoading,
                  ),
                  
                  VitaConfigSection(
                    selectedPowerType: _selectedPowerType,
                    powerTypeOptions: _powerTypeOptions,
                    onPowerTypeChanged: (v) => setState(() => _selectedPowerType = v),
                    selectedMotorType: _selectedMotorType,
                    motorTypeOptions: _motorTypeOptions,
                    onMotorTypeChanged: (v) => setState(() => _selectedMotorType = v),
                    openingPhotocell: _openingPhotocell,
                    onOpeningPhotocellChanged: (v) => setState(() => _openingPhotocell = v),
                    closingPhotocell: _closingPhotocell,
                    onClosingPhotocellChanged: (v) => setState(() => _closingPhotocell = v),
                    isLoading: _isLoading,
                  ),



                  const SizedBox(height: 32),

                  const SizedBox(height: 32),
                  _buildActionButtons(),
                  
                  _buildDeleteButton(), // Botón de Eliminar Agregado

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }


  Future<void> _pickImage(ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
      
      if (image != null) {
        setState(() {
          _pickedImage = image;
          _photoPath = null; // Clear existing remote path if any to show local
        });
        SnackbarHelper.showSuccess(context, AppLocalizations.of(context)!.deviceFormImageLoadedSuccess);
      }
    } catch (e) {
      SnackbarHelper.showError(context, AppLocalizations.of(context)!.deviceFormImageLoadError(e.toString()));
    }
  }

  void _showImageSourceActionSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(AppLocalizations.of(context)!.deviceFormSelectImage, style: AppTextStyles.cardTitle.copyWith(fontSize: 18)),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: AppColors.primaryPurple),
              title: Text(AppLocalizations.of(context)!.deviceFormTakePhoto),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: AppColors.primaryPurple),
              title: Text(AppLocalizations.of(context)!.deviceFormGallery),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
             if (_pickedImage != null || _photoPath != null)
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: Text(AppLocalizations.of(context)!.deviceFormDeletePhoto, style: const TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                     _pickedImage = null;
                     _photoPath = null;
                  });
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoSelector() {
    ImageProvider? imageProvider;
    
    if (_pickedImage != null) {
      if (kIsWeb) {
        imageProvider = NetworkImage(_pickedImage!.path); // For web, path is a blob URL
      } else {
         imageProvider = FileImage(File(_pickedImage!.path));
      }
    } else if (_photoPath != null) {
      imageProvider = NetworkImage(_photoPath!);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: _showImageSourceActionSheet,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.divider),
                  image: imageProvider != null 
                    ? DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      )
                    : const DecorationImage(
                        image: AssetImage('assets/images/porton_fondo.png'),
                        fit: BoxFit.cover,
                        opacity: 0.3, // Opacidad reducida para que se note que es placeholder
                      ),
                ),
                child: imageProvider == null 
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                         const Icon(
                          Icons.add_a_photo_outlined,
                          size: 40,
                          color: AppColors.primaryPurple,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          AppLocalizations.of(context)!.deviceFormPhotoHint,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.primaryPurple,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    )
                  : null,
              ),
              
              // Overlay para cambiar imagen si ya existe
              if (imageProvider != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.edit_outlined,
                        color: Colors.white,
                        size: 20,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        AppLocalizations.of(context)!.changePhotoButton, 
                        style: AppTextStyles.bodySmall.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }



  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: CustomButton(
            text: AppLocalizations.of(context)!.deviceFormCancel,
            onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
            type: ButtonType.outline,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: CustomButton(
            text: widget.initialData != null 
                ? AppLocalizations.of(context)!.deviceFormSubmitUpdate 
                : AppLocalizations.of(context)!.deviceFormSubmitCreate,
            onPressed: _isLoading ? null : _handleSave,
            isLoading: _isLoading,
            type: ButtonType.primary,
          ),
        ),
      ],
    );
  }
  Future<void> _handleDelete() async {
    final l10n = AppLocalizations.of(context)!;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deviceFormDeleteDevice, style: const TextStyle(color: Colors.red)),
        content: Text(l10n.deviceFormDeleteConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.msgCancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(l10n.generalDelete),
          ),
        ],
      ),
    );

    if (confirm == true) {
      if (!mounted) return;
      setState(() => _isLoading = true);

      // Simular borrado
      await Future.delayed(const Duration(seconds: 1)); 

      if (!mounted) return;
      setState(() => _isLoading = false);
      
      SnackbarHelper.showSuccess(context, AppLocalizations.of(context)!.deviceFormDeletedSuccess);
      
      // Navegar a la lista de dispositivos
      context.go('/devices');
    }
  }

  Widget _buildDeleteButton() {
     if (widget.initialData == null) return const SizedBox.shrink(); // Solo mostrar si estamos editando
     
     return Container(
       width: double.infinity,
       padding: const EdgeInsets.only(top: 24),
       child: TextButton.icon(
         onPressed: _isLoading ? null : _handleDelete,
         icon: const Icon(Icons.delete_forever, color: Colors.red),
         label: Text(
           AppLocalizations.of(context)!.deleteDeviceButton,
           style: const TextStyle(
             color: Colors.red, 
             fontSize: 16, 
             fontWeight: FontWeight.bold
            ),
         ),
         style: TextButton.styleFrom(
           padding: const EdgeInsets.symmetric(vertical: 16),
           backgroundColor: Colors.red.withValues(alpha: 0.05),
           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
         ),
       ),
     );
  }

}


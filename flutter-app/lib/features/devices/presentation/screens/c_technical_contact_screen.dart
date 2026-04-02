import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/validators.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/snackbar_helper.dart';
import '../../../../shared/widgets/page_header.dart'; // Nuevo
import '../../domain/entities/device.dart';
import '../../../../core/services/device_service.dart'; // Import para buscar por ID

/// Pantalla de Contacto Técnico según mockup 5_contactoTecnico.png
/// Con panel de info del dispositivo, datos del técnico y notas
class TechnicalContactScreen extends StatefulWidget {
  final String? deviceId; // Parametro ID
  final Device? device;
  
  const TechnicalContactScreen({
    super.key,
    this.deviceId,
    this.device,
  });

  @override
  State<TechnicalContactScreen> createState() => _TechnicalContactScreenState();
}

class _TechnicalContactScreenState extends State<TechnicalContactScreen> {
  final _formKey = GlobalKey<FormState>();
  
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _countryController = TextEditingController();
  final _phoneController = TextEditingController();
  final _notesController = TextEditingController();
  
  bool _isLoading = false;
  Device? _device; // Estado local para el dispositivo

  @override
  void initState() {
    super.initState();
    // Prioridad: usar objeto pasado, sino buscar por ID
    _device = widget.device;
    if (_device == null && widget.deviceId != null) {
      // Device loaded from API via DeviceService
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _countryController.dispose();
    _phoneController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    // Simular guardado
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    SnackbarHelper.showSuccess(context, AppLocalizations.of(context)!.technicalContactSaveSuccess);
    
    setState(() => _isLoading = false);
  }

  Future<void> _handleDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.technicalContactDeleteDialogTitle),
        content: Text(AppLocalizations.of(context)!.technicalContactDeleteDialogContent),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(AppLocalizations.of(context)!.technicalContactCancelButton),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              AppLocalizations.of(context)!.technicalContactDeleteButton,
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      setState(() => _isLoading = true);
      
      await Future.delayed(const Duration(seconds: 1));
      
      if (!mounted) return;
      
      SnackbarHelper.showSuccess(context, AppLocalizations.of(context)!.technicalContactDeleteSuccess);
      context.pop();
    }
  }

  void _handleContactMaintenance() {
    SnackbarHelper.showInfo(context, AppLocalizations.of(context)!.technicalContactMaintenanceInfo);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header Reutilizable
              const SizedBox(height: 16), // Espacio superior
              PageHeader(
                title: AppLocalizations.of(context)!.technicalContactTitle,
                titleFontSize: 24,
                showBackButton: true,
                showLogo: true,
              ),

              const SizedBox(height: 16),

            // Panel de Información del Dispositivo
              // Panel de Información del Dispositivo
              if (_device != null)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  color: const Color(0xFFEBEBEB), // Gris claro
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Columna Izquierda: Dispositivo, Modelo, Serie
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.technicalContactDeviceLabel,
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            Text(
                              '${AppLocalizations.of(context)!.technicalContactModelLabel} ${_device!.model}',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            Text(
                              '${AppLocalizations.of(context)!.technicalContactSerialLabel} ${_device!.serialNumber}',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Columna Derecha: Estado, Detalle
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${AppLocalizations.of(context)!.technicalContactStatusLabel} ${_device!.status.displayName}',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            Text(
                              '${AppLocalizations.of(context)!.technicalContactDetailLabel} ${_device!.type.displayName}',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 24),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Título: Datos del Técnico
                      Text(
                        AppLocalizations.of(context)!.technicalContactTechDataTitle,
                        style: AppTextStyles.screenTitle.copyWith(
                          color: AppColors.titleBlue,
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),

                      // Nombre de usuario
                      CustomTextField(
                        hintText: AppLocalizations.of(context)!.technicalContactNameHint,
                        controller: _nameController,
                        validator: (value) => Validators.required(value, context),
                        enabled: !_isLoading,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                      ),
                      const SizedBox(height: 12),

                      // Correo
                      CustomTextField(
                        hintText: AppLocalizations.of(context)!.technicalContactEmailHint,
                        controller: _emailController,
                        validator: (value) => Validators.email(value, context),
                        keyboardType: TextInputType.emailAddress,
                        enabled: !_isLoading,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                      ),
                      const SizedBox(height: 12),

                      // País
                      CustomTextField(
                        hintText: AppLocalizations.of(context)!.technicalContactCountryHint,
                        controller: _countryController,
                        enabled: !_isLoading,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                      ),
                      const SizedBox(height: 12),

                      // Teléfono
                      CustomTextField(
                        hintText: AppLocalizations.of(context)!.technicalContactPhoneHint,
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        enabled: !_isLoading,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                      ),
                      
                      const SizedBox(height: 24),

                      // Sección IA (Container gris redondeado)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEBEBEB),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          children: [
                            Text(
                              AppLocalizations.of(context)!.technicalContactAiDescription,
                              style: AppTextStyles.bodySmall.copyWith(
                                fontSize: 13,
                                color: Colors.black87,
                                height: 1.4,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 12),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Semantics(
                                  label: AppLocalizations.of(context)!.technicalContactAiPermissionText,
                                  child: Checkbox(
                                    value: true, // TODO: Bind to state variable
                                    onChanged: (val) {},
                                    activeColor: AppColors.primaryPurple, // Color oscuro del mockup
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                ),
                                Flexible(
                                  child: Text(
                                    AppLocalizations.of(context)!.technicalContactAiPermissionText,
                                    style: AppTextStyles.bodySmall.copyWith(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF0A3057),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Semantics(
                                  label: 'IA artificial intelligence icon',
                                  child: const Icon(Icons.auto_awesome, size: 16, color: Color(0xFF0A3057)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Título: Notas
                      Text(
                        AppLocalizations.of(context)!.technicalContactNotesTitle,
                        style: AppTextStyles.screenTitle.copyWith(
                          color: AppColors.titleBlue,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),

                      // Campo de Notas (Textarea)
                      CustomTextField(
                        hintText: '',
                        controller: _notesController,
                        maxLines: 3,
                        enabled: !_isLoading,
                        contentPadding: const EdgeInsets.all(16),
                      ),

                      const SizedBox(height: 32),

                      // Botones Eliminar y Guardar
                      Row(
                        children: [
                          // Botón Eliminar (Rojo)
                          Expanded(
                            child: SizedBox(
                              height: 48,
                              child: ElevatedButton(
                                onPressed: _isLoading ? null : _handleDelete,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFFF3B30), // Rojo brillante
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  elevation: 0,
                                ),
                                child: Text(
                                  AppLocalizations.of(context)!.technicalContactDeleteButton,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          // Botón Guardar (Azul)
                          Expanded(
                            child: SizedBox(
                              height: 48,
                              child: ElevatedButton(
                                onPressed: _isLoading ? null : _handleSave,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF1976D2), // Azul
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  elevation: 0,
                                ),
                                child: Text(
                                  AppLocalizations.of(context)!.technicalContactSaveButton,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

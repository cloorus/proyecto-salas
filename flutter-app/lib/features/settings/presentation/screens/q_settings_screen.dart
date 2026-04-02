import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; // Import go_router
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/snackbar_helper.dart';
import '../../../../shared/widgets/page_header.dart'; // Asegurar que PageHeader tenga showBackButton

/// Pantalla de Configuración / Perfil Expandida
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Controladores de Perfil
  final _nombreController = TextEditingController(text: 'Carlos Mena');
  final _telefonoController = TextEditingController(text: '+506 8888-8888');
  final _correoController = TextEditingController(text: 'carlos@bgnius.com');
  final _direccionController = TextEditingController(text: 'San José, Costa Rica');
  final _paisController = TextEditingController(text: 'Costa Rica');
  final _idiomaController = TextEditingController(text: 'Español');

  // Controladores de Password
  final _passwordActualController = TextEditingController();
  final _passwordNuevaController = TextEditingController();
  final _passwordRepetirController = TextEditingController();

  // Controladores de Servidor
  final _serverUrlController = TextEditingController(text: 'https://api.bgnius.com');

  // Estados de Configuración
  bool _darkMode = false;
  bool _highContrast = false;
  bool _reducedMotion = false;
  bool _biometricsEnabled = false;
  String _environment = 'Producción';
  double _fontSize = 1.0; // 1.0 = Normal

  // Estado de la foto de perfil
  String? _profileImagePath;

  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void dispose() {
    _nombreController.dispose();
    _telefonoController.dispose();
    _correoController.dispose();
    _direccionController.dispose();
    _paisController.dispose();
    _idiomaController.dispose();
    _passwordActualController.dispose();
    _passwordNuevaController.dispose();
    _passwordRepetirController.dispose();
    _serverUrlController.dispose();
    super.dispose();
  }

  Future<void> _handleActualizar() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return;
      setState(() => _isLoading = false);
      SnackbarHelper.showSuccess(context, AppLocalizations.of(context)!.settingsUpdatedSuccess);
      _passwordActualController.clear();
      _passwordNuevaController.clear();
      _passwordRepetirController.clear();
    }
  }

  void _showPhotoOptions() {
    final hasPhoto = _profileImagePath != null;
    
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(AppLocalizations.of(context)!.settingsChangePhoto, style: AppTextStyles.cardTitle.copyWith(fontSize: 18)),
            const SizedBox(height: 20),
            _buildOptionTile(AppLocalizations.of(context)!.settingsPhotoCamera, null, () => _handlePhotoSelection('camera')),
            _buildOptionTile(AppLocalizations.of(context)!.settingsPhotoGallery, null, () => _handlePhotoSelection('gallery')),
            if (hasPhoto)
              _buildOptionTile(AppLocalizations.of(context)!.settingsPhotoRemove, null, () => _handlePhotoSelection('remove')),
          ],
        ),
      ),
    );
  }

  void _handlePhotoSelection(String option) {
    Navigator.pop(context);
    
    switch (option) {
      case 'camera':
      case 'gallery':
        // Mock photo selection - en una implementación real aquí iría image_picker
        setState(() {
          _profileImagePath = 'mock_photo_path';
        });
        SnackbarHelper.showSuccess(context, AppLocalizations.of(context)!.settingsPhotoUpdated);
        break;
      case 'remove':
        setState(() {
          _profileImagePath = null;
        });
        SnackbarHelper.showSuccess(context, AppLocalizations.of(context)!.settingsPhotoRemoved);
        break;
    }
  }

  void _showCountryPicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(AppLocalizations.of(context)!.settingsSelectCountry, style: AppTextStyles.cardTitle.copyWith(fontSize: 18)),
            const SizedBox(height: 20),
            _buildOptionTile(AppLocalizations.of(context)!.settingsCountryCostaRica, '🇨🇷', () => _setCountry(AppLocalizations.of(context)!.settingsCountryCostaRica)),
            _buildOptionTile(AppLocalizations.of(context)!.settingsCountryMexico, '🇲🇽', () => _setCountry(AppLocalizations.of(context)!.settingsCountryMexico)),
            _buildOptionTile(AppLocalizations.of(context)!.settingsCountrySpain, '🇪🇸', () => _setCountry(AppLocalizations.of(context)!.settingsCountrySpain)),
          ],
        ),
      ),
    );
  }

  void _setCountry(String country) {
    setState(() => _paisController.text = country);
    Navigator.pop(context);
  }

  void _showLanguagePicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(AppLocalizations.of(context)!.settingsSelectLanguage, style: AppTextStyles.cardTitle.copyWith(fontSize: 18)),
            const SizedBox(height: 20),
            _buildOptionTile(AppLocalizations.of(context)!.settingsLanguageSpanish, null, () => _setLanguage(AppLocalizations.of(context)!.settingsLanguageSpanish)),
            _buildOptionTile(AppLocalizations.of(context)!.settingsLanguageEnglish, null, () => _setLanguage(AppLocalizations.of(context)!.settingsLanguageEnglish)),
          ],
        ),
      ),
    );
  }

  void _setLanguage(String lang) {
    setState(() => _idiomaController.text = lang);
    Navigator.pop(context);
  }

  void _showEnvironmentPicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(AppLocalizations.of(context)!.settingsSelectEnvironment, style: AppTextStyles.cardTitle.copyWith(fontSize: 18)),
            const SizedBox(height: 20),
            _buildOptionTile(AppLocalizations.of(context)!.settingsEnvironmentProduction, null, () => _setEnv(AppLocalizations.of(context)!.settingsEnvironmentProduction)),
            _buildOptionTile(AppLocalizations.of(context)!.settingsEnvironmentStaging, null, () => _setEnv(AppLocalizations.of(context)!.settingsEnvironmentStaging)),
            _buildOptionTile(AppLocalizations.of(context)!.settingsEnvironmentDevelopment, null, () => _setEnv(AppLocalizations.of(context)!.settingsEnvironmentDevelopment)),
          ],
        ),
      ),
    );
  }

  void _setEnv(String env) {
    setState(() => _environment = env);
    Navigator.pop(context);
  }

  Widget _buildOptionTile(String title, String? leading, VoidCallback onTap) {
    return ListTile(
      leading: leading != null ? Text(leading, style: const TextStyle(fontSize: 24)) : null,
      title: Text(title, style: AppTextStyles.bodyMedium),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),
            PageHeader(
              title: AppLocalizations.of(context)!.settingsTitle,
              titleFontSize: 24,
              showBackButton: true,
              onBack: () => context.go('/devices'), // Navegar explícitamente a Dispositivos (Tab 0)
            ),
            
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // SECCIÓN 1: PERFIL
                      _buildSectionTitle(AppLocalizations.of(context)!.settingsProfileSection),
                      const SizedBox(height: 16),
                      
                      // Foto de perfil
                      Center(
                        child: Stack(
                          children: [
                            GestureDetector(
                              onTap: _showPhotoOptions,
                              child: CircleAvatar(
                                radius: 50, // 100px diameter
                                backgroundColor: AppColors.primaryPurple,
                                backgroundImage: _profileImagePath != null
                                    ? const AssetImage('assets/images/placeholder_avatar.png') // Imagen placeholder
                                    : null,
                                child: _profileImagePath == null
                                    ? const Icon(
                                        Icons.person,
                                        size: 50,
                                        color: Colors.white,
                                      )
                                    : null,
                              ),
                            ),
                            // Indicador de edición (ícono de cámara)
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: AppColors.primaryPurple,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white, width: 2),
                                ),
                                child: const Icon(
                                  Icons.camera_alt,
                                  size: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      CustomTextField(hintText: AppLocalizations.of(context)!.settingsFieldName, controller: _nombreController),
                      const SizedBox(height: 12),
                      CustomTextField(hintText: AppLocalizations.of(context)!.settingsFieldPhone, controller: _telefonoController, keyboardType: TextInputType.phone),
                      const SizedBox(height: 12),
                      CustomTextField(hintText: AppLocalizations.of(context)!.settingsFieldEmail, controller: _correoController, keyboardType: TextInputType.emailAddress),
                      const SizedBox(height: 12),
                      CustomTextField(hintText: AppLocalizations.of(context)!.settingsFieldAddress, controller: _direccionController),
                      const SizedBox(height: 12),
                      _buildReadOnlyFieldWithAction(_paisController, AppLocalizations.of(context)!.settingsFieldCountry, _showCountryPicker),
                      const SizedBox(height: 12),
                      _buildReadOnlyFieldWithAction(_idiomaController, AppLocalizations.of(context)!.settingsFieldLanguage, _showLanguagePicker),
                      
                      const SizedBox(height: 32),

                      // SECCIÓN 2: APARIENCIA
                      _buildSectionTitle(AppLocalizations.of(context)!.settingsAppearanceSection),
                      const SizedBox(height: 12),
                      SwitchListTile(
                        title: Text(AppLocalizations.of(context)!.settingsDarkMode, style: AppTextStyles.bodyMedium),
                        value: _darkMode,
                        onChanged: (val) => setState(() => _darkMode = val),
                        activeColor: AppColors.primaryPurple,
                      ),
                      ListTile(
                        title: Text(AppLocalizations.of(context)!.settingsFontSize, style: AppTextStyles.bodyMedium),
                        subtitle: Slider(
                          value: _fontSize,
                          min: 0.8,
                          max: 1.4,
                          divisions: 3,
                          label: _fontSize.toString(),
                          activeColor: AppColors.primaryPurple,
                          onChanged: (val) => setState(() => _fontSize = val),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // SECCIÓN 3: ACCESIBILIDAD
                      _buildSectionTitle(AppLocalizations.of(context)!.settingsAccessibilitySection),
                      const SizedBox(height: 12),
                      SwitchListTile(
                        title: Text(AppLocalizations.of(context)!.settingsHighContrast, style: AppTextStyles.bodyMedium),
                        value: _highContrast,
                        onChanged: (val) => setState(() => _highContrast = val),
                        activeColor: AppColors.primaryPurple,
                      ),
                      SwitchListTile(
                        title: Text(AppLocalizations.of(context)!.settingsReduceMotion, style: AppTextStyles.bodyMedium),
                        value: _reducedMotion,
                        onChanged: (val) => setState(() => _reducedMotion = val),
                        activeColor: AppColors.primaryPurple,
                      ),

                      const SizedBox(height: 24),

                      // SECCIÓN 4: SEGURIDAD
                      _buildSectionTitle(AppLocalizations.of(context)!.settingsSecuritySection),
                      const SizedBox(height: 12),
                      CustomTextField(hintText: AppLocalizations.of(context)!.settingsCurrentPassword, controller: _passwordActualController, isPassword: true),
                      const SizedBox(height: 12),
                      CustomTextField(hintText: AppLocalizations.of(context)!.settingsNewPassword, controller: _passwordNuevaController, isPassword: true),
                      const SizedBox(height: 12),
                      CustomTextField(hintText: AppLocalizations.of(context)!.settingsRepeatPassword, controller: _passwordRepetirController, isPassword: true),
                      const SizedBox(height: 12),
                      SwitchListTile(
                        title: Text(AppLocalizations.of(context)!.settingsBiometrics, style: AppTextStyles.bodyMedium),
                        subtitle: Text(AppLocalizations.of(context)!.settingsBiometricsSubtitle, style: AppTextStyles.bodySmall),
                        value: _biometricsEnabled,
                        onChanged: (val) => setState(() => _biometricsEnabled = val),
                        activeColor: AppColors.primaryPurple,
                      ),

                      const SizedBox(height: 24),

                      // SECCIÓN 5: SERVIDOR (AVANZADO)
                      _buildSectionTitle(AppLocalizations.of(context)!.settingsServerSection),
                      const SizedBox(height: 12),
                      ListTile(
                        title: Text(AppLocalizations.of(context)!.settingsEnvironment, style: AppTextStyles.bodyMedium),
                        subtitle: Text(_environment, style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.bold)),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: _showEnvironmentPicker,
                      ),
                      const SizedBox(height: 8),
                      CustomTextField(hintText: AppLocalizations.of(context)!.settingsServerUrl, controller: _serverUrlController),

                       const SizedBox(height: 24),

                      // SECCIÓN 6: INFO APP
                      _buildSectionTitle(AppLocalizations.of(context)!.settingsInfoSection),
                      const SizedBox(height: 12),
                      ListTile(
                        title: Text(AppLocalizations.of(context)!.settingsAppVersion, style: AppTextStyles.bodyMedium),
                        trailing: Text('1.0.2 (Build 45)', style: AppTextStyles.bodySmall),
                      ),
                      ListTile(
                        title: Text(AppLocalizations.of(context)!.settingsTermsConditions, style: AppTextStyles.bodyMedium),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {},
                      ),
                      ListTile(
                        title: Text(AppLocalizations.of(context)!.settingsPrivacyPolicy, style: AppTextStyles.bodyMedium),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {},
                      ),


                      CustomButton(
                        text: AppLocalizations.of(context)!.settingsSaveChanges,
                        type: ButtonType.primary,
                        onPressed: _isLoading ? null : _handleActualizar,
                        isLoading: _isLoading,
                      ),
                      const SizedBox(height: 16),
                      // BOTÓN CERRAR SESIÓN
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.logout, color: Colors.red),
                          label: const Text("Cerrar Sesión", style: TextStyle(color: Colors.red, fontSize: 16)),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.red),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          ),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: const Text("Cerrar Sesión"),
                                content: const Text("¿Estás seguro de que deseas cerrar sesión?"),
                                actions: [
                                  TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancelar")),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(ctx);
                                      context.go("/logout");
                                    },
                                    child: const Text("Cerrar Sesión", style: TextStyle(color: Colors.red)),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.cardTitle.copyWith(
            color: AppColors.titleBlue,
            fontSize: 18,
            fontWeight: FontWeight.bold
          ),
        ),
        const Divider(color: Colors.grey, thickness: 0.5),
      ],
    );
  }

  Widget _buildReadOnlyFieldWithAction(TextEditingController controller, String hint, VoidCallback onTap) {
    return Row(
      children: [
        Expanded(
          child: CustomTextField(hintText: hint, controller: controller, enabled: false),
        ),
        const SizedBox(width: 12),
        TextButton(
          onPressed: onTap,
          child: Text(AppLocalizations.of(context)!.settingsChangeButton, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primaryPurple)),
        ),
      ],
    );
  }
}

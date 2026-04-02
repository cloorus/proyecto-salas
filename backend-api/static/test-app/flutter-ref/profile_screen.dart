import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/models/user.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/validators/app_validators.dart';
import '../../../../core/design_system/atoms/form_fields.dart';
import '../../../../core/design_system/molecules/common_widgets.dart';
import '../state/profile_cubit.dart';
import '../state/profile_state.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _phonePrefixController = TextEditingController(text: '+506');
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();

  // Password fields
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmNewPasswordController = TextEditingController();
  final _obscureCurrentPasswordNotifier = ValueNotifier<bool>(true);
  final _obscureNewPasswordNotifier = ValueNotifier<bool>(true);
  final _obscureConfirmNewPasswordNotifier = ValueNotifier<bool>(true);

  String _selectedCountry = 'Costa Rica';
  String _selectedLanguage = 'Español';
  String _selectedPhonePrefix = '+506';
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  // Debouncing for save button
  DateTime? _lastSaveAttempt;
  static const _saveDebounceDuration = Duration(milliseconds: 1000);

  final List<String> _countries = [
    'Costa Rica',
    'Estados Unidos',
    'México',
    'España',
    'Colombia',
    'Argentina',
    'Chile',
    'Perú',
  ];

  final Map<String, String> _phonePrefixes = {
    '+1': '🇺🇸 Estados Unidos / Canadá',
    '+52': '🇲🇽 México',
    '+34': '🇪🇸 España',
    '+506': '🇨🇷 Costa Rica',
    '+57': '🇨🇴 Colombia',
    '+54': '🇦🇷 Argentina',
    '+56': '🇨🇱 Chile',
    '+51': '🇵🇪 Perú',
    '+55': '🇧🇷 Brasil',
    '+593': '🇪🇨 Ecuador',
    '+58': '🇻🇪 Venezuela',
    '+507': '🇵🇦 Panamá',
  };

  final List<String> _languages = [
    'Español',
    'English',
    'Português',
    'Français',
    'Deutsch', // Alemán
    'Italiano',
    '中文', // Chino
    '日本語', // Japonés
    '한국어', // Coreano
    'Русский', // Ruso
    'العربية', // Árabe
    'हिन्दी', // Hindi
  ];

  @override
  void initState() {
    super.initState();
    // Add listeners to password fields for real-time validation
    _currentPasswordController.addListener(_onPasswordFieldChanged);
    _newPasswordController.addListener(_onPasswordFieldChanged);
    _confirmNewPasswordController.addListener(_onPasswordFieldChanged);
  }

  @override
  void dispose() {
    _currentPasswordController.removeListener(_onPasswordFieldChanged);
    _newPasswordController.removeListener(_onPasswordFieldChanged);
    _confirmNewPasswordController.removeListener(_onPasswordFieldChanged);

    _nameController.dispose();
    _phoneController.dispose();
    _phonePrefixController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmNewPasswordController.dispose();
    _obscureCurrentPasswordNotifier.dispose();
    _obscureNewPasswordNotifier.dispose();
    _obscureConfirmNewPasswordNotifier.dispose();
    super.dispose();
  }

  /// Re-validate password fields when any password field changes
  void _onPasswordFieldChanged() {
    if (_autovalidateMode == AutovalidateMode.onUserInteraction) {
      _formKey.currentState?.validate();
    }
  }

  void _populateFormFields(User user) {
    _nameController.text = user.displayName;
    _emailController.text = user.email;
    _phoneController.text = user.phone ?? '';

    // Set phone prefix from user data or default
    final userPrefix = user.phonePrefix ?? '+506';
    _selectedPhonePrefix = _phonePrefixes.containsKey(userPrefix) ? userPrefix : '+506';
    _phonePrefixController.text = _selectedPhonePrefix;

    _addressController.text = user.address ?? '';
    _selectedCountry = user.country ?? _countries.first;
    _selectedLanguage = user.language ?? _languages.first;
  }

  /// Validator for current password field
  String? _validateCurrentPassword(String? value) {
    final hasAnyPasswordInput = _newPasswordController.text.isNotEmpty ||
        _confirmNewPasswordController.text.isNotEmpty;

    if (hasAnyPasswordInput && (value == null || value.isEmpty)) {
      return 'Debes ingresar tu contraseña actual para cambiarla';
    }

    if (value != null && value.isNotEmpty && value.length < 8) {
      return 'La contraseña debe tener al menos 8 caracteres';
    }

    return null;
  }

  /// Validator for new password field
  String? _validateNewPassword(String? value) {
    final hasAnyPasswordInput = _currentPasswordController.text.isNotEmpty ||
        _confirmNewPasswordController.text.isNotEmpty;

    if (hasAnyPasswordInput && (value == null || value.isEmpty)) {
      return 'Debes ingresar una nueva contraseña';
    }

    if (value != null && value.isNotEmpty && value.length < 8) {
      return 'La contraseña debe tener al menos 8 caracteres';
    }

    return null;
  }

  /// Validator for confirm password field
  String? _validateConfirmPassword(String? value) {
    final hasAnyPasswordInput = _currentPasswordController.text.isNotEmpty ||
        _newPasswordController.text.isNotEmpty;

    if (hasAnyPasswordInput && (value == null || value.isEmpty)) {
      return 'Debes confirmar tu nueva contraseña';
    }

    if (value != null && value.isNotEmpty) {
      if (value.length < 8) {
        return 'La contraseña debe tener al menos 8 caracteres';
      }
      if (value != _newPasswordController.text) {
        return 'Las contraseñas no coinciden';
      }
    }

    return null;
  }

  void _handleSave() {
    // Debouncing: Prevent multiple rapid clicks
    final now = DateTime.now();
    if (_lastSaveAttempt != null &&
        now.difference(_lastSaveAttempt!) < _saveDebounceDuration) {
      // Ignore click if within debounce duration
      return;
    }
    _lastSaveAttempt = now;

    // Enable real-time validation after first submit attempt
    setState(() {
      _autovalidateMode = AutovalidateMode.onUserInteraction;
    });

    if (!_formKey.currentState!.validate()) return;

    final cubit = context.read<ProfileCubit>();
    final currentUser = cubit.authService.currentUser;

    if (currentUser == null) return;

    // Parse name
    final nameParts = _nameController.text.trim().split(' ');
    final firstName = nameParts.isNotEmpty ? nameParts.first : null;
    final lastName = nameParts.length > 1 ? nameParts.skip(1).join(' ') : null;

    // Create updated user
    final updatedUser = currentUser.copyWith(
      firstName: firstName,
      lastName: lastName,
      phone: _phoneController.text.trim().isNotEmpty ? _phoneController.text.trim() : null,
      phonePrefix: _selectedPhonePrefix, // Use dropdown selection
      address: _addressController.text.trim().isNotEmpty ? _addressController.text.trim() : null,
      country: _selectedCountry,
      language: _selectedLanguage,
    );

    // Update profile via cubit
    cubit.updateProfile(updatedUser);

    // Handle password change if any field filled
    final hasAnyPasswordInput = _currentPasswordController.text.isNotEmpty ||
        _newPasswordController.text.isNotEmpty ||
        _confirmNewPasswordController.text.isNotEmpty;

    if (hasAnyPasswordInput) {
      // Show confirmation dialog before changing password
      _showPasswordChangeConfirmation();
    }
  }

  /// Shows confirmation dialog before password change
  Future<void> _showPasswordChangeConfirmation() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.lock_outline, color: AppTheme.primaryPurple),
            const SizedBox(width: 8),
            const Text('Confirmar Cambio de Contraseña'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '¿Estás seguro de que deseas cambiar tu contraseña?',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.primaryPurple.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '⚠️ Importante:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text('• Deberás usar la nueva contraseña en tu próximo inicio de sesión'),
                  Text('• Asegúrate de recordar tu nueva contraseña'),
                  Text('• Este cambio es irreversible'),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text(
              'Cancelar',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryPurple,
            ),
            child: const Text('Confirmar Cambio'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      // User confirmed, proceed with password change
      final cubit = context.read<ProfileCubit>();
      cubit.changePassword(
        currentPassword: _currentPasswordController.text,
        newPassword: _newPasswordController.text,
      );
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.errorRed,
      ),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_outline, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: AppTheme.primaryGreen,
      ),
    );

    // Clear password fields after successful change
    if (message.contains('Contraseña')) {
      _currentPasswordController.clear();
      _newPasswordController.clear();
      _confirmNewPasswordController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.bgGray,
      child: BlocListener<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is ProfileSaveSuccess) {
            _showSuccess(state.message ?? 'Perfil actualizado exitosamente');
          } else if (state is PasswordChangeSuccess) {
            _showSuccess(state.message ?? 'Contraseña cambiada exitosamente');
          } else if (state is ProfileError) {
            _showError(state.message);
          }
        },
        child: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            // Populate form when profile is loaded
            if (state is ProfileLoaded) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _populateFormFields(state.user);
              });
            }

            final isLoadingProfile = state is ProfileLoading ||
                state is ProfileSaveInProgress;
            final isLoadingPassword = state is PasswordChangeInProgress;
            final isLoading = isLoadingProfile || isLoadingPassword;

            return CommonWidgets.centeredContent(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  _buildProfileCard(
                    isLoading: isLoading,
                    isLoadingProfile: isLoadingProfile,
                    isLoadingPassword: isLoadingPassword,
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildProfileCard({
    required bool isLoading,
    required bool isLoadingProfile,
    required bool isLoadingPassword,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          autovalidateMode: _autovalidateMode,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header with loading indicator for profile
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Editar Perfil',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.secondaryBlue,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  if (isLoadingProfile) ...[
                    const SizedBox(width: 12),
                    const SizedBox(
                      height: 16,
                      width: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryGreen),
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 24),

              // Name
              FormFields.text(
                controller: _nameController,
                label: 'Nombre Completo',
                icon: Icons.person,
                validator: AppValidators.required,
              ),
              const SizedBox(height: 16),

              // Email (read-only)
              FormFields.email(
                controller: _emailController,
                enabled: false,
              ),
              const SizedBox(height: 16),

              // Phone Prefix + Phone
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: DropdownButtonFormField<String>(
                      value: _selectedPhonePrefix,
                      decoration: InputDecoration(
                        labelText: 'Código',
                        prefixIcon: const Icon(Icons.flag),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                      ),
                      items: _phonePrefixes.entries
                          .map((entry) => DropdownMenuItem(
                                value: entry.key,
                                child: Text(
                                  entry.key,
                                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                                ),
                              ))
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _selectedPhonePrefix = value;
                            _phonePrefixController.text = value;
                          });
                        }
                      },
                      selectedItemBuilder: (context) {
                        return _phonePrefixes.entries.map((entry) {
                          return Text(
                            entry.key,
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                          );
                        }).toList();
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 5,
                    child: FormFields.phone(controller: _phoneController),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Address
              FormFields.text(
                controller: _addressController,
                label: 'Dirección',
                icon: Icons.location_on,
              ),
              const SizedBox(height: 16),

              // Country Dropdown
              DropdownButtonFormField<String>(
                value: _selectedCountry,
                decoration: InputDecoration(
                  labelText: 'País',
                  prefixIcon: const Icon(Icons.public),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                items: _countries
                    .map((country) => DropdownMenuItem(
                          value: country,
                          child: Text(country),
                        ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _selectedCountry = value);
                  }
                },
              ),
              const SizedBox(height: 16),

              // Language Dropdown
              DropdownButtonFormField<String>(
                value: _selectedLanguage,
                decoration: InputDecoration(
                  labelText: 'Idioma',
                  prefixIcon: const Icon(Icons.language),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                items: _languages
                    .map((lang) => DropdownMenuItem(
                          value: lang,
                          child: Text(lang),
                        ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _selectedLanguage = value);
                  }
                },
              ),
              const SizedBox(height: 32),

              // Password Section with loading indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Cambiar Contraseña (Opcional)',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.secondaryBlue,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  if (isLoadingPassword) ...[
                    const SizedBox(width: 12),
                    const SizedBox(
                      height: 16,
                      width: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryGreen),
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 20),

              FormFields.password(
                controller: _currentPasswordController,
                obscureNotifier: _obscureCurrentPasswordNotifier,
                label: 'Contraseña Actual',
                minLength: 8,
                required: false,
                validator: _validateCurrentPassword,
              ),
              const SizedBox(height: 16),

              FormFields.password(
                controller: _newPasswordController,
                obscureNotifier: _obscureNewPasswordNotifier,
                label: 'Contraseña Nueva',
                minLength: 8,
                required: false,
                validator: _validateNewPassword,
              ),
              const SizedBox(height: 16),

              FormFields.password(
                controller: _confirmNewPasswordController,
                obscureNotifier: _obscureConfirmNewPasswordNotifier,
                label: 'Repetir Contraseña',
                minLength: 8,
                required: false,
                validator: _validateConfirmPassword,
              ),
              const SizedBox(height: 32),

              // Save Button
              ElevatedButton(
                onPressed: isLoading ? null : _handleSave,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.secondaryBlue,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        'Guardar Cambios',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
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

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../core/utils/validators.dart';
import '../../../../shared/widgets/index.dart';
import '../providers/auth_providers.dart';
import '../providers/register_provider.dart';

/// Pantalla de Crear Usuario
/// Implementa Clean Architecture y i18n
class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Controllers
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _prefixController = TextEditingController();
  final _phoneController = TextEditingController();

  // Dropdowns
  String? _selectedCountry;
  String? _selectedLanguage;
  
  // Mock data
  // Mock data
  final List<String> _countries = [
    'Colombia', 
    'Costa Rica',
    'El Salvador',
    'España', 
    'Guatemala',
    'Honduras',
    'México', 
    'Nicaragua',
    'Panamá',
    'Argentina', 
    'Chile'
  ];
  final List<String> _languages = ['Español', 'English', 'Português'];
  final List<String> _phonePrefixes = [
    '+57', // Colombia
    '+506', // Costa Rica
    '+503', // El Salvador
    '+34', // España
    '+502', // Guatemala
    '+504', // Honduras
    '+52', // México
    '+505', // Nicaragua
    '+507', // Panamá
    '+54', // Argentina
    '+56', // Chile
  ];

  // State
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _prefixController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _handleRegister() async {
    final l10n = AppLocalizations.of(context)!;
    
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final notifier = ref.read(registerNotifierProvider.notifier);
    final state = ref.read(registerNotifierProvider);

    if (!state.acceptTerms) {
      SnackbarHelper.showError(context, l10n.registerErrorTerms);
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      SnackbarHelper.showError(context, l10n.validationPasswordsNoMatch);
      return;
    }

    final success = await notifier.register(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text,
      phone: '${_prefixController.text} ${_phoneController.text}'.trim(),
      address: _addressController.text.trim(),
      country: _selectedCountry,
      language: _selectedLanguage,
    );

    if (success && mounted) {
      SnackbarHelper.showSuccess(context, l10n.registerSuccess);
      context.go('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(registerNotifierProvider);
    final notifier = ref.read(registerNotifierProvider.notifier);

    // Error listener
    ref.listen(registerNotifierProvider, (previous, next) {
      if (next.errorMessage != null && !next.isLoading) {
        SnackbarHelper.showError(context, next.errorMessage!);
        notifier.clearError();
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Header: Título e Isologotipo
                  PageHeader(
                    title: l10n.registerTitle,
                    titleFontSize: 28, // Ajustado a 28 para coincidir con Login
                    showBackButton: true,
                    showLogo: true,
                    enableMenu: false, // Menu disabled
                    onBack: () => context.go('/'), // Explicitly go to login
                  ),
                  
                  const SizedBox(height: 24),

                  // Campo Nombre
                  // Campo Nombre
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.registerNameLabel,
                        style: GoogleFonts.montserrat(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF333333),
                        ),
                      ),
                      const SizedBox(height: 8),
                      AuthInputField(
                        hintText: l10n.registerNameHint,
                        prefixIcon: Icons.person_outline,
                        controller: _nameController,
                        validator: (value) => Validators.required(value, context),
                        enabled: !state.isLoading,
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Campo Correo
                  // Campo Correo
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.registerEmailLabel,
                        style: GoogleFonts.montserrat(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF333333),
                        ),
                      ),
                      const SizedBox(height: 8),
                      AuthInputField(
                        hintText: l10n.registerEmailHint,
                        prefixIcon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                        controller: _emailController,
                        validator: (value) => Validators.email(value, context),
                        enabled: !state.isLoading,
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Campo Dirección
                  // Campo Dirección
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.registerAddressLabel,
                        style: GoogleFonts.montserrat(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF333333),
                        ),
                      ),
                      const SizedBox(height: 8),
                      AuthInputField(
                        hintText: l10n.registerAddressHint,
                        prefixIcon: Icons.location_on_outlined,
                        controller: _addressController,
                        validator: (value) => Validators.required(value, context),
                        enabled: !state.isLoading,
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // País
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.registerCountryLabel,
                        style: GoogleFonts.montserrat(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF333333),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFFE0E0E0)),
                          borderRadius: BorderRadius.circular(12),
                          color: state.isLoading ? Colors.grey.shade100 : Colors.white,
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            isExpanded: true,
                            value: _selectedCountry,
                            hint: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              child: Text(
                                l10n.registerCountryHint,
                                style: GoogleFonts.montserrat(
                                  fontSize: 16,
                                  color: const Color(0xFF999999),
                                ),
                              ),
                            ),
                            items: _countries.map((country) {
                              return DropdownMenuItem(
                                value: country,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  child: Text(
                                    country,
                                    style: GoogleFonts.montserrat(fontSize: 16),
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: state.isLoading 
                              ? null 
                              : (value) => setState(() => _selectedCountry = value),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Idioma
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.registerLanguageLabel,
                        style: GoogleFonts.montserrat(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF333333),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFFE0E0E0)),
                          borderRadius: BorderRadius.circular(12),
                          color: state.isLoading ? Colors.grey.shade100 : Colors.white,
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            isExpanded: true,
                            value: _selectedLanguage,
                            hint: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              child: Text(
                                l10n.registerLanguageHint,
                                style: GoogleFonts.montserrat(
                                  fontSize: 16,
                                  color: const Color(0xFF999999),
                                ),
                              ),
                            ),
                            items: _languages.map((language) {
                              return DropdownMenuItem(
                                value: language,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  child: Text(
                                    language,
                                    style: GoogleFonts.montserrat(fontSize: 16),
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: state.isLoading 
                              ? null 
                              : (value) => setState(() => _selectedLanguage = value),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Campo Contraseña
                  // Campo Contraseña
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.registerPasswordLabel,
                        style: GoogleFonts.montserrat(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF333333),
                        ),
                      ),
                      const SizedBox(height: 8),
                      AuthInputField(
                        hintText: l10n.registerPasswordHint,
                        prefixIcon: Icons.lock_outline,
                        isPassword: true,
                        controller: _passwordController,
                        validator: (value) => Validators.password(value, context),
                        enabled: !state.isLoading,
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Campo Repetir Contraseña
                  // Campo Repetir Contraseña
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.registerConfirmPasswordLabel,
                        style: GoogleFonts.montserrat(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF333333),
                        ),
                      ),
                      const SizedBox(height: 8),
                      AuthInputField(
                        hintText: l10n.registerConfirmPasswordHint,
                        prefixIcon: Icons.lock_outline,
                        isPassword: true,
                        controller: _confirmPasswordController,
                        validator: (value) => Validators.required(value, context),
                        enabled: !state.isLoading,
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Prefijo y Teléfono en fila
                  Row(
                    children: [
                      // Prefijo (pequeño)
                      Expanded(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.registerPhonePrefixLabel,
                              style: GoogleFonts.montserrat(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF333333),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: const Color(0xFFE0E0E0)),
                                borderRadius: BorderRadius.circular(12),
                                color: state.isLoading ? Colors.grey.shade100 : Colors.white,
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  isExpanded: true,
                                  value: _prefixController.text.isEmpty ? null : _prefixController.text,
                                  hint: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8),
                                    child: Text(
                                      '+57',
                                      style: GoogleFonts.montserrat(
                                        fontSize: 14,
                                        color: const Color(0xFF999999),
                                      ),
                                    ),
                                  ),
                                  items: _phonePrefixes.map((prefix) {
                                    return DropdownMenuItem(
                                      value: prefix,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 8),
                                        child: Text(
                                          prefix,
                                          style: GoogleFonts.montserrat(fontSize: 14),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: state.isLoading 
                                    ? null 
                                    : (value) => setState(() => _prefixController.text = value ?? ''),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Teléfono (grande)
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.registerPhoneLabel,
                              style: GoogleFonts.montserrat(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF333333),
                              ),
                            ),
                            const SizedBox(height: 8),
                            AuthInputField(
                              hintText: l10n.registerPhoneHint,
                              keyboardType: TextInputType.phone,
                              controller: _phoneController,
                              validator: (value) => Validators.required(value, context),
                              enabled: !state.isLoading,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Declaración de conformidad (Checkbox)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFFE0E0E0)),
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                    ),
                    child: GestureDetector(
                      onTap: state.isLoading ? null : () => notifier.toggleAcceptTerms(),
                      child: Row(
                        children: [
                          Checkbox(
                            value: state.acceptTerms,
                            onChanged: state.isLoading ? null : (value) => notifier.toggleAcceptTerms(),
                            activeColor: const Color(0xFF673AB7),
                          ),
                          Expanded(
                            child: Text(
                              l10n.registerAcceptTerms,
                              style: GoogleFonts.montserrat(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xFF333333),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Botón Vincular Usuario
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: state.isLoading ? null : _handleRegister,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0A3057),
                        foregroundColor: Colors.white,
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        disabledBackgroundColor: Colors.grey.shade400,
                      ),
                      child: state.isLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                                ),
                            )
                          : Text(
                              l10n.registerButton,
                              style: GoogleFonts.montserrat(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Link a Login
                  GestureDetector(
                    onTap: state.isLoading ? null : () => context.go('/'),
                    child: RichText(
                      text: TextSpan(
                        text: l10n.registerAlreadyHaveAccount,
                        style: GoogleFonts.montserrat(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF666666),
                        ),
                        children: [
                          TextSpan(
                            text: l10n.registerLoginLink,
                            style: GoogleFonts.montserrat(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF0066CC),
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

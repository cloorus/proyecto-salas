import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/index.dart';
import '../providers/login_provider.dart';

/// Pantalla de Login según mockup 1_login.png
/// Con logo B.gnius, campos con iconos, checkbox "Recuérdame", y botones estilizados
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController(text: 'admin@bgnius.com');
  final _passwordController = TextEditingController(text: 'Test1234!');
  final _formKey = GlobalKey<FormState>();
  // State moved to loginProvider

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;
    
    // Use provider to execute login
    final success = await ref.read(loginProvider.notifier).login(
      _emailController.text,
      _passwordController.text,
    );
    
    if (!mounted) return;
    
    if (success) {
      if (!mounted) return;
      context.go('/devices');
    } else {
      final error = ref.read(loginProvider).errorMessage;
      SnackbarHelper.showError(
        context, 
        error ?? AppLocalizations.of(context)!.loginInvalidCredentials,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Watch login state from provider
    final loginState = ref.watch(loginProvider);
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Calcula el tamaño responsivo
          final screenWidth = constraints.maxWidth;
          final screenHeight = constraints.maxHeight;

          // Ancho máximo de contenido: 90% del ancho o 850px (aumentado)
          final contentWidth = screenWidth > 700 ? 850.0 : screenWidth * 0.90;
          final horizontalPadding = (screenWidth - contentWidth) / 2;

          // Tamaños de fuente responsivos según especificaciones
          // Tamaños de fuente responsivos fijos para mejor legibilidad
          final welcomeFontSize = screenWidth > 700 ? 34.0 : 30.0;
          final buttonFontSize = 18.0;
          final labelFontSize = 16.0;

          return SafeArea(
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: (screenHeight - 48).clamp(0.0, double.infinity),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Espaciado superior
                        SizedBox(height: screenHeight * 0.03),

                        // Logo BGnius
                        Image.asset(
                          'assets/images/logo_imagotipo.png',
                          width: screenWidth > 700
                              ? screenWidth * 0.5
                              : screenWidth * 0.6,
                          height: screenWidth > 700 ? 80 : 90,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                             return const Icon(Icons.error, size: 80);
                          },
                        ),

                        // Espaciado antes de los campos
                        SizedBox(height: screenHeight * 0.08),

                        // Campo Correo
                        SizedBox(
                          width: contentWidth,
                          child: AuthInputField(
                            controller: _emailController,
                            hintText: AppLocalizations.of(context)!.loginEmailHint,
                            prefixIcon: Icons.person_outline,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            validator: (value) => Validators.email(value, context),
                            enabled: !loginState.isLoading,
                          ),
                        ),

                        // Espaciado entre campos
                        const SizedBox(height: 16),

                        // Campo Contraseña
                        SizedBox(
                          width: contentWidth,
                          child: AuthInputField(
                            controller: _passwordController,
                            hintText: AppLocalizations.of(context)!.loginPasswordHint,
                            prefixIcon: Icons.lock_outline,
                            isPassword: true,
                            textInputAction: TextInputAction.done,
                            validator: (value) => Validators.required(value, context),
                            enabled: !loginState.isLoading,
                            onFieldSubmitted: (_) => _handleLogin(),
                            showPasswordText: AppLocalizations.of(context)!.loginShowPassword,
                            hidePasswordText: AppLocalizations.of(context)!.loginHidePassword,
                          ),
                        ),


                        // Recuérdame y Olvidé mi contraseña
                        const SizedBox(height: 12),
                        SizedBox(
                          width: contentWidth,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Checkbox Recuérdame
                              LabeledCheckbox(
                                label: AppLocalizations.of(context)!.loginRememberMe,
                                value: loginState.rememberMe,
                                onChanged: loginState.isLoading 
                                  ? null 
                                  : (value) {
                                      ref.read(loginProvider.notifier).toggleRememberMe();
                                    },
                                enabled: !loginState.isLoading,
                              ),
                              // Olvide mi contraseña
                              TextButton(
                                onPressed: loginState.isLoading
                                    ? null
                                    : () => context.push('/forgot-password'),
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: Size.zero,
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: Text(
                                  AppLocalizations.of(context)!.loginForgotPassword,
                                  style: GoogleFonts.montserrat(
                                    fontSize: labelFontSize,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.error,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Espaciado antes del botón Ingresar
                        SizedBox(height: screenHeight * 0.04),

                        // Botón Ingresar
                        AuthButton(
                          text: AppLocalizations.of(context)!.loginButton,
                          onPressed: _handleLogin,
                          isLoading: loginState.isLoading,
                          width: contentWidth * 0.5,
                        ),

                        // Espaciado antes del botón Crear Usuario
                        SizedBox(height: screenHeight * 0.15),

                        // Botón Crear Usuario
                        AuthButton(
                          text: AppLocalizations.of(context)!.loginCreateAccount,
                          onPressed: () => context.push('/register'),
                          isOutline: true,
                          width: contentWidth * 0.5,
                        ),

                      // Enlace discreto a Biblioteca de Componentes
                      const SizedBox(height: 24),
                      TextButton(
                        onPressed: loginState.isLoading
                            ? null
                            : () => context.push('/component-library'),
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          AppLocalizations.of(context)!.loginLibraryLink,
                          style: GoogleFonts.montserrat(
                            fontSize: labelFontSize * 0.85,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),

                      // Espaciado inferior
                      SizedBox(height: screenHeight * 0.04),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
        },
      ),
    );
  }
}



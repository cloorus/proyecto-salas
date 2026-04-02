import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:async';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../core/utils/validators.dart';
import '../../../../shared/widgets/index.dart';
import '../providers/auth_providers.dart';
import '../providers/forgot_password_provider.dart';

/// Pantalla de Restablecer Contraseña
/// Implementa Clean Architecture y i18n
class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _codeController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _repeatPasswordController = TextEditingController();
  
  Timer? _timer;

  @override
  void dispose() {
    _emailController.dispose();
    _codeController.dispose();
    _newPasswordController.dispose();
    _repeatPasswordController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    final notifier = ref.read(forgotPasswordNotifierProvider.notifier);
    int timeLeft = 60;
    notifier.updateTimer(timeLeft);
    
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timeLeft > 0) {
        timeLeft--;
        notifier.updateTimer(timeLeft);
      } else {
        timer.cancel();
      }
    });
  }

  Future<void> _handleGetCode() async {
    final l10n = AppLocalizations.of(context)!;
    
    if (_emailController.text.isEmpty) {
      SnackbarHelper.showError(context, l10n.forgotPasswordErrorEmail);
      return;
    }

    final notifier = ref.read(forgotPasswordNotifierProvider.notifier);
    final success = await notifier.sendCode(_emailController.text.trim());

    if (success && mounted) {
      SnackbarHelper.showSuccess(context, l10n.forgotPasswordCodeSent(_emailController.text));
      _startTimer();
    }
  }

  Future<void> _handleResetPassword() async {
    final l10n = AppLocalizations.of(context)!;
    
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_newPasswordController.text != _repeatPasswordController.text) {
      SnackbarHelper.showError(context, l10n.forgotPasswordErrorPasswordMismatch);
      return;
    }

    final notifier = ref.read(forgotPasswordNotifierProvider.notifier);
    final success = await notifier.resetPassword(
      email: _emailController.text.trim(),
      code: _codeController.text.trim(),
      newPassword: _newPasswordController.text,
    );

    if (success && mounted) {
      SnackbarHelper.showSuccess(context, l10n.forgotPasswordSuccess);
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(forgotPasswordNotifierProvider);
    final notifier = ref.read(forgotPasswordNotifierProvider.notifier);

    // Error listener
    ref.listen(forgotPasswordNotifierProvider, (previous, next) {
      if (next.errorMessage != null && !next.isLoading) {
        SnackbarHelper.showError(context, next.errorMessage!);
        notifier.clearError();
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final screenWidth = constraints.maxWidth;
          final screenHeight = constraints.maxHeight;
          
          final contentWidth = screenWidth > 700 ? 850.0 : screenWidth * 0.90;
          final horizontalPadding = (screenWidth - contentWidth) / 2;
          
          // Tamaños de fuente fijos para legibilidad (mismos que Login)
          final titleFontSize = screenWidth > 700 ? 34.0 : 30.0;
          final buttonFontSize = 18.0;
          final timerTextSize = 16.0;
          final timerCounterSize = 26.0;
          final resetButtonTextSize = 18.0;

          return SafeArea(
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: screenHeight - 48),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: screenHeight * 0.04),
                        
                        // Header
                        SizedBox(
                          width: contentWidth,
                          child: PageHeader(
                            title: l10n.forgotPasswordTitle,
                            titleFontSize: titleFontSize,
                            showBackButton: true,
                            showLogo: true,
                            enableMenu: false, // Menu disabled
                            onBack: () => context.go('/'), // Explicitly go to login
                          ),
                        ),
                        
                        SizedBox(height: screenHeight * 0.05),
                        
                        // Campo Correo/Usuario
                        AuthInputField(
                          hintText: l10n.forgotPasswordEmailHint,
                          prefixIcon: Icons.person_outline,
                          keyboardType: TextInputType.emailAddress,
                          controller: _emailController,
                          enabled: !state.codeSent && !state.isLoading,
                          validator: (value) => state.codeSent ? null : Validators.email(value, context),
                        ),
                        
                        const SizedBox(height: 12),
                        
                        // Botón o Timer
                        if (!state.codeSent)
                          Container(
                            width: contentWidth * 0.65,
                            height: 40,
                            decoration: BoxDecoration(
                              color: const Color(0xFF0066CC),
                              borderRadius: BorderRadius.circular(50),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.blue.shade300,
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: ElevatedButton(
                              onPressed: state.isLoading ? null : _handleGetCode,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF0066CC),
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
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
                                      l10n.forgotPasswordGetCodeButton,
                                      style: GoogleFonts.montserrat(
                                        fontSize: buttonFontSize,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                      ),
                                    ),
                            ),
                          )
                        else
                          Container(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.access_time,
                                  color: const Color(0xFFFFA500),
                                  size: screenWidth > 700 ? 24 : 20,
                                ),
                                const SizedBox(width: 16),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      l10n.forgotPasswordTimeRemaining,
                                      style: GoogleFonts.montserrat(
                                        fontSize: timerTextSize,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFF0A3057),
                                      ),
                                    ),
                                    Text(
                                      l10n.forgotPasswordTimeRemainingOf,
                                      style: GoogleFonts.montserrat(
                                        fontSize: timerTextSize,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFF0A3057),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 16),
                                Text(
                                  '${state.timeLeft}s',
                                  style: GoogleFonts.montserrat(
                                    fontSize: timerCounterSize,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF0A3057),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        
                        if (state.codeSent) ...[
                          SizedBox(height: screenHeight * 0.05),
                          
                          // Campo Nueva Contraseña
                          // Campo Nueva Contraseña
                          AuthInputField(
                            hintText: l10n.forgotPasswordNewPasswordHint,
                            prefixIcon: Icons.lock_outline,
                            enabled: !state.isLoading,
                            isPassword: true,
                            controller: _newPasswordController,
                            validator: (value) => Validators.password(value, context),
                          ),
                          
                          const SizedBox(height: 12),
                          
                          // Campo Repetir Contraseña
                          // Campo Repetir Contraseña
                          AuthInputField(
                            hintText: l10n.forgotPasswordRepeatPasswordHint,
                            prefixIcon: Icons.lock_outline,
                            enabled: !state.isLoading,
                            isPassword: true,
                            controller: _repeatPasswordController,
                            validator: (value) => Validators.required(value, context),
                          ),
                          
                          const SizedBox(height: 12),
                          
                          // Campo Código Temporal
                          // Campo Código Temporal
                          AuthInputField(
                            hintText: l10n.forgotPasswordCodeHint,
                            keyboardType: TextInputType.number,
                            enabled: !state.isLoading,
                            controller: _codeController,
                            validator: (value) => Validators.required(value, context),
                          ),
                          
                          SizedBox(height: screenHeight * 0.05),
                          
                          // Botón Restablecer
                          Container(
                            width: contentWidth * 0.65,
                            height: 40,
                            decoration: BoxDecoration(
                              color: const Color(0xFF662d91),
                              borderRadius: BorderRadius.circular(50),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.purple.shade300,
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: ElevatedButton(
                              onPressed: state.isLoading ? null : _handleResetPassword,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF662d91),
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
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
                                      l10n.forgotPasswordResetButton,
                                      style: GoogleFonts.montserrat(
                                        fontSize: resetButtonTextSize,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                      ),
                                    ),
                            ),
                          ),
                        ],
                        
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

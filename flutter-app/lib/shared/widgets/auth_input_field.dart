import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../core/theme/app_colors.dart';

/// Campo de texto personalizado para pantallas de autenticación
/// 
/// Características:
/// - Estilo neumórfico con sombras
/// - Bordes redondeados (50px)
/// - Icono opcional (prefixIcon)
/// - Soporte para contraseñas con botón "Mostrar"
/// - Estados: normal, loading (disabled), error con sombra rojiza
/// 
/// Ejemplo:
/// ```dart
/// AuthInputField(
///   controller: emailController,
///   hintText: 'Correo',
///   prefixIcon: Icons.person_outline,
///   keyboardType: TextInputType.emailAddress,
///   validator: Validators.email,
/// )
/// ```
class AuthInputField extends StatefulWidget {
  final TextEditingController? controller;
  final String hintText;
  final IconData? prefixIcon;
  final bool isPassword;
  final String? Function(String?)? validator;
  final bool enabled;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final void Function(String)? onChanged;
  final void Function(String)? onFieldSubmitted;
  final String? showPasswordText;  // NEW
  final String? hidePasswordText;  // NEW

  const AuthInputField({
    super.key,
    this.controller,
    required this.hintText,
    this.prefixIcon,
    this.isPassword = false,
    this.validator,
    this.enabled = true,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.onChanged,
    this.onFieldSubmitted,
    this.showPasswordText,  // NEW
    this.hidePasswordText,  // NEW
  });

  @override
  State<AuthInputField> createState() => _AuthInputFieldState();
}

class _AuthInputFieldState extends State<AuthInputField> {
  bool _obscureText = true;
  String? _errorText;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final labelFontSize = screenWidth > 700 ? 16.0 : 16.0; // Fixed legible size for inputs
    final hasError = _errorText != null && _errorText!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(50),
            border: Border.all(
              color: hasError 
                  ? const Color(0xFFE53935).withValues(alpha: 0.3)  // Rojo suave para borde
                  : AppColors.inputBorder,
              width: hasError ? 1.0 : 0.5,
            ),
            boxShadow: [
              BoxShadow(
                color: hasError 
                    ? const Color(0xFFE53935).withValues(alpha: 0.4)  // Sombra rojiza cuando hay error
                    : Colors.black.withValues(alpha: 0.4),            // Sombra negra normal
                blurRadius: 10,
                spreadRadius: 0,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: TextFormField(
              controller: widget.controller,
              enabled: widget.enabled,
              obscureText: widget.isPassword && _obscureText,
              keyboardType: widget.keyboardType,
              textInputAction: widget.textInputAction,
              textAlignVertical: TextAlignVertical.center,
              validator: (value) {
                final error = widget.validator?.call(value);
                // Actualizar el estado del error para cambiar la sombra
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted) {
                    setState(() => _errorText = error);
                  }
                });
                return error;
              },
              onChanged: (value) {
                // Limpiar error al escribir
                if (_errorText != null) {
                  setState(() => _errorText = null);
                }
                widget.onChanged?.call(value);
              },
              onFieldSubmitted: widget.onFieldSubmitted,
              style: GoogleFonts.montserrat(
                fontSize: labelFontSize,
                color: Colors.black,
              ),
              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: GoogleFonts.montserrat(
                  fontSize: labelFontSize,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
                prefixIcon: widget.prefixIcon != null
                    ? Icon(
                        widget.prefixIcon,
                        color: Colors.black,
                        size: 24,
                      )
                    : null,
                suffixIcon: widget.isPassword
                    ? TextButton(
                        onPressed: widget.enabled
                            ? () => setState(() => _obscureText = !_obscureText)
                            : null,
                        child: Text(
                          _obscureText 
                            ? (widget.showPasswordText ?? AppLocalizations.of(context)!.showPasswordButton)
                            : (widget.hidePasswordText ?? AppLocalizations.of(context)!.hidePasswordButton),
                          style: GoogleFonts.montserrat(
                            fontSize: labelFontSize * 0.85,
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      )
                    : null,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                focusedErrorBorder: InputBorder.none,
                errorStyle: const TextStyle(height: 0, fontSize: 0), // Ocultar mensaje de error por defecto
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ),
        ),
        // Mostrar mensaje de error debajo del campo (opcional, más sutil)
        if (hasError)
          Padding(
            padding: const EdgeInsets.only(left: 24, top: 6),
            child: Text(
              _errorText!,
              style: GoogleFonts.montserrat(
                fontSize: labelFontSize * 0.85,
                color: const Color(0xFFE53935),
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
      ],
    );
  }
}

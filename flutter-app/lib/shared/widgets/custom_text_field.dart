import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

/// Campo de texto personalizado según el Design System de BGnius VITA
/// 
/// Características:
/// - Bordes redondeados (25px)
/// - Icono opcional a la izquierda
/// - Botón mostrar/ocultar para contraseñas
/// - Estados: normal, enfocado, error, deshabilitado
/// - Validación integrada
class CustomTextField extends StatefulWidget {
  final String hintText;
  final String? labelText;
  final IconData? prefixIcon;
  final bool isPassword;
  final bool enabled;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final int maxLines;
  final bool autofocus;
  final FocusNode? focusNode;
  final EdgeInsetsGeometry? contentPadding;

  const CustomTextField({
    super.key,
    required this.hintText,
    this.labelText,
    this.prefixIcon,
    this.isPassword = false,
    this.enabled = true,
    this.controller,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.onChanged,
    this.onSubmitted,
    this.maxLines = 1,
    this.autofocus = false,
    this.focusNode,
    this.contentPadding,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;
  String? _errorText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label opcional
        if (widget.labelText != null) ...[
          Text(
            widget.labelText!,
            style: AppTextStyles.inputLabel,
          ),
          const SizedBox(height: 8),
        ],
        
        // Campo de texto
        TextFormField(
          controller: widget.controller,
          obscureText: widget.isPassword && _obscureText,
          enabled: widget.enabled,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          maxLines: widget.isPassword ? 1 : widget.maxLines,
          autofocus: widget.autofocus,
          focusNode: widget.focusNode,
          style: AppTextStyles.inputText,
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: AppTextStyles.inputHint,
            errorText: _errorText,
            errorStyle: AppTextStyles.inputError,
            
            // Icono izquierdo
            prefixIcon: widget.prefixIcon != null
                ? Icon(
                    widget.prefixIcon,
                    color: AppColors.textSecondary,
                    size: 22,
                  )
                : null,
            
            // Botón mostrar/ocultar contraseña
            suffixIcon: widget.isPassword
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                    icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                      color: Colors.black,
                      size: 20,
                    ),
                  )
                : null,
            suffixIconConstraints: const BoxConstraints(
              minHeight: 0,
              minWidth: 0,
            ),
            
            // Padding interno
            contentPadding: widget.contentPadding ?? const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 16,
            ),
            
            // Bordes
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: const BorderSide(
                color: AppColors.inputBorder,
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: const BorderSide(
                color: AppColors.inputBorder,
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: const BorderSide(
                color: AppColors.primaryPurple,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: const BorderSide(
                color: AppColors.error,
                width: 1,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: const BorderSide(
                color: AppColors.error,
                width: 2,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide(
                color: AppColors.inputBorder.withValues(alpha: 0.5),
                width: 1,
              ),
            ),
            
            // Fondo
            filled: true,
            fillColor: widget.enabled 
                ? AppColors.surface 
                : AppColors.background,
          ),
          
          validator: (value) {
            if (widget.validator != null) {
              final error = widget.validator!(value);
              // Actualizar estado de error para mostrar borde rojo
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) {
                  setState(() {
                    _errorText = error;
                  });
                }
              });
              return error;
            }
            return null;
          },
          
          onChanged: widget.onChanged,
          onFieldSubmitted: widget.onSubmitted,
        ),
      ],
    );
  }
}

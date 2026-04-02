import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

/// Tipos de botón disponibles
enum ButtonType {
  primary,    // Púrpura - acciones principales
  secondary,  // Azul - acciones secundarias
  danger,     // Rojo - eliminar, cancelar
  success,    // Verde - confirmar, agregar
  outline,    // Borde púrpura, fondo transparente
  text,       // Solo texto
}

/// Botón personalizado según el Design System de BGnius VITA
/// 
/// Características:
/// - Múltiples variantes (primary, secondary, danger, success, outline, text)
/// - Estados: enabled, disabled, loading
/// - Icono opcional a la izquierda
/// - Animación de escala al presionar
class CustomButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonType type;
  final IconData? icon;
  final bool isLoading;
  final bool isExpanded;
  final double? width;
  final double height;
  final double fontSize;
  final Color? backgroundColor;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = ButtonType.primary,
    this.icon,
    this.isLoading = false,
    this.isExpanded = true,
    this.width,
    this.height = 52,
    this.fontSize = 16,
    this.backgroundColor,
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  bool get _isEnabled => widget.onPressed != null && !widget.isLoading;

  Color get _backgroundColor {
    if (!_isEnabled) {
      return AppColors.textDisabled;
    }
    if (widget.backgroundColor != null) {
      return widget.backgroundColor!;
    }
    switch (widget.type) {
      case ButtonType.primary:
        return AppColors.primaryPurple;
      case ButtonType.secondary:
        return AppColors.secondaryBlue;
      case ButtonType.danger:
        return AppColors.error;
      case ButtonType.success:
        return AppColors.success;
      case ButtonType.outline:
      case ButtonType.text:
        return Colors.transparent;
    }
  }

  Color get _textColor {
    if (!_isEnabled && widget.type != ButtonType.outline && widget.type != ButtonType.text) {
      return Colors.white;
    }
    switch (widget.type) {
      case ButtonType.primary:
      case ButtonType.secondary:
      case ButtonType.danger:
      case ButtonType.success:
        return Colors.white;
      case ButtonType.outline:
        return _isEnabled ? AppColors.primaryPurple : AppColors.textDisabled;
      case ButtonType.text:
        return _isEnabled ? AppColors.primaryPurple : AppColors.textDisabled;
    }
  }

  Border? get _border {
    if (widget.type == ButtonType.outline) {
      return Border.all(
        color: _isEnabled ? AppColors.primaryPurple : AppColors.textDisabled,
        width: 2,
      );
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _isEnabled ? (_) => _animationController.forward() : null,
      onTapUp: _isEnabled ? (_) => _animationController.reverse() : null,
      onTapCancel: _isEnabled ? () => _animationController.reverse() : null,
      onTap: _isEnabled ? widget.onPressed : null,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          );
        },
        child: Container(
          width: widget.isExpanded ? double.infinity : widget.width,
          height: widget.height,
          padding: (!widget.isExpanded && widget.width == null) 
              ? const EdgeInsets.symmetric(horizontal: 24) 
              : null,
          decoration: BoxDecoration(
            color: _backgroundColor,
            borderRadius: BorderRadius.circular(30),
            border: _border,
            boxShadow: widget.type != ButtonType.outline && 
                       widget.type != ButtonType.text && 
                       _isEnabled
                ? [
                    BoxShadow(
                      color: _backgroundColor.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Center(
            widthFactor: (!widget.isExpanded && widget.width == null) ? 1.0 : null,
            child: widget.isLoading
                ? SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(_textColor),
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (widget.icon != null) ...[
                        Icon(
                          widget.icon,
                          color: _textColor,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                      ],
                      Text(
                        widget.text,
                        style: AppTextStyles.buttonText.copyWith(
                          color: _textColor,
                          fontSize: widget.fontSize,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

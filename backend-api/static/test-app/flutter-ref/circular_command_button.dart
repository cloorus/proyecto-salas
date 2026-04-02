import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

/// Botón circular estilo BGnius VITA para comandos de dispositivos.
///
/// Diseño basado en la interfaz BGnius:
/// - Círculo blanco con sombra sutil
/// - Icono coloreado en el centro
/// - Texto descriptivo debajo
/// - Estado deshabilitado con opacidad reducida
///
/// Ejemplo de uso:
/// ```dart
/// CircularCommandButton(
///   icon: Icons.lock_open,
///   label: 'Abrir',
///   color: AppTheme.primaryGreen,
///   onPressed: () => _sendCommand('OPEN'),
///   isEnabled: hasPermission,
/// )
/// ```
class CircularCommandButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback? onPressed;
  final bool isEnabled;
  final double size;

  const CircularCommandButton({
    Key? key,
    required this.icon,
    required this.label,
    required this.color,
    this.onPressed,
    this.isEnabled = true,
    this.size = 70,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool enabled = isEnabled && onPressed != null;

    return Opacity(
      opacity: enabled ? 1.0 : 0.4,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Círculo con icono
          Material(
            color: Colors.white,
            shape: const CircleBorder(),
            elevation: enabled ? 3 : 1,
            shadowColor: Colors.black.withOpacity(0.15),
            child: InkWell(
              onTap: enabled ? onPressed : null,
              customBorder: const CircleBorder(),
              child: Container(
                width: size,
                height: size,
                alignment: Alignment.center,
                child: Icon(
                  icon,
                  color: enabled ? color : Colors.grey.shade400,
                  size: size * 0.5,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Texto
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: enabled ? AppTheme.textDark : Colors.grey.shade500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

/// Botón circular pequeño para controles secundarios.
///
/// Variante compacta del CircularCommandButton para acciones secundarias
/// como lámpara, relé, bloquear, etc.
class CircularSecondaryButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback? onPressed;
  final bool isEnabled;
  final bool isActive;

  const CircularSecondaryButton({
    Key? key,
    required this.icon,
    required this.label,
    required this.color,
    this.onPressed,
    this.isEnabled = true,
    this.isActive = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool enabled = isEnabled && onPressed != null;

    return Opacity(
      opacity: enabled ? 1.0 : 0.4,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Círculo pequeño
          Material(
            color: isActive && enabled ? color.withOpacity(0.1) : Colors.white,
            shape: CircleBorder(
              side: isActive && enabled
                  ? BorderSide(color: color, width: 2)
                  : BorderSide.none,
            ),
            elevation: enabled ? 2 : 1,
            shadowColor: Colors.black.withOpacity(0.1),
            child: InkWell(
              onTap: enabled ? onPressed : null,
              customBorder: const CircleBorder(),
              child: Container(
                width: 56,
                height: 56,
                alignment: Alignment.center,
                child: Icon(
                  icon,
                  color: enabled ? color : Colors.grey.shade400,
                  size: 28,
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          // Texto
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: enabled ? AppTheme.textDark : Colors.grey.shade500,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

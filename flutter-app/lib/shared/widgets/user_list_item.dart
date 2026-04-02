import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

/// Tipos de acceso de usuario
enum UserAccessType { 
  user, 
  bluetooth, 
  physicalControl 
}

/// Widget reutilizable para mostrar un item de usuario en una lista
/// 
/// Este componente soporta diferentes estilos y comportamientos:
/// - Usuarios normales vs administradores (estilo oscuro)
/// - Estados seleccionables con checkbox
/// - Iconos según tipo de acceso (Usuario, Bluetooth, Control Físico)
/// - Acción de edición integrada
/// 
/// Ejemplo de uso:
/// ```dart
/// UserListItem(
///   name: 'Carlos',
///   type: UserAccessType.user,
///   isAdmin: true,
///   onEditPressed: () => _editUser(),
/// )
/// ```
class UserListItem extends StatelessWidget {
  /// Nombre del usuario a mostrar
  final String name;
  
  /// Tipo de acceso del usuario
  final UserAccessType type;
  
  /// Si el usuario es administrador (aplica estilo oscuro)
  final bool isAdmin;
  
  /// Si el item está seleccionado (muestra check verde)
  final bool isSelected;
  
  /// Si el item es clickeable (para selección)
  final bool isClickable;
  
  /// Callback cuando se hace tap en el item (para selección)
  final VoidCallback? onTap;
  
  /// Callback cuando se presiona el botón "Editar"
  final VoidCallback? onEditPressed;

  const UserListItem({
    super.key,
    required this.name,
    required this.type,
    this.isAdmin = false,
    this.isSelected = false,
    this.isClickable = false,
    this.onTap,
    this.onEditPressed,
  });

  /// Determina el icono según el tipo de usuario
  IconData _getIconData() {
    switch (type) {
      case UserAccessType.bluetooth:
        return Icons.bluetooth;
      case UserAccessType.physicalControl:
        return Icons.sensors;
      case UserAccessType.user:
        return Icons.person_outline;
    }
  }

  /// Determina el color del icono según el tipo
  Color _getIconColor() {
    if (isAdmin) return Colors.white70;
    
    switch (type) {
      case UserAccessType.bluetooth:
        return const Color(0xFF1976D2);
      case UserAccessType.physicalControl:
      case UserAccessType.user:
        return AppColors.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Colores según si es admin o no
    final Color bgColor = isAdmin ? const Color(0xFF424242) : Colors.white;
    final Color textColor = isAdmin ? Colors.white : AppColors.textPrimary;
    final Color editColor = isAdmin ? Colors.white70 : AppColors.textSecondary;

    return GestureDetector(
      onTap: isClickable ? onTap : null,
      child: Container(
        height: 60,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(50),
          border: isAdmin ? null : Border.all(color: const Color(0xFFE0E0E0)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icono del tipo de usuario
            Icon(
              _getIconData(),
              color: _getIconColor(),
              size: 28,
            ),
            const SizedBox(width: 16),

            // Nombre del usuario
            Expanded(
              child: Text(
                name,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w500,
                  color: textColor,
                ),
              ),
            ),

            // Check verde si está seleccionado
            if (isSelected) ...[ 
              const Icon(
                Icons.check,
                color: Color(0xFF4CAF50),
                size: 28,
              ),
              const SizedBox(width: 12),
            ],

            // Botón Editar
            if (onEditPressed != null)
              GestureDetector(
                onTap: onEditPressed,
                child: Text(
                  AppLocalizations.of(context)!.editButton,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: editColor,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

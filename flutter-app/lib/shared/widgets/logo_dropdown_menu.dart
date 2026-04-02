import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

/// Menú desplegable que aparece al hacer clic en el logo
class LogoDropdownMenu extends StatelessWidget {
  const LogoDropdownMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _MenuItem(
            icon: Icons.devices,
            title: 'Dispositivos',
            onTap: () {
              Navigator.pop(context);
              context.go('/devices');
            },
          ),
          const Divider(height: 1),
          _MenuItem(
            icon: Icons.group,
            title: 'Grupos',
            onTap: () {
              Navigator.pop(context);
              context.go('/groups');
            },
          ),

          const Divider(height: 1),
          _MenuItem(
            icon: Icons.settings,
            title: 'Configuración',
            onTap: () {
              Navigator.pop(context);
              context.go('/settings');
            },
          ),
          const Divider(height: 1),
          _MenuItem(
            icon: Icons.logout,
            title: 'Cerrar sesión',
            onTap: () {
              Navigator.pop(context);
              context.go('/');
            },
            isDestructive: true,
          ),
        ],
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool isDestructive;

  const _MenuItem({
    required this.icon,
    required this.title,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: isDestructive ? Colors.red : const Color(0xFF662d91),
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: GoogleFonts.montserrat(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isDestructive ? Colors.red : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Función helper para mostrar el menú
void showLogoMenu(BuildContext context, Offset position) {
  showMenu(
    context: context,
    position: RelativeRect.fromLTRB(
      position.dx,
      position.dy + 10,
      position.dx + 200,
      position.dy + 300,
    ),
    items: [
      PopupMenuItem(
        padding: EdgeInsets.zero,
        child: const LogoDropdownMenu(),
      ),
    ],
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    elevation: 8,
  );
}

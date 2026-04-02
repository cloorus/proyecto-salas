import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../core/theme/app_colors.dart';

/// Bottom Navigation Bar personalizado para BGnius VITA
/// 
/// 4 tabs principales:
/// - Dispositivos
/// - Grupos
/// - Usuarios
/// - Configuraciones
class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                index: 0,
                icon: Icons.devices_outlined,
                activeIcon: Icons.devices,
                label: AppLocalizations.of(context)!.navDevices,
              ),
              _buildNavItem(
                index: 1,
                icon: Icons.group_work_outlined,
                activeIcon: Icons.group_work,
                label: AppLocalizations.of(context)!.navGroups,
              ),
              _buildNavItem(
                index: 2,
                icon: Icons.people_outline,
                activeIcon: Icons.people,
                label: AppLocalizations.of(context)!.navUsers,
              ),
              _buildNavItem(
                index: 3,
                icon: Icons.settings_outlined,
                activeIcon: Icons.settings,
                label: AppLocalizations.of(context)!.navSettings,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
  }) {
    final isActive = currentIndex == index;

    return Expanded(
      child: Semantics(
        label: label + (isActive ? ' (selected)' : ''),
        button: true,
        selected: isActive,
        child: InkWell(
          onTap: () => onTap(index),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isActive ? activeIcon : icon,
                  color: isActive ? AppColors.primaryPurple : AppColors.textSecondary,
                  size: 26,
                  semanticLabel: label,
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                    color: isActive ? AppColors.primaryPurple : AppColors.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

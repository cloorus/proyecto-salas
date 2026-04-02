import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

/// AppBar personalizado para BGnius VITA
/// 
/// Características:
/// - Título centrado en azul oscuro
/// - Icono de casa a la derecha
/// - Botón back cuando aplique
/// - Fondo transparente
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final bool showHomeButton;
  final VoidCallback? onHomePressed;
  final List<Widget>? actions;
  final Color? backgroundColor;

  const CustomAppBar({
    super.key,
    required this.title,
    this.showBackButton = true,
    this.showHomeButton = true,
    this.onHomePressed,
    this.actions,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: AppTextStyles.appBarTitle,
      ),
      centerTitle: true,
      backgroundColor: backgroundColor ?? Colors.transparent,
      elevation: 0,
      leading: showBackButton
          ? IconButton(
              icon: const Icon(Icons.arrow_back),
              color: AppColors.titleBlue,
              onPressed: () => Navigator.of(context).pop(),
            )
          : null,
      actions: [
        if (showHomeButton)
          IconButton(
            icon: const Icon(Icons.home_outlined),
            color: AppColors.titleBlue,
            onPressed: onHomePressed ?? () {
              // Navegar a home
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
          ),
        if (actions != null) ...actions!,
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

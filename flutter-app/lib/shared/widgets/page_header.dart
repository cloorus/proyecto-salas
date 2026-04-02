import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart'; // Asegurar importación de colores
import 'logo_dropdown_menu.dart';

/// Encabezado de página estandarizado con Título Centrado y Logo a la derecha
class PageHeader extends StatelessWidget {
  final String title;
  final double titleFontSize;
  final bool showBackButton;
  final bool showLogo;
  final bool enableMenu; // Nuevo parámetro para controlar el menú
  final VoidCallback? onBack;

  const PageHeader({
    super.key,
    required this.title,
    this.titleFontSize = 24.0, // Tamaño responsive por defecto
    this.showBackButton = false,
    this.showLogo = true,
    this.enableMenu = true, // Por defecto habilitado
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Forzar altura mínima para evitar que el logo se corte
          const SizedBox(height: 60, width: double.infinity),

          // Título Centrado (Fondo)
          // Título Centrado (Fondo)
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 60.0), // Mayor margen para evitar solapamiento con logo
              child: Text(
                title,
                style: GoogleFonts.montserrat(
                  fontSize: titleFontSize,
                  fontWeight: FontWeight.w600,
                  color: AppColors.titleBlue,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),

          // Botón Back (Izquierda - Capa Superior)
          if (showBackButton)
            Positioned(
              left: 0,
              child: IconButton(
                icon: const Icon(Icons.arrow_back),
                color: AppColors.titleBlue, // Usar color del tema
                onPressed: onBack ?? () => context.pop(),
              ),
            ),

          // Logo alineado a la derecha (Capa Superior)
          if (showLogo)
            Positioned(
              right: 0,
              child: enableMenu
                  ? GestureDetector(
                      onTap: () {
                        // Obtener posición del widget para mostrar menú debajo
                        final RenderBox renderBox =
                            context.findRenderObject() as RenderBox;
                        final position = renderBox.localToGlobal(Offset.zero);
                        showLogoMenu(
                          context,
                          Offset(position.dx + renderBox.size.width - 200,
                              position.dy + 50),
                        );
                      },
                      child: Image.asset(
                        'assets/images/logoMenu.png',
                        height: 40, // Ajustar altura según necesidad
                        fit: BoxFit.contain,
                      ),
                    )
                  : SvgPicture.asset(
                      'assets/images/IconoLogo_transparente.svg',
                      width: 35,
                      height: 40,
                      fit: BoxFit.contain,
                    ),
            ),
        ],
      ),
    );
  }
}


import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/device.dart';

/// Tarjeta de dispositivo con imagen grande
///
/// - Imagen a pantalla completa de la tarjeta
/// - Nombre en banner inferior semitransparente
/// - Borde dorado si isPrimary
/// - Punto de estado online/offline
/// - Imagen por defecto si imageUrl es null
class DeviceImageCard extends StatelessWidget {
  final Device device;
  final VoidCallback onTap;
  final VoidCallback? onDoubleTap;

  const DeviceImageCard({
    super.key,
    required this.device,
    required this.onTap,
    this.onDoubleTap,
  });

  @override
  Widget build(BuildContext context) {
    final isPrimary = device.isPrimary;

    return GestureDetector(
      onTap: onTap,
      onDoubleTap: onDoubleTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isPrimary
                ? const Color(0xFFFFB300) // Dorado para principal
                : AppColors.primaryPurple, // Púrpura para todos los demás
            width: isPrimary ? 3 : 2,
          ),
          boxShadow: [
            BoxShadow(
              color: isPrimary
                  ? const Color(0xFFFFB300).withValues(alpha: 0.35)
                  : AppColors.primaryPurple.withValues(alpha: 0.15),
              blurRadius: isPrimary ? 12 : 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(isPrimary ? 13 : 16),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Imagen del dispositivo
              _buildImage(),

              // Gradient overlay inferior
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.72),
                        Colors.transparent,
                      ],
                    ),
                  ),
                  child: Text(
                    device.name,
                    style: GoogleFonts.montserrat(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),

              // Indicador online/offline (superior derecha)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: device.isOnline
                        ? AppColors.statusOnline
                        : AppColors.statusOffline,
                    border: Border.all(color: Colors.white, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),
              ),

              // Badge "Principal" (superior izquierda)
              if (isPrimary)
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFB300),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Principal',
                      style: GoogleFonts.montserrat(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImage() {
    if (device.imageUrl != null && device.imageUrl!.isNotEmpty) {
      return Image.network(
        device.imageUrl!,
        fit: BoxFit.cover,
        headers: const {'Accept': 'image/webp,image/*'},
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AppColors.primaryPurple.withValues(alpha: 0.5),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          debugPrint('IMAGE ERROR: $error for ${device.imageUrl}');
          return _buildDefaultPlaceholder();
        },
      );
    }
    return _buildDefaultPlaceholder();
  }


  Widget _buildDefaultPlaceholder() {
    return Container(
      color: const Color(0xFFE8E8E8),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/images/IconoLogo_transparente.svg',
              width: 56,
              height: 56,
              colorFilter: ColorFilter.mode(
                AppColors.primaryPurple.withValues(alpha: 0.4),
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              device.type.displayName,
              style: GoogleFonts.montserrat(
                fontSize: 11,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';

/// Avatar circular para mostrar usuario o iniciales
class UserAvatar extends StatelessWidget {
  final String? imageUrl;
  final String initials;
  final double size;
  final Color? backgroundColor;

  const UserAvatar({
    super.key,
    this.imageUrl,
    required this.initials,
    this.size = 60,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: size / 2,
      backgroundColor: backgroundColor ?? AppColors.primaryPurple,
      backgroundImage: imageUrl != null ? NetworkImage(imageUrl!) : null,
      child: imageUrl == null
          ? Text(
              initials,
              style: GoogleFonts.poppins(
                fontSize: size * 0.4,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            )
          : null,
    );
  }
}

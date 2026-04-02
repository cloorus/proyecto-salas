import 'package:flutter/material.dart';

/// CustomPainter que dibuja la forma del tab con esquinas superiores redondeadas
/// y curvas cóncavas ("orejas") en las esquinas inferiores, siguiendo el diseño
/// del proyecto smart_home_control.
class TabShapePainter extends CustomPainter {
  final Color color;
  final double topLeftRadius;
  final double topRightRadius;
  final double earRadius;

  TabShapePainter({
    required this.color,
    this.topLeftRadius = 10.0,
    this.topRightRadius = 10.0,
    this.earRadius = 8.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();

    // Comenzamos desde la esquina inferior izquierda (con la "oreja" curva)
    path.moveTo(0, size.height);

    // Curva cóncava de la "oreja" izquierda (hacia arriba y luego hacia la derecha)
    path.quadraticBezierTo(
      earRadius,
      size.height,
      earRadius,
      size.height - earRadius,
    );

    // Línea vertical izquierda (hacia arriba)
    path.lineTo(earRadius, topLeftRadius);

    // Esquina superior izquierda redondeada
    path.quadraticBezierTo(
      earRadius,
      0,
      earRadius + topLeftRadius,
      0,
    );

    // Línea horizontal superior
    path.lineTo(size.width - earRadius - topRightRadius, 0);

    // Esquina superior derecha redondeada
    path.quadraticBezierTo(
      size.width - earRadius,
      0,
      size.width - earRadius,
      topRightRadius,
    );

    // Línea vertical derecha (hacia abajo)
    path.lineTo(size.width - earRadius, size.height - earRadius);

    // Curva cóncava de la "oreja" derecha
    path.quadraticBezierTo(
      size.width - earRadius,
      size.height,
      size.width,
      size.height,
    );

    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant TabShapePainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.topLeftRadius != topLeftRadius ||
        oldDelegate.topRightRadius != topRightRadius ||
        oldDelegate.earRadius != earRadius;
  }
}

/// Widget wrapper para usar TabShapePainter fácilmente
class TabShape extends StatelessWidget {
  final Color color;
  final Widget? child;
  final double topLeftRadius;
  final double topRightRadius;
  final double earRadius;

  const TabShape({
    super.key,
    required this.color,
    this.child,
    this.topLeftRadius = 10.0,
    this.topRightRadius = 10.0,
    this.earRadius = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: TabShapePainter(
        color: color,
        topLeftRadius: topLeftRadius,
        topRightRadius: topRightRadius,
        earRadius: earRadius,
      ),
      child: child,
    );
  }
}

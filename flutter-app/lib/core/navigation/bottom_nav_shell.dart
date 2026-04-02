import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../shared/widgets/custom_bottom_nav_bar.dart';

/// Shell de navegación con Bottom Navigation Bar
/// 
/// Envuelve las 4 pantallas principales y mantiene el estado
/// de navegación entre ellas
class BottomNavShell extends StatefulWidget {
  final Widget child;
  final String location;

  const BottomNavShell({
    super.key,
    required this.child,
    required this.location,
  });

  @override
  State<BottomNavShell> createState() => _BottomNavShellState();
}

class _BottomNavShellState extends State<BottomNavShell> {
  int _calculateSelectedIndex(String location) {
    if (location.startsWith('/devices')) return 0;
    if (location.startsWith('/groups')) return 1;
    if (location.startsWith('/users')) return 2;
    if (location.startsWith('/settings')) return 3;
    return 0;
  }

  void _onItemTapped(int index) {
    switch (index) {
      case 0:
        context.go('/devices');
        break;
      case 1:
        context.go('/groups');
        break;
      case 2:
        context.go('/users');
        break;
      case 3:
        context.go('/settings');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Bottom nav bar deshabilitada — navegación via menú lateral o header
    final shouldShowBottomNav = false;
    
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: shouldShowBottomNav 
          ? CustomBottomNavBar(
              currentIndex: _calculateSelectedIndex(widget.location),
              onTap: _onItemTapped,
            )
          : null,
    );
  }
}

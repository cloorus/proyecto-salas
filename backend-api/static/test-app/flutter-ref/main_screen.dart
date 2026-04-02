import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../core/services/auth_service.dart';
import '../core/theme/app_theme.dart';
import '../features/devices/presentation/screens/devices_screen_provider.dart';
import '../features/auth/presentation/screens/profile_screen_provider.dart';
import '../features/support/presentation/screens/support_request_list_screen_provider.dart';

/// MainScreen with BottomNavigationBar
///
/// Contains 3 tabs:
/// - Dispositivos (DevicesScreen)
/// - Configuración (ProfileScreen)
/// - Soporte (SupportRequestListScreen)
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  // Tab screens
  final List<Widget> _screens = const [
    DevicesScreenProvider(),
    ProfileScreenProvider(),
    SupportRequestListScreenProvider(),
  ];

  // Tab titles
  final List<String> _titles = const [
    'Pantalla Principal',
    'Configuración',
    'Soporte',
  ];

  Future<void> _logout() async {
    await context.read<AuthService>().logout();
    if (mounted) {
      Navigator.of(context).pushReplacementNamed('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      drawer: _buildDrawer(),
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      leading: Builder(
        builder: (context) => IconButton(
          icon: const Icon(Icons.menu, color: AppTheme.primaryPurple, size: 28),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
      ),
      title: Text(
        _titles[_currentIndex],
        style: const TextStyle(
          color: AppTheme.titleBlue,
          fontSize: 22,
          fontWeight: FontWeight.w600,
          fontFamily: 'Montserrat',
        ),
      ),
      actions: [
        // Logo BGnius (clickeable para abrir drawer)
        InkWell(
          onTap: () {
            Scaffold.of(context).openDrawer();
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
            child: Image.asset(
              'assets/images/IconoLogo_transparente.png',
              height: 40,
              width: 40,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: AppTheme.primaryPurple),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 40, color: AppTheme.primaryPurple),
                ),
                const SizedBox(height: 12),
                Text(
                  context.read<AuthService>().currentUser?.email ?? 'Usuario',
                  style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.devices, color: AppTheme.primaryPurple, size: 24),
            title: const Text('Dispositivos'),
            onTap: () {
              Navigator.pop(context);
              setState(() => _currentIndex = 0);
            },
          ),
          ListTile(
            leading: const Icon(Icons.shield, color: AppTheme.primaryPurple, size: 24),
            title: const Text('Gestionar Permisos'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/permissions');
            },
          ),
          ListTile(
            leading: const Icon(Icons.support_agent, color: AppTheme.primaryPurple, size: 24),
            title: const Text('Mis Solicitudes de Soporte'),
            onTap: () {
              Navigator.pop(context);
              setState(() => _currentIndex = 2);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: AppTheme.primaryPurple, size: 24),
            title: const Text('Cerrar Sesión'),
            onTap: () {
              Navigator.pop(context);
              _logout();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: (index) {
        setState(() => _currentIndex = index);
      },
      selectedItemColor: AppTheme.primaryPurple,
      unselectedItemColor: Colors.grey,
      selectedFontSize: 14,
      unselectedFontSize: 12,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.devices),
          label: 'Dispositivos',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Configuración',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.support_agent),
          label: 'Soporte',
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../navigation/bottom_nav_shell.dart';
import '../../features/auth/presentation/screens/l_login_screen.dart';
import '../../features/auth/presentation/screens/b_register_screen.dart';
import '../../features/auth/presentation/screens/m_reset_password_screen.dart';
import '../../features/devices/presentation/screens/a_devices_list_screen.dart';
import '../../features/devices/presentation/screens/device_control_screen.dart';

import '../../features/devices/presentation/screens/c_technical_contact_screen.dart';
import '../../features/devices/presentation/screens/ble_pairing_screen.dart';
import '../../features/devices/presentation/screens/k_event_log_screen.dart';
import '../../features/devices/presentation/screens/h_device_info_screen.dart';
import '../../features/devices/presentation/screens/r_device_all_details_screen.dart';
import '../../features/devices/presentation/screens/g_shared_users_screen.dart';
import '../../features/devices/presentation/screens/device_detail_screen.dart';
import '../../features/devices/presentation/screens/i_device_parameters_screen.dart';
import '../../features/devices/presentation/screens/p_link_virtual_user_screen.dart';
import '../../features/devices/presentation/screens/f_device_edit_screen.dart';
import '../../features/devices/presentation/screens/d_add_device_screen.dart';
import '../../features/groups/presentation/screens/e_groups_screen.dart';
import '../../features/users/presentation/screens/o_users_screen.dart';
import '../../features/users/presentation/screens/user_access_screen.dart';
import '../../features/users/presentation/screens/n_user_roles_screen.dart';
import '../../features/settings/presentation/screens/q_settings_screen.dart';
import '../../features/notifications/presentation/screens/notifications_screen.dart';
import '../../features/notifications/presentation/screens/notification_preferences_screen.dart';
import '../../features/design_system/component_library_screen.dart';

import '../../features/devices/domain/entities/device.dart';
import '../services/api_client.dart';

/// Rutas públicas que no requieren autenticación
const _publicRoutes = ['/', '/register', '/forgot-password', '/component-library', '/logout'];

/// Configuración de rutas de la aplicación con Bottom Navigation
final appRouter = GoRouter(
  initialLocation: '/',
  redirect: (context, state) {
    final location = state.uri.toString();
    final isPublicRoute = _publicRoutes.any((r) => location == r || location.startsWith('$r?') || location.startsWith('$r/') && r != '/');
    
    // Handle logout route
    if (location == '/logout') {
      // Clear tokens and redirect to login
      ApiClient.instance.clearTokens();
      return '/';
    }
    
    // If going to a protected route without a token, redirect to login
    if (!isPublicRoute && !ApiClient.instance.hasValidToken) {
      return '/';
    }
    
    return null;
  },
  routes: [
    // ========== AUTH ROUTES (Outside Shell) ==========
    GoRoute(
      path: '/',
      name: 'login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      name: 'register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/forgot-password',
      name: 'forgot-password',
      builder: (context, state) => const ForgotPasswordScreen(),
    ),
    GoRoute(
      path: '/component-library',
      name: 'component-library',
      builder: (context, state) => const ComponentLibraryScreen(),
    ),
    // Logout route - handled by redirect above, but needs a route entry
    GoRoute(
      path: '/logout',
      name: 'logout',
      builder: (context, state) => const LoginScreen(),
    ),
    
    // Full Screen Route for User Roles (No Bottom Nav)
    GoRoute(
      path: '/users/:id/roles',
      name: 'user-roles',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return UserRolesScreen(
          device: extra?['device'],
          userId: state.pathParameters['id'],
          userName: extra?['name'],
          userEmail: extra?['email'],
        );
      },
    ),

    // ========== MAIN APP ROUTES (Inside Shell with Bottom Nav) ==========
    ShellRoute(
      builder: (context, state, child) {
        return BottomNavShell(
          location: state.uri.toString(),
          child: child,
        );
      },
      routes: [
        // ========== DEVICES TAB ==========
        GoRoute(
          path: '/devices',
          name: 'devices',
          builder: (context, state) => const DevicesListScreen(),
          routes: [
            GoRoute(
              path: 'ble-pairing',
              name: 'ble-pairing',
              builder: (context, state) => const BlePairingScreen(),
            ),
            GoRoute(
              path: 'add',
              name: 'add-device',
              builder: (context, state) => const AddDeviceScreen(),
            ),
            GoRoute(
              path: ':id/control',
              name: 'device-control',
              builder: (context, state) {
                final deviceId = state.pathParameters['id']!;
                return DeviceControlScreen(deviceId: deviceId);
              },
            ),
            GoRoute(
              path: ':id/technical-contact',
              name: 'technical-contact',
              builder: (context, state) {
                final deviceId = state.pathParameters['id'];
                final device = state.extra as Device?;
                return TechnicalContactScreen(
                  deviceId: deviceId,
                  device: device,
                );
              },
            ),
            GoRoute(
              path: ':id/info',
              name: 'device-info',
              builder: (context, state) {
                final deviceId = state.pathParameters['id']!;
                return DeviceInfoScreen(deviceId: deviceId);
              },
            ),
            GoRoute(
              path: ':id/all-details',
              name: 'device-all-details',
              builder: (context, state) {
                final deviceId = state.pathParameters['id']!;
                return DeviceAllDetailsScreen(deviceId: deviceId);
              },
            ),
            GoRoute(
              path: ':id/events',
              name: 'event-log',
              builder: (context, state) {
                return const EventLogScreen();
              },
            ),
            GoRoute(
              path: ':id/registered-users',
              name: 'registered-users',
              builder: (context, state) {
                final deviceId = state.pathParameters['id'];
                final device = state.extra as Device?;
                return RegisteredUsersScreen(deviceId: deviceId, device: device);
              },
            ),
            GoRoute(
              path: ':id/detail',
              name: 'device-detail',
              builder: (context, state) {
                final deviceId = state.pathParameters['id']!;
                final device = state.extra as Device?;
                return DeviceDetailScreen(deviceId: deviceId, device: device);
              },
            ),
            GoRoute(
              path: ':id/parameters',
              name: 'device-parameters',
              builder: (context, state) {
                final deviceId = state.pathParameters['id']!;
                return DeviceParametersScreen(deviceId: deviceId);
              },
            ),
            GoRoute(
              path: ':id/link-user',
              name: 'link-device-user',
              builder: (context, state) {
                final deviceId = state.pathParameters['id']!;
                return LinkDeviceUserScreen(deviceId: deviceId);
              },
            ),
            GoRoute(
              path: ':id/edit',
              name: 'device-edit',
              builder: (context, state) {
                final deviceId = state.pathParameters['id']!;
                return DeviceEditScreen(deviceId: deviceId);
              },
            ),
            GoRoute(
              path: ':id/edit-properties',
              name: 'device-edit-properties',
              builder: (context, state) {
                final device = state.extra as Device?;
                return AddDeviceScreen(device: device);
              },
            ),
          ],
        ),

        // ========== GROUPS TAB ==========
        GoRoute(
          path: '/groups',
          name: 'groups',
          builder: (context, state) => const GroupsScreen(),
        ),

        // ========== USERS TAB ==========
        GoRoute(
          path: '/users',
          name: 'users',
          builder: (context, state) => const UsersScreen(),
          routes: [
            GoRoute(
              path: ':id/access',
              name: 'user-access',
              builder: (context, state) {
                return const UserAccessScreen();
              },
            ),

          ],
        ),

        // ========== NOTIFICATIONS ==========
        GoRoute(
          path: '/notifications',
          name: 'notifications',
          builder: (context, state) => const NotificationsScreen(),
          routes: [
            GoRoute(
              path: 'preferences',
              name: 'notification-preferences',
              builder: (context, state) => const NotificationPreferencesScreen(),
            ),
          ],
        ),

        // ========== SETTINGS TAB ==========
        GoRoute(
          path: '/settings',
          name: 'settings',
          builder: (context, state) => const SettingsScreen(),
        ),
      ],
    ),
  ],
);

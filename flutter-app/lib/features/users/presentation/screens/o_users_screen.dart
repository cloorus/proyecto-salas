import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/snackbar_helper.dart';
import '../../../../shared/widgets/page_header.dart';
import '../../../../shared/widgets/selectable_list_item.dart';
import '../../../../shared/widgets/user_list_item.dart';

// Re-exportar el enum desde el componente compartido para uso local
export '../../../../shared/widgets/user_list_item.dart' show UserAccessType;

/// Modelo de usuario con acceso
class UserWithAccess {
  final String id;
  final String name;
  final UserAccessType type;
  final bool isAdmin;

  UserWithAccess({
    required this.id,
    required this.name,
    required this.type,
    this.isAdmin = false,
  });
}

/// Pantalla de Usuarios con Accesos
/// Implementación según mockup 9_usuariosConAccesos.png
/// Ruta: /users
class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  // Usuarios con acceso actual
  final List<UserWithAccess> _linkedUsers = [
    UserWithAccess(id: '1', name: '*Carlos', type: UserAccessType.user, isAdmin: true),
    UserWithAccess(id: '2', name: 'Widget Carro Esposa', type: UserAccessType.bluetooth),
    UserWithAccess(id: '3', name: 'Usuario 1', type: UserAccessType.user),
    UserWithAccess(id: '4', name: 'Usuario 2', type: UserAccessType.user),
    UserWithAccess(id: '5', name: 'Usuario con control 1', type: UserAccessType.physicalControl),
  ];

  // Usuarios disponibles para vincular
  List<UserWithAccess> _availableUsers = [
    UserWithAccess(id: '6', name: 'Botón Carro', type: UserAccessType.bluetooth),
    UserWithAccess(id: '7', name: 'Usuario 7', type: UserAccessType.user),
    UserWithAccess(id: '8', name: 'Control', type: UserAccessType.physicalControl),
  ];

  // IDs de usuarios seleccionados para vincular
  Set<String> _selectedUserIds = {};

  void _toggleUserSelection(String userId) {
    setState(() {
      if (_selectedUserIds.contains(userId)) {
        _selectedUserIds.remove(userId);
      } else {
        _selectedUserIds.add(userId);
      }
    });
  }

  void _linkSelectedUsers() {
    if (_selectedUserIds.isEmpty) {
      SnackbarHelper.showError(context, AppLocalizations.of(context)!.usersScreenErrorSelectUsers);
      return;
    }

    final usersToLink = _availableUsers
        .where((user) => _selectedUserIds.contains(user.id))
        .toList();

    setState(() {
      _linkedUsers.addAll(usersToLink);
      _availableUsers.removeWhere((user) => _selectedUserIds.contains(user.id));
      _selectedUserIds.clear();
    });

    SnackbarHelper.showSuccess(
      context,
      AppLocalizations.of(context)!.usersScreenSuccessLinked(usersToLink.length),
    );
  }

  void _editUser(UserWithAccess user) {
    SnackbarHelper.showInfo(context, AppLocalizations.of(context)!.usersScreenEditInfo(user.name));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: Column(
          children: [
            // ========== HEADER ==========
            const SizedBox(height: 16),
            PageHeader(
              title: AppLocalizations.of(context)!.usersScreenTitle,
              titleFontSize: 24,
            ),

            // ========== BANNER INFO DISPOSITIVO ==========
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              color: const Color(0xFFF5F5F5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Columna izquierda
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.usersScreenDeviceLabel,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${AppLocalizations.of(context)!.usersScreenModelLabel} FAC 500 Vita',
                          style: AppTextStyles.bodyMedium,
                        ),
                        Text(
                          '${AppLocalizations.of(context)!.usersScreenSerialLabel} 123456',
                          style: AppTextStyles.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                  // Columna derecha
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${AppLocalizations.of(context)!.usersScreenStatusLabel} En línea',
                          style: AppTextStyles.bodyMedium,
                        ),
                        Text(
                          '${AppLocalizations.of(context)!.usersScreenDetailLabel} motor casa',
                          style: AppTextStyles.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ========== CONTENIDO SCROLLABLE ==========
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Lista de usuarios con acceso
                    ..._linkedUsers.map((user) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: UserListItem(
                        name: user.name,
                        type: user.type,
                        isAdmin: user.isAdmin,
                        onEditPressed: () => _editUser(user),
                      ),
                    )),

                    const SizedBox(height: 24),

                    // ========== SEPARADOR "Usuarios Disponibles:" ==========
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                      decoration: BoxDecoration(
                        color: const Color(0xFF9E9E9E),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Center(
                        child: Text(
                          AppLocalizations.of(context)!.usersScreenAvailableUsersTitle,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Lista de usuarios disponibles
                    ..._availableUsers.map((user) {
                      final isSelected = _selectedUserIds.contains(user.id);
                      return UserListItem(
                        name: user.name,
                        type: user.type,
                        isAdmin: user.isAdmin,
                        isSelected: isSelected,
                        isClickable: true,
                        onTap: () => _toggleUserSelection(user.id),
                        onEditPressed: () => _editUser(user),
                      );
                    }),

                    const SizedBox(height: 32),

                    // ========== BOTÓN CTA ==========
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _linkSelectedUsers,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1976D2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          elevation: 2,
                        ),
                        child: Text(
                          AppLocalizations.of(context)!.usersScreenLinkButton,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

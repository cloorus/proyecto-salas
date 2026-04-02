import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/snackbar_helper.dart';
import '../../../devices/domain/entities/device.dart';

enum AccessType { user, bluetooth, physicalControl }

class UserAccess {
  final String id;
  final String name;
  final AccessType type;
  final bool isAdmin;

  UserAccess({
    required this.id,
    required this.name,
    required this.type,
    this.isAdmin = false,
  });
}

/// Pantalla de Gestión de Accesos de Usuarios a Dispositivos
/// Según mockup 9_usuariosConAccesos.png con mejoras propuestas
class UserAccessScreen extends StatefulWidget {
  final Device? device;
  
  const UserAccessScreen({
    super.key,
    this.device,
  });

  @override
  State<UserAccessScreen> createState() => _UserAccessScreenState();
}

class _UserAccessScreenState extends State<UserAccessScreen> {
  final _linkedSearchController = TextEditingController();
  final _availableSearchController = TextEditingController();
  
  // Usuarios con acceso
  List<UserAccess> _linkedUsers = [
    UserAccess(id: '1', name: '*Carlos', type: AccessType.user, isAdmin: true),
    UserAccess(id: '2', name: 'Widget Carro Esposa', type: AccessType.bluetooth),
    UserAccess(id: '3', name: 'Usuario 1', type: AccessType.user),
    UserAccess(id: '4', name: 'Usuario 2', type: AccessType.user),
    UserAccess(id: '5', name: 'Usuario con control 1', type: AccessType.physicalControl),
  ];
  
  // Usuarios disponibles para vincular
  List<UserAccess> _availableUsers = [
    UserAccess(id: '6', name: 'Botón Carro', type: AccessType.bluetooth),
    UserAccess(id: '7', name: 'Usuario 7', type: AccessType.user),
    UserAccess(id: '8', name: 'Control', type: AccessType.physicalControl),
    UserAccess(id: '9', name: 'Usuario 8', type: AccessType.user),
    UserAccess(id: '10', name: 'Bluetooth Oficina', type: AccessType.bluetooth),
  ];
  
  Set<String> _selectedAvailableIds = {};
  String _linkedSearchQuery = '';
  String _availableSearchQuery = '';

  @override
  void dispose() {
    _linkedSearchController.dispose();
    _availableSearchController.dispose();
    super.dispose();
  }

  List<UserAccess> get _filteredLinkedUsers {
    if (_linkedSearchQuery.isEmpty) return _linkedUsers;
    return _linkedUsers.where((user) => 
      user.name.toLowerCase().contains(_linkedSearchQuery.toLowerCase())
    ).toList();
  }

  List<UserAccess> get _filteredAvailableUsers {
    if (_availableSearchQuery.isEmpty) return _availableUsers;
    return _availableUsers.where((user) => 
      user.name.toLowerCase().contains(_availableSearchQuery.toLowerCase())
    ).toList();
  }

  void _unlinkUser(UserAccess user) {
    if (user.isAdmin) {
      SnackbarHelper.showError(context, AppLocalizations.of(context)!.userAccessErrorAdminUnlink);
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.userAccessUnlinkDialogTitle),
        content: Text(AppLocalizations.of(context)!.userAccessUnlinkDialogContent(user.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.userAccessCancelButton),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _linkedUsers.remove(user);
                _availableUsers.add(user);
              });
              Navigator.pop(context);
              SnackbarHelper.showSuccess(context, AppLocalizations.of(context)!.userAccessSuccessUnlinked(user.name));
            },
            child: Text(AppLocalizations.of(context)!.userAccessUnlinkButton, style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }

  void _linkSelectedUsers() {
    if (_selectedAvailableIds.isEmpty) {
      SnackbarHelper.showError(context, AppLocalizations.of(context)!.userAccessErrorSelectUsers);
      return;
    }

    final usersToLink = _availableUsers
        .where((user) => _selectedAvailableIds.contains(user.id))
        .toList();

    setState(() {
      _linkedUsers.addAll(usersToLink);
      _availableUsers.removeWhere((user) => _selectedAvailableIds.contains(user.id));
      _selectedAvailableIds.clear();
    });

    SnackbarHelper.showSuccess(
      context,
      AppLocalizations.of(context)!.userAccessSuccessLinked(usersToLink.length),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              color: AppColors.surface,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of(context)!.userAccessScreenTitle,
                    style: AppTextStyles.screenTitle.copyWith(
                      color: AppColors.titleBlue,
                      fontSize: 24,
                    ),
                  ),
                  Icon(
                    Icons.home_outlined,
                    size: 32,
                    color: AppColors.titleBlue,
                  ),
                ],
              ),
            ),

            // Panel de información del dispositivo
            if (widget.device != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                color: const Color(0xFFF5F5F5),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(AppLocalizations.of(context)!.userAccessDeviceLabel, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
                          Text('${AppLocalizations.of(context)!.userAccessModelLabel} ${widget.device!.model}', style: AppTextStyles.bodyMedium),
                          Text('${AppLocalizations.of(context)!.userAccessSerialLabel} ${widget.device!.serialNumber}', style: AppTextStyles.bodyMedium),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${AppLocalizations.of(context)!.userAccessStatusLabel} ${widget.device!.status.displayName}', style: AppTextStyles.bodyMedium),
                          Text('${AppLocalizations.of(context)!.userAccessDetailLabel} ${widget.device!.type.displayName}', style: AppTextStyles.bodyMedium),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

            // Contenido scrollable
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // SECCIÓN 1: Usuarios Actualmente Vinculados
                    _buildSectionTitle(
                      AppLocalizations.of(context)!.userAccessLinkedUsersTitle,
                      AppColors.tabPurple,
                      Icons.people,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      AppLocalizations.of(context)!.userAccessLinkedUsersDesc,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),

                    // Búsqueda en usuarios vinculados
                    _buildSearchBar(_linkedSearchController, (value) {
                      setState(() => _linkedSearchQuery = value);
                    }),
                    const SizedBox(height: 12),

                    // Lista de usuarios vinculados
                    ..._filteredLinkedUsers.map((user) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _buildUserItem(
                          user: user,
                          isLinked: true,
                          onUnlink: () => _unlinkUser(user),
                        ),
                      );
                    }).toList(),

                    const SizedBox(height: 32),

                    // SECCIÓN 2: Usuarios Disponibles
                    _buildSectionTitle(
                      AppLocalizations.of(context)!.userAccessAvailableUsersTitle,
                      const Color(0xFF9E9E9E),
                      Icons.person_add,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      AppLocalizations.of(context)!.userAccessAvailableUsersDesc,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),

                    // Búsqueda en usuarios disponibles
                    _buildSearchBar(_availableSearchController, (value) {
                      setState(() => _availableSearchQuery = value);
                    }),
                    const SizedBox(height: 12),

                    // Lista de usuarios disponibles
                    ..._filteredAvailableUsers.map((user) {
                      final isSelected = _selectedAvailableIds.contains(user.id);
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _buildUserItem(
                          user: user,
                          isLinked: false,
                          isSelected: isSelected,
                          onToggle: () {
                            setState(() {
                              if (isSelected) {
                                _selectedAvailableIds.remove(user.id);
                              } else {
                                _selectedAvailableIds.add(user.id);
                              }
                            });
                          },
                        ),
                      );
                    }).toList(),

                    const SizedBox(height: 24),

                    // Botón Vincular
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: _selectedAvailableIds.isEmpty ? null : _linkSelectedUsers,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1976D2),
                          disabledBackgroundColor: Colors.grey[300],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          _selectedAvailableIds.length > 1 
                            ? AppLocalizations.of(context)!.userAccessLinkButtonPlural(_selectedAvailableIds.length)
                            : AppLocalizations.of(context)!.userAccessLinkButtonSingle(_selectedAvailableIds.length),
                          style: TextStyle(
                            color: _selectedAvailableIds.isEmpty ? Colors.grey[600] : Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, Color bgColor, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white, size: 20),
          const SizedBox(width: 8),
          Text(
            title,
            style: AppTextStyles.bodyMedium.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(TextEditingController controller, Function(String) onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: const Color(0xFFBDBDBD)),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: AppLocalizations.of(context)!.userAccessSearchHint,
          hintStyle: AppTextStyles.inputHint,
          prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
          border: InputBorder.none,
          suffixIcon: controller.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, size: 20),
                  onPressed: () {
                    controller.clear();
                    onChanged('');
                  },
                )
              : null,
        ),
      ),
    );
  }

  Widget _buildUserItem({
    required UserAccess user,
    required bool isLinked,
    bool isSelected = false,
    VoidCallback? onToggle,
    VoidCallback? onUnlink,
  }) {
    IconData iconData;
    Color iconColor;

    switch (user.type) {
      case AccessType.bluetooth:
        iconData = Icons.bluetooth;
        iconColor = Colors.blue;
        break;
      case AccessType.physicalControl:
        iconData = Icons.sensors;
        iconColor = AppColors.textSecondary;
        break;
      case AccessType.user:
      default:
        iconData = Icons.person;
        iconColor = AppColors.textSecondary;
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected ? AppColors.success : const Color(0xFFBDBDBD),
          width: isSelected ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Checkbox (solo para usuarios disponibles)
          if (!isLinked) ...[
            Checkbox(
              value: isSelected,
              onChanged: (value) => onToggle?.call(),
              activeColor: AppColors.success,
            ),
            const SizedBox(width: 8),
          ],

          // Icono del tipo de acceso
          Icon(iconData, color: iconColor, size: 24),
          const SizedBox(width: 12),

          // Nombre del usuario
          Expanded(
            child: Text(
              user.name,
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: user.isAdmin ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),

          // Indicador de selección (check verde) - alternativa visual
          if (isSelected && !isLinked)
            Icon(Icons.check_circle, color: AppColors.success, size: 20),

          const SizedBox(width: 8),

          // Botón Editar o Desvincular
          if (isLinked)
            IconButton(
              onPressed: user.isAdmin ? null : onUnlink,
              icon: Icon(
                Icons.person_remove,
                color: user.isAdmin ? Colors.grey : AppColors.error,
                size: 20,
              ),
              tooltip: user.isAdmin ? AppLocalizations.of(context)!.userAccessTooltipAdmin : AppLocalizations.of(context)!.userAccessTooltipUnlink,
            )
          else
            TextButton(
              onPressed: () {
                SnackbarHelper.showInfo(context, AppLocalizations.of(context)!.userAccessEditInfo(user.name));
              },
              child: Text(
                AppLocalizations.of(context)!.userAccessEditButton,
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ),
        ],
      ),
    );
  }
}

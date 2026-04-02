import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/snackbar_helper.dart';
import '../../../../shared/widgets/page_header.dart';
import '../../../devices/domain/entities/device.dart';
import '../../../devices/presentation/providers/permissions_provider.dart'; // Corrected Path
import '../../../devices/presentation/providers/shared_users_provider.dart'; // Import Shared Users (Correct path)

/// Pantalla de Gestión de Roles y Permisos de Usuario en Dispositivo
class UserRolesScreen extends ConsumerStatefulWidget {
  final Device? device;
  final String? userId;
  final String? userName;
  final String? userEmail;
  
  const UserRolesScreen({
    super.key,
    this.device,
    this.userId,
    this.userName,
    this.userEmail,
  });

  @override
  ConsumerState<UserRolesScreen> createState() => _UserRolesScreenState();
}

class _UserRolesScreenState extends ConsumerState<UserRolesScreen> {
  // Permission keys - will be populated with localized strings in build method
  late Map<String, String> _permissionKeys;

  late Map<String, bool> _permissionsState;

  @override
  void initState() {
    super.initState();
    _permissionsState = {};
    
    // Initialize will be done in build method after context is available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializePermissions();
    });
  }
  
  void _initializePermissions() {
    if (mounted && widget.device != null) {
      final currentPerms = ref.read(permissionsProvider)[widget.device!.id] ?? {};
      setState(() {
        for (var entry in _permissionKeys.entries) {
          if (currentPerms.contains(entry.value)) {
            _permissionsState[entry.key] = true;
          }
        }
      });
    }
  }

  void _assignRoles() {
    final l10n = AppLocalizations.of(context)!;
    final selectedActions = <String>{};
    _permissionsState.forEach((key, value) {
      if (value) {
        selectedActions.add(_permissionKeys[key]!);
      }
    });

    if (selectedActions.isEmpty) {
      SnackbarHelper.showError(context, l10n.userRolesErrorNoPermissions);
      return;
    }

    if (widget.device != null) {
        // Guardar permisos en permissionProvider
        ref.read(permissionsProvider.notifier).setPermissions(widget.device!.id, selectedActions);

        // Guardar usuario en SharedUsersProvider (Simulando creación/actualización)
        final userProvider = ref.read(sharedUsersProvider.notifier);
        // Crear un usuario nuevo o actualizar existente
        final newUser = RegisteredUser(
          id: widget.userId ?? DateTime.now().millisecondsSinceEpoch.toString(), // ID simple
          name: widget.userName ?? 'Usuario',
          type: UserType.standard, // Default type
          email: widget.userEmail,
          permissions: selectedActions,
        );
        
        // Obtener la lista actual para verificar existencia
        final currentUsers = ref.read(sharedUsersProvider)[widget.device!.id] ?? [];
        final existingUserIndex = currentUsers.indexWhere((u) => u.id == (widget.userId ?? ''));

        if (existingUserIndex != -1) {
          // Actualizar existente
          final updatedUser = currentUsers[existingUserIndex].copyWith(
            name: widget.userName ?? currentUsers[existingUserIndex].name,
            email: widget.userEmail ?? currentUsers[existingUserIndex].email,
            permissions: selectedActions,
          );
          userProvider.updateUser(widget.device!.id, updatedUser);
        } else {
             // Crear nuevo si no existe
             final newUser = RegisteredUser(
              id: widget.userId == 'new-user-123' 
                  ? DateTime.now().millisecondsSinceEpoch.toString() // Generar ID real si viene de link screen con ID temporal
                  : (widget.userId ?? DateTime.now().millisecondsSinceEpoch.toString()),
              name: widget.userName ?? 'Usuario',
              type: UserType.standard, // Default type
              email: widget.userEmail,
              permissions: selectedActions,
            );
            userProvider.addUser(widget.device!.id, newUser);
        }

        SnackbarHelper.showSuccess(
          context,
          l10n.userRolesSuccessAssigned,
        );

        // Volver a la lista de usuarios
        if (mounted) context.pop();
    } else {
       SnackbarHelper.showError(context, l10n.userRolesErrorUnknownDevice);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    // Initialize permission keys with localized strings
    _permissionKeys = {
      l10n.userRolesPermissionOpen: 'open',
      l10n.userRolesPermissionClose: 'close',
      l10n.userRolesPermissionPause: 'pause',
      l10n.userRolesPermissionPedestrian: 'pedestrian',
      l10n.userRolesPermissionLock: 'lock',
      l10n.userRolesPermissionLight: 'light',
      l10n.userRolesPermissionSwitch: 'aux_switch',
      l10n.userRolesPermissionControlPanel: 'control_panel',
      l10n.userRolesPermissionReports: 'view_events',
      l10n.userRolesPermissionViewContact: 'view_contact',
      l10n.userRolesPermissionViewParams: 'view_params',
      l10n.userRolesPermissionEditDevice: 'edit_device',
      l10n.userRolesPermissionAssignUsers: 'view_users',
    };
    
    // Initialize permissions state if empty
    if (_permissionsState.isEmpty) {
      _permissionsState = {
        for (var key in _permissionKeys.keys) key: false
      };
    }
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
               const SizedBox(height: 16),
               PageHeader(
                title: l10n.userRolesTitle,
                titleFontSize: 22,
                showBackButton: true,
              ),

              const SizedBox(height: 16),

              // Panel de Información del Dispositivo (Estilo TechnicalContact)
              if (widget.device != null)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  color: const Color(0xFFEBEBEB), // Gris claro
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Columna Izquierda
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${l10n.userRolesDeviceLabel}:', style: AppTextStyles.bodyMedium),
                            Text('${l10n.userRolesModelLabel} ${widget.device!.model}', style: AppTextStyles.bodyMedium),
                            Text('${l10n.userRolesSerialLabel} ${widget.device!.serialNumber}', style: AppTextStyles.bodyMedium),
                          ],
                        ),
                      ),
                      // Columna Derecha
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${l10n.userRolesStatusLabel} ${widget.device!.status.displayName}', style: AppTextStyles.bodyMedium),
                             Text('${l10n.userRolesDetailLabel} ${widget.device!.type.displayName}', style: AppTextStyles.bodyMedium),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Campos de Usuario
                    _buildUserField(l10n.userRolesSelectedUserLabel, widget.userName ?? l10n.userRolesNewUserDefault),
                    const SizedBox(height: 16),
                    _buildUserField(l10n.userRolesEmailLabel, widget.userEmail ?? ''),
                    
                    const SizedBox(height: 32),

                    // Sección: Permisos y Roles
                    _buildSectionTitle(l10n.userRolesPermissionsTitle),
                    const SizedBox(height: 16),

                    // Grid de Permisos
                    _buildPermissionsGrid(),

                    const SizedBox(height: 32),

                     // Botón Asignar Roles
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: _assignRoles,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1976D2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: Text(
                          l10n.userRolesAssignButton,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserField(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.bodyMedium.copyWith(color: Colors.grey)),
          Text(value, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1976D2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        title,
        style: AppTextStyles.bodyMedium.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildPermissionsGrid() {
    final l10n = AppLocalizations.of(context)!;
    
    // Definir categorías para visualizar mejor
    final controls = [
      l10n.userRolesPermissionOpen, 
      l10n.userRolesPermissionClose, 
      l10n.userRolesPermissionPause, 
      l10n.userRolesPermissionPedestrian
    ];
    final aux = [
      l10n.userRolesPermissionLock, 
      l10n.userRolesPermissionLight, 
      l10n.userRolesPermissionSwitch
    ];
    final management = [
      l10n.userRolesPermissionControlPanel, 
      l10n.userRolesPermissionReports, 
      l10n.userRolesPermissionViewContact, 
      l10n.userRolesPermissionViewParams, 
      l10n.userRolesPermissionEditDevice, 
      l10n.userRolesPermissionAssignUsers
    ];
    
    // Combinar en columnas
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            children: [
                ...controls.map((k) => _buildCheckboxItem(k)),
                ...aux.map((k) => _buildCheckboxItem(k)),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            children: management.map((k) => _buildCheckboxItem(k)).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildCheckboxItem(String label) {
    final value = _permissionsState[label] ?? false;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        onTap: () {
          setState(() {
            _permissionsState[label] = !value;
          });
        },
        child: Row(
          children: [
            SizedBox(
              width: 24,
              height: 24,
              child: Checkbox(
                value: value,
                onChanged: (newValue) {
                  setState(() {
                    _permissionsState[label] = newValue ?? false;
                  });
                },
                activeColor: const Color(0xFF1976D2),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/page_header.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/selectable_list_item.dart';
import '../../../devices/domain/entities/device.dart';
import '../providers/shared_users_provider.dart';

/// Pantalla de Usuarios Registrados
/// Refinamiento: Selección única, Doble Click para editar, Panel de Info.
class RegisteredUsersScreen extends ConsumerStatefulWidget {
  final String? deviceId;
  final Device? device;

  const RegisteredUsersScreen({
    super.key,
    this.deviceId,
    this.device,
  });

  @override
  ConsumerState<RegisteredUsersScreen> createState() => _RegisteredUsersScreenState();
}

class _RegisteredUsersScreenState extends ConsumerState<RegisteredUsersScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  String _searchQuery = '';
  String? _selectedUserId; // Estado para selección única

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text.toLowerCase();
    });
  }

  void _linkUser() {
    if (widget.deviceId != null) {
      context.push('/devices/${widget.deviceId}/link-user');
    }
  }

  void _navigateToUserRoles(RegisteredUser user) {
     if (widget.deviceId != null) {
         context.pushNamed(
          'user-roles',
          pathParameters: {'id': user.id},
          extra: {
            'name': user.name,
            'email': user.email ?? 'No email',
            'device': widget.device, 
          },
        );
     }
  }

  @override
  Widget build(BuildContext context) {
    // Obtener usuarios del provider
    final deviceId = widget.deviceId ?? '';
    final allUsers = ref.watch(sharedUsersProvider)[deviceId] ?? [];

    final filteredUsers = allUsers.where((user) {
      return user.name.toLowerCase().contains(_searchQuery);
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),
            // Header
            PageHeader(
              title: AppLocalizations.of(context)!.sharedUsersTitle,
              titleFontSize: 24,
              showBackButton: true,
            ),
            
             const SizedBox(height: 16),

             // Panel de Información del Dispositivo (Nuevo Requerimiento)
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
                            Text(AppLocalizations.of(context)!.sharedUsersDeviceLabel, style: AppTextStyles.bodyMedium),
                            Text('${AppLocalizations.of(context)!.sharedUsersModelLabel} ${widget.device!.model}', style: AppTextStyles.bodyMedium),
                            Text('${AppLocalizations.of(context)!.sharedUsersSerialLabel} ${widget.device!.serialNumber}', style: AppTextStyles.bodyMedium),
                          ],
                        ),
                      ),
                      // Columna Derecha
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${AppLocalizations.of(context)!.sharedUsersStatusLabel} ${widget.device!.status.displayName}', style: AppTextStyles.bodyMedium),
                             Text('${AppLocalizations.of(context)!.sharedUsersDetailLabel} ${widget.device!.type.displayName}', style: AppTextStyles.bodyMedium),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

            // Contenido principal
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Campo de búsqueda
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFE3F2FD),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: AppColors.inputBorder,
                          width: 1,
                        ),
                      ),
                      child: TextField(
                        controller: _searchController,
                        style: AppTextStyles.bodyMedium,
                        decoration: InputDecoration(
                          hintText: AppLocalizations.of(context)!.sharedUsersSearchHint,
                          hintStyle: AppTextStyles.inputHint.copyWith(
                            color: Colors.black54,
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.black54,
                            semanticLabel: AppLocalizations.of(context)!.sharedUsersSearchHint,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 14,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Lista de usuarios
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                             BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                             )
                          ]
                        ),
                        child: filteredUsers.isEmpty 
                        ? Center(
                            child: Semantics(
                              liveRegion: true,
                              child: Text(
                                AppLocalizations.of(context)!.sharedUsersEmptyList, 
                                style: AppTextStyles.bodyMedium.copyWith(color: Colors.grey)
                              ),
                            )
                          )
                        : Scrollbar(
                          controller: _scrollController,
                          thumbVisibility: true,
                          thickness: 6,
                          radius: const Radius.circular(4),
                          child: ListView.separated(
                            controller: _scrollController,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 12,
                            ),
                            itemCount: filteredUsers.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 8),
                            itemBuilder: (context, index) {
                              final user = filteredUsers[index];
                              final isSelected = _selectedUserId == user.id;
                              
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedUserId = user.id;
                                  });
                                },
                                onDoubleTap: () {
                                  _navigateToUserRoles(user);
                                },
                                child: SelectableListItem(
                                  title: user.name,
                                  isSelected: isSelected, // Solo si es el ID seleccionado
                                  onTap: () {
                                     // Redundante si usamos GestureDetector, pero SelectableListItem requiere onTap
                                     // Lo dejamos vacío o duplicamos la lógica de selección por si acaso.
                                     setState(() {
                                        _selectedUserId = user.id;
                                     });
                                  },
                                  leading: Semantics(
                                    label: '${user.type.displayName} user',
                                    child: Icon(
                                      user.type.icon,
                                      color: user.type.color,
                                      size: 24,
                                    ),
                                  ),
                                  showSelectionMarker: isSelected, // Logo solo si está seleccionado
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Botón Vincular Usuario
                    CustomButton(
                      text: AppLocalizations.of(context)!.sharedUsersLinkButton,
                      onPressed: _linkUser,
                      type: ButtonType.primary,
                    )
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

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/snackbar_helper.dart';
import '../../../../shared/widgets/page_header.dart';
import '../../../../shared/widgets/selectable_list_item.dart';
import '../../domain/entities/device_group.dart';
import '../../../devices/domain/entities/device.dart';
import '../widgets/group_selector_item.dart';
import '../widgets/add_device_section.dart';
import '../providers/groups_providers.dart';

/// Pantalla de Gestión de Grupos
///
/// Permite crear, editar, eliminar grupos y gestionar los dispositivos dentro de ellos.
class GroupsScreen extends ConsumerStatefulWidget {
  const GroupsScreen({super.key});

  @override
  ConsumerState<GroupsScreen> createState() => _GroupsScreenState();
}

class _GroupsScreenState extends ConsumerState<GroupsScreen> {
  // Estado local de UI
  List<DeviceGroup> _groups = [];
  List<Device> _allDevices = [];
  DeviceGroup? _selectedGroup;
  String? _selectedDeviceId; // Dropdown

  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  Future<void> _loadData() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final repo = ref.read(groupsRepositoryProvider);
      final results = await Future.wait([
        repo.getGroups(),
        repo.getDevices(),
      ]);

      if (!mounted) return;

      final groupsResult = results[0] as dynamic; // Cast to specific Either
      final devicesResult = results[1] as dynamic;

      String? error;
      groupsResult.fold(
        (failure) => error = failure.message,
        (data) => _groups = data,
      );

      if (error != null) {
        setState(() {
          _errorMessage = error;
          _isLoading = false;
        });
        return;
      }

      devicesResult.fold(
        (failure) => error = failure.message,
        (data) => _allDevices = data,
      );

      if (error != null) {
        setState(() {
          _errorMessage = error;
          _isLoading = false;
        });
        return;
      }

      if (_selectedGroup == null && _groups.isNotEmpty) {
        _selectedGroup = _groups.first;
      } else if (_selectedGroup != null) {
        final index = _groups.indexWhere((g) => g.id == _selectedGroup!.id);
        if (index != -1) {
          _selectedGroup = _groups[index];
        } else if (_groups.isNotEmpty) {
          _selectedGroup = _groups.first;
        } else {
          _selectedGroup = null;
        }
      }

      setState(() => _isLoading = false);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  bool get _isTodosGroupSelected => _selectedGroup?.id == 'group_todos';

  List<Device> _getAvailableDevices() {
    if (_selectedGroup == null) return [];
    if (_isTodosGroupSelected) return [];

    return _allDevices.where((device) {
      return !_selectedGroup!.deviceIds.contains(device.id);
    }).toList();
  }

  List<Device> _getDevicesInGroup() {
    if (_selectedGroup == null) return [];
    return _allDevices.where((device) {
      return _selectedGroup!.deviceIds.contains(device.id);
    }).toList();
  }

  // --- ACTIONS ---

  Future<void> _createGroup(String name, String description) async {
    final repo = ref.read(groupsRepositoryProvider);
    final result = await repo.createGroup(name, description);

    result.fold((failure) => SnackbarHelper.showError(context, failure.message),
        (newGroup) {
      _loadData().then((_) {
        setState(() {
          _selectedGroup = newGroup; // Select new group
        });
      });
      SnackbarHelper.showSuccess(
          context, AppLocalizations.of(context)!.groupsSuccessCreated);
    });
  }

  Future<void> _updateGroup(String name, String description) async {
    if (_selectedGroup == null) return;
    final repo = ref.read(groupsRepositoryProvider);
    final result =
        await repo.updateGroup(_selectedGroup!.id, name, description);

    result.fold((failure) => SnackbarHelper.showError(context, failure.message),
        (updated) {
      _loadData();
      SnackbarHelper.showSuccess(
          context, AppLocalizations.of(context)!.groupsSuccessUpdated);
    });
  }

  Future<void> _deleteGroup() async {
    if (_selectedGroup == null) return;
    final repo = ref.read(groupsRepositoryProvider);
    final result = await repo.deleteGroup(_selectedGroup!.id);

    result.fold((failure) => SnackbarHelper.showError(context, failure.message),
        (_) {
      _loadData().then((_) {
        setState(
            () => _selectedGroup = null); // Will default to TODOS in _loadData
      });
      SnackbarHelper.showSuccess(
          context, AppLocalizations.of(context)!.groupsSuccessDeleted);
    });
  }

  Future<void> _addDeviceToGroup() async {
    final l10n = AppLocalizations.of(context);
    if (_selectedGroup == null || _selectedDeviceId == null) return;

    final repo = ref.read(groupsRepositoryProvider);
    final result =
        await repo.addDeviceToGroup(_selectedGroup!.id, _selectedDeviceId!);

    result.fold(
      (failure) => SnackbarHelper.showError(context, failure.message),
      (updated) {
        final deviceName = _allDevices
            .firstWhere((d) => d.id == _selectedDeviceId!,
                orElse: () => Device(
                    id: '',
                    name: 'Device',
                    type: DeviceType.other,
                    model: '',
                    serialNumber: '',
                    createdAt: DateTime.now()))
            .name;
        SnackbarHelper.showSuccess(
            context, l10n.groupsSuccessDeviceAdded(deviceName, updated.name));
        _loadData();
        setState(() => _selectedDeviceId = null);
      },
    );
  }

  Future<void> _removeDeviceFromGroup(String deviceId) async {
    if (_selectedGroup == null) return;
    final repo = ref.read(groupsRepositoryProvider);
    final result =
        await repo.removeDeviceFromGroup(_selectedGroup!.id, deviceId);

    result.fold((failure) => SnackbarHelper.showError(context, failure.message),
        (updated) {
      SnackbarHelper.showSuccess(
          context, AppLocalizations.of(context)!.groupsSuccessDeviceRemoved);
      _loadData();
    });
  }

  // --- DIALOGS ---

  void _showCreateGroupDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final nameCtrl = TextEditingController();
    final descCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.groupCreateTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              decoration: InputDecoration(labelText: l10n.groupNameLabel),
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: descCtrl,
              decoration: InputDecoration(labelText: l10n.groupDescLabel),
              textCapitalization: TextCapitalization.sentences,
            ),
          ],
        ),
        actions: [
          TextButton(
            child: Text(l10n.groupsBtnCancel),
            onPressed: () => Navigator.pop(ctx),
          ),
          ElevatedButton(
            child: Text(l10n.groupsBtnCreate),
            onPressed: () {
              Navigator.pop(ctx);
              _createGroup(nameCtrl.text, descCtrl.text);
            },
          ),
        ],
      ),
    );
  }

  void _showEditGroupDialog(BuildContext context) {
    if (_selectedGroup == null) return;
    final l10n = AppLocalizations.of(context);
    final nameCtrl = TextEditingController(text: _selectedGroup!.name);
    final descCtrl = TextEditingController(text: _selectedGroup!.description);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.groupEditTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              decoration: InputDecoration(labelText: l10n.groupNameLabel),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: descCtrl,
              decoration: InputDecoration(labelText: l10n.groupDescLabel),
            ),
          ],
        ),
        actions: [
          TextButton(
            child: Text(l10n.groupsBtnCancel),
            onPressed: () => Navigator.pop(ctx),
          ),
          ElevatedButton(
            child: Text(l10n.groupsBtnSave),
            onPressed: () {
              Navigator.pop(ctx);
              _updateGroup(nameCtrl.text, descCtrl.text);
            },
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.groupDeleteConfirmTitle),
        content: Text(l10n.groupDeleteConfirmBody),
        actions: [
          TextButton(
            child: Text(l10n.groupsBtnCancel),
            onPressed: () => Navigator.pop(ctx),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, foregroundColor: Colors.white),
            child: Text(l10n.groupsBtnDelete),
            onPressed: () {
              Navigator.pop(ctx);
              _deleteGroup();
            },
          ),
        ],
      ),
    );
  }

  void _showRemoveDeviceConfirmation(BuildContext context, String deviceId) {
    final l10n = AppLocalizations.of(context);
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
                title: Text(l10n.deviceRemoveConfirmTitle),
                content: Text(l10n.deviceRemoveConfirmBody),
                actions: [
                  TextButton(
                    child: Text(l10n.groupsBtnCancel),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white),
                    child: Text(l10n.groupsBtnRemove),
                    onPressed: () {
                      Navigator.pop(ctx);
                      _removeDeviceFromGroup(deviceId);
                    },
                  )
                ]));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null)
      return const Scaffold(body: Center(child: CircularProgressIndicator()));

    if (_isLoading)
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    if (_errorMessage != null) {
      return Scaffold(
          body: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(_errorMessage!),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _loadData, child: Text(l10n.generalRetry))
          ])));
    }

    final devicesInGroup = _getDevicesInGroup();
    final availableDevices = _getAvailableDevices();

    return Scaffold(
      backgroundColor: Colors.white,
      // floatingActionButton removed
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),
            PageHeader(
              title: l10n.groupsTitleSimple, // Changed from l10n.groupsTitle
              titleFontSize: 24,
              showBackButton: true,
              onBack: () {
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.goNamed('devices');
                }
              },
            ),

            // Groups Vertical Section
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // 'Mis Grupos' text removed

                    // Vertical List of Groups
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _groups.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final group = _groups[index];
                        final isSelected = group.id == _selectedGroup?.id;
                        return GroupSelectorItem(
                          name: group.name,
                          isSelected: isSelected,
                          onTap: () {
                            setState(() {
                              _selectedGroup = group;
                              _selectedDeviceId = null;
                            });
                          },
                        );
                      },
                    ),

                    const SizedBox(height: 16),

                    // Add Group Button (Moved from FAB)
                    Center(
                      child: TextButton.icon(
                        onPressed: () => _showCreateGroupDialog(context),
                        icon: const Icon(Icons.add_circle_outline,
                            color: AppColors.primaryPurple),
                        label: Text(
                          l10n.groupsButtonCreateAction,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.primaryPurple,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Group Info & Management Actions
                    if (_selectedGroup != null) ...[
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              _selectedGroup!.name,
                              style: AppTextStyles.titleMedium.copyWith(
                                color: AppColors.primaryPurple,
                              ),
                            ),
                          ),
                          if (!_isTodosGroupSelected) ...[
                            IconButton(
                              icon: const Icon(Icons.edit,
                                  size: 20, color: AppColors.primaryPurple),
                              onPressed: () => _showEditGroupDialog(context),
                              tooltip: 'Editar Grupo',
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline,
                                  size: 20, color: Colors.red),
                              onPressed: () => _showDeleteConfirmation(context),
                              tooltip: 'Eliminar Grupo',
                            ),
                          ]
                        ],
                      ),
                      if (_selectedGroup!.description != null &&
                          _selectedGroup!.description!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 4, bottom: 8),
                          child: Text(
                            _selectedGroup!.description!,
                            style: AppTextStyles.bodySmall
                                .copyWith(fontStyle: FontStyle.italic),
                          ),
                        ),
                      const SizedBox(height: 12),
                      Text(
                        l10n.groupsSubsectionDevices,
                        style: AppTextStyles.titleMedium.copyWith(
                          color: AppColors.titleBlue,
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (devicesInGroup.isEmpty)
                        _buildEmptyState(l10n.groupsEmptyList)
                      else
                        ...devicesInGroup.map((device) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: SelectableListItem(
                              title: device.name,
                              isSelected: false,
                              showSelectionMarker: false,
                              onTap: null, // Removed navigation
                              trailing: !_isTodosGroupSelected
                                  ? IconButton(
                                      icon: const Icon(Icons.delete_outline,
                                          color: Colors.red),
                                      onPressed: () =>
                                          _showRemoveDeviceConfirmation(
                                              context, device.id),
                                      tooltip: 'Quitar del grupo',
                                    )
                                  : null,
                            ),
                          );
                        }).toList(),
                    ],

                    const SizedBox(height: 32),

                    // Add Device Section
                    if (_selectedGroup != null && !_isTodosGroupSelected)
                      AddDeviceSection(
                        availableDevices: availableDevices,
                        selectedDeviceId: _selectedDeviceId,
                        onDeviceChanged: (v) =>
                            setState(() => _selectedDeviceId = v),
                        onAdd: _addDeviceToGroup,
                      )
                    else if (_selectedGroup != null && _isTodosGroupSelected)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE3F2FD),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFF90CAF9)),
                        ),
                        child: Column(
                          children: [
                            const Icon(Icons.info,
                                color: Color(0xFF1976D2), size: 32),
                            const SizedBox(height: 8),
                            Text(l10n.groupsInfoTodosTitle,
                                style: AppTextStyles.bodyMedium.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF1565C0))),
                            const SizedBox(height: 4),
                            Text(l10n.groupsInfoTodosBody,
                                textAlign: TextAlign.center,
                                style: AppTextStyles.bodySmall
                                    .copyWith(color: const Color(0xFF0D47A1))),
                          ],
                        ),
                      ),

                    const SizedBox(height: 60), // Space for FAB
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFBDBDBD), width: 1),
      ),
      child: Center(
        child: Text(message,
            style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary, fontStyle: FontStyle.italic)),
      ),
    );
  }
}

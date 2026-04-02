import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/theme/app_theme.dart';
import '../state/group_cubit.dart';
import '../state/group_state.dart';
import '../state/audit_log_cubit.dart';
import '../state/audit_log_state.dart';
import '../widgets/group_list_panel.dart';
import '../widgets/group_detail_panel.dart';
import '../widgets/audit_log_list.dart';

/// Pantalla principal de Gestión de Permisos
///
/// Contiene 2 tabs:
/// - Tab 1: Gestión de Grupos (panel izquierdo: lista, panel derecho: permisos + dispositivos)
/// - Tab 2: Reportes de Auditoría (filtros + lista paginada + exportación)
class PermissionsManagementScreen extends StatefulWidget {
  const PermissionsManagementScreen({Key? key}) : super(key: key);

  @override
  State<PermissionsManagementScreen> createState() =>
      _PermissionsManagementScreenState();
}

class _PermissionsManagementScreenState
    extends State<PermissionsManagementScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (mounted) setState(() {});
    });

    // Cargar datos iniciales
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GroupCubit>().loadGroups();
      context.read<AuditLogCubit>().loadLogs();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgGray,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildTabBar(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildGroupsTab(),
                _buildReportsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: AppTheme.textDark),
        onPressed: () => Navigator.pop(context),
      ),
      title: const Text(
        'Gestionar Permisos',
        style: TextStyle(
          color: AppTheme.titleBlue,
          fontSize: 22,
          fontWeight: FontWeight.w600,
          fontFamily: 'Montserrat',
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SvgPicture.asset(
            'assets/images/IconoLogo_transparente.png',
            height: 40,
            width: 40,
            fit: BoxFit.contain,
          ),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        children: [
          // Tab Grupos (redondeado con gap)
          Expanded(
            child: GestureDetector(
              onTap: () => _tabController.animateTo(0),
              child: Container(
                margin: const EdgeInsets.only(right: 4),
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                decoration: BoxDecoration(
                  color: _tabController.index == 0
                      ? AppTheme.primaryPurple
                      : Colors.grey.shade300,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Text(
                  'Grupos',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: _tabController.index == 0
                        ? Colors.white
                        : Colors.black54,
                  ),
                ),
              ),
            ),
          ),
          // Tab Reportes (redondeado con gap)
          Expanded(
            child: GestureDetector(
              onTap: () => _tabController.animateTo(1),
              child: Container(
                margin: const EdgeInsets.only(left: 4),
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                decoration: BoxDecoration(
                  color: _tabController.index == 1
                      ? AppTheme.primaryPurple
                      : Colors.grey.shade300,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Text(
                  'Reportes',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: _tabController.index == 1
                        ? Colors.white
                        : Colors.black54,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGroupsTab() {
    return BlocListener<GroupCubit, GroupState>(
      listener: (context, state) {
        // Mostrar SnackBar de éxito
        if (state is GroupMutationSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.white),
                  const SizedBox(width: 8),
                  Expanded(child: Text(state.message)),
                ],
              ),
              backgroundColor: AppTheme.primaryPurple,
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 2),
            ),
          );
        }

        // Mostrar SnackBar de error
        if (state is GroupError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.error_outline, color: Colors.white),
                  const SizedBox(width: 8),
                  Expanded(child: Text(state.message)),
                ],
              ),
              backgroundColor: AppTheme.errorRed,
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      },
      child: BlocBuilder<GroupCubit, GroupState>(
        builder: (context, state) {
          // Solo mostrar spinner en carga inicial
          if (state is GroupInitial || state is GroupLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is GroupError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 48,
                    color: AppTheme.errorRed,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    state.message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: AppTheme.errorRed),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.read<GroupCubit>().loadGroups(),
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          }

          if (state is GroupLoaded) {
            final selectedGroup = state.selectedGroup;

            return Stack(
              children: [
                Row(
                  children: [
                    // Panel izquierdo: Lista de grupos (30%)
                    Expanded(
                      flex: 3,
                      child: Container(
                        color: Colors.white,
                        child: const GroupListPanel(),
                      ),
                    ),

                    const VerticalDivider(width: 1),

                    // Panel derecho: Permisos + Dispositivos (70%)
                    Expanded(
                      flex: 7,
                      child: selectedGroup != null
                          ? Container(
                              color: Colors.white,
                              child: GroupDetailPanel(
                                selectedGroup: selectedGroup,
                                availablePermissions: state.availablePermissions,
                              ),
                            )
                          : const Center(
                              child: Text('Seleccione un grupo'),
                            ),
                    ),
                  ],
                ),

                // Indicador discreto de mutación en progreso
                if (state.isMutating)
                  Positioned(
                    top: 16,
                    right: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryPurple.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Guardando...',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            );
          }

          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildReportsTab() {
    return BlocListener<AuditLogCubit, AuditLogState>(
      listener: (context, state) {
        if (state is AuditLogExportSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.white),
                  SizedBox(width: 8),
                  Expanded(child: Text('CSV exportado exitosamente')),
                ],
              ),
              backgroundColor: AppTheme.primaryPurple,
              behavior: SnackBarBehavior.floating,
              duration: Duration(seconds: 2),
            ),
          );
        }
      },
      child: Container(
        color: Colors.white,
        child: const AuditLogList(),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../domain/entities/support_request.dart';
import '../state/support_request_list_cubit.dart';
import '../state/support_request_list_state.dart';
import '../state/support_request_mutation_cubit.dart';
import '../state/support_request_mutation_state.dart';
import '../widgets/support_request_list_item.dart';
import '../../../../core/theme/app_theme.dart';

/// Pantalla que muestra la lista de solicitudes de soporte
class SupportRequestListScreen extends StatefulWidget {
  const SupportRequestListScreen({super.key});

  @override
  State<SupportRequestListScreen> createState() => _SupportRequestListScreenState();
}

class _SupportRequestListScreenState extends State<SupportRequestListScreen> {
  SupportRequestStatus? _currentFilter;

  @override
  void initState() {
    super.initState();
    context.read<SupportRequestListCubit>().load();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SupportRequestMutationCubit, SupportRequestMutationState>(
      listener: (context, state) {
        if (state is SupportRequestMutationSuccess) {
          // Mostrar mensaje de éxito
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
            ),
          );
          // Refrescar lista
          context.read<SupportRequestListCubit>().refresh();
        } else if (state is SupportRequestMutationError) {
          // Mostrar mensaje de error
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      child: BlocBuilder<SupportRequestListCubit, SupportRequestListState>(
        builder: (context, state) {
          if (state is SupportRequestListLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is SupportRequestListError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    state.message,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  OutlinedButton.icon(
                    onPressed: () {
                      context.read<SupportRequestListCubit>().refresh();
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Reintentar'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.primaryPurple,
                      side: const BorderSide(color: AppTheme.primaryPurple, width: 2),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          if (state is SupportRequestListLoaded) {
            if (state.requests.isEmpty) {
              return _buildEmptyState();
            }

            return RefreshIndicator(
              onRefresh: () async {
                await context.read<SupportRequestListCubit>().refresh();
              },
              child: Column(
                children: [
                  // Filter chip
                  if (state.currentFilter != null)
                    Container(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Chip(
                            label: Text('Filtro: ${state.currentFilter!.label}'),
                            deleteIcon: const Icon(Icons.close, size: 18),
                            onDeleted: () {
                              setState(() {
                                _currentFilter = null;
                              });
                              context.read<SupportRequestListCubit>().filterByStatus(null);
                            },
                          ),
                        ],
                      ),
                    ),

                  // List
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: state.requests.length,
                      itemBuilder: (context, index) {
                        final request = state.requests[index];
                        return SupportRequestListItem(
                          request: request,
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              '/support-request-detail',
                              arguments: request,
                            ).then((result) {
                              // Manejar resultado del detalle
                              if (result != null) {
                                // Si es bool (edición), refrescar lista
                                if (result is bool && result) {
                                  context.read<SupportRequestListCubit>().refresh();
                                }
                                // Si es Map con acción 'archive', actualizar estado
                                else if (result is Map && result['action'] == 'archive') {
                                  final request = result['request'] as SupportRequest;
                                  final resolution = result['resolution'] as String;
                                  context.read<SupportRequestMutationCubit>().update(
                                    id: request.id,
                                    status: SupportRequestStatus.resolved,
                                    resolution: resolution,
                                  );
                                }
                              }
                            });
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.support_agent,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No hay solicitudes de soporte',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Cuando solicites soporte para un dispositivo,\naparecerá aquí',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Filtrar por Estado'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Opción: Todas
              ListTile(
                title: const Text('Todas'),
                leading: Radio<SupportRequestStatus?>(
                  value: null,
                  groupValue: _currentFilter,
                  onChanged: (value) {
                    Navigator.pop(dialogContext);
                    setState(() {
                      _currentFilter = value;
                    });
                    context.read<SupportRequestListCubit>().filterByStatus(value);
                  },
                ),
                onTap: () {
                  Navigator.pop(dialogContext);
                  setState(() {
                    _currentFilter = null;
                  });
                  context.read<SupportRequestListCubit>().filterByStatus(null);
                },
              ),

              // Opciones de estado
              ...SupportRequestStatus.values.map((status) {
                return ListTile(
                  title: Text(status.label),
                  leading: Radio<SupportRequestStatus?>(
                    value: status,
                    groupValue: _currentFilter,
                    onChanged: (value) {
                      Navigator.pop(dialogContext);
                      setState(() {
                        _currentFilter = value;
                      });
                      context.read<SupportRequestListCubit>().filterByStatus(value);
                    },
                  ),
                  onTap: () {
                    Navigator.pop(dialogContext);
                    setState(() {
                      _currentFilter = status;
                    });
                    context.read<SupportRequestListCubit>().filterByStatus(status);
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }
}

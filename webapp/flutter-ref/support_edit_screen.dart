import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../devices/domain/entities/device.dart';
import '../../domain/entities/support_request.dart';
import '../../domain/validators/support_request_validator.dart';
import '../state/support_request_mutation_cubit.dart';
import '../state/support_request_mutation_state.dart';
import '../widgets/device_info_header.dart';
import '../../../../core/theme/app_theme.dart';

/// Pantalla para solicitar soporte técnico
class SupportRequestEditScreen extends StatefulWidget {
  final Device? device;
  final SupportRequest? request;

  const SupportRequestEditScreen({
    super.key,
    this.device,
    this.request,
  }) : assert(device != null || request != null, 'Either device or request must be provided');

  @override
  State<SupportRequestEditScreen> createState() => _SupportRequestEditScreenState();
}

class _SupportRequestEditScreenState extends State<SupportRequestEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final _notesController = TextEditingController();

  SupportRequestPriority _selectedPriority = SupportRequestPriority.medium;

  bool get _isEditing => widget.request != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      _notesController.text = widget.request!.notes;
      _selectedPriority = widget.request!.priority;
    }
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgGray,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.textDark),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          _isEditing ? 'Editar Solicitud' : 'Contacto Técnico',
          style: const TextStyle(
            color: AppTheme.titleBlue,
            fontSize: 22,
            fontWeight: FontWeight.w600,
            fontFamily: 'Montserrat',
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.home, color: AppTheme.primaryPurple),
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
            },
          ),
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
      ),
      body: BlocListener<SupportRequestMutationCubit, SupportRequestMutationState>(
        listener: (context, state) {
          if (state is SupportRequestMutationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
            // Navegar a la lista de solicitudes
            Navigator.pop(context);
            Navigator.pushNamed(context, '/support-requests');
          } else if (state is SupportRequestMutationError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: BlocBuilder<SupportRequestMutationCubit, SupportRequestMutationState>(
          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Información del dispositivo (sin status)
                    DeviceInfoHeader(
                      deviceName: _isEditing ? widget.request!.deviceName : widget.device!.name,
                      deviceModel: _isEditing ? widget.request!.deviceModel : widget.device!.model,
                      serialNumber: _isEditing ? widget.request!.deviceSerialNumber : widget.device!.serialNumber,
                      details: _getDeviceDetails(),
                    ),
                    const SizedBox(height: 24),

                    // Selector de prioridad
                    _buildPrioritySelector(),
                    const SizedBox(height: 24),

                    // Campo de notas
                    _buildNotesField(),
                    const SizedBox(height: 80), // Espacio para el footer
                  ],
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: BlocBuilder<SupportRequestMutationCubit, SupportRequestMutationState>(
        builder: (context, state) {
          final isLoading = state is SupportRequestMutationSaving;
          return SafeArea(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Botón Cancelar
                  Expanded(
                    child: OutlinedButton(
                      onPressed: isLoading ? null : () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppTheme.primaryPurple,
                        side: const BorderSide(color: AppTheme.primaryPurple, width: 2),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: const Text(
                        'Cancelar',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Botón Contactar Mantenimiento
                  Expanded(
                    child: ElevatedButton(
                      onPressed: isLoading ? null : _handleSubmit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryPurple,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: isLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              _isEditing ? 'Guardar Cambios' : 'Contactar Mantenimiento',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String? _getDeviceDetails() {
    if (_isEditing) {
      return widget.request!.deviceDetails;
    }

    // Construir detalles del dispositivo para creación
    final details = <String>[];
    if (widget.device!.location != null) {
      details.add(widget.device!.location!);
    }
    return details.isNotEmpty ? details.join(' - ') : null;
  }

  Widget _buildPrioritySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Prioridad de la Solicitud',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: SupportRequestPriority.values.map((priority) {
            final isSelected = _selectedPriority == priority;
            return _PriorityChip(
              priority: priority,
              isSelected: isSelected,
              onTap: () {
                setState(() {
                  _selectedPriority = priority;
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildNotesField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Notas',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              ' *',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Describe el problema o la razón de la solicitud de soporte',
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _notesController,
          maxLines: 6,
          maxLength: 1000,
          decoration: InputDecoration(
            hintText: 'Ejemplo: El motor no responde correctamente, se escuchan ruidos extraños al abrir...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            filled: true,
            fillColor: Colors.grey[50],
            counterText: '${_notesController.text.length}/1000',
          ),
          validator: SupportRequestValidator.validateNotes,
          onChanged: (value) {
            setState(() {}); // Update counter
          },
        ),
      ],
    );
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      final cubit = context.read<SupportRequestMutationCubit>();

      if (_isEditing) {
        // Actualizar solicitud existente
        cubit.update(
          id: widget.request!.id,
          notes: _notesController.text.trim(),
          priority: _selectedPriority,
        );
      } else {
        // Crear nueva solicitud
        cubit.create(
          deviceId: widget.device!.id.toString(),
          deviceName: widget.device!.name,
          deviceSerialNumber: widget.device!.serialNumber,
          deviceModel: widget.device!.model,
          notes: _notesController.text.trim(),
          priority: _selectedPriority,
          deviceStatus: widget.device!.status,
          deviceDetails: _getDeviceDetails(),
        );
      }
    }
  }
}

/// Chip de prioridad seleccionable
class _PriorityChip extends StatelessWidget {
  final SupportRequestPriority priority;
  final bool isSelected;
  final VoidCallback onTap;

  const _PriorityChip({
    required this.priority,
    required this.isSelected,
    required this.onTap,
  });

  Color _getPriorityColor() {
    switch (priority) {
      case SupportRequestPriority.urgent:
        return Colors.red;
      case SupportRequestPriority.high:
        return Colors.orange;
      case SupportRequestPriority.medium:
        return Colors.blue;
      case SupportRequestPriority.low:
        return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getPriorityColor();

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? color : color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.flag,
              size: 18,
              color: isSelected ? Colors.white : color,
            ),
            const SizedBox(width: 8),
            Text(
              priority.label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

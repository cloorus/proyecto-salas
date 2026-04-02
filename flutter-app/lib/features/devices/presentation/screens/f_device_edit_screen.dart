import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/page_header.dart';
import '../../../../shared/widgets/snackbar_helper.dart';
import '../../domain/entities/device_info.dart';
import '../providers/device_info_provider.dart';
import '../widgets/device_form.dart';
import 'package:image_picker/image_picker.dart';

class DeviceEditScreen extends ConsumerStatefulWidget {
  final String deviceId;

  const DeviceEditScreen({
    super.key,
    required this.deviceId,
  });

  @override
  ConsumerState<DeviceEditScreen> createState() => _DeviceEditScreenState();
}

class _DeviceEditScreenState extends ConsumerState<DeviceEditScreen> {
  
  Future<void> _handleSave(Map<String, dynamic> data) async {
    debugPrint('[SAVE] _handleSave called with data keys: ${data.keys.toList()}');
    debugPrint('[SAVE] data: $data');
    
    // Build API payload from ALL form data
    final apiData = <String, dynamic>{};
    
    // Basic info
    if (data['name'] != null && data['name'].toString().isNotEmpty) apiData['name'] = data['name'];
    if (data['location'] != null) apiData['location'] = data['location'];
    if (data['description'] != null) apiData['description'] = data['description'];
    if (data['model'] != null) apiData['model'] = data['model'];
    // Map Flutter device types to API types
    final typeMap = {'Portón': 'gate', 'Barrera': 'barrier', 'Puerta': 'door', 'Cámara': 'camera', 'Otro': 'other'};
    if (data['type'] != null) apiData['device_type'] = typeMap[data['type']] ?? data['type'];
    
    debugPrint('[SAVE] apiData to send: $apiData');
    
    try {
      final result = await ref.read(apiDeviceRepositoryProvider).updateDevice(widget.deviceId, apiData);
      
      final success = result.fold(
        (failure) {
          debugPrint('[SAVE] API error: ${failure.message}');
          if (mounted) {
            SnackbarHelper.showError(context, 'Error al guardar: ${failure.message}');
          }
          return false;
        },
        (device) {
          debugPrint('[SAVE] API success: device updated');
          return true;
        },
      );
      
      if (!success || !mounted) return;
      
      // Upload photo if selected
      if (data['imageFile'] != null) {
        final photoResult = await ref.read(apiDeviceRepositoryProvider).uploadDevicePhoto(
          widget.deviceId,
          data['imageFile'],
        );
        photoResult.fold(
          (failure) => debugPrint('[SAVE] Photo upload failed: ${failure.message}'),
          (_) => debugPrint('[SAVE] Photo uploaded successfully'),
        );
      }
      
      SnackbarHelper.showSuccess(context, AppLocalizations.of(context)!.deviceEditSuccessMessage);
      
      // Force refresh both device info and devices list
      ref.invalidate(deviceInfoProvider(widget.deviceId));
      ref.invalidate(devicesListProvider);
      
      // Navigate back to device info
      context.goNamed('device-info', pathParameters: {'id': widget.deviceId});
      
    } catch (e) {
      debugPrint('[SAVE] Exception: $e');
      if (mounted) {
        SnackbarHelper.showError(context, 'Error: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceAsync = ref.watch(deviceInfoProvider(widget.deviceId));

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),
            PageHeader(
              title: AppLocalizations.of(context)!.deviceEditTitle,
              titleFontSize: 24,
              showBackButton: true,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: deviceAsync.when(
                data: (device) => DeviceForm(
                  initialData: device,
                  onSave: _handleSave,
                ),
                loading: () => const Center(
                  child: CircularProgressIndicator(color: AppColors.primaryPurple),
                ),
                error: (err, stack) => Center(
                  child: Text('Error: $err'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

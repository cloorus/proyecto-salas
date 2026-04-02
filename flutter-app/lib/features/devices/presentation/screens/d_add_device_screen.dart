import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/snackbar_helper.dart';
import '../../../../shared/widgets/page_header.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/curved_tab_bar.dart'; // Import CurvedTabBar
// import '../../../../core/constants/app_messages.dart'; // Removed - using AppLocalizations instead
import '../../domain/entities/device.dart';
import '../widgets/device_form.dart';
import '../widgets/device_scan_view.dart'; // Import DeviceScanView
import '../providers/device_info_provider.dart';

class AddDeviceScreen extends ConsumerStatefulWidget {
  final Device? device;

  const AddDeviceScreen({
    super.key,
    this.device,
  });

  @override
  ConsumerState<AddDeviceScreen> createState() => _AddDeviceScreenState();
}

class _AddDeviceScreenState extends ConsumerState<AddDeviceScreen> {
  int _selectedTabIndex = 0; // State for tab selection

  Future<void> _handleSave(Map<String, dynamic> data) async {
    // Usar repositorio real
    await ref.read(deviceRepositoryProvider).createDevice(data);

    if (!mounted) return;
    
    SnackbarHelper.showSuccess(context, AppLocalizations.of(context)!.msgDeviceAdded);
    
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;
    
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Changed to white to match design/tabs
      body: SafeArea(
        child: Column(
          children: [

            PageHeader(
              title: AppLocalizations.of(context)!.deviceAddTitle,
              titleFontSize: 24,
              showBackButton: true,
            ),
            
            // Tabs: Por Formulario vs Por Wireless
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: CurvedTabBar(
                tabs: const ['Por Formulario', 'Por Wireless'],
                selectedIndex: _selectedTabIndex,
                onTabChanged: (index) {
                  setState(() {
                    _selectedTabIndex = index;
                  });
                },
                onAddPressed: null, 
                showAddButton: false, // Explicitly hide the add button 
              ),
            ),

            Expanded(
              child: Container(
                width: double.infinity,
                color: const Color(0xFFEBEBEB), // Background for content area
                padding: const EdgeInsets.all(16),
                child: _selectedTabIndex == 0 
                  ? DeviceForm(
                      initialData: null, // Always null for "Add" mode
                      onSave: _handleSave,
                    )
                  : DeviceScanView( // New Scan View
                      parentDevice: widget.device,
                      onScanComplete: () {
                        // Optional: Switch to form or handle completion
                      },
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

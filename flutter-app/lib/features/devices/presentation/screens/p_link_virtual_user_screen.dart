import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/page_header.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../../../../shared/widgets/snackbar_helper.dart';

/// Pantalla 10: Vincular usuario virtual
class LinkDeviceUserScreen extends StatefulWidget {
  final String deviceId;

  const LinkDeviceUserScreen({
    super.key,
    required this.deviceId,
  });

  @override
  State<LinkDeviceUserScreen> createState() => _LinkDeviceUserScreenState();
}

class _LinkDeviceUserScreenState extends State<LinkDeviceUserScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _labelController = TextEditingController();

  void _addUser() {
    if (_emailController.text.isEmpty) {
      SnackbarHelper.showError(context, AppLocalizations.of(context)!.linkVirtualUserErrorEmail);
      return;
    }

    // Simular lógica de agregar
    SnackbarHelper.showSuccess(context, AppLocalizations.of(context)!.linkVirtualUserSuccess);

    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        // Navegar a la pantalla de asignación de roles
        // ID simulado 'new-user'
        context.pushReplacementNamed(
          'user-roles',
          pathParameters: {'id': 'new-user-123'},
          extra: {
            'name': _labelController.text.isNotEmpty ? _labelController.text : AppLocalizations.of(context)!.linkVirtualUserNewUserName,
            'email': _emailController.text,
            // 'device': widget.device // No tenemos el objeto device aquí, pasaremos null y la pantalla manejará el header vacío
          },
        );
      } 
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      const SizedBox(height: 16),
                      // Header
                      // Header
                      PageHeader(
                        title: AppLocalizations.of(context)!.linkVirtualUserTitle,
                        titleFontSize: 20,
                        showBackButton: true,
                      ),
                      
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Logo
                            Semantics(
                              label: 'BGnius VITA logo',
                              child: SvgPicture.asset(
                                'assets/images/Bgnius_logo.svg',
                                width: 200,
                                height: 80,
                                fit: BoxFit.contain,
                              ),
                            ),

                            const SizedBox(height: 40),

                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 24),
                              child: Column(
                                children: [
                                  // Campo Usuario/Correo
                                  CustomTextField(
                                    controller: _emailController,
                                    labelText: AppLocalizations.of(context)!.linkVirtualUserEmailLabel,
                                    hintText: AppLocalizations.of(context)!.linkVirtualUserEmailHint,
                                    prefixIcon: Icons.email_outlined,
                                  ),

                                  const SizedBox(height: 24),

                                  // Campo Etiqueta
                                  CustomTextField(
                                    controller: _labelController,
                                    labelText: AppLocalizations.of(context)!.linkVirtualUserLabelLabel,
                                    hintText: AppLocalizations.of(context)!.linkVirtualUserLabelHint,
                                    prefixIcon: Icons.label_outline,
                                  ),

                                  const SizedBox(height: 60),

                                  // Botón Agregar
                                  CustomButton(
                                    text: AppLocalizations.of(context)!.linkVirtualUserAddButton,
                                    onPressed: _addUser,
                                    type: ButtonType.primary,
                                    // backgroundColor: const Color(0xFF0D6EFD), // Removing manual Blue to match design system (Purple)
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            );
          }
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/widgets/index.dart';

/// Pantalla de biblioteca/showcase de componentes del Design System
/// 
/// Muestra todos los componentes, colores, fuentes y assets disponibles
/// en la aplicación para referencia y testing.
class ComponentLibraryScreen extends StatelessWidget {
  const ComponentLibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Biblioteca de Componentes', style: AppTextStyles.appBarTitle),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionHeader('Colores'),
          _buildColorsSection(),
          const SizedBox(height: 32),
          
          _buildSectionHeader('Tipografía'),
          _buildTypographySection(),
          const SizedBox(height: 32),
          
          _buildSectionHeader('Espaciados'),
          _buildSpacingSection(),
          const SizedBox(height: 32),
          
          _buildSectionHeader('Botones'),
          _buildButtonsSection(),
          const SizedBox(height: 32),
          
          _buildSectionHeader('Inputs'),
          _buildInputsSection(),
          const SizedBox(height: 32),
          
          _buildSectionHeader('Componentes de Usuario'),
          _buildUserComponentsSection(),
          const SizedBox(height: 32),
          
          _buildSectionHeader('Componentes de Información'),
          _buildInfoComponentsSection(),
          const SizedBox(height: 32),
          
          _buildSectionHeader('Componentes de Layout'),
          _buildLayoutComponentsSection(),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16, top: 8),
      child: Text(title, style: AppTextStyles.sectionTitle),
    );
  }

  // ==================== COLORES ====================
  Widget _buildColorsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildColorSubsection('Colores Primarios', [
          _ColorItem('Primary Purple', AppColors.primaryPurple, '#7B2CBF'),
          _ColorItem('Tab Purple', AppColors.tabPurple, '#673AB7'),
          _ColorItem('Secondary Blue', AppColors.secondaryBlue, '#0072BC'),
          _ColorItem('Title Blue', AppColors.titleBlue, '#303F9F'),
        ]),
        const SizedBox(height: 16),
        
        _buildColorSubsection('Colores de Estado', [
          _ColorItem('Success', AppColors.success, '#4CAF50'),
          _ColorItem('Error', AppColors.error, '#E53935'),
          _ColorItem('Warning', AppColors.warning, '#FF9800'),
          _ColorItem('Info', AppColors.info, '#2196F3'),
        ]),
        const SizedBox(height: 16),
        
        _buildColorSubsection('Colores Neutros', [
          _ColorItem('Background', AppColors.background, '#F5F5F5'),
          _ColorItem('Surface', AppColors.surface, '#FFFFFF'),
          _ColorItem('Text Primary', AppColors.textPrimary, '#212121'),
          _ColorItem('Text Secondary', AppColors.textSecondary, '#757575'),
          _ColorItem('Divider', AppColors.divider, '#E0E0E0'),
        ]),
        const SizedBox(height: 16),
        
        _buildColorSubsection('Colores de Botones de Control', [
          _ColorItem('Open Button', AppColors.openButton, '#4CAF50'),
          _ColorItem('Close Button', AppColors.closeButton, '#FF5722'),
          _ColorItem('Pause Button', AppColors.pauseButton, '#9E9E9E'),
          _ColorItem('Pedestrian Button', AppColors.pedestrianButton, '#03A9F4'),
        ]),
      ],
    );
  }

  Widget _buildColorSubsection(String title, List<_ColorItem> colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: colors.map((color) => _buildColorSwatch(color)).toList(),
        ),
      ],
    );
  }

  Widget _buildColorSwatch(_ColorItem colorItem) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: 48,
            decoration: BoxDecoration(
              color: colorItem.color,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 8),
          Text(colorItem.name, style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w600)),
          Text(colorItem.hex, style: AppTextStyles.bodySmall),
        ],
      ),
    );
  }

  // ==================== TIPOGRAFÍA ====================
  Widget _buildTypographySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTextStyleDemo('Screen Title', AppTextStyles.screenTitle, 'Bienvenido a BGnius'),
        _buildTextStyleDemo('Section Title', AppTextStyles.sectionTitle, 'Sección de Componentes'),
        _buildTextStyleDemo('AppBar Title', AppTextStyles.appBarTitle, 'Título del AppBar'),
        _buildTextStyleDemo('Card Title', AppTextStyles.cardTitle, 'Título de Card'),
        _buildTextStyleDemo('Body Large', AppTextStyles.bodyLarge, 'Texto de cuerpo grande para párrafos'),
        _buildTextStyleDemo('Body Medium', AppTextStyles.bodyMedium, 'Texto de cuerpo mediano'),
        _buildTextStyleDemo('Body Small', AppTextStyles.bodySmall, 'Texto pequeño para detalles'),
        _buildTextStyleDemo('Button Text', AppTextStyles.buttonText, 'TEXTO DE BOTÓN'),
        _buildTextStyleDemo('Link', AppTextStyles.link, 'Enlace clickeable'),
        _buildTextStyleDemo('Device Name', AppTextStyles.deviceName, 'Dispositivo FAC 500'),
      ],
    );
  }

  Widget _buildTextStyleDemo(String name, TextStyle style, String example) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name, style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w600,
          )),
          const SizedBox(height: 4),
          Text(example, style: style),
          const SizedBox(height: 4),
          Text(
            'Size: ${style.fontSize?.toStringAsFixed(0)}px • Weight: ${style.fontWeight.toString().split('.').last}',
            style: AppTextStyles.bodySmall.copyWith(fontSize: 10),
          ),
        ],
      ),
    );
  }

  // ==================== ESPACIADOS ====================
  Widget _buildSpacingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSpacingDemo('8px', 8),
        _buildSpacingDemo('12px', 12),
        _buildSpacingDemo('16px', 16),
        _buildSpacingDemo('20px', 20),
        _buildSpacingDemo('24px', 24),
        _buildSpacingDemo('32px', 32),
      ],
    );
  }

  Widget _buildSpacingDemo(String name, double size) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(name, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
          ),
          Container(
            width: size,
            height: 24,
            color: AppColors.primaryPurple,
          ),
        ],
      ),
    );
  }

  // ==================== BOTONES ====================
  Widget _buildButtonsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Primary Button', style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        CustomButton(
          text: 'Botón Principal',
          onPressed: () {},
        ),
        const SizedBox(height: 16),
        
        Text('Outlined Button', style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        OutlinedButton(
          onPressed: () {},
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.secondaryBlue,
            side: BorderSide(color: AppColors.secondaryBlue),
          ),
          child: const Text('Botón Outlined'),
        ),
        const SizedBox(height: 16),
        
        Text('Text Button', style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        TextButton(
          onPressed: () {},
          child: const Text('Botón de Texto'),
        ),
        const SizedBox(height: 16),
        
        Text('Disabled Button', style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        CustomButton(
          text: 'Botón Deshabilitado',
          onPressed: null,
        ),
      ],
    );
  }

  // ==================== INPUTS ====================
  Widget _buildInputsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Text Field', style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        CustomTextField(
          controller: TextEditingController(),
          hintText: 'Ingresa tu texto aquí',
          labelText: 'Campo de Texto',
        ),
        const SizedBox(height: 16),
        
        Text('Text Field con Icono', style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        CustomTextField(
          controller: TextEditingController(),
          hintText: 'usuario@ejemplo.com',
          labelText: 'Email',
          prefixIcon: Icons.email_outlined,
        ),
        const SizedBox(height: 16),
        
        Text('Switch', style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        CustomSwitch(
          label: 'Opción activada',
          value: true,
          onChanged: (value) {},
        ),
      ],
    );
  }

  // ==================== COMPONENTES DE USUARIO ====================
  Widget _buildUserComponentsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('User List Item - Usuario Normal', style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        UserListItem(
          name: 'Carlos Mena',
          type: UserAccessType.user,
          onEditPressed: () {},
        ),
        const SizedBox(height: 12),
        
        Text('User List Item - Administrador', style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        UserListItem(
          name: '*Admin Principal',
          type: UserAccessType.user,
          isAdmin: true,
          onEditPressed: () {},
        ),
        const SizedBox(height: 12),
        
        Text('User List Item - Bluetooth', style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        UserListItem(
          name: 'Widget Carro',
          type: UserAccessType.bluetooth,
          onEditPressed: () {},
        ),
        const SizedBox(height: 12),
        
        Text('User List Item - Seleccionado', style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        UserListItem(
          name: 'Usuario Seleccionado',
          type: UserAccessType.user,
          isSelected: true,
          isClickable: true,
          onTap: () {},
          onEditPressed: () {},
        ),
        const SizedBox(height: 12),
        
        Text('Selectable List Item', style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        SelectableListItem(
          title: 'Item Seleccionable',
          isSelected: false,
          onTap: () {},
        ),
      ],
    );
  }

  // ==================== COMPONENTES DE INFORMACIÓN ====================
  Widget _buildInfoComponentsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Info Section', style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        InfoSection(
          icon: Icons.location_on_outlined,
          title: 'Ubicación',
          content: 'Sala principal - Casa',
        ),
        const SizedBox(height: 12),
        
        InfoSection(
          icon: Icons.info_outline,
          title: 'Estado',
          content: 'En línea',
          contentColor: AppColors.success,
        ),
        const SizedBox(height: 16),
        
        Text('Loading Indicator', style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        const Center(
          child: SizedBox(
            width: 40,
            height: 40,
            child: LoadingIndicator(),
          ),
        ),
        const SizedBox(height: 16),
        
        Text('Error Display', style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        const ErrorDisplay(
          message: 'Error de ejemplo para demostración',
        ),
      ],
    );
  }

  // ==================== COMPONENTES DE LAYOUT ====================
  Widget _buildLayoutComponentsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Page Header', style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        const PageHeader(
          title: 'Título de Página',
        ),
        const SizedBox(height: 16),
        
        Text('Expandable Section', style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        ExpandableSection(
          title: 'Sección Expandible',
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text('Contenido de la sección expandible', style: AppTextStyles.bodyMedium),
            ),
          ],
        ),
        const SizedBox(height: 16),
        
        Text('Device Header', style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        DeviceHeader(
          model: 'FAC 500 Vita',
          serialNumber: '123456789',
          isOnline: true,
          onDetailPressed: () {},
        ),
      ],
    );
  }
}

class _ColorItem {
  final String name;
  final Color color;
  final String hex;

  _ColorItem(this.name, this.color, this.hex);
}

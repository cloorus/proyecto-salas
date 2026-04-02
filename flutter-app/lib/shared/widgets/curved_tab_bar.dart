import 'package:flutter/material.dart';
import 'tab_shape_painter.dart';
import '../../core/theme/app_colors.dart';

/// Colores del tema para los tabs curvados
class CurvedTabBarColors {
  /// Color púrpura para tabs activos (#662D91)
  static const Color activeTab = Color(0xFF662D91);
  
  /// Color gris para tabs inactivos (#A39D9D)
  static const Color inactiveTab = Color(0xFFA39D9D);
  
  /// Color gris claro para el botón "+" (#E8E8E8)
  static const Color addButton = Color(0xFFE8E8E8);
  
  /// Color del texto inactivo (#666666)
  static const Color inactiveText = Color(0xFF666666);
}

/// Widget de barra de tabs con forma curva característica del diseño BGnius.
/// 
/// Cada tab tiene esquinas superiores redondeadas y curvas cóncavas ("orejas")
/// en las esquinas inferiores, con una línea púrpura de conexión en la base.
class CurvedTabBar extends StatelessWidget {
  /// Lista de títulos para cada tab
  final List<String> tabs;
  
  /// Índice del tab actualmente seleccionado
  final int selectedIndex;
  
  /// Callback cuando se selecciona un tab
  final ValueChanged<int>? onTabChanged;
  
  /// Callback cuando se presiona el botón "+"
  final VoidCallback? onAddPressed;
  
  /// Altura de los tabs (sin incluir la línea inferior)
  final double tabHeight;
  
  /// Altura de la línea púrpura inferior
  final double lineHeight;
  
  /// Si se debe mostrar el botón "+"
  final bool showAddButton;

  const CurvedTabBar({
    super.key,
    required this.tabs,
    required this.selectedIndex,
    this.onTabChanged,
    this.onAddPressed,
    this.tabHeight = 36.0,
    this.lineHeight = 7.0,  // Aumentado de 5.0 a 7.0 para línea más gruesa
    this.showAddButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Fila de tabs
          SizedBox(
            height: tabHeight,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Tabs dinámicos
                ...tabs.asMap().entries.map((entry) {
                  final index = entry.key;
                  final title = entry.value;
                  final isActive = index == selectedIndex;
                  
                  return Expanded(
                    flex: index == 0 ? 5 : 4, // Primer tab más ancho
                    child: Padding(
                      padding: EdgeInsets.only(
                        right: index < tabs.length - 1 || showAddButton ? 3.0 : 0,
                      ),
                      child: _buildTab(
                        title: title,
                        isActive: isActive,
                        onTap: () => onTabChanged?.call(index),
                      ),
                    ),
                  );
                }),
                
                // Botón "+"
                if (showAddButton) _buildAddButton(),
              ],
            ),
          ),
          
          // Línea púrpura inferior
          Container(
            height: lineHeight,
            width: double.infinity,
            color: CurvedTabBarColors.activeTab,
          ),
        ],
      ),
    );
  }

  /// Construye un tab individual con la forma curva
  Widget _buildTab({
    required String title,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: TabShape(
        color: isActive 
            ? CurvedTabBarColors.activeTab 
            : CurvedTabBarColors.inactiveTab,
        topLeftRadius: 18,
        topRightRadius: 18,
        earRadius: 14,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              title,
              style: TextStyle(
                color: isActive ? Colors.white : CurvedTabBarColors.inactiveText,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ),
    );
  }

  /// Construye el botón de agregar "+"
  Widget _buildAddButton() {
    return GestureDetector(
      onTap: onAddPressed,
      child: SizedBox(
        width: 70,  // Más ancho (era 50)
        child: TabShape(
          color: CurvedTabBarColors.addButton,
          topLeftRadius: 18,
          topRightRadius: 18,
          earRadius: 14,
          child: const Center(
            child: Text(
              '+',
              style: TextStyle(
                color: CurvedTabBarColors.inactiveText,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

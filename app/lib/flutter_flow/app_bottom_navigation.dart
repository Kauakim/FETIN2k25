import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/tabela_pag/tabela_pag_widget.dart';
import '/home_mapa/home_mapa_widget.dart';
import '/tasks/tasks_widget.dart';
import '/perfil_usuario/perfil_usuario_widget.dart';
import 'package:flutter/material.dart';

class AppBottomNavigation extends StatelessWidget {
  final int currentIndex;
  
  const AppBottomNavigation({
    super.key,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    final isMobileDevice = isMobile || MediaQuery.of(context).size.width < 768;
    
    return Container(
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        boxShadow: [
          BoxShadow(
            blurRadius: 10.0,
            color: Color(0x1A000000),
            offset: Offset(0.0, -5.0),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isMobileDevice ? 8.0 : 16.0,
            vertical: isMobileDevice ? 8.0 : 12.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                context: context,
                icon: Icons.map_outlined,
                selectedIcon: Icons.map,
                label: 'Mapa',
                index: 0,
                isSelected: currentIndex == 0,
                onTap: () => _navigateToPage(context, 0),
                isMobile: isMobileDevice,
              ),
              _buildNavItem(
                context: context,
                icon: Icons.table_chart_outlined,
                selectedIcon: Icons.table_chart,
                label: 'Tabela',
                index: 1,
                isSelected: currentIndex == 1,
                onTap: () => _navigateToPage(context, 1),
                isMobile: isMobileDevice,
              ),
              _buildNavItem(
                context: context,
                icon: Icons.assignment_outlined,
                selectedIcon: Icons.assignment,
                label: 'Tasks',
                index: 2,
                isSelected: currentIndex == 2,
                onTap: () => _navigateToPage(context, 2),
                isMobile: isMobileDevice,
              ),
              _buildNavItem(
                context: context,
                icon: Icons.person_outline,
                selectedIcon: Icons.person,
                label: 'Perfil',
                index: 3,
                isSelected: currentIndex == 3,
                onTap: () => _navigateToPage(context, 3),
                isMobile: isMobileDevice,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required IconData icon,
    required IconData selectedIcon,
    required String label,
    required int index,
    required bool isSelected,
    required VoidCallback onTap,
    required bool isMobile,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.0),
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: isMobile ? 8.0 : 12.0,
            horizontal: isMobile ? 4.0 : 8.0,
          ),
          decoration: BoxDecoration(
            color: isSelected 
              ? FlutterFlowTheme.of(context).primary.withValues(alpha: 0.1)
              : Colors.transparent,
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isSelected ? selectedIcon : icon,
                color: isSelected 
                  ? FlutterFlowTheme.of(context).primary
                  : FlutterFlowTheme.of(context).secondaryText,
                size: isMobile ? 24.0 : 28.0,
              ),
              SizedBox(height: isMobile ? 4.0 : 6.0),
              Text(
                label,
                style: FlutterFlowTheme.of(context).labelSmall.copyWith(
                  color: isSelected 
                    ? FlutterFlowTheme.of(context).primary
                    : FlutterFlowTheme.of(context).secondaryText,
                  fontSize: isMobile ? 11.0 : 12.0,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToPage(BuildContext context, int index) {
    // Evita navegar para a mesma página
    if (index == currentIndex) return;
    
    switch (index) {
      case 0:
        context.pushNamed(HomeMapaWidget.routeName);
        break;
      case 1:
        context.pushNamed(TabelaPagWidget.routeName);
        break;
      case 2:
        context.pushNamed(TasksWidget.routeName);
        break;
      case 3:
        context.pushNamed(PerfilUsuarioWidget.routeName);
        break;
    }
  }
}

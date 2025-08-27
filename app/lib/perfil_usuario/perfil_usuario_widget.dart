import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/app_bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'perfil_usuario_model.dart';
export 'perfil_usuario_model.dart';

class PerfilUsuarioWidget extends StatefulWidget {
  const PerfilUsuarioWidget({super.key});

  static String routeName = 'PerfilUsuario';
  static String routePath = '/perfilUsuario';

  @override
  State<PerfilUsuarioWidget> createState() => _PerfilUsuarioWidgetState();
}

class _PerfilUsuarioWidgetState extends State<PerfilUsuarioWidget> {
  late PerfilUsuarioModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PerfilUsuarioModel());
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).primary,
          automaticallyImplyLeading: false,
          title: Text(
            'Perfil do Usuário',
            style: FlutterFlowTheme.of(context).headlineMedium.copyWith(
              color: Colors.white,
              fontSize: 22.0,
              letterSpacing: 0.0,
            ),
          ),
          centerTitle: false,
          elevation: 2.0,
        ),
        bottomNavigationBar: AppBottomNavigation(currentIndex: 3),
        body: SafeArea(
          top: true,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Profile Picture Section
                Container(
                  width: 120.0,
                  height: 120.0,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).alternate,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: FlutterFlowTheme.of(context).primary,
                      width: 3.0,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(60.0),
                    child: Image.network(
                      _model.fotoPerfilUrl,
                      width: 120.0,
                      height: 120.0,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 120.0,
                          height: 120.0,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context).alternate,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.person,
                            size: 60.0,
                            color: FlutterFlowTheme.of(context).primaryText,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                
                SizedBox(height: 32.0),
                
                // User Info Card
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(24.0),
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    borderRadius: BorderRadius.circular(16.0),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 4.0,
                        color: Color(0x33000000),
                        offset: Offset(0.0, 2.0),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name Section
                      Text(
                        'Nome',
                        style: FlutterFlowTheme.of(context).bodyMedium.copyWith(
                          color: FlutterFlowTheme.of(context).secondaryText,
                          fontSize: 14.0,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 12.0,
                        ),
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).primaryBackground,
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(
                            color: FlutterFlowTheme.of(context).alternate,
                            width: 1.0,
                          ),
                        ),
                        child: Text(
                          _model.nomeUsuario,
                          style: FlutterFlowTheme.of(context).bodyLarge.copyWith(
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      
                      SizedBox(height: 24.0),
                      
                      // Password Section
                      Text(
                        'Senha',
                        style: FlutterFlowTheme.of(context).bodyMedium.copyWith(
                          color: FlutterFlowTheme.of(context).secondaryText,
                          fontSize: 14.0,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 12.0,
                        ),
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).primaryBackground,
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(
                            color: FlutterFlowTheme.of(context).alternate,
                            width: 1.0,
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                _model.senhaVisibility 
                                  ? _model.senhaUsuario 
                                  : '•' * _model.senhaUsuario.length,
                                style: FlutterFlowTheme.of(context).bodyLarge.copyWith(
                                  letterSpacing: _model.senhaVisibility ? 0.0 : 2.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  _model.toggleSenhaVisibility();
                                });
                              },
                              child: Icon(
                                _model.senhaVisibility 
                                  ? Icons.visibility_off 
                                  : Icons.visibility,
                                color: FlutterFlowTheme.of(context).secondaryText,
                                size: 24.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                
                SizedBox(height: 32.0),
                
                // Tracking Control Card
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(24.0),
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    borderRadius: BorderRadius.circular(16.0),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 4.0,
                        color: Color(0x33000000),
                        offset: Offset(0.0, 2.0),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            color: FlutterFlowTheme.of(context).primary,
                            size: 24.0,
                          ),
                          SizedBox(width: 12.0),
                          Expanded(
                            child: Text(
                              'Rastreamento',
                              style: FlutterFlowTheme.of(context).headlineSmall.copyWith(
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      
                      SizedBox(height: 16.0),
                      
                      Text(
                        'Ative o rastreamento para permitir que sua localização seja monitorada a cada 5 segundos.',
                        style: FlutterFlowTheme.of(context).bodyMedium.copyWith(
                          color: FlutterFlowTheme.of(context).secondaryText,
                          letterSpacing: 0.0,
                        ),
                      ),
                      
                      SizedBox(height: 24.0),
                      
                      // Tracking Toggle
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 12.0,
                        ),
                        decoration: BoxDecoration(
                          color: _model.isTrackingEnabled 
                            ? FlutterFlowTheme.of(context).primary.withOpacity(0.1)
                            : FlutterFlowTheme.of(context).primaryBackground,
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(
                            color: _model.isTrackingEnabled 
                              ? FlutterFlowTheme.of(context).primary
                              : FlutterFlowTheme.of(context).alternate,
                            width: 1.0,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _model.isTrackingEnabled 
                                    ? 'Rastreamento Ativo' 
                                    : 'Rastreamento Inativo',
                                  style: FlutterFlowTheme.of(context).bodyLarge.copyWith(
                                    color: _model.isTrackingEnabled 
                                      ? FlutterFlowTheme.of(context).primary
                                      : FlutterFlowTheme.of(context).primaryText,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                if (_model.isTrackingEnabled)
                                  Text(
                                    'Atualizando a cada 5 segundos',
                                    style: FlutterFlowTheme.of(context).bodySmall.copyWith(
                                      color: FlutterFlowTheme.of(context).primary,
                                      letterSpacing: 0.0,
                                    ),
                                  ),
                              ],
                            ),
                            Switch(
                              value: _model.isTrackingEnabled,
                              onChanged: (value) {
                                setState(() {
                                  _model.toggleTracking();
                                });
                              },
                              activeColor: FlutterFlowTheme.of(context).primary,
                              activeTrackColor: FlutterFlowTheme.of(context).primary.withOpacity(0.3),
                              inactiveThumbColor: FlutterFlowTheme.of(context).secondaryText,
                              inactiveTrackColor: FlutterFlowTheme.of(context).alternate,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                
                SizedBox(height: 40.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

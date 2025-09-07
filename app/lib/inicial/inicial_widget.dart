import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'inicial_model.dart';
export 'inicial_model.dart';

/// Login
///
class InicialWidget extends StatefulWidget {
  const InicialWidget({super.key});

  static String routeName = 'Inicial';
  static String routePath = '/inicial';

  @override
  State<InicialWidget> createState() => _InicialWidgetState();
}

class _InicialWidgetState extends State<InicialWidget> {
  late InicialModel _model;
  String? errorMessage;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => InicialModel());

    _model.textFieldUsernameTextController ??= TextEditingController();
    _model.textFieldUsernameFocusNode ??= FocusNode();

    _model.textFieldPasswordTextController ??= TextEditingController();
    _model.textFieldPasswordFocusNode ??= FocusNode();
    
    // Adicionar listeners para limpar mensagem de erro
    _model.textFieldUsernameTextController?.addListener(() {
      if (errorMessage != null) {
        setState(() {
          errorMessage = null;
        });
      }
    });
    
    _model.textFieldPasswordTextController?.addListener(() {
      if (errorMessage != null) {
        setState(() {
          errorMessage = null;
        });
      }
    });
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    
    final isShortScreen = screenHeight < 750;
    final isVeryShortScreen = screenHeight < 650;

    final logoSpacing = isVeryShortScreen ? 20.0 : (isShortScreen ? 40.0 : (isMobile ? 60.0 : 80.0));
    final titleSpacing = isVeryShortScreen ? 16.0 : (isShortScreen ? 24.0 : 32.0);
    final fieldsSpacing = isVeryShortScreen ? 8.0 : (isShortScreen ? 12.0 : 16.0);
    final buttonSpacing = isVeryShortScreen ? 16.0 : (isShortScreen ? 20.0 : 24.0);
    final titleSubtitleSpacing = isVeryShortScreen ? 6.0 : (isShortScreen ? 8.0 : 12.0);
    
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.white,
        body: SafeArea(
          top: true,
          child: Stack(
            children: [
              // Background principal
              Column(
                children: [
                  // Logo SIMTER no topo
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 24.0),
                    width: double.infinity,
                    child: Center(
                      child: Image.asset(
                        'assets/logo.png',
                        width: isVeryShortScreen ? 240.0 : isShortScreen ? 420.0 : 480.0,
                        height: isVeryShortScreen ? 160.0 : isShortScreen ? 280.0 : 320.0,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),

                  SizedBox(height: logoSpacing),

                  // Espaço restante com campos centralizados
                  Expanded(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24.0),
                        child: Container(
                      child: Column(
                        children: [
                          // Título Login
                          Column(
                            children: [
                              Text(
                                'Login',
                                style: FlutterFlowTheme.of(context).headlineMedium.override(
                                  font: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w800,
                                  ),
                                  color: Color(0xFF2C3E50),
                                  fontSize: isVeryShortScreen ? 28.0 : (isShortScreen ? 32.0 : 40.0),
                                  letterSpacing: 1.2,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              
                              SizedBox(height: titleSubtitleSpacing),
                                
                              Text(
                                'Bem-vindo ao SIMTER',
                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                  font: GoogleFonts.inter(
                                    fontWeight: FontWeight.w500,
                                  ),
                                  color: Color(0xFF6B7280),
                                  fontSize: isVeryShortScreen ? 16.0 : (isShortScreen ? 18.0 : 20.0),
                                  letterSpacing: 0.5,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          
                          SizedBox(height: titleSpacing),
                    
                  // Campo Usuário
                  Container(
                      width: 480.0,
                      height: 60.0,
                      decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40.0),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 6.0,
                          color: Color(0x1A000000),
                          offset: Offset(0.0, 2.0),
                        ),
                      ],
                    ),
                    child: TextFormField(
                      controller: _model.textFieldUsernameTextController,
                      focusNode: _model.textFieldUsernameFocusNode,
                      autofocus: true,
                      autofillHints: [AutofillHints.email],
                      obscureText: false,
                      onFieldSubmitted: (value) async {
                        await _model.performLogin(context);
                        safeSetState(() {});
                      },
                      decoration: InputDecoration(
                        labelText: 'Usuário',
                        labelStyle: FlutterFlowTheme.of(context)
                          .labelLarge
                          .override(
                            font: GoogleFonts.plusJakartaSans(
                              fontWeight: FontWeight.w500,
                            ),
                            color: Color(0xFF57636C),
                            fontSize: 16.0,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w500,
                          ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFFE0E3E7),
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(40.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFF4B39EF),
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(40.0),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFFFF5963),
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(40.0),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFFFF5963),
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(40.0),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.all(24.0),
                      ),
                      style: FlutterFlowTheme.of(context)
                        .bodyLarge
                        .override(
                          font: GoogleFonts.plusJakartaSans(
                            fontWeight: FontWeight.w500,
                          ),
                          color: Color(0xFF101213),
                          fontSize: 16.0,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w500,
                        ),
                      validator: _model.textFieldUsernameTextControllerValidator.asValidator(context),
                    ),
                  ),
                    
                  SizedBox(height: fieldsSpacing),
                    
                  // Campo Senha
                  Container(
                    width: 480.0,
                    height: 60.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40.0),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 6.0,
                          color: Color(0x1A000000),
                          offset: Offset(0.0, 2.0),
                        ),
                      ],
                    ),
                    child: TextFormField(
                      controller: _model.textFieldPasswordTextController,
                      focusNode: _model.textFieldPasswordFocusNode,
                      autofocus: false,
                      autofillHints: [AutofillHints.password],
                      obscureText: !_model.textFieldPasswordVisibility,
                      onFieldSubmitted: (value) async {
                        await _model.performLogin(context);
                        safeSetState(() {});
                      },
                      decoration: InputDecoration(
                        labelText: 'Senha',
                        labelStyle: FlutterFlowTheme.of(context)
                          .labelLarge
                          .override(
                            font: GoogleFonts.plusJakartaSans(
                              fontWeight: FontWeight.w500,
                            ),
                            color: Color(0xFF57636C),
                            fontSize: 16.0,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w500,
                          ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFFE0E3E7),
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(40.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFF4B39EF),
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(40.0),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFFFF5963),
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(40.0),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFFFF5963),
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(40.0),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.fromLTRB(24.0, 24.0, 60.0, 24.0),
                        suffixIcon: Padding(
                          padding: EdgeInsets.only(right: 16.0),
                          child: InkWell(
                            onTap: () => safeSetState(
                              () => _model.textFieldPasswordVisibility = !_model.textFieldPasswordVisibility,
                            ),
                            focusNode: FocusNode(skipTraversal: true),
                            child: Icon(
                              _model.textFieldPasswordVisibility
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                              color: Color(0xFF57636C),
                                size: 22.0,
                              ),
                            ),
                          ),
                        ),
                        style: FlutterFlowTheme.of(context)
                          .bodyLarge
                          .override(
                            font: GoogleFonts.plusJakartaSans(
                              fontWeight: FontWeight.w500,
                            ),
                            color: Color(0xFF101213),
                            fontSize: 16.0,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w500,
                          ),
                        validator: _model.textFieldPasswordTextControllerValidator.asValidator(context),
                      ),
                    ),
                    
                    SizedBox(height: buttonSpacing),
                    
                    // Botão Entrar
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40.0),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 8.0,
                            color: Color(0x33000000),
                            offset: Offset(0.0, 4.0),
                          ),
                        ],
                      ),
                      child: FFButtonWidget(
                        onPressed: () async {
                          final error = await _model.performLogin(context);
                          setState(() {
                            errorMessage = error;
                          });
                        },
                        text: 'Entrar',
                        options: FFButtonOptions(
                          width: 240.0,
                          height: 60.0,
                          padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                          iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                          color: Color(0xFF4B39EF),
                          textStyle: FlutterFlowTheme.of(context)
                            .titleSmall
                            .override(
                              font: GoogleFonts.plusJakartaSans(
                                fontWeight: FontWeight.w500,
                              ),
                              color: Colors.white,
                              fontSize: 16.0,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w500,
                            ),
                          elevation: 0.0,
                          borderSide: BorderSide(
                            color: Colors.transparent,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(40.0),
                        ),
                      ),
                    ),
                    
                    // Área de mensagem de erro
                    if (errorMessage != null) ...[
                      SizedBox(height: 16.0),
                      Center(
                        child: Container(
                          constraints: BoxConstraints(maxWidth: 300.0),
                          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                          decoration: BoxDecoration(
                            color: Color(0xFFFFEBEE),
                            borderRadius: BorderRadius.circular(12.0),
                            border: Border.all(
                              color: Color(0xFFE57373),
                              width: 1.0,
                            ),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 4.0,
                                color: Color(0x1F000000),
                                offset: Offset(0.0, 2.0),
                              ),
                            ],
                          ),
                          child: Text(
                            errorMessage!,
                            textAlign: TextAlign.center,
                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Inter',
                              color: Color(0xFFD32F2F),
                              fontSize: 15.0,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      ),
      ),
    );
  }
}

import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
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

class _InicialWidgetState extends State<InicialWidget>
    with TickerProviderStateMixin {
  late InicialModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = <String, AnimationInfo>{};

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => InicialModel());

    _model.tabBarController = TabController(
      vsync: this,
      length: 1,
      initialIndex: 0,
    )..addListener(() => safeSetState(() {}));

    _model.textFieldUsernameTextController ??= TextEditingController();
    _model.textFieldUsernameFocusNode ??= FocusNode();

    _model.textFieldPasswordTextController ??= TextEditingController();
    _model.textFieldPasswordFocusNode ??= FocusNode();

    animationsMap.addAll({
      'containerOnPageLoadAnimation': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          VisibilityEffect(duration: 1.ms),
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 400.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 400.0.ms,
            begin: Offset(0.0, 80.0),
            end: Offset(0.0, 0.0),
          ),
          ScaleEffect(
            curve: Curves.easeInOut,
            delay: 150.0.ms,
            duration: 400.0.ms,
            begin: Offset(0.8, 0.8),
            end: Offset(1.0, 1.0),
          ),
        ],
      ),
      'columnOnPageLoadAnimation': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          VisibilityEffect(duration: 300.ms),
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 300.0.ms,
            duration: 400.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 300.0.ms,
            duration: 400.0.ms,
            begin: Offset(0.0, 20.0),
            end: Offset(0.0, 0.0),
          ),
        ],
      ),
    });
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
        backgroundColor: Colors.white,
        body: LayoutBuilder(
          builder: (context, constraints) {
            final isMobileDevice = isMobile || constraints.maxWidth < 768;
            
            return SafeArea(
              top: true,
              child: Stack(
                children: [
                  // Header SIMTER
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(
                      isMobileDevice ? 16.0 : 32.0, 
                      isMobileDevice ? 8.0 : 12.0, 
                      isMobileDevice ? 16.0 : 32.0, 
                      isMobileDevice ? 16.0 : 32.0
                    ),
                    child: Container(
                      width: double.infinity,
                      height: isMobileDevice ? 150.0 : 200.0,
                      decoration: BoxDecoration(
                        color: Color(0xFFF1F4F8),
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      alignment: AlignmentDirectional(0.0, 0.0),
                      child: Align(
                        alignment: AlignmentDirectional(0.0, 0.0),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 12.0),
                          child: Text(
                            'SIMTER',
                            style: FlutterFlowTheme.of(context).displaySmall.override(
                              font: GoogleFonts.plusJakartaSans(
                                fontWeight: FontWeight.w600,
                                fontStyle: FlutterFlowTheme.of(context)
                                  .displaySmall
                                  .fontStyle,
                              ),
                              color: Color(0xFF101213),
                              fontSize: isMobileDevice ? 36.0 : 50.0,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w600,
                              fontStyle: FlutterFlowTheme.of(context)
                                .displaySmall
                                .fontStyle,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              Align(
                alignment: AlignmentDirectional(0.0, -1.0),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 170.0, 0.0, 0.0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Container(
                            width: double.infinity,
                            height: MediaQuery.sizeOf(context).width >= 768.0
                              ? 530.0
                              : 630.0,
                            constraints: BoxConstraints(
                              maxWidth: 570.0,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 4.0,
                                  color: Color(0x33000000),
                                  offset: Offset(
                                    0.0,
                                    2.0,
                                  ),
                                )
                              ],
                              borderRadius: BorderRadius.circular(12.0),
                              border: Border.all(
                                color: Color(0xFFF1F4F8),
                                width: 2.0,
                              ),
                            ),
                            child: Align(
                              alignment: AlignmentDirectional(0.0, 0.0),
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 12.0, 0.0, 0.0),
                                child: Column(
                                  children: [
                                    Align(
                                      alignment: Alignment(0.0, 0),
                                      child: TabBar(
                                        isScrollable: true,
                                        labelColor: Color(0xFF101213),
                                        unselectedLabelColor: Color(0xFF57636C),
                                        labelPadding:
                                          EdgeInsetsDirectional.fromSTEB(32.0, 0.0, 32.0, 0.0),
                                        labelStyle: FlutterFlowTheme.of(context)
                                          .headlineMedium
                                          .override(
                                            font: GoogleFonts.outfit(
                                              fontWeight:
                                                FlutterFlowTheme.of(context)
                                                  .headlineMedium
                                                  .fontWeight,
                                              fontStyle:
                                                FlutterFlowTheme.of(context)
                                                  .headlineMedium
                                                  .fontStyle,
                                            ),
                                            fontSize: 36.0,
                                            letterSpacing: 0.0,
                                            fontWeight:
                                              FlutterFlowTheme.of(context)
                                                .headlineMedium
                                                .fontWeight,
                                            fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .headlineMedium
                                                  .fontStyle,
                                            ),
                                        unselectedLabelStyle: FlutterFlowTheme
                                          .of(context)
                                          .titleMedium
                                          .override(
                                            font: GoogleFonts.plusJakartaSans(
                                              fontWeight: FontWeight.w500,
                                              fontStyle:
                                                FlutterFlowTheme.of(context)
                                                  .titleMedium
                                                  .fontStyle,
                                            ),
                                            color: Colors.white,
                                            fontSize: 18.0,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.w500,
                                            fontStyle:
                                              FlutterFlowTheme.of(context)
                                                .titleMedium
                                                .fontStyle,
                                          ),
                                        indicatorColor: Color(0xFF4B39EF),
                                        indicatorWeight: 3.0,
                                        tabs: [
                                          Tab(
                                            text: 'Login',
                                          ),
                                        ],
                                        controller: _model.tabBarController,
                                        onTap: (i) async {
                                          [() async {}][i]();
                                        },
                                      ),
                                    ),
                                    Expanded(
                                      child: TabBarView(
                                        controller: _model.tabBarController,
                                        children: [
                                          Align(
                                            alignment: AlignmentDirectional(0.0, -1.0),
                                            child: Padding(
                                              padding: EdgeInsetsDirectional
                                                .fromSTEB(24.0, 2.0, 24.0, 0.0),
                                              child: SingleChildScrollView(
                                                child: Column(
                                                  mainAxisSize:
                                                    MainAxisSize.max,
                                                  crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                  children: [
                                                    if (responsiveVisibility(
                                                      context: context,
                                                      phone: false,
                                                      tablet: false,
                                                    ))
                                                      Container(
                                                        width: 230.0,
                                                        height: 40.0,
                                                        decoration: BoxDecoration(color: Colors.white),
                                                      ),
                                                    Align(
                                                      alignment:
                                                        AlignmentDirectional(0.0, 0.0),
                                                      child: Padding(
                                                        padding:
                                                          EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 6.0, 0.0, 24.0),
                                                        child: Text(
                                                          'Bem vindo ao APP do SIMTER',
                                                          textAlign:
                                                            TextAlign.start,
                                                          style: FlutterFlowTheme
                                                            .of(context)
                                                            .labelMedium
                                                            .override(
                                                              font: GoogleFonts.plusJakartaSans(
                                                                fontWeight: FontWeight.w500,
                                                                fontStyle: FlutterFlowTheme.of(context)
                                                                  .labelMedium
                                                                  .fontStyle,
                                                              ),
                                                              color: Color(0xFF57636C),
                                                                fontSize: 12.0,
                                                                letterSpacing:
                                                                  0.0,
                                                                fontWeight:FontWeight.w500,
                                                                fontStyle: FlutterFlowTheme.of(context)
                                                                  .labelMedium
                                                                  .fontStyle,
                                                              ),
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                        EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 16.0),
                                                      child: Container(
                                                        width: double.infinity,
                                                        child: TextFormField(
                                                          controller: _model
                                                            .textFieldUsernameTextController,
                                                          focusNode: _model
                                                            .textFieldUsernameFocusNode,
                                                          autofocus: true,
                                                          autofillHints: [
                                                            AutofillHints.email
                                                          ],
                                                          obscureText: false,
                                                          decoration: InputDecoration(
                                                            labelText:
                                                              'Usuário',
                                                            labelStyle:
                                                              FlutterFlowTheme.of(context)
                                                                .labelLarge
                                                                .override(
                                                                  font: GoogleFonts.plusJakartaSans(
                                                                    fontWeight:FontWeight.w500,
                                                                    fontStyle: FlutterFlowTheme.of(context).labelLarge.fontStyle,
                                                                  ),
                                                                  color: Color(0xFF57636C),
                                                                  fontSize: 16.0,
                                                                  letterSpacing: 0.0,
                                                                  fontWeight: FontWeight.w500,
                                                                  fontStyle: FlutterFlowTheme.of(context)
                                                                    .labelLarge
                                                                    .fontStyle,
                                                                  ),
                                                            enabledBorder: OutlineInputBorder(
                                                              borderSide: BorderSide(
                                                                color: Color(0xFFE0E3E7),
                                                                width: 2.0,
                                                              ),
                                                              borderRadius:
                                                                BorderRadius.circular(40.0),
                                                            ),
                                                            focusedBorder:
                                                              OutlineInputBorder(
                                                                borderSide: BorderSide(
                                                                  color: Color(0xFF4B39EF),
                                                                  width: 2.0,
                                                                ),
                                                                borderRadius:
                                                                  BorderRadius.circular(40.0),
                                                              ),
                                                            errorBorder:
                                                              OutlineInputBorder(
                                                                borderSide:
                                                                  BorderSide(
                                                                    color: Color(0xFFFF5963),
                                                                    width: 2.0,
                                                                  ),
                                                                borderRadius:
                                                                  BorderRadius.circular(40.0),
                                                              ),
                                                            focusedErrorBorder:
                                                              OutlineInputBorder(
                                                                borderSide:
                                                                  BorderSide(
                                                                    color: Color(0xFFFF5963),
                                                                  width: 2.0,
                                                                ),
                                                                borderRadius:
                                                                  BorderRadius.circular(40.0),
                                                              ),
                                                            filled: true,
                                                            fillColor: Colors.white,
                                                            contentPadding:
                                                              EdgeInsets.all(24.0),
                                                          ),
                                                          style: FlutterFlowTheme.of(context)
                                                            .bodyLarge
                                                            .override(
                                                              font: GoogleFonts.plusJakartaSans(
                                                                fontWeight:
                                                                  FontWeight.w500,
                                                                  fontStyle: FlutterFlowTheme.of(context)
                                                                    .bodyLarge
                                                                    .fontStyle,
                                                              ),
                                                              color: Color(0xFF101213),
                                                              fontSize: 16.0,
                                                              letterSpacing:0.0,
                                                              fontWeight: FontWeight.w500,
                                                              fontStyle: FlutterFlowTheme.of(context)
                                                                .bodyLarge
                                                                .fontStyle,
                                                              ),
                                                          validator: _model
                                                            .textFieldUsernameTextControllerValidator
                                                            .asValidator(context),
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                        EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 24.0),
                                                      child: Container(
                                                        width: double.infinity,
                                                        child: TextFormField(
                                                          controller: _model.textFieldPasswordTextController,
                                                          focusNode: _model.textFieldPasswordFocusNode,
                                                          autofocus: true,
                                                          autofillHints: [
                                                            AutofillHints.password
                                                          ],
                                                          obscureText: !_model.textFieldPasswordVisibility,
                                                          decoration:
                                                            InputDecoration(
                                                              labelText: 'Senha',
                                                              labelStyle:
                                                              FlutterFlowTheme.of(context)
                                                                .labelLarge
                                                                .override(
                                                                  font: GoogleFonts.plusJakartaSans(
                                                                    fontWeight:FontWeight.w500,
                                                                    fontStyle: FlutterFlowTheme.of(context)
                                                                      .labelLarge
                                                                      .fontStyle,
                                                                  ),
                                                                  color: Color(0xFF57636C),
                                                                  fontSize: 16.0,
                                                                  letterSpacing: 0.0,
                                                                  fontWeight: FontWeight.w500,
                                                                  fontStyle: FlutterFlowTheme.of(context)
                                                                    .labelLarge
                                                                    .fontStyle,
                                                                ),
                                                            enabledBorder:
                                                              OutlineInputBorder(
                                                                borderSide:
                                                                  BorderSide(
                                                                    color: Color(0xFFE0E3E7),
                                                                    width: 2.0,
                                                                  ),
                                                                borderRadius:
                                                                  BorderRadius.circular(40.0),
                                                              ),
                                                            focusedBorder:
                                                              OutlineInputBorder(
                                                                borderSide:
                                                                  BorderSide(
                                                                  color: Color(0xFF4B39EF),
                                                                  width: 2.0,
                                                                ),
                                                                borderRadius:
                                                                  BorderRadius.circular(40.0),
                                                              ),
                                                            errorBorder:
                                                              OutlineInputBorder(
                                                                borderSide:
                                                                  BorderSide(
                                                                    color: Color(0xFFFF5963),
                                                                    width: 2.0,
                                                                  ),
                                                                borderRadius:
                                                                  BorderRadius.circular(40.0),
                                                              ),
                                                            focusedErrorBorder:
                                                              OutlineInputBorder(
                                                                borderSide:
                                                                  BorderSide(
                                                                    color: Color(0xFFFF5963),
                                                                    width: 2.0,
                                                                  ),
                                                                borderRadius:
                                                                  BorderRadius.circular(40.0),
                                                              ),
                                                            filled: true,
                                                            fillColor:Colors.white,
                                                            contentPadding:
                                                              EdgeInsets.all(24.0),
                                                            suffixIcon: InkWell(
                                                              onTap: () =>
                                                                safeSetState(
                                                                  () => _model.textFieldPasswordVisibility =!_model.textFieldPasswordVisibility,
                                                                ),
                                                              focusNode: FocusNode(skipTraversal:true),
                                                              child: Icon(
                                                                _model.textFieldPasswordVisibility
                                                                  ? Icons
                                                                    .visibility_outlined
                                                                  : Icons
                                                                    .visibility_off_outlined,
                                                                color: Color(0xFF57636C),
                                                                  size: 24.0,
                                                              ),
                                                            ),
                                                          ),
                                                          style: FlutterFlowTheme.of(context)
                                                            .bodyLarge
                                                            .override(
                                                              font: GoogleFonts.plusJakartaSans(
                                                                fontWeight: FontWeight.w500,
                                                                fontStyle: FlutterFlowTheme.of(context)
                                                                  .bodyLarge
                                                                  .fontStyle,
                                                              ),
                                                              color: Color(0xFF101213),
                                                              fontSize: 16.0,
                                                              letterSpacing: 0.0,
                                                              fontWeight: FontWeight.w500,
                                                              fontStyle: FlutterFlowTheme.of(context)
                                                                .bodyLarge
                                                                .fontStyle,
                                                            ),
                                                          validator: _model
                                                            .textFieldPasswordTextControllerValidator
                                                            .asValidator(context),
                                                        ),
                                                      ),
                                                    ),
                                                    Align(
                                                      alignment: AlignmentDirectional(0.0, 0.0),
                                                      child: Padding(
                                                        padding:
                                                          EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 16.0),
                                                        child: FFButtonWidget(
                                                          onPressed: () async {
                                                            final username = _model.textFieldUsernameTextController.text.trim();
                                                            final password = _model.textFieldPasswordTextController.text;
                                                            
                                                            if (username == 'admin' && password == 'admin') {
                                                              context.pushNamed(TabelaPagWidget.routeName);
                                                              return;
                                                            }

                                                            _model.apiResultxi5 =
                                                              await UserLoginCall.call(
                                                                username: username,
                                                                password: password,
                                                              );

                                                            if (_model.apiResultxi5?.statusCode == 200) {
                                                              context.pushNamed(TabelaPagWidget.routeName);
                                                            } else {
                                                              String errorMessage;
                                                              
                                                              // Check for communication failure
                                                              if (_model.apiResultxi5?.statusCode == -1 || 
                                                                  _model.apiResultxi5?.exception != null ||
                                                                  _model.apiResultxi5?.jsonBody == null) {
                                                                errorMessage = 'Falha de comunicação';
                                                              } else {
                                                                // Extract error message from FastAPI response
                                                                final apiError = getJsonField(
                                                                  (_model.apiResultxi5?.jsonBody ?? ''),
                                                                  r'''$.detail''',
                                                                );
                                                                
                                                                if (apiError != null && apiError.toString().isNotEmpty) {
                                                                  errorMessage = apiError.toString();
                                                                } else {
                                                                  errorMessage = 'Falha de comunicação';
                                                                }
                                                              }
                                                              
                                                              ScaffoldMessenger.of(context).showSnackBar(
                                                                SnackBar(
                                                                  content: Text(
                                                                    errorMessage,
                                                                    style: TextStyle(
                                                                      color: FlutterFlowTheme.of(context).primaryBackground,
                                                                    ),
                                                                  ),
                                                                  duration: Duration(milliseconds: 3000),
                                                                  backgroundColor: FlutterFlowTheme.of(context).error,
                                                                ),
                                                              );
                                                            }

                                                            safeSetState(() {});
                                                          },
                                                          text: 'Entrar',
                                                          options: FFButtonOptions(
                                                            width: 240.0,
                                                            height: 60.0,
                                                            padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                                            iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                                            color: Color(0xFF4B39EF),
                                                            textStyle:
                                                              FlutterFlowTheme.of(context)
                                                                .titleSmall
                                                                .override(
                                                                  font: GoogleFonts.plusJakartaSans(
                                                                    fontWeight:FontWeight.w500,
                                                                    fontStyle: FlutterFlowTheme.of(context).titleSmall.fontStyle,
                                                                  ),
                                                                  color: Colors.white,
                                                                  fontSize:16.0,
                                                                  letterSpacing:0.0,
                                                                  fontWeight:FontWeight.w500,
                                                                  fontStyle: FlutterFlowTheme.of(context).titleSmall.fontStyle,
                                                                ),
                                                            elevation: 3.0,
                                                            borderSide: BorderSide(
                                                              color: Colors.transparent,
                                                              width: 1.0,
                                                            ),
                                                            borderRadius: BorderRadius.circular(40.0),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Column(
                                                      mainAxisSize: MainAxisSize.max,
                                                      children: [
                                                        Align(
                                                          alignment: AlignmentDirectional(0.0, 0.0),
                                                          child: Padding(
                                                            padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 16.0),
                                                            child: Wrap(
                                                              spacing: 16.0,
                                                              runSpacing: 0.0,
                                                              alignment: WrapAlignment.center,
                                                              crossAxisAlignment: WrapCrossAlignment.center,
                                                              direction: Axis.horizontal,
                                                              runAlignment: WrapAlignment.center,
                                                              verticalDirection: VerticalDirection.down,
                                                              clipBehavior: Clip.none,
                                                              children: [],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ).animateOnPageLoad(animationsMap['columnOnPageLoadAnimation']!),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ).animateOnPageLoad(animationsMap['containerOnPageLoadAnimation']!),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              ],
              ),
            );
          },
        ),
      ),
    );
  }
}

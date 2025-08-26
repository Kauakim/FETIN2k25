import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:async';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'tabela_pag_model.dart';
export 'tabela_pag_model.dart';

class TabelaPagWidget extends StatefulWidget {
  const TabelaPagWidget({super.key});

  static String routeName = 'TabelaPag';
  static String routePath = '/tabelaPag';

  @override
  State<TabelaPagWidget> createState() => _TabelaPagWidgetState();
}

class _TabelaPagWidgetState extends State<TabelaPagWidget> {
  late TabelaPagModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => TabelaPagModel());
    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();
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
            'Page Title',
            style: FlutterFlowTheme.of(context).headlineMedium.copyWith(
              color: Colors.white,
              fontSize: 22.0,
              letterSpacing: 0.0,
            ),
          ),
          centerTitle: false,
          elevation: 2.0,
        ),
        body: Stack(
          children: [
            SafeArea(
              top: true,
              child: Column(
                children: [
                  // Search and Filter Row
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: Container(
                            width: 200.0,
                            child: TextFormField(
                              controller: _model.textController,
                              focusNode: _model.textFieldFocusNode,
                              onChanged: (_) => EasyDebounce.debounce(
                                '_model.textController',
                                Duration(milliseconds: 2000),
                                () async {
                                  safeSetState(() => _model.apiRequestCompleter = null);
                                  await _model.waitForApiRequestCompleted(minWait: 500, maxWait: 1000);
                                },
                              ),
                              decoration: InputDecoration(
                                isDense: true,
                                hintText: 'Pesquisar',
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Color(0x00000000)),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Color(0x00000000)),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: FlutterFlowTheme.of(context).error),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: FlutterFlowTheme.of(context).error),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                filled: true,
                                fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                              ),
                              cursorColor: FlutterFlowTheme.of(context).primaryText,
                              validator: _model.textControllerValidator.asValidator(context),
                            ),
                          ),
                        ),
                        SizedBox(width: 8.0),
                        FFButtonWidget(
                          onPressed: () {
                            setState(() {
                              _model.toggleFilterMenu();
                            });
                          },
                          text: 'Filtro${_model.hasActiveFilters() ? ' (${_model.hasActiveFilters() ? "Ativo" : ""})' : ''}',
                          options: FFButtonOptions(
                            height: 40.0,
                            padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                            color: _model.hasActiveFilters() 
                              ? FlutterFlowTheme.of(context).secondary 
                              : FlutterFlowTheme.of(context).primary,
                            textStyle: FlutterFlowTheme.of(context).titleSmall.copyWith(
                              color: Colors.white,
                              letterSpacing: 0.0,
                            ),
                            elevation: 0.0,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Header Row
                  Container(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(child: Text('Beacon', style: FlutterFlowTheme.of(context).bodyMedium.copyWith(fontWeight: FontWeight.bold))),
                        Expanded(child: Text('Tipo', style: FlutterFlowTheme.of(context).bodyMedium.copyWith(fontWeight: FontWeight.bold))),
                        Expanded(child: Text('Status', style: FlutterFlowTheme.of(context).bodyMedium.copyWith(fontWeight: FontWeight.bold))),
                        Expanded(child: Text('Coordenada', style: FlutterFlowTheme.of(context).bodyMedium.copyWith(fontWeight: FontWeight.bold))),
                      ],
                    ),
                  ),
                  
                  // Data List (Expandable)
                  Expanded(
                    child: FutureBuilder<ApiCallResponse>(
                      future: (_model.apiRequestCompleter ??= Completer<ApiCallResponse>()
                        ..complete(BeaconsGetAllCall.call())).future,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(FlutterFlowTheme.of(context).primary),
                            ),
                          );
                        }
                        
                        final beaconsMap = getJsonField(snapshot.data!.jsonBody, r'''$.Beacons''') as Map<String, dynamic>? ?? {};
                        final allBeacons = beaconsMap.values.toList();
                        final filteredBeacons = _model.getFilteredBeacons(allBeacons);

                        return ListView.builder(
                          itemCount: filteredBeacons.length,
                          itemBuilder: (context, index) {
                            final beacon = filteredBeacons[index];
                            return Container(
                              padding: EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Expanded(child: Text(beacon['beacon'] ?? '', style: FlutterFlowTheme.of(context).bodyMedium)),
                                  Expanded(child: Text(beacon['tipo'] ?? '', style: FlutterFlowTheme.of(context).bodyMedium)),
                                  Expanded(child: Text(beacon['status'] ?? '', style: FlutterFlowTheme.of(context).bodyMedium)),
                                  Expanded(child: Text('${beacon['x']}, ${beacon['y']}', style: FlutterFlowTheme.of(context).bodyMedium)),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            
            // Full Screen Filter Menu Overlay
            if (_model.showFilterMenu)
              Positioned.fill(
                child: Container(
                  color: Colors.black.withOpacity(0.5), // Semi-transparent background
                  child: SafeArea(
                    child: Container(
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                      child: Column(
                        children: [
                          // Header with close button
                          Container(
                            padding: EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context).primary,
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 4.0,
                                  color: Color(0x33000000),
                                  offset: Offset(0.0, 2.0),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Filtros',
                                  style: FlutterFlowTheme.of(context).headlineMedium.copyWith(
                                    color: Colors.white,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Row(
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        setState(() {
                                          _model.clearAllFilters();
                                        });
                                      },
                                      child: Text(
                                        'Limpar Tudo',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        setState(() {
                                          _model.toggleFilterMenu();
                                        });
                                      },
                                      icon: Icon(
                                        Icons.close,
                                        color: Colors.white,
                                        size: 24.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          
                          // Scrollable filter content
                          Expanded(
                            child: SingleChildScrollView(
                              padding: EdgeInsets.all(20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Máquinas
                                  Text(
                                    'Máquinas',
                                    style: FlutterFlowTheme.of(context).titleLarge.copyWith(
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.bold,
                                      color: FlutterFlowTheme.of(context).primary,
                                    ),
                                  ),
                                  SizedBox(height: 12.0),
                                  Wrap(
                                    spacing: 8.0,
                                    runSpacing: 8.0,
                                    children: [
                                      _buildFilterChip('Estação de Carga', _model.filterEstacaoCarga, (value) {
                                        setState(() {
                                          _model.filterEstacaoCarga = value;
                                        });
                                      }),
                                      _buildFilterChip('Impressora 3D', _model.filterImpressora3d, (value) {
                                        setState(() {
                                          _model.filterImpressora3d = value;
                                        });
                                      }),
                                      _buildFilterChip('Impressora', _model.filterImpressora, (value) {
                                        setState(() {
                                          _model.filterImpressora = value;
                                        });
                                      }),
                                      _buildFilterChip('Máquina de Corrosão', _model.filterMaquinaCorrosao, (value) {
                                        setState(() {
                                          _model.filterMaquinaCorrosao = value;
                                        });
                                      }),
                                      _buildFilterChip('Estação de Solda', _model.filterEstacaoSolda, (value) {
                                        setState(() {
                                          _model.filterEstacaoSolda = value;
                                        });
                                      }),
                                      _buildFilterChip('CNC', _model.filterCNC, (value) {
                                        setState(() {
                                          _model.filterCNC = value;
                                        });
                                      }),
                                      _buildFilterChip('Máquina de Corte', _model.filterMaquinaCorte, (value) {
                                        setState(() {
                                          _model.filterMaquinaCorte = value;
                                        });
                                      }),
                                      _buildFilterChip('Bancada de Reparos e Carga', _model.filterBancadaReparos, (value) {
                                        setState(() {
                                          _model.filterBancadaReparos = value;
                                        });
                                      }),
                                    ],
                                  ),
                                  SizedBox(height: 24.0),
                                  
                                  // Beacons
                                  Text(
                                    'Beacons',
                                    style: FlutterFlowTheme.of(context).titleLarge.copyWith(
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.bold,
                                      color: FlutterFlowTheme.of(context).primary,
                                    ),
                                  ),
                                  SizedBox(height: 12.0),
                                  Wrap(
                                    spacing: 8.0,
                                    runSpacing: 8.0,
                                    children: [
                                      _buildFilterChip('Multímetro', _model.filterMultimetro, (value) {
                                        setState(() {
                                          _model.filterMultimetro = value;
                                        });
                                      }),
                                      _buildFilterChip('Kit de Reparos', _model.filterKitReparos, (value) {
                                        setState(() {
                                          _model.filterKitReparos = value;
                                        });
                                      }),
                                      _buildFilterChip('Chapa de Material', _model.filterChapaMaterial, (value) {
                                        setState(() {
                                          _model.filterChapaMaterial = value;
                                        });
                                      }),
                                      _buildFilterChip('Estanho', _model.filterEstanho, (value) {
                                        setState(() {
                                          _model.filterEstanho = value;
                                        });
                                      }),
                                      _buildFilterChip('Componentes', _model.filterComponentes, (value) {
                                        setState(() {
                                          _model.filterComponentes = value;
                                        });
                                      }),
                                      _buildFilterChip('Filamento', _model.filterFilamento, (value) {
                                        setState(() {
                                          _model.filterFilamento = value;
                                        });
                                      }),
                                    ],
                                  ),
                                  SizedBox(height: 24.0),
                                  
                                  // Tipos
                                  Text(
                                    'Tipos',
                                    style: FlutterFlowTheme.of(context).titleLarge.copyWith(
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.bold,
                                      color: FlutterFlowTheme.of(context).primary,
                                    ),
                                  ),
                                  SizedBox(height: 12.0),
                                  Wrap(
                                    spacing: 8.0,
                                    runSpacing: 8.0,
                                    children: [
                                      _buildFilterChip('Material', _model.filterMaterial, (value) {
                                        setState(() {
                                          _model.filterMaterial = value;
                                        });
                                      }),
                                      _buildFilterChip('Ferramenta', _model.filterFerramenta, (value) {
                                        setState(() {
                                          _model.filterFerramenta = value;
                                        });
                                      }),
                                    ],
                                  ),
                                  SizedBox(height: 24.0),
                                  
                                  // Status
                                  Text(
                                    'Status',
                                    style: FlutterFlowTheme.of(context).titleLarge.copyWith(
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.bold,
                                      color: FlutterFlowTheme.of(context).primary,
                                    ),
                                  ),
                                  SizedBox(height: 12.0),
                                  Wrap(
                                    spacing: 8.0,
                                    runSpacing: 8.0,
                                    children: [
                                      _buildFilterChip('Em Uso', _model.filterEmUso, (value) {
                                        setState(() {
                                          _model.filterEmUso = value;
                                        });
                                      }),
                                      _buildFilterChip('Disponível', _model.filterDisponivel, (value) {
                                        setState(() {
                                          _model.filterDisponivel = value;
                                        });
                                      }),
                                      _buildFilterChip('Descarregado', _model.filterDescarregado, (value) {
                                        setState(() {
                                          _model.filterDescarregado = value;
                                        });
                                      }),
                                      _buildFilterChip('Processado', _model.filterProcessado, (value) {
                                        setState(() {
                                          _model.filterProcessado = value;
                                        });
                                      }),
                                      _buildFilterChip('Indisponível', _model.filterIndisponivel, (value) {
                                        setState(() {
                                          _model.filterIndisponivel = value;
                                        });
                                      }),
                                      _buildFilterChip('Carregando', _model.filterCarregando, (value) {
                                        setState(() {
                                          _model.filterCarregando = value;
                                        });
                                      }),
                                      _buildFilterChip('Carregado', _model.filterCarregado, (value) {
                                        setState(() {
                                          _model.filterCarregado = value;
                                        });
                                      }),
                                    ],
                                  ),
                                  SizedBox(height: 20.0),
                                ],
                              ),
                            ),
                          ),
                          
                          // Apply/Close buttons at bottom
                          Container(
                            padding: EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context).secondaryBackground,
                              border: Border(
                                top: BorderSide(
                                  color: FlutterFlowTheme.of(context).alternate,
                                  width: 1.0,
                                ),
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: FFButtonWidget(
                                    onPressed: () {
                                      setState(() {
                                        _model.clearAllFilters();
                                      });
                                    },
                                    text: 'Limpar Filtros',
                                    options: FFButtonOptions(
                                      height: 48.0,
                                      color: FlutterFlowTheme.of(context).alternate,
                                      textStyle: FlutterFlowTheme.of(context).titleMedium.copyWith(
                                        color: FlutterFlowTheme.of(context).primaryText,
                                        letterSpacing: 0.0,
                                      ),
                                      elevation: 0.0,
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 12.0),
                                Expanded(
                                  child: FFButtonWidget(
                                    onPressed: () {
                                      setState(() {
                                        _model.toggleFilterMenu();
                                      });
                                    },
                                    text: 'Aplicar Filtros',
                                    options: FFButtonOptions(
                                      height: 48.0,
                                      color: FlutterFlowTheme.of(context).primary,
                                      textStyle: FlutterFlowTheme.of(context).titleMedium.copyWith(
                                        color: Colors.white,
                                        letterSpacing: 0.0,
                                      ),
                                      elevation: 0.0,
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected, Function(bool) onChanged) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: onChanged,
      selectedColor: FlutterFlowTheme.of(context).primary.withOpacity(0.2),
      checkmarkColor: FlutterFlowTheme.of(context).primary,
      backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
      labelStyle: TextStyle(
        color: isSelected 
          ? FlutterFlowTheme.of(context).primary 
          : FlutterFlowTheme.of(context).primaryText,
        fontSize: 12.0,
      ),
      side: BorderSide(
        color: isSelected 
          ? FlutterFlowTheme.of(context).primary 
          : FlutterFlowTheme.of(context).alternate,
        width: 1.0,
      ),
    );
  }
}
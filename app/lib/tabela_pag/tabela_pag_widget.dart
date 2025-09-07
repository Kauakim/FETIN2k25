import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/app_bottom_navigation.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  final FocusNode _keyboardFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => TabelaPagModel());
    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();
  }

  @override
  void dispose() {
    _keyboardFocusNode.dispose();
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: _keyboardFocusNode,
      autofocus: true,
      onKey: (RawKeyEvent event) {
        // Só processa Enter se o menu de filtro estiver aberto E a barra de pesquisa não estiver focada
        if (_model.showFilterMenu && 
            event is RawKeyDownEvent && 
            event.logicalKey == LogicalKeyboardKey.enter &&
            !(_model.textFieldFocusNode?.hasFocus ?? false)) {
          setState(() {
            _model.confirmFilters();
          });
        }
      },
      child: GestureDetector(
        onTap: () {
          // Se o campo de pesquisa não estiver focado, remove foco de outros elementos
          if (!(_model.textFieldFocusNode?.hasFocus ?? false)) {
            FocusScope.of(context).unfocus();
            FocusManager.instance.primaryFocus?.unfocus();
            // Mantém o foco no listener global apenas se o menu estiver aberto
            if (_model.showFilterMenu) {
              _keyboardFocusNode.requestFocus();
            }
          }
        },
        child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        bottomNavigationBar: AppBottomNavigation(currentIndex: 1),
        body: LayoutBuilder(
          builder: (context, constraints) {
            final isMobileDevice = isMobile || constraints.maxWidth < 768;
            
            return Stack(
              children: [
                SafeArea(
                  top: true,
                  child: Column(
                    children: [
                      SizedBox(height: 24.0),
                      
                      // Table Container
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: isMobileDevice ? 16.0 : 24.0,
                          ),
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context).secondaryBackground,
                            borderRadius: BorderRadius.circular(12.0),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 4.0,
                                color: Color(0x1A000000),
                                offset: Offset(0.0, 2.0),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12.0),
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
                                  padding: EdgeInsets.zero,
                                  itemCount: filteredBeacons.length + 1, // +1 para o header
                                  itemBuilder: (context, index) {
                                    if (index == 0) {
                                      // Header row
                                      return Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: isMobileDevice ? 16.0 : 24.0,
                                          vertical: isMobileDevice ? 12.0 : 16.0,
                                        ),
                                        decoration: BoxDecoration(
                                          color: FlutterFlowTheme.of(context).primary.withValues(alpha: 0.1),
                                          border: Border(
                                            bottom: BorderSide(
                                              color: Colors.white,
                                              width: 2.0,
                                            ),
                                          ),
                                        ),
                                        child: IntrinsicHeight(
                                          child: Row(
                                            children: [
                                              Expanded(
                                                flex: isMobileDevice ? 2 : 3,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    border: Border(
                                                      right: BorderSide(
                                                        color: Colors.white,
                                                        width: 1.0,
                                                      ),
                                                    ),
                                                  ),
                                                  child: Text(
                                                    'Beacon',
                                                    style: FlutterFlowTheme.of(context).bodyMedium.copyWith(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: isMobileDevice ? 14 : 16,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 8.0),
                                              Expanded(
                                                flex: isMobileDevice ? 2 : 2,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    border: Border(
                                                      right: BorderSide(
                                                        color: Colors.white,
                                                        width: 1.0,
                                                      ),
                                                    ),
                                                  ),
                                                  child: Text(
                                                    'Tipo',
                                                    style: FlutterFlowTheme.of(context).bodyMedium.copyWith(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: isMobileDevice ? 14 : 16,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 8.0),
                                              Expanded(
                                                flex: isMobileDevice ? 2 : 2,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    border: Border(
                                                      right: BorderSide(
                                                        color: Colors.white,
                                                        width: 1.0,
                                                      ),
                                                    ),
                                                  ),
                                                  child: Text(
                                                    'Status',
                                                    style: FlutterFlowTheme.of(context).bodyMedium.copyWith(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: isMobileDevice ? 14 : 16,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 8.0),
                                              Expanded(
                                                flex: isMobileDevice ? 2 : 3,
                                                child: Text(
                                                  'Coordenada',
                                                  style: FlutterFlowTheme.of(context).bodyMedium.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: isMobileDevice ? 14 : 16,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }
                                    
                                    // Data rows
                                    final beacon = filteredBeacons[index - 1];
                                    return Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: isMobileDevice ? 16.0 : 24.0,
                                        vertical: isMobileDevice ? 12.0 : 16.0,
                                      ),
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                            color: FlutterFlowTheme.of(context).alternate,
                                            width: 0.5,
                                          ),
                                        ),
                                      ),
                                      child: IntrinsicHeight(
                                        child: Row(
                                          children: [
                                            Expanded(
                                              flex: isMobileDevice ? 2 : 3,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  border: Border(
                                                    right: BorderSide(
                                                      color: Colors.white,
                                                      width: 1.0,
                                                    ),
                                                  ),
                                                ),
                                                child: Text(
                                                  beacon['beacon'] ?? '',
                                                  style: FlutterFlowTheme.of(context).bodyMedium.copyWith(
                                                    fontSize: isMobileDevice ? 13 : 15,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 8.0),
                                            Expanded(
                                              flex: isMobileDevice ? 2 : 2,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  border: Border(
                                                    right: BorderSide(
                                                      color: Colors.white,
                                                      width: 1.0,
                                                    ),
                                                  ),
                                                ),
                                                child: Text(
                                                  beacon['tipo'] ?? '',
                                                  style: FlutterFlowTheme.of(context).bodyMedium.copyWith(
                                                    fontSize: isMobileDevice ? 13 : 15,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 8.0),
                                            Expanded(
                                              flex: isMobileDevice ? 2 : 2,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  border: Border(
                                                    right: BorderSide(
                                                      color: Colors.white,
                                                      width: 1.0,
                                                    ),
                                                  ),
                                                ),
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: isMobileDevice ? 6.0 : 8.0,
                                                    vertical: isMobileDevice ? 2.0 : 4.0,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: _getStatusColor(beacon['status'] ?? '').withValues(alpha: 0.1),
                                                    borderRadius: BorderRadius.circular(4.0),
                                                    border: Border.all(
                                                      color: _getStatusColor(beacon['status'] ?? ''),
                                                      width: 1.0,
                                                    ),
                                                  ),
                                                  child: Text(
                                                    beacon['status'] ?? '',
                                                    style: FlutterFlowTheme.of(context).bodySmall.copyWith(
                                                      fontSize: isMobileDevice ? 11 : 13,
                                                      color: _getStatusColor(beacon['status'] ?? ''),
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                    overflow: TextOverflow.ellipsis,
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 8.0),
                                            Expanded(
                                              flex: isMobileDevice ? 2 : 3,
                                              child: Text(
                                                '${beacon['x']}, ${beacon['y']}',
                                                style: FlutterFlowTheme.of(context).bodyMedium.copyWith(
                                                  fontSize: isMobileDevice ? 13 : 15,
                                                  fontFamily: 'monospace',
                                                ),
                                                textAlign: TextAlign.center,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      
                      SizedBox(height: 24.0),
                    ],
                  ),
                ),
                
                // Full Screen Filter Menu Overlay
                if (_model.showFilterMenu)
                  Positioned.fill(
                    child: Container(
                      color: Colors.black.withValues(alpha: 0.5),
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
                                      // Pesquisa Section
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Pesquisa',
                                            style: FlutterFlowTheme.of(context).titleLarge.copyWith(
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.bold,
                                              color: FlutterFlowTheme.of(context).primary,
                                            ),
                                          ),
                                          SizedBox(height: 12.0),
                                          TextFormField(
                                            controller: _model.textController,
                                            focusNode: _model.textFieldFocusNode,
                                            onChanged: (_) async {
                                              safeSetState(() => _model.apiRequestCompleter = null);
                                              await _model.waitForApiRequestCompleted(minWait: 500, maxWait: 1000);
                                            },
                                            onFieldSubmitted: (_) {
                                              setState(() {
                                                _model.confirmFilters();
                                              });
                                            },
                                            decoration: InputDecoration(
                                              hintText: 'Digite para pesquisar beacons...',
                                              contentPadding: EdgeInsets.symmetric(
                                                horizontal: 16,
                                                vertical: 14,
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: FlutterFlowTheme.of(context).alternate,
                                                  width: 1.0,
                                                ),
                                                borderRadius: BorderRadius.circular(8.0),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: FlutterFlowTheme.of(context).primary,
                                                  width: 2.0,
                                                ),
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
                                            style: TextStyle(fontSize: 16),
                                            cursorColor: FlutterFlowTheme.of(context).primaryText,
                                            validator: _model.textControllerValidator.asValidator(context),
                                          ),
                                          SizedBox(height: 24.0),
                                        ],
                                      ),
                                      // Máquinas
                                      _buildFilterSection(
                                        'Máquinas',
                                        [
                                          _buildFilterChip('Estação de Carga', _model.filterEstacaoCarga, (value) {
                                            setState(() => _model.filterEstacaoCarga = value);
                                          }),
                                          _buildFilterChip('Impressora 3D', _model.filterImpressora3d, (value) {
                                            setState(() => _model.filterImpressora3d = value);
                                          }),
                                          _buildFilterChip('Impressora', _model.filterImpressora, (value) {
                                            setState(() => _model.filterImpressora = value);
                                          }),
                                          _buildFilterChip('Máquina de Corrosão', _model.filterMaquinaCorrosao, (value) {
                                            setState(() => _model.filterMaquinaCorrosao = value);
                                          }),
                                          _buildFilterChip('Estação de Solda', _model.filterEstacaoSolda, (value) {
                                            setState(() => _model.filterEstacaoSolda = value);
                                          }),
                                          _buildFilterChip('CNC', _model.filterCNC, (value) {
                                            setState(() => _model.filterCNC = value);
                                          }),
                                          _buildFilterChip('Máquina de Corte', _model.filterMaquinaCorte, (value) {
                                            setState(() => _model.filterMaquinaCorte = value);
                                          }),
                                          _buildFilterChip('Bancada de Reparos e Carga', _model.filterBancadaReparos, (value) {
                                            setState(() => _model.filterBancadaReparos = value);
                                          }),
                                        ],
                                      ),
                                      
                                      // Beacons
                                      _buildFilterSection(
                                        'Beacons',
                                        [
                                          _buildFilterChip('Multímetro', _model.filterMultimetro, (value) {
                                            setState(() => _model.filterMultimetro = value);
                                          }),
                                          _buildFilterChip('Kit de Reparos', _model.filterKitReparos, (value) {
                                            setState(() => _model.filterKitReparos = value);
                                          }),
                                          _buildFilterChip('Chapa de Material', _model.filterChapaMaterial, (value) {
                                            setState(() => _model.filterChapaMaterial = value);
                                          }),
                                          _buildFilterChip('Estanho', _model.filterEstanho, (value) {
                                            setState(() => _model.filterEstanho = value);
                                          }),
                                          _buildFilterChip('Componentes', _model.filterComponentes, (value) {
                                            setState(() => _model.filterComponentes = value);
                                          }),
                                          _buildFilterChip('Filamento', _model.filterFilamento, (value) {
                                            setState(() => _model.filterFilamento = value);
                                          }),
                                        ],
                                      ),
                                      
                                      // Tipos
                                      _buildFilterSection(
                                        'Tipos',
                                        [
                                          _buildFilterChip('Material', _model.filterMaterial, (value) {
                                            setState(() => _model.filterMaterial = value);
                                          }),
                                          _buildFilterChip('Ferramenta', _model.filterFerramenta, (value) {
                                            setState(() => _model.filterFerramenta = value);
                                          }),
                                        ],
                                      ),
                                      
                                      // Status
                                      _buildFilterSection(
                                        'Status',
                                        [
                                          _buildFilterChip('Em Uso', _model.filterEmUso, (value) {
                                            setState(() => _model.filterEmUso = value);
                                          }),
                                          _buildFilterChip('Disponível', _model.filterDisponivel, (value) {
                                            setState(() => _model.filterDisponivel = value);
                                          }),
                                          _buildFilterChip('Descarregado', _model.filterDescarregado, (value) {
                                            setState(() => _model.filterDescarregado = value);
                                          }),
                                          _buildFilterChip('Processado', _model.filterProcessado, (value) {
                                            setState(() => _model.filterProcessado = value);
                                          }),
                                          _buildFilterChip('Indisponível', _model.filterIndisponivel, (value) {
                                            setState(() => _model.filterIndisponivel = value);
                                          }),
                                          _buildFilterChip('Carregando', _model.filterCarregando, (value) {
                                            setState(() => _model.filterCarregando = value);
                                          }),
                                          _buildFilterChip('Carregado', _model.filterCarregado, (value) {
                                            setState(() => _model.filterCarregado = value);
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
                                    // Main confirm button (takes most space)
                                    Expanded(
                                      flex: 5,
                                      child: FFButtonWidget(
                                        onPressed: () {
                                          setState(() {
                                            _model.confirmFilters();
                                          });
                                        },
                                        text: 'Confirmar Filtros',
                                        options: FFButtonOptions(
                                          height: 48.0,
                                          color: FlutterFlowTheme.of(context).primary,
                                          textStyle: FlutterFlowTheme.of(context).titleMedium.copyWith(
                                            color: Colors.white,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          elevation: 2.0,
                                          borderRadius: BorderRadius.circular(8.0),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 12.0),
                                    // Clear filters button with trash icon (smaller)
                                    Container(
                                      height: 48.0,
                                      width: 48.0,
                                      child: FFButtonWidget(
                                        onPressed: () {
                                          setState(() {
                                            _model.clearAllFilters();
                                          });
                                        },
                                        text: '',
                                        icon: Icon(
                                          Icons.delete_outline,
                                          color: Colors.white,
                                          size: 20.0,
                                        ),
                                        options: FFButtonOptions(
                                          height: 48.0,
                                          width: 48.0,
                                          padding: EdgeInsets.zero,
                                          color: FlutterFlowTheme.of(context).error,
                                          textStyle: FlutterFlowTheme.of(context).titleMedium.copyWith(
                                            color: Colors.white,
                                            letterSpacing: 0.0,
                                          ),
                                          elevation: 2.0,
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

                // Floating Filter Button - Bottom Right
                Positioned(
                  bottom: 80.0, // Above bottom navigation
                  right: 20.0,
                  child: FloatingActionButton.extended(
                    onPressed: () {
                      setState(() {
                        _model.toggleFilterMenu();
                      });
                    },
                    icon: Icon(
                      _model.showFilterMenu ? Icons.filter_list_off : Icons.filter_list,
                      color: Colors.white,
                    ),
                    label: Text(
                      'Filtro${_model.hasActiveFilters() ? ' (Ativo)' : ''}',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    backgroundColor: _model.hasActiveFilters() 
                      ? FlutterFlowTheme.of(context).secondary 
                      : FlutterFlowTheme.of(context).primary,
                    elevation: 6.0,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    ),
    );
  }

  Widget _buildFilterSection(String title, List<Widget> chips) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
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
          children: chips,
        ),
        SizedBox(height: 24.0),
      ],
    );
  }

  Widget _buildFilterChip(String label, bool isSelected, Function(bool) onChanged) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: onChanged,
      selectedColor: FlutterFlowTheme.of(context).primary.withValues(alpha: 0.2),
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

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'em uso':
        return Colors.orange;
      case 'disponível':
        return Colors.green;
      case 'descarregado':
        return Colors.red;
      case 'processado':
        return Colors.blue;
      case 'indisponível':
        return Colors.grey;
      case 'carregando':
        return Colors.amber;
      case 'carregado':
        return Colors.lightGreen;
      default:
        return FlutterFlowTheme.of(context).primaryText;
    }
  }
}

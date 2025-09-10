import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/app_bottom_navigation.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/backend/api_requests/api_calls.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'relatorios_model.dart';
export 'relatorios_model.dart';

class RelatoriosWidget extends StatefulWidget {
  const RelatoriosWidget({super.key});

  static String routeName = 'Relatorios';
  static String routePath = '/relatorios';

  @override
  State<RelatoriosWidget> createState() => _RelatoriosWidgetState();
}

class _RelatoriosWidgetState extends State<RelatoriosWidget> {
  late RelatoriosModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool showFilters = false;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => RelatoriosModel());
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobileDevice = isMobile || MediaQuery.of(context).size.width < 768;
    
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      behavior: HitTestBehavior.translucent,
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        bottomNavigationBar: AppBottomNavigation(currentIndex: 3),
        body: Column(
          children: [
            // Header with search and filter
            Container(
              padding: EdgeInsets.all(isMobileDevice ? 16.0 : 20.0),
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).secondaryBackground,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 4.0,
                    color: Color(0x1A000000),
                    offset: Offset(0.0, 2.0),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _model.textController,
                          focusNode: _model.textFieldFocusNode,
                          onChanged: (value) => EasyDebounce.debounce(
                            '_model.textController',
                            Duration(milliseconds: 500),
                            () {
                              _model.searchText = value;
                              setState(() {});
                            },
                          ),
                          decoration: InputDecoration(
                            hintText: 'Pesquisar máquinas...',
                            prefixIcon: Icon(
                              Icons.search,
                              color: FlutterFlowTheme.of(context).secondaryText,
                              size: 24.0,
                            ),
                            suffixIcon: _model.textController?.text.isNotEmpty == true
                              ? IconButton(
                                  icon: Icon(Icons.clear),
                                  onPressed: () {
                                    _model.textController?.clear();
                                    _model.searchText = '';
                                    setState(() {});
                                  },
                                )
                              : null,
                            filled: true,
                            fillColor: FlutterFlowTheme.of(context).primaryBackground,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).alternate,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).alternate,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).primary,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 16.0),
                      Material(
                        color: Colors.transparent,
                        child: IconButton(
                          onPressed: () {
                            setState(() {
                              showFilters = !showFilters;
                            });
                          },
                          icon: Icon(
                            Icons.filter_list,
                            size: 24.0,
                            color: _model.hasActiveFilters() 
                              ? FlutterFlowTheme.of(context).primary
                              : FlutterFlowTheme.of(context).primaryText,
                          ),
                          style: IconButton.styleFrom(
                            backgroundColor: _model.hasActiveFilters()
                              ? FlutterFlowTheme.of(context).primary.withOpacity(0.1)
                              : FlutterFlowTheme.of(context).alternate,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            minimumSize: Size(48, 48),
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  // Filters Section
                  if (showFilters) ...[
                    SizedBox(height: 20.0),
                    _buildFiltersSection(isMobileDevice),
                  ],
                ],
              ),
            ),

            // Main content
            Expanded(
              child: FutureBuilder<ApiCallResponse>(
                future: InfoGetAllCall.call(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(FlutterFlowTheme.of(context).primary),
                      ),
                    );
                  }
                  
                  final infoMap = getJsonField(snapshot.data!.jsonBody, r'''$.Info''') as Map<String, dynamic>? ?? {};
                  final allReports = infoMap.values.toList();
                  final filteredReports = _model.getFilteredReports(allReports);
                  final statistics = _model.calculateStatistics(filteredReports);

                  if (filteredReports.isEmpty) {
                    return _buildEmptyState(isMobileDevice);
                  }

                  return Column(
                    children: [
                      // Statistics Cards
                      //_buildStatisticsSection(statistics, isMobileDevice),
                      
                      // Reports Table/List
                      Expanded(
                        child: _buildReportsContent(filteredReports, isMobileDevice),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFiltersSection(bool isMobileDevice) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).primaryBackground,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: FlutterFlowTheme.of(context).alternate,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Filtros',
                style: FlutterFlowTheme.of(context).titleMedium.copyWith(
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.w600,
                  fontSize: 16.0,
                ),
              ),
              FFButtonWidget(
                onPressed: () {
                  setState(() {
                    _model.clearAllFilters();
                  });
                },
                text: 'Limpar',
                options: FFButtonOptions(
                  height: 32.0,
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  iconPadding: EdgeInsets.zero,
                  color: FlutterFlowTheme.of(context).error,
                  textStyle: FlutterFlowTheme.of(context).bodyMedium.copyWith(
                    color: Colors.white,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500,
                  ),
                  borderRadius: BorderRadius.circular(6.0),
                  elevation: 2.0,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.0),
          
          if (isMobileDevice) ...[
            // Mobile: Stacked layout
            _buildPeriodFilter(),
            SizedBox(height: 12.0),
            _buildMachineFilter([]),
          ] else ...[
            // Desktop: Row layout
            Row(
              children: [
                Expanded(child: _buildPeriodFilter()),
                SizedBox(width: 16.0),
                Expanded(child: _buildMachineFilter([])),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPeriodFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Período',
          style: FlutterFlowTheme.of(context).bodyMedium.copyWith(
            fontWeight: FontWeight.w500,
            fontSize: 14.0,
          ),
        ),
        SizedBox(height: 10.0),
        DropdownButtonFormField<String>(
          value: _model.selectedPeriod,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide(color: FlutterFlowTheme.of(context).alternate),
            ),
          ),
          items: ['Todos', 'Hoje', 'Última Semana', 'Último Mês', 'Últimos 3 Meses']
              .map((period) => DropdownMenuItem(
                    value: period,
                    child: Text(period),
                  ))
              .toList(),
          onChanged: (value) {
            setState(() {
              _model.selectedPeriod = value ?? 'Todos';
            });
          },
        ),
      ],
    );
  }

  Widget _buildMachineFilter(List<dynamic> reports) {
    final machines = _model.getUniqueMachines(reports);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Máquina',
          style: FlutterFlowTheme.of(context).bodyMedium.copyWith(
            fontWeight: FontWeight.w500,
            fontSize: 14.0,
          ),
        ),
        SizedBox(height: 10.0),
        DropdownButtonFormField<String>(
          value: machines.contains(_model.selectedMachine) ? _model.selectedMachine : 'Todas',
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(color: FlutterFlowTheme.of(context).alternate),
            ),
          ),
          items: machines
              .map((machine) => DropdownMenuItem(
                    value: machine,
                    child: Text(machine),
                  ))
              .toList(),
          onChanged: (value) {
            setState(() {
              _model.selectedMachine = value ?? 'Todas';
            });
          },
        ),
      ],
    );
  }

  Widget _buildStatisticsSection(Map<String, dynamic> stats, bool isMobileDevice) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: isMobileDevice 
        ? Column(
            children: [
              Row(
                children: [
                  Expanded(child: _buildStatCard('Total de Tasks', stats['totalTasks'].toString(), Icons.assignment, Colors.blue)),
                  SizedBox(width: 8.0),
                  Expanded(child: _buildStatCard('Concluídas', stats['completedTasks'].toString(), Icons.check_circle, Colors.green)),
                ],
              ),
              SizedBox(height: 8.0),
              Row(
                children: [
                  Expanded(child: _buildStatCard('Canceladas', stats['canceledTasks'].toString(), Icons.cancel, Colors.red)),
                  SizedBox(width: 8.0),
                  Expanded(child: _buildStatCard('Horas Totais', stats['totalHours'].toStringAsFixed(1), Icons.access_time, Colors.orange)),
                ],
              ),
            ],
          )
        : Row(
            children: [
              Expanded(child: _buildStatCard('Total de Tasks', stats['totalTasks'].toString(), Icons.assignment, Colors.blue)),
              SizedBox(width: 12.0),
              Expanded(child: _buildStatCard('Concluídas', stats['completedTasks'].toString(), Icons.check_circle, Colors.green)),
              SizedBox(width: 12.0),
              Expanded(child: _buildStatCard('Canceladas', stats['canceledTasks'].toString(), Icons.cancel, Colors.red)),
              SizedBox(width: 12.0),
              Expanded(child: _buildStatCard('Horas Totais', stats['totalHours'].toStringAsFixed(1), Icons.access_time, Colors.orange)),
            ],
          ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(16.0),
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
      child: Column(
        children: [
          Icon(icon, color: color, size: 24.0),
          SizedBox(height: 8.0),
          Text(
            value,
            style: FlutterFlowTheme.of(context).headlineSmall.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          SizedBox(height: 4.0),
          Text(
            title,
            style: FlutterFlowTheme.of(context).bodySmall.copyWith(
              color: FlutterFlowTheme.of(context).secondaryText,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildReportsContent(List<dynamic> reports, bool isMobileDevice) {
    if (isMobileDevice) {
      return _buildMobileReportsList(reports);
    } else {
      return _buildDesktopReportsTable(reports);
    }
  }

  Widget _buildMobileReportsList(List<dynamic> reports) {
    return ListView.builder(
      padding: EdgeInsets.all(16.0),
      itemCount: reports.length,
      itemBuilder: (context, index) {
        final report = reports[index];
        return Container(
          margin: EdgeInsets.only(bottom: 12.0),
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
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Machine name
                Row(
                  children: [
                    Icon(
                      Icons.precision_manufacturing,
                      size: 20.0,
                      color: FlutterFlowTheme.of(context).primary,
                    ),
                    SizedBox(width: 8.0),
                    Expanded(
                      child: Text(
                        report['maquina']?.toString() ?? 'Máquina não especificada',
                        style: FlutterFlowTheme.of(context).titleSmall.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 16.0,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.0),
                
                // Date
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 16.0,
                      color: FlutterFlowTheme.of(context).secondaryText,
                    ),
                    SizedBox(width: 6.0),
                    Text(
                      _formatDate(report['data']?.toString() ?? ''),
                      style: FlutterFlowTheme.of(context).bodySmall.copyWith(
                        color: FlutterFlowTheme.of(context).secondaryText,
                        fontSize: 12.0,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.0),
                
                // Stats row
                Row(
                  children: [
                    Expanded(
                      child: _buildMiniStat('Concluídas', report['tasksConcluidas']?.toString() ?? '0', Colors.green),
                    ),
                    SizedBox(width: 12.0),
                    Expanded(
                      child: _buildMiniStat('Canceladas', report['tasksCanceladas']?.toString() ?? '0', Colors.red),
                    ),
                    SizedBox(width: 12.0),
                    Expanded(
                      child: _buildMiniStat('Horas', (report['horasTrabalhadas']?.toDouble() ?? 0.0).toStringAsFixed(1), Colors.orange),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMiniStat(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        SizedBox(height: 2.0),
        Text(
          label,
          style: TextStyle(
            fontSize: 10.0,
            color: FlutterFlowTheme.of(context).secondaryText,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildDesktopReportsTable(List<dynamic> reports) {
    return Container(
      margin: EdgeInsets.all(16.0),
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
      child: Column(
        children: [
          // Table header
          Container(
            padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).primary,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12.0),
                topRight: Radius.circular(12.0),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    'Máquina',
                    style: FlutterFlowTheme.of(context).titleSmall.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Data',
                    style: FlutterFlowTheme.of(context).titleSmall.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Tasks Concluídas',
                    style: FlutterFlowTheme.of(context).titleSmall.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Tasks Canceladas',
                    style: FlutterFlowTheme.of(context).titleSmall.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Horas Trabalhadas',
                    style: FlutterFlowTheme.of(context).titleSmall.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          
          // Table rows
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: reports.length,
              itemBuilder: (context, index) {
                final report = reports[index];
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: FlutterFlowTheme.of(context).alternate,
                        width: 0.5,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Text(
                          report['maquina']?.toString() ?? 'N/A',
                          style: FlutterFlowTheme.of(context).bodyMedium.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          _formatDate(report['data']?.toString() ?? ''),
                          style: FlutterFlowTheme.of(context).bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          report['tasksConcluidas']?.toString() ?? '0',
                          style: FlutterFlowTheme.of(context).bodyMedium.copyWith(
                            color: Colors.green,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          report['tasksCanceladas']?.toString() ?? '0',
                          style: FlutterFlowTheme.of(context).bodyMedium.copyWith(
                            color: Colors.red,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          (report['horasTrabalhadas']?.toDouble() ?? 0.0).toStringAsFixed(1),
                          style: FlutterFlowTheme.of(context).bodyMedium.copyWith(
                            color: Colors.orange,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(bool isMobileDevice) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.analytics_outlined,
              size: isMobileDevice ? 64.0 : 80.0,
              color: FlutterFlowTheme.of(context).secondaryText,
            ),
            SizedBox(height: 16.0),
            Text(
              'Nenhum relatório encontrado',
              style: FlutterFlowTheme.of(context).titleMedium.copyWith(
                color: FlutterFlowTheme.of(context).secondaryText,
                fontSize: isMobileDevice ? 18.0 : 20.0,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.0),
            Text(
              'Tente ajustar os filtros ou aguarde a geração de novos relatórios.',
              style: FlutterFlowTheme.of(context).bodyMedium.copyWith(
                color: FlutterFlowTheme.of(context).secondaryText,
                fontSize: isMobileDevice ? 14.0 : 16.0,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }
}

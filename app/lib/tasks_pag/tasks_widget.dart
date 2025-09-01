import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/app_bottom_navigation.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'tasks_model.dart';
export 'tasks_model.dart';

class TasksWidget extends StatefulWidget {
  const TasksWidget({super.key});

  static String routeName = 'Tasks';
  static String routePath = '/tasks';

  @override
  State<TasksWidget> createState() => _TasksWidgetState();
}

class _TasksWidgetState extends State<TasksWidget> {
  late TasksModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool showFilters = false;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => TasksModel());
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
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).primary,
          automaticallyImplyLeading: false,
          title: Text(
            'Minhas Tasks',
            style: FlutterFlowTheme.of(context).headlineMedium.copyWith(
              color: Colors.white,
              fontSize: 22.0,
              letterSpacing: 0.0,
            ),
          ),
          centerTitle: false,
          elevation: 2.0,
        ),
        bottomNavigationBar: AppBottomNavigation(currentIndex: 2),
        body: Column(
          children: [
            // Search and Filter Bar
            Container(
              padding: EdgeInsets.all(isMobileDevice ? 12.0 : 16.0),
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
                          controller: _model.searchController,
                          focusNode: _model.searchFocusNode,
                          onChanged: (_) => EasyDebounce.debounce(
                            '_model.searchController',
                            Duration(milliseconds: 500),
                            () => setState(() {}),
                          ),
                          decoration: InputDecoration(
                            hintText: 'Pesquisar tasks...',
                            prefixIcon: Icon(
                              Icons.search,
                              color: FlutterFlowTheme.of(context).secondaryText,
                            ),
                            suffixIcon: _model.searchController?.text.isNotEmpty == true
                              ? IconButton(
                                  icon: Icon(Icons.clear),
                                  onPressed: () {
                                    _model.clearSearch();
                                    setState(() {});
                                  },
                                )
                              : null,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 12.0,
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
                            filled: true,
                            fillColor: FlutterFlowTheme.of(context).primaryBackground,
                          ),
                        ),
                      ),
                      SizedBox(width: 12.0),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            showFilters = !showFilters;
                          });
                        },
                        icon: Icon(
                          Icons.filter_list,
                          color: _model.hasActiveFilters() 
                            ? FlutterFlowTheme.of(context).primary
                            : FlutterFlowTheme.of(context).secondaryText,
                        ),
                        style: IconButton.styleFrom(
                          backgroundColor: _model.hasActiveFilters()
                            ? FlutterFlowTheme.of(context).primary.withOpacity(0.1)
                            : FlutterFlowTheme.of(context).alternate,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  // Filters Section
                  if (showFilters) ...[
                    SizedBox(height: 16.0),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).primaryBackground,
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(
                          color: FlutterFlowTheme.of(context).alternate,
                          width: 1.0,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Filtros por Status',
                                style: FlutterFlowTheme.of(context).titleMedium.copyWith(
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    _model.clearAllFilters();
                                  });
                                },
                                child: Text(
                                  'Limpar',
                                  style: TextStyle(
                                    color: FlutterFlowTheme.of(context).primary,
                                    fontSize: 14.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12.0),
                          Wrap(
                            spacing: 8.0,
                            runSpacing: 8.0,
                            children: [
                              _buildFilterChip('Pendente', _model.filterPendente, 'pendente'),
                              _buildFilterChip('Em Andamento', _model.filterEmAndamento, 'emAndamento'),
                              _buildFilterChip('Concluída', _model.filterConcluida, 'concluida'),
                              _buildFilterChip('Cancelada', _model.filterCancelada, 'cancelada'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            
            // Tasks List
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _model.getFilteredTasks(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          FlutterFlowTheme.of(context).primary,
                        ),
                      ),
                    );
                  }
                  
                  if (snapshot.hasError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 64.0,
                            color: FlutterFlowTheme.of(context).error,
                          ),
                          SizedBox(height: 16.0),
                          Text(
                            'Erro ao carregar tasks',
                            style: FlutterFlowTheme.of(context).headlineSmall.copyWith(
                              color: FlutterFlowTheme.of(context).error,
                              letterSpacing: 0.0,
                            ),
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            'Tente novamente mais tarde',
                            style: FlutterFlowTheme.of(context).bodyMedium.copyWith(
                              color: FlutterFlowTheme.of(context).secondaryText,
                              letterSpacing: 0.0,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  
                  final filteredTasks = snapshot.data ?? [];
                  
                  if (filteredTasks.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.assignment_outlined,
                            size: 64.0,
                            color: FlutterFlowTheme.of(context).secondaryText,
                          ),
                          SizedBox(height: 16.0),
                          Text(
                            'Nenhuma task encontrada',
                            style: FlutterFlowTheme.of(context).headlineSmall.copyWith(
                              color: FlutterFlowTheme.of(context).secondaryText,
                              letterSpacing: 0.0,
                            ),
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            'Tente ajustar os filtros ou termos de pesquisa',
                            style: FlutterFlowTheme.of(context).bodyMedium.copyWith(
                              color: FlutterFlowTheme.of(context).secondaryText,
                              letterSpacing: 0.0,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  
                  return ListView.builder(
                    padding: EdgeInsets.all(isMobileDevice ? 12.0 : 16.0),
                    itemCount: filteredTasks.length,
                    itemBuilder: (context, index) {
                      final task = filteredTasks[index];
                      return _buildTaskCard(task, isMobileDevice);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected, String filterType) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (value) {
        setState(() {
          _model.toggleFilter(filterType);
        });
      },
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

  Widget _buildTaskCard(Map<String, dynamic> task, bool isMobile) {
    return Container(
      margin: EdgeInsets.only(bottom: isMobile ? 12.0 : 16.0),
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
      child: InkWell(
        onTap: () {
          // TODO: Navigate to task details
        },
        borderRadius: BorderRadius.circular(12.0),
        child: Padding(
          padding: EdgeInsets.all(isMobile ? 16.0 : 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with title and priority
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      task['titulo'] ?? '',
                      style: FlutterFlowTheme.of(context).titleMedium.copyWith(
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(width: 12.0),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                    decoration: BoxDecoration(
                      color: _model.getPriorityColor(task['prioridade'] ?? '').withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4.0),
                      border: Border.all(
                        color: _model.getPriorityColor(task['prioridade'] ?? ''),
                        width: 1.0,
                      ),
                    ),
                    child: Text(
                      task['prioridade'] ?? '',
                      style: FlutterFlowTheme.of(context).bodySmall.copyWith(
                        color: _model.getPriorityColor(task['prioridade'] ?? ''),
                        fontSize: 11.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: 8.0),
              
              // Description
              Text(
                task['descricao'] ?? '',
                style: FlutterFlowTheme.of(context).bodyMedium.copyWith(
                  color: FlutterFlowTheme.of(context).secondaryText,
                  letterSpacing: 0.0,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              
              SizedBox(height: 12.0),
              
              // Status and location row
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                    decoration: BoxDecoration(
                      color: _model.getStatusColor(task['status'] ?? '').withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4.0),
                      border: Border.all(
                        color: _model.getStatusColor(task['status'] ?? ''),
                        width: 1.0,
                      ),
                    ),
                    child: Text(
                      task['status'] ?? '',
                      style: FlutterFlowTheme.of(context).bodySmall.copyWith(
                        color: _model.getStatusColor(task['status'] ?? ''),
                        fontSize: 11.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(width: 12.0),
                  Icon(
                    Icons.location_on_outlined,
                    size: 16.0,
                    color: FlutterFlowTheme.of(context).secondaryText,
                  ),
                  SizedBox(width: 4.0),
                  Expanded(
                    child: Text(
                      task['localizacao'] ?? '',
                      style: FlutterFlowTheme.of(context).bodySmall.copyWith(
                        color: FlutterFlowTheme.of(context).secondaryText,
                        letterSpacing: 0.0,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: 8.0),
              
              // Footer with beacon and deadline
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.person_outline,
                        size: 16.0,
                        color: FlutterFlowTheme.of(context).primary,
                      ),
                      SizedBox(width: 4.0),
                      Text(
                        task['assignedTo'] ?? '',
                        style: FlutterFlowTheme.of(context).bodySmall.copyWith(
                          color: FlutterFlowTheme.of(context).primary,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.schedule,
                        size: 16.0,
                        color: FlutterFlowTheme.of(context).secondaryText,
                      ),
                      SizedBox(width: 4.0),
                      Text(
                        task['dataLimite'] ?? '',
                        style: FlutterFlowTheme.of(context).bodySmall.copyWith(
                          color: FlutterFlowTheme.of(context).secondaryText,
                          letterSpacing: 0.0,
                        ),
                      ),
                    ],
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

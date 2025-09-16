import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/app_bottom_navigation.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
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
    
    // Load dropdown options and update UI when ready
    _loadDropdownOptionsWithStateUpdate();
  }
  
  void _loadDropdownOptionsWithStateUpdate() async {
    await _model.loadDropdownOptions(() {
      if (mounted) {
        setState(() {
          // Trigger UI rebuild when options are loaded
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
        bottomNavigationBar: AppBottomNavigation(currentIndex: 2),
        body: Column(
          children: [
            // Search and Filter Bar
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
                          controller: _model.searchController,
                          focusNode: _model.searchFocusNode,
                          onChanged: (_) => EasyDebounce.debounce(
                            '_model.searchController',
                            Duration(milliseconds: 500),
                            () => setState(() {}),
                          ),
                          decoration: InputDecoration(
                            hintText: 'Pesquisar...',
                            prefixIcon: Icon(
                              Icons.search,
                              color: FlutterFlowTheme.of(context).secondaryText,
                              size: 24.0,
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
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).primary,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            filled: true,
                            fillColor: FlutterFlowTheme.of(context).primaryBackground,
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
                      if (FFAppState().isManager) ...[
                        SizedBox(width: 16.0),
                        Material(
                          color: Colors.transparent,
                          child: IconButton(
                            onPressed: () {
                              setState(() {
                                _model.toggleCreateForm();
                              });
                            },
                            icon: Icon(
                              _model.showCreateForm ? Icons.close : Icons.add,
                              color: FlutterFlowTheme.of(context).primaryText,
                              size: 24.0,
                            ),
                            style: IconButton.styleFrom(
                              backgroundColor: FlutterFlowTheme.of(context).primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              minimumSize: Size(48, 48),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  
                  // Filters Section
                  if (showFilters) ...[
                    SizedBox(height: 20.0),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).primaryBackground,
                        borderRadius: BorderRadius.circular(12.0),
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
                                'Filtrar por Status',
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
                          Wrap(
                            spacing: 12.0,
                            runSpacing: 12.0,
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

            if (_model.showCreateForm && FFAppState().isManager) ...[
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(16.0),
                  child: _buildCreateEditForm(isMobileDevice),
                ),
              ),
            ] else ...[
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
                            'Erro ao carregar as tasks',
                            style: FlutterFlowTheme.of(context).headlineSmall.copyWith(
                              color: FlutterFlowTheme.of(context).error,
                              letterSpacing: 0.0,
                            ),
                          )
                        ],
                      ),
                    );
                  }
                  
                  final filteredTasks = snapshot.data ?? [];
                  
                  if (filteredTasks.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.all(isMobileDevice ? 24.0 : 32.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.assignment_outlined,
                              size: isMobileDevice ? 48.0 : 64.0,
                              color: FlutterFlowTheme.of(context).secondaryText,
                            ),
                            SizedBox(height: isMobileDevice ? 12.0 : 16.0),
                            Text(
                              'Nenhuma task encontrada',
                              style: FlutterFlowTheme.of(context).titleMedium.copyWith(
                                color: FlutterFlowTheme.of(context).primaryText,
                                fontSize: isMobileDevice ? 16.0 : 20.0,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.0,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 8.0),
                            Text(
                              'com base nos filtros aplicados',
                              style: FlutterFlowTheme.of(context).titleMedium.copyWith(
                                color: FlutterFlowTheme.of(context).secondaryText,
                                fontSize: isMobileDevice ? 16.0 : 20.0,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.0,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
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
              )
            ],
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
        fontSize: 14.0,
      ),
      side: BorderSide(
        color: isSelected 
          ? FlutterFlowTheme.of(context).primary 
          : FlutterFlowTheme.of(context).alternate,
        width: 1.0,
      ),
    );
  }

  Widget _buildCreateEditForm(bool isMobile) {
    return Container(
      margin: EdgeInsets.all(isMobile ? 12.0 : 16.0),
      padding: EdgeInsets.all(isMobile ? 16.0 : 24.0),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Expanded(
                child: Text(
                  _model.isEditing ? 'Editar Task' : 'Nova Task',
                  style: FlutterFlowTheme.of(context).headlineSmall.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 24.0,
                  ),
                ),
              ),
            ],
          ),
          
          SizedBox(height: 12.0),
          
          // Mensagem Field
          _buildTextField(
            label: 'Mensagem *',
            controller: _model.mensagemController,
            focusNode: _model.mensagemFocusNode,
            hintText: 'Descreva a task...',
            maxLines: 3,
          ),
          
          SizedBox(height: 10.0),
          
          // Tipo Destino Dropdown
          _buildDropdownField(
            label: 'Tipo de Destino *',
            value: _model.selectedTipoDestino,
            items: ['Maquina', 'Pessoa', 'Coordenada'],
            hintText: 'Selecione o tipo de destino',
            onChanged: (value) {
              setState(() {
                _model.selectedTipoDestino = value;
                _model.selectedDestino = null; // Reset destino quando tipo muda
                _model.destinoXController?.clear();
                _model.destinoYController?.clear();
              });
            },
          ),
          
          SizedBox(height: 10.0),
          
          // Destino Field (conditional based on tipo destino)
          if (_model.selectedTipoDestino == 'Maquina')
            _buildDropdownField(
              label: 'Máquina *',
              value: _model.selectedDestino,
              items: _model.maquinasOptions,
              hintText: 'Selecione a máquina',
              onChanged: (value) {
                setState(() {
                  _model.selectedDestino = value;
                });
              },
            )
          else if (_model.selectedTipoDestino == 'Pessoa')
            _buildDropdownField(
              label: 'Funcionário *',
              value: _model.selectedDestino,
              items: _model.funcionariosOptions,
              hintText: 'Selecione o funcionário',
              onChanged: (value) {
                setState(() {
                  _model.selectedDestino = value;
                });
              },
            )
          else if (_model.selectedTipoDestino == 'Coordenada')
            Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        label: 'Coordenada X *',
                        controller: _model.destinoXController,
                        focusNode: _model.destinoXFocusNode,
                        hintText: 'Ex: 10.5',
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    SizedBox(width: 12.0),
                    Expanded(
                      child: _buildTextField(
                        label: 'Coordenada Y *',
                        controller: _model.destinoYController,
                        focusNode: _model.destinoYFocusNode,
                        hintText: 'Ex: 20.3',
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          
          SizedBox(height: 10.0),
          
          // Beacons Multi-Select
          _buildMultiSelectField(
            label: 'Ferramentas e Materiais',
            selectedItems: _model.selectedBeacons,
            items: _model.beaconsOptions,
            hintText: 'Selecione ferramentas e materiais (opcional)',
            onChanged: (selectedItems) {
              setState(() {
                _model.selectedBeacons = selectedItems;
              });
            },
          ),
          
          SizedBox(height: 10.0),
          
          // Tipo da Task Dropdown
          _buildDropdownField(
            label: 'Tipo da Task *',
            value: _model.selectedTipo,
            items: _model.tipoOptions,
            hintText: 'Selecione o tipo da task',
            onChanged: (value) {
              setState(() {
                _model.selectedTipo = value;
              });
            },
          ),
          
          SizedBox(height: 10.0),
          
          // Status da Task Dropdown
          _buildDropdownField(
            label: 'Status da Task *',
            value: _model.selectedStatus,
            items: _model.statusOptions,
            hintText: 'Selecione o status da task',
            onChanged: (value) {
              setState(() {
                _model.selectedStatus = value;
              });
            },
          ),
          
          SizedBox(height: 24.0),
          
          // Action Buttons (siguiendo el patrón de tabela/mapa)
          Container(
            child: Row(
              children: [
                // Main action button (takes most space)
                Expanded(
                  flex: 5,
                  child: FFButtonWidget(
                    onPressed: _model.validateForm() ? () async {
                      bool success = false;
                      if (_model.isEditing) {
                        success = await _model.updateTask(context);
                      } else {
                        success = await _model.createTask(context);
                      }
                      
                      if (success) {
                        setState(() {
                          _model.toggleCreateForm();
                        });
                      }
                    } : null,
                    text: _model.isEditing ? 'Atualizar Task' : 'Criar Task',
                    options: FFButtonOptions(
                      height: 48.0,
                      color: FlutterFlowTheme.of(context).primary,
                      textStyle: FlutterFlowTheme.of(context).titleMedium.copyWith(
                        color: Colors.white,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.w600,
                        fontSize: 18.0,
                      ),
                      elevation: 2.0,
                      borderRadius: BorderRadius.circular(8.0),
                      disabledTextColor: Colors.white,
                    ),
                  ),
                ),
                SizedBox(width: 16.0),
                // Clear form button with trash icon (smaller)
                Container(
                  height: 48.0,
                  width: 48.0,
                  child: FFButtonWidget(
                    onPressed: () {
                      _model.clearForm();
                      setState(() {});
                    },
                    text: '',
                    icon: Icon(
                      Icons.delete_outline,
                      color: Colors.white,
                      size: 26.0,
                    ),
                    options: FFButtonOptions(
                      height: 48.0,
                      width: 48.0,
                      padding: EdgeInsets.fromLTRB(7.0, 2.0, 0.0, 2.0),
                      iconPadding: EdgeInsets.zero,
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
    );
  }

  Widget _buildTaskCard(Map<String, dynamic> task, bool isMobile) {
    // Parse beacons list
    List<String> beacons = [];
    if (task['beacons'] != null) {
      if (task['beacons'] is List) {
        beacons = List<String>.from(task['beacons']);
      } else if (task['beacons'] is String && task['beacons'].toString().isNotEmpty) {
        beacons = task['beacons'].toString().split(',').map((e) => e.trim()).toList();
      }
    }

    return Container(
      margin: EdgeInsets.only(bottom: isMobile ? 12.0 : 16.0),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            blurRadius: 8.0,
            color: Color(0x1A000000),
            offset: Offset(0.0, 4.0),
          ),
        ],
        border: Border.all(
          color: _model.getStatusColor(task['status'] ?? '').withOpacity(0.3),
          width: 2.0,
        ),
      ),
      child: InkWell(
        onTap: () {
          // TODO: Navigate to task details
        },
        borderRadius: BorderRadius.circular(12.0),
        child: Padding(
          padding: EdgeInsets.all(isMobile ? 16.0 : 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with title and status
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          task['descricao'] ?? task['mensagem'] ?? 'Sem descrição',
                          style: FlutterFlowTheme.of(context).titleMedium.copyWith(
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w700,
                            fontSize: isMobile ? 16.0 : 20.0,
                            color: FlutterFlowTheme.of(context).primaryText,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 8.0),
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                              decoration: BoxDecoration(
                                color: _model.getPriorityColor(task['tipo'] ?? '').withOpacity(0.15),
                                borderRadius: BorderRadius.circular(20.0),
                                border: Border.all(
                                  color: _model.getPriorityColor(task['tipo'] ?? ''),
                                  width: 1.5,
                                ),
                              ),
                              child: Text(
                                task['tipo'] ?? 'Geral',
                                style: FlutterFlowTheme.of(context).bodySmall.copyWith(
                                  color: _model.getPriorityColor(task['tipo'] ?? ''),
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 16.0),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                    decoration: BoxDecoration(
                      color: _model.getStatusColor(task['status'] ?? ''),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Text(
                      task['status'] ?? 'Pendente',
                      style: FlutterFlowTheme.of(context).bodySmall.copyWith(
                        color: Colors.white,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: 16.0),
              
              // Location and User info
              Container(
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).primaryBackground,
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(
                    color: FlutterFlowTheme.of(context).alternate,
                    width: 1.0,
                  ),
                ),
                child: Column(
                  children: [
                    if (task['destino']?.toString().isNotEmpty == true) ...[
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context).primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Icon(
                              Icons.location_on,
                              size: 24.0,
                              color: FlutterFlowTheme.of(context).primary,
                            ),
                          ),
                          SizedBox(width: 16.0),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Destino',
                                  style: FlutterFlowTheme.of(context).bodySmall.copyWith(
                                    color: FlutterFlowTheme.of(context).secondaryText,
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 3.0),
                                Text(
                                  task['destino'] ?? 'Sem destino',
                                  style: FlutterFlowTheme.of(context).bodyMedium.copyWith(
                                    color: FlutterFlowTheme.of(context).primaryText,
                                    letterSpacing: 0.0,
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12.0),
                    ],
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context).secondary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Icon(
                            Icons.person,
                            size: 24.0,
                            color: FlutterFlowTheme.of(context).secondary,
                          ),
                        ),
                        SizedBox(width: 16.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Responsável',
                                style: FlutterFlowTheme.of(context).bodySmall.copyWith(
                                  color: FlutterFlowTheme.of(context).secondaryText,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 3.0),
                              Text(
                                task['user'] ?? 'Não atribuído',
                                style: FlutterFlowTheme.of(context).bodyMedium.copyWith(
                                  color: FlutterFlowTheme.of(context).secondary,
                                  letterSpacing: 0.0,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Beacons section
              if (beacons.isNotEmpty) ...[
                SizedBox(height: 16.0),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(
                      color: Colors.blue.withOpacity(0.3),
                      width: 1.0,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.sensors,
                            size: 24.0,
                            color: Colors.blue,
                          ),
                          SizedBox(width: 8.0),
                          Text(
                            'Beacons Necessários',
                            style: FlutterFlowTheme.of(context).bodyMedium.copyWith(
                              color: Colors.blue,
                              fontWeight: FontWeight.w600,
                              fontSize: 18.0,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12.0),
                      Wrap(
                        spacing: 6.0,
                        runSpacing: 6.0,
                        children: beacons.map((beacon) => Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Text(
                            beacon,
                            style: FlutterFlowTheme.of(context).bodySmall.copyWith(
                              color: Colors.white,
                              fontSize: 14.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        )).toList(),
                      ),
                    ],
                  ),
                ),
              ],
              
              // Manager actions
              if (FFAppState().isManager) ...[
                Container(
                  height: 1.0,
                  color: FlutterFlowTheme.of(context).alternate,
                  margin: EdgeInsets.symmetric(vertical: 20.0),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: IconButton(
                        onPressed: () {
                          _model.loadTaskForEditing(task);
                          setState(() {});
                        },
                        icon: Icon(
                          Icons.edit_rounded,
                          size: 24.0,
                          color: FlutterFlowTheme.of(context).primary,
                        ),
                        style: IconButton.styleFrom(
                          minimumSize: Size(40.0, 40.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 16.0),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: IconButton(
                        onPressed: () {
                          _showDeleteConfirmation(context, task);
                        },
                        icon: Icon(
                          Icons.delete_rounded,
                          size: 24.0,
                          color: Colors.red,
                        ),
                        style: IconButton.styleFrom(
                          minimumSize: Size(40.0, 40.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController? controller,
    required FocusNode? focusNode,
    required String hintText,
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: FlutterFlowTheme.of(context).bodyMedium.copyWith(
            color: FlutterFlowTheme.of(context).secondaryText,
            fontSize: 14.0,
            letterSpacing: 0.0,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 6.0),
        TextFormField(
          controller: controller,
          focusNode: focusNode,
          maxLines: maxLines,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: FlutterFlowTheme.of(context).bodyMedium.copyWith(
              color: FlutterFlowTheme.of(context).secondaryText,
              letterSpacing: 0.0,
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
            contentPadding: EdgeInsets.all(12.0),
          ),
          style: FlutterFlowTheme.of(context).bodyMedium.copyWith(
            letterSpacing: 0.0,
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<String> items,
    required String hintText,
    required Function(String?) onChanged,
  }) {
    // Debug print to see what options are available
    print('Building dropdown for $label with ${items.length} items: $items');
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: FlutterFlowTheme.of(context).bodyMedium.copyWith(
            color: FlutterFlowTheme.of(context).secondaryText,
            fontSize: 14.0,
            letterSpacing: 0.0,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 6.0),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).primaryBackground,
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(
              color: FlutterFlowTheme.of(context).alternate,
              width: 1.0,
            ),
          ),
          child: _model.isLoadingOptions
            ? Padding(
                padding: EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    SizedBox(
                      width: 16.0,
                      height: 16.0,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.0,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          FlutterFlowTheme.of(context).primary,
                        ),
                      ),
                    ),
                    SizedBox(width: 8.0),
                    Text(
                      'Carregando opções...',
                      style: FlutterFlowTheme.of(context).bodyMedium.copyWith(
                        color: FlutterFlowTheme.of(context).secondaryText,
                        letterSpacing: 0.0,
                      ),
                    ),
                  ],
                ),
              )
            : DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: value,
                  hint: Padding(
                    padding: EdgeInsets.only(left: 12.0),
                    child: Text(
                      _getDropdownHintText(label, items),
                      style: FlutterFlowTheme.of(context).bodyMedium.copyWith(
                        color: items.isEmpty 
                          ? FlutterFlowTheme.of(context).error
                          : FlutterFlowTheme.of(context).secondaryText,
                        letterSpacing: 0.0,
                      ),
                    ),
                  ),
                  isExpanded: true,
                  icon: Padding(
                    padding: EdgeInsets.only(right: 12.0),
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      color: FlutterFlowTheme.of(context).secondaryText,
                    ),
                  ),
                  items: _getDropdownItems(label, items),
                  onChanged: (selectedValue) {
                    // Don't allow selection of placeholder messages
                    if (selectedValue != null && !selectedValue.startsWith('Sem ')) {
                      onChanged(selectedValue);
                    }
                  },
                ),
              ),
        ),
      ],
    );
  }

  void _showDeleteConfirmation(BuildContext context, Map<String, dynamic> task) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Confirmar Exclusão',
            style: FlutterFlowTheme.of(context).titleMedium,
          ),
          content: Text(
            'Tem certeza que deseja deletar esta task?\n\n"${task['descricao'] ?? 'Task sem descrição'}"',
            style: FlutterFlowTheme.of(context).bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancelar',
                style: FlutterFlowTheme.of(context).bodyMedium.copyWith(
                  color: FlutterFlowTheme.of(context).secondaryText,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
                
                // Check if widget is still mounted before performing deletion
                if (mounted && context.mounted) {
                  final success = await _model.deleteTask(context, task['id'].toString());
                  if (success && mounted) {
                    setState(() {});
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: Text('Deletar'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildMultiSelectField({
    required String label,
    required List<String> selectedItems,
    required List<String> items,
    required String hintText,
    required Function(List<String>) onChanged,
  }) {
    // Debug print to see what options are available
    print('Building multi-select for $label with ${items.length} items: $items');
    print('Currently selected: $selectedItems');
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: FlutterFlowTheme.of(context).bodyMedium.copyWith(
            color: FlutterFlowTheme.of(context).secondaryText,
            fontSize: 14.0,
            letterSpacing: 0.0,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 6.0),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).primaryBackground,
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(
              color: FlutterFlowTheme.of(context).alternate,
              width: 1.0,
            ),
          ),
          child: _model.isLoadingOptions
            ? Padding(
                padding: EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    SizedBox(
                      width: 16.0,
                      height: 16.0,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.0,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          FlutterFlowTheme.of(context).primary,
                        ),
                      ),
                    ),
                    SizedBox(width: 8.0),
                    Text(
                      'Carregando opções...',
                      style: FlutterFlowTheme.of(context).bodyMedium.copyWith(
                        color: FlutterFlowTheme.of(context).secondaryText,
                        letterSpacing: 0.0,
                      ),
                    ),
                  ],
                ),
              )
            : Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(8.0),
                  onTap: () => _showImprovedMultiSelectDialog(
                    title: label,
                    items: items,
                    selectedItems: selectedItems,
                    onSelectionChanged: onChanged,
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: selectedItems.isEmpty
                            ? Text(
                                _getMultiSelectHintText(label, items),
                                style: FlutterFlowTheme.of(context).bodyMedium.copyWith(
                                  color: items.isEmpty 
                                    ? FlutterFlowTheme.of(context).error
                                    : FlutterFlowTheme.of(context).secondaryText,
                                  letterSpacing: 0.0,
                                  fontStyle: items.isEmpty ? FontStyle.italic : FontStyle.normal,
                                ),
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Wrap(
                                    spacing: 6.0,
                                    runSpacing: 6.0,
                                    children: selectedItems.take(3).map((item) {
                                      return Container(
                                        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                                        decoration: BoxDecoration(
                                          color: FlutterFlowTheme.of(context).primary,
                                          borderRadius: BorderRadius.circular(16.0),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              item,
                                              style: FlutterFlowTheme.of(context).bodySmall.copyWith(
                                                color: Colors.white,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            SizedBox(width: 4.0),
                                            InkWell(
                                              onTap: () {
                                                List<String> newSelection = List.from(selectedItems);
                                                newSelection.remove(item);
                                                onChanged(newSelection);
                                              },
                                              child: Icon(
                                                Icons.close,
                                                size: 16.0,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                  if (selectedItems.length > 3)
                                    Padding(
                                      padding: EdgeInsets.only(top: 6.0),
                                      child: Text(
                                        '+${selectedItems.length - 3} mais...',
                                        style: FlutterFlowTheme.of(context).bodySmall.copyWith(
                                          color: FlutterFlowTheme.of(context).primary,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                        ),
                        SizedBox(width: 8.0),
                        Icon(
                          Icons.arrow_drop_down,
                          color: FlutterFlowTheme.of(context).secondaryText,
                          size: 24.0,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
        ),
      ],
    );
  }

  void _showImprovedMultiSelectDialog({
    required String title,
    required List<String> items,
    required List<String> selectedItems,
    required Function(List<String>) onSelectionChanged,
  }) {
    List<String> tempSelection = List.from(selectedItems);
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              title: Row(
                children: [
                  Icon(
                    Icons.build_outlined,
                    color: FlutterFlowTheme.of(context).primary,
                    size: 24.0,
                  ),
                  SizedBox(width: 8.0),
                  Expanded(
                    child: Text(
                      title,
                      style: FlutterFlowTheme.of(context).titleMedium.copyWith(
                        color: FlutterFlowTheme.of(context).primaryText,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              content: Container(
                width: double.maxFinite,
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.6,
                ),
                child: items.isEmpty 
                  ? Container(
                      padding: EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.inventory_2_outlined,
                            size: 48.0,
                            color: FlutterFlowTheme.of(context).secondaryText,
                          ),
                          SizedBox(height: 16.0),
                          Text(
                            'Sem ferramentas e materiais disponíveis no momento.',
                            style: FlutterFlowTheme.of(context).bodyMedium.copyWith(
                              color: FlutterFlowTheme.of(context).secondaryText,
                              fontSize: 16.0,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: ListView.separated(
                            shrinkWrap: true,
                            itemCount: items.length,
                            separatorBuilder: (context, index) => Divider(
                              height: 1.0,
                              color: FlutterFlowTheme.of(context).alternate,
                            ),
                            itemBuilder: (context, index) {
                              final item = items[index];
                              final isSelected = tempSelection.contains(item);
                              
                              return Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    setDialogState(() {
                                      if (isSelected) {
                                        tempSelection.remove(item);
                                      } else {
                                        tempSelection.add(item);
                                      }
                                    });
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 20.0,
                                          height: 20.0,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: isSelected 
                                                ? FlutterFlowTheme.of(context).primary
                                                : FlutterFlowTheme.of(context).alternate,
                                              width: 2.0,
                                            ),
                                            color: isSelected 
                                              ? FlutterFlowTheme.of(context).primary
                                              : Colors.transparent,
                                          ),
                                          child: isSelected
                                            ? Icon(
                                                Icons.check,
                                                size: 14.0,
                                                color: Colors.white,
                                              )
                                            : null,
                                        ),
                                        SizedBox(width: 12.0),
                                        Expanded(
                                          child: Text(
                                            item,
                                            style: FlutterFlowTheme.of(context).bodyMedium.copyWith(
                                              color: isSelected 
                                                ? FlutterFlowTheme.of(context).primaryText
                                                : FlutterFlowTheme.of(context).secondaryText,
                                              fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  ),
                  child: Text(
                    'Cancelar',
                    style: FlutterFlowTheme.of(context).bodyMedium.copyWith(
                      color: FlutterFlowTheme.of(context).secondaryText,
                      fontWeight: FontWeight.w700,
                      fontSize: 16.0,
                    ),
                  ),
                ),
                if (items.isNotEmpty) ...[
                  if (tempSelection.isNotEmpty)
                    TextButton(
                      onPressed: () {
                        setDialogState(() {
                          tempSelection.clear();
                        });
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      ),
                      child: Text(
                        'Limpar',
                        style: FlutterFlowTheme.of(context).bodyMedium.copyWith(
                          color: FlutterFlowTheme.of(context).error,
                          fontWeight: FontWeight.w700,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  ElevatedButton(
                    onPressed: () {
                      onSelectionChanged(tempSelection);
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: FlutterFlowTheme.of(context).primary,
                      foregroundColor: FlutterFlowTheme.of(context).primaryText,
                      padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: Text(
                      'Confirmar',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                ],
              ],
            );
          },
        );
      },
    );
  }

  String _getDropdownHintText(String label, List<String> items) {
    if (items.isEmpty) {
      if (label.contains('Máquina')) {
        return 'Sem máquinas no momento';
      } else if (label.contains('Funcionário')) {
        return 'Sem funcionários no momento';
      } else if (label.contains('Beacon')) {
        return 'Sem beacons no momento';
      } else {
        return 'Sem opções no momento';
      }
    }
    
    // Return original hint text based on label
    if (label.contains('Máquina')) {
      return 'Selecione a máquina';
    } else if (label.contains('Funcionário')) {
      return 'Selecione o funcionário';
    } else if (label.contains('Beacon')) {
      return 'Selecione o beacon (opcional)';
    } else {
      return 'Selecione uma opção';
    }
  }

  List<DropdownMenuItem<String>> _getDropdownItems(String label, List<String> items) {
    if (items.isEmpty) {
      String emptyMessage;
      if (label.contains('Máquina')) {
        emptyMessage = 'Sem máquinas no momento';
      } else if (label.contains('Funcionário')) {
        emptyMessage = 'Sem funcionários no momento';
      } else if (label.contains('Beacon')) {
        emptyMessage = 'Sem beacons no momento';
      } else {
        emptyMessage = 'Sem opções no momento';
      }
      
      return [
        DropdownMenuItem<String>(
          value: emptyMessage,
          enabled: false,
          child: Padding(
            padding: EdgeInsets.only(left: 12.0),
            child: Text(
              emptyMessage,
              style: FlutterFlowTheme.of(context).bodyMedium.copyWith(
                color: FlutterFlowTheme.of(context).error,
                letterSpacing: 0.0,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ),
      ];
    }
    
    return items.map((String item) {
      return DropdownMenuItem<String>(
        value: item,
        child: Padding(
          padding: EdgeInsets.only(left: 12.0),
          child: Text(
            item,
            style: FlutterFlowTheme.of(context).bodyMedium.copyWith(
              letterSpacing: 0.0,
            ),
          ),
        ),
      );
    }).toList();
  }

  String _getMultiSelectHintText(String label, List<String> items) {
    if (items.isEmpty) {
      return 'Sem ferramentas e materiais no momento';
    }
    return 'Selecione ferramentas e materiais (opcional)';
  }
}

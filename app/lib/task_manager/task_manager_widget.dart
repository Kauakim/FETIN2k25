import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/app_bottom_navigation.dart';
import '/tasks_pag/tasks_widget.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'task_manager_model.dart';
export 'task_manager_model.dart';

class TaskManagerWidget extends StatefulWidget {
  final Map<String, dynamic>? taskToEdit;
  
  const TaskManagerWidget({
    super.key,
    this.taskToEdit,
  });

  static String routeName = 'TaskManager';
  static String routePath = '/taskManager';

  @override
  State<TaskManagerWidget> createState() => _TaskManagerWidgetState();
}

class _TaskManagerWidgetState extends State<TaskManagerWidget> {
  late TaskManagerModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool showFilters = false;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => TaskManagerModel());
    
    // If task to edit was passed, load it
    if (widget.taskToEdit != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _model.loadTaskForEditing(widget.taskToEdit!);
        setState(() {});
      });
    }
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
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 24.0,
            ),
            onPressed: () {
              context.pushNamed(TasksWidget.routeName);
            },
          ),
          title: Text(
            'Gerenciar Tasks',
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
          child: CustomScrollView(
            slivers: [
              // Search, Filter and Create Bar
              SliverToBoxAdapter(
                child: Container(
                  padding: EdgeInsets.all(isMobileDevice ? 8.0 : 12.0),
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
                            'searchController',
                            Duration(milliseconds: 300),
                            () => setState(() {}),
                          ),
                          decoration: InputDecoration(
                            labelText: 'Buscar tasks...',
                            labelStyle: FlutterFlowTheme.of(context).bodyMedium.copyWith(
                              color: FlutterFlowTheme.of(context).secondaryText,
                            ),
                            prefixIcon: Icon(
                              Icons.search,
                              color: FlutterFlowTheme.of(context).secondaryText,
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
                            contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
                          ),
                          style: FlutterFlowTheme.of(context).bodyMedium,
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
                      SizedBox(width: 8.0),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _model.toggleCreateForm();
                          });
                        },
                        icon: Icon(
                          _model.showCreateForm ? Icons.close : Icons.add,
                          color: Colors.white,
                        ),
                        style: IconButton.styleFrom(
                          backgroundColor: FlutterFlowTheme.of(context).primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  // Filters Section
                  if (showFilters) ...[
                    SizedBox(height: 12.0),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(12.0),
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
                          Text(
                            'Filtrar por Status:',
                            style: FlutterFlowTheme.of(context).bodyMedium.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 8.0),
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
            )
            ),

            // Create/Edit Form
            if (_model.showCreateForm) ...[
              SliverToBoxAdapter(
                child: _buildCreateEditForm(isMobileDevice),
              ),
            ],
            
            // Tasks List
            SliverFillRemaining(
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
                            size: 48.0,
                            color: FlutterFlowTheme.of(context).secondaryText,
                          ),
                          SizedBox(height: 16.0),
                          Text(
                            'Erro ao carregar tasks',
                            style: FlutterFlowTheme.of(context).bodyMedium,
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
                            Icons.task_alt,
                            size: 48.0,
                            color: FlutterFlowTheme.of(context).secondaryText,
                          ),
                          SizedBox(height: 16.0),
                          Text(
                            'Nenhuma task encontrada',
                            style: FlutterFlowTheme.of(context).bodyMedium,
                          ),
                        ],
                      ),
                    );
                  }
                  
                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final task = filteredTasks[index];
                        return Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: isMobileDevice ? 8.0 : 12.0,
                            vertical: 4.0,
                          ),
                          child: _buildTaskCard(task, isMobileDevice),
                        );
                      },
                      childCount: filteredTasks.length,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    ));
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

  Widget _buildCreateEditForm(bool isMobile) {
    return Container(
      margin: EdgeInsets.all(isMobile ? 8.0 : 12.0),
      padding: EdgeInsets.all(isMobile ? 12.0 : 16.0),
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
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    _model.toggleCreateForm();
                  });
                },
                icon: Icon(Icons.close),
                style: IconButton.styleFrom(
                  backgroundColor: FlutterFlowTheme.of(context).alternate,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
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
          
          // Destino Field
          _buildTextField(
            label: 'Destino *',
            controller: _model.destinoController,
            focusNode: _model.destinoFocusNode,
            hintText: 'Ex: Estação de Carga 1',
          ),
          
          SizedBox(height: 10.0),
          
          // Tipo Destino Field
          _buildTextField(
            label: 'Tipo de Destino',
            controller: _model.tipoDestinoController,
            focusNode: _model.tipoDestinoFocusNode,
            hintText: 'Ex: Local, Departamento, Setor',
          ),
          
          SizedBox(height: 10.0),
          
          // Row with dropdowns
          Row(
            children: [
              Expanded(
                child: _buildDropdown(
                  label: 'Tipo da Task *',
                  value: _model.selectedTipo,
                  items: _model.tipoOptions,
                  onChanged: (value) {
                    setState(() {
                      _model.selectedTipo = value;
                    });
                  },
                  hintText: 'Selecione o tipo',
                ),
              ),
              SizedBox(width: 12.0),
              Expanded(
                child: _buildDropdown(
                  label: 'Status *',
                  value: _model.selectedStatus,
                  items: _model.statusOptions,
                  onChanged: (value) {
                    setState(() {
                      _model.selectedStatus = value;
                    });
                  },
                  hintText: 'Selecione o status',
                ),
              ),
            ],
          ),
          
          SizedBox(height: 10.0),
          
          // Beacons Field
          _buildTextField(
            label: 'Beacons',
            controller: _model.beaconsController,
            focusNode: _model.beaconsFocusNode,
            hintText: 'Ex: B001, B002, B003 (separados por vírgula)',
          ),
          
          SizedBox(height: 10.0),
          
          // Dependências Field
          _buildTextField(
            label: 'Dependências',
            controller: _model.dependenciasController,
            focusNode: _model.dependenciasFocusNode,
            hintText: 'IDs das tasks que devem ser concluídas antes',
          ),
          
          SizedBox(height: 16.0),
          
          // Action Buttons
          Row(
            children: [
              Expanded(
                child: FFButtonWidget(
                  onPressed: () {
                    _model.clearForm();
                    setState(() {});
                  },
                  text: 'Limpar',
                  options: FFButtonOptions(
                    height: 40.0,
                    padding: EdgeInsets.symmetric(horizontal: 12.0),
                    iconPadding: EdgeInsets.zero,
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    textStyle: FlutterFlowTheme.of(context).bodyMedium,
                    borderSide: BorderSide(
                      color: FlutterFlowTheme.of(context).alternate,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              
              SizedBox(width: 12.0),
              
              Expanded(
                flex: 2,
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
                    height: 40.0,
                    padding: EdgeInsets.symmetric(horizontal: 12.0),
                    iconPadding: EdgeInsets.zero,
                    color: FlutterFlowTheme.of(context).primary,
                    textStyle: FlutterFlowTheme.of(context).bodyMedium.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTaskCard(Map<String, dynamic> task, bool isMobile) {
    return Container(
      margin: EdgeInsets.only(bottom: isMobile ? 8.0 : 12.0),
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
          _model.loadTaskForEditing(task);
          setState(() {});
        },
        borderRadius: BorderRadius.circular(12.0),
        child: Padding(
          padding: EdgeInsets.all(isMobile ? 12.0 : 16.0),
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
                  SizedBox(width: 8.0),
                  Icon(
                    Icons.edit,
                    size: 16.0,
                    color: FlutterFlowTheme.of(context).primary,
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
              
              // Footer with ID and user
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.tag,
                        size: 16.0,
                        color: FlutterFlowTheme.of(context).secondaryText,
                      ),
                      SizedBox(width: 4.0),
                      Text(
                        'ID: ${task['id']}',
                        style: FlutterFlowTheme.of(context).bodySmall.copyWith(
                          color: FlutterFlowTheme.of(context).secondaryText,
                        ),
                      ),
                    ],
                  ),
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
                          fontWeight: FontWeight.w500,
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

  Widget _buildTextField({
    required String label,
    required TextEditingController? controller,
    required FocusNode? focusNode,
    required String hintText,
    int maxLines = 1,
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
  
  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
    required String hintText,
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
          child: DropdownButton<String>(
            value: value,
            hint: Padding(
              padding: EdgeInsets.only(left: 12.0),
              child: Text(
                hintText,
                style: FlutterFlowTheme.of(context).bodyMedium.copyWith(
                  color: FlutterFlowTheme.of(context).secondaryText,
                  letterSpacing: 0.0,
                ),
              ),
            ),
            isExpanded: true,
            underline: SizedBox(),
            icon: Padding(
              padding: EdgeInsets.only(right: 12.0),
              child: Icon(
                Icons.keyboard_arrow_down,
                color: FlutterFlowTheme.of(context).secondaryText,
              ),
            ),
            items: items.map((String item) {
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
            }).toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}

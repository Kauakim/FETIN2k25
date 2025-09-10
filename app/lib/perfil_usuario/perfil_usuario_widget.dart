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
    
    // Set callback for state updates
    _model.setStateCallback(() {
      if (mounted) {
        setState(() {});
      }
    });
    
    // Load user data and conditionally load users list for managers
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _model.loadUserInfo().then((_) {
        // Only load all users if the user is a manager
        if (_model.isManager) {
          _model.loadAllUsers();
        }
      });
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
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        bottomNavigationBar: AppBottomNavigation(currentIndex: FFAppState().isManager ? 4 : 3),
        body: SafeArea(
          top: true,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // User Info Card
                Builder(
                  builder: (context) {
                    if (_model.isLoading) {
                      return Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(32.0),
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).secondaryBackground,
                          borderRadius: BorderRadius.circular(20.0),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 4.0,
                              color: Color(0x33000000),
                              offset: Offset(0.0, 2.0),
                            ),
                          ],
                        ),
                        child: Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              FlutterFlowTheme.of(context).primary,
                            ),
                          ),
                        ),
                      );
                    }
                    
                    return Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(28.0),
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                        borderRadius: BorderRadius.circular(20.0),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 12.0,
                            color: Color(0x15000000),
                            offset: Offset(0.0, 4.0),
                          ),
                          BoxShadow(
                            blurRadius: 24.0,
                            color: Color(0x08000000),
                            offset: Offset(0.0, 8.0),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Name Section
                          _buildInfoField('Nome', _model.nomeUsuario),
                          SizedBox(height: 24.0),
                          
                          // Email Section
                          if (_model.emailUsuario.isNotEmpty) ...[
                            _buildInfoField('Email', _model.emailUsuario),
                            SizedBox(height: 24.0),
                          ],
                          
                          // Role Section
                          if (_model.roleUsuario.isNotEmpty) ...[
                            _buildInfoField('Função', _model.roleUsuario),
                            SizedBox(height: 24.0),
                          ],
                          
                          // User Type Section
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  (_model.isManager 
                                    ? FlutterFlowTheme.of(context).primary
                                    : FlutterFlowTheme.of(context).secondary).withOpacity(0.1),
                                  (_model.isManager 
                                    ? FlutterFlowTheme.of(context).primary
                                    : FlutterFlowTheme.of(context).secondary).withOpacity(0.05),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(12.0),
                              border: Border.all(
                                color: (_model.isManager 
                                  ? FlutterFlowTheme.of(context).primary
                                  : FlutterFlowTheme.of(context).secondary).withOpacity(0.3),
                                width: 1.0,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 4.0,
                                  color: (_model.isManager 
                                    ? FlutterFlowTheme.of(context).primary
                                    : FlutterFlowTheme.of(context).secondary).withOpacity(0.1),
                                  offset: Offset(0.0, 2.0),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 36.0,
                                  height: 36.0,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        _model.isManager 
                                          ? FlutterFlowTheme.of(context).primary
                                          : FlutterFlowTheme.of(context).secondary,
                                        (_model.isManager 
                                          ? FlutterFlowTheme.of(context).primary
                                          : FlutterFlowTheme.of(context).secondary).withOpacity(0.8),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(18.0),
                                    boxShadow: [
                                      BoxShadow(
                                        blurRadius: 4.0,
                                        color: (_model.isManager 
                                          ? FlutterFlowTheme.of(context).primary
                                          : FlutterFlowTheme.of(context).secondary).withOpacity(0.3),
                                        offset: Offset(0.0, 2.0),
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    _model.isManager ? Icons.admin_panel_settings : Icons.work,
                                    color: Colors.white,
                                    size: 20.0,
                                  ),
                                ),
                                SizedBox(width: 16.0),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Tipo de Usuário',
                                      style: FlutterFlowTheme.of(context).bodySmall.copyWith(
                                        color: FlutterFlowTheme.of(context).secondaryText,
                                        fontSize: 12.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(height: 4.0),
                                    Text(
                                      _model.isManager ? 'Gerente' : 'Funcionário',
                                      style: FlutterFlowTheme.of(context).bodyLarge.copyWith(
                                        color: _model.isManager 
                                          ? FlutterFlowTheme.of(context).primary
                                          : FlutterFlowTheme.of(context).secondary,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
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
                    );
                  },
                ),
                
                SizedBox(height: 32.0),
                
                // Conditional sections based on user type
                if (_model.isWorker) ...[
                  // Tracking Control Card for Workers
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
                ] else if (_model.isManager) ...[
                  // User Management Section for Managers
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(20.0),
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.manage_accounts,
                                  color: FlutterFlowTheme.of(context).primary,
                                  size: 24.0,
                                ),
                                SizedBox(width: 12.0),
                                Text(
                                  'Gerenciar Usuários',
                                  style: FlutterFlowTheme.of(context).headlineSmall.copyWith(
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
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
                        
                        SizedBox(height: 16.0),
                        
                        Text(
                          'Gerencie os usuários do sistema, adicione novos funcionários e edite informações existentes.',
                          style: FlutterFlowTheme.of(context).bodyMedium.copyWith(
                            color: FlutterFlowTheme.of(context).secondaryText,
                            letterSpacing: 0.0,
                          ),
                        ),
                        
                        SizedBox(height: 16.0),
                        
                        // Create/Edit Form
                        if (_model.showCreateForm || _model.showEditForm) ...[
                          _buildUserForm(),
                          SizedBox(height: 20.0),
                        ],
                        
                        // Users List
                        if (_model.isLoadingUsers)
                          Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                FlutterFlowTheme.of(context).primary,
                              ),
                            ),
                          )
                        else if (_model.allUsers.isEmpty)
                          Center(
                            child: Column(
                              children: [
                                Icon(
                                  Icons.people_outline,
                                  size: 48.0,
                                  color: FlutterFlowTheme.of(context).secondaryText,
                                ),
                                SizedBox(height: 12.0),
                                Text(
                                  'Nenhum usuário encontrado',
                                  style: FlutterFlowTheme.of(context).bodyMedium.copyWith(
                                    color: FlutterFlowTheme.of(context).secondaryText,
                                  ),
                                ),
                              ],
                            ),
                          )
                        else
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: _model.allUsers.length,
                            itemBuilder: (context, index) {
                              final user = _model.allUsers[index];
                              return _buildUserCard(user);
                            },
                          ),
                      ],
                    ),
                  ),
                ],
                
                SizedBox(height: 40.0),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUserForm() {
    final isEdit = _model.showEditForm;
    
    return Container(
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
          Text(
            isEdit ? 'Editar Usuário' : 'Criar Novo Usuário',
            style: FlutterFlowTheme.of(context).bodyLarge.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),

          SizedBox(height: 16.0),
          
          // Username field
          TextFormField(
            controller: _model.usernameController,
            focusNode: _model.usernameFocusNode,
            decoration: InputDecoration(
              labelText: 'Nome de usuário *',
              labelStyle: FlutterFlowTheme.of(context).bodyMedium.copyWith(
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
              fillColor: FlutterFlowTheme.of(context).secondaryBackground,
            ),
          ),
          
          SizedBox(height: 16.0),
          
          // Password field
          TextFormField(
            controller: _model.passwordController,
            focusNode: _model.passwordFocusNode,
            obscureText: true,
            decoration: InputDecoration(
              labelText: isEdit ? 'Nova senha (Deixe vazio para manter)' : 'Senha *',
              labelStyle: FlutterFlowTheme.of(context).bodyMedium.copyWith(
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
              fillColor: FlutterFlowTheme.of(context).secondaryBackground,
            ),
          ),
          
          SizedBox(height: 16.0),
          
          // Email field
          TextFormField(
            controller: _model.emailController,
            focusNode: _model.emailFocusNode,
            decoration: InputDecoration(
              labelText: 'Email *',
              labelStyle: FlutterFlowTheme.of(context).bodyMedium.copyWith(
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
              fillColor: FlutterFlowTheme.of(context).secondaryBackground,
            ),
          ),
          
          SizedBox(height: 16.0),
          
          // Role field - Dropdown
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Função *',
                style: FlutterFlowTheme.of(context).bodyMedium.copyWith(
                  color: FlutterFlowTheme.of(context).secondaryText,
                  fontSize: 16.0,
                ),
              ),
              SizedBox(height: 8.0),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 12.0),
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(
                    color: FlutterFlowTheme.of(context).alternate,
                    width: 1.0,
                  ),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _model.roleController.text.isEmpty ? null : _model.roleController.text,
                    hint: Text(
                      isEdit ? 'Selecione para alterar' : 'Selecione uma função',
                      style: FlutterFlowTheme.of(context).bodyMedium.copyWith(
                        color: FlutterFlowTheme.of(context).secondaryText,
                      ),
                    ),
                    isExpanded: true,
                    icon: Icon(
                      Icons.arrow_drop_down,
                      color: FlutterFlowTheme.of(context).secondaryText,
                    ),
                    items: [
                      DropdownMenuItem<String>(
                        value: 'manager',
                        child: Row(
                          children: [
                            Icon(
                              Icons.admin_panel_settings,
                              color: FlutterFlowTheme.of(context).primary,
                              size: 20.0,
                            ),
                            SizedBox(width: 8.0),
                            Text(
                              'Gerente',
                              style: FlutterFlowTheme.of(context).bodyMedium,
                            ),
                          ],
                        ),
                      ),
                      DropdownMenuItem<String>(
                        value: 'worker',
                        child: Row(
                          children: [
                            Icon(
                              Icons.work,
                              color: FlutterFlowTheme.of(context).secondary,
                              size: 20.0,
                            ),
                            SizedBox(width: 8.0),
                            Text(
                              'Funcionário',
                              style: FlutterFlowTheme.of(context).bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ],
                    onChanged: (String? newValue) {
                      setState(() {
                        _model.roleController.text = newValue ?? '';
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
          
          SizedBox(height: 20.0),
          
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    // Validação dos campos
                    final username = _model.usernameController.text.trim();
                    final password = _model.passwordController.text.trim();
                    final email = _model.emailController.text.trim();
                    final role = _model.roleController.text.trim();
                    
                    String? errorMessage;
                    
                    if (isEdit) {
                      // Modo edição: apenas senha pode ficar vazia
                      if (username.isEmpty && password.isEmpty && email.isEmpty && role.isEmpty) {
                        errorMessage = 'Preencha pelo menos um campo para atualizar!';
                      }
                    } else {
                      // Modo criação: todos os campos obrigatórios
                      if (username.isEmpty) {
                        errorMessage = 'Nome de usuário é obrigatório!';
                      } else if (password.isEmpty) {
                        errorMessage = 'Senha é obrigatória!';
                      } else if (email.isEmpty) {
                        errorMessage = 'Email é obrigatório!';
                      } else if (role.isEmpty) {
                        errorMessage = 'Função é obrigatória!';
                      }
                    }
                    
                    if (errorMessage != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Row(
                            children: [
                              Icon(
                                Icons.warning,
                                color: Colors.white,
                                size: 20.0,
                              ),
                              SizedBox(width: 8.0),
                              Expanded(child: Text(errorMessage)),
                            ],
                          ),
                          backgroundColor: FlutterFlowTheme.of(context).error,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      );
                      return;
                    }
                    
                    bool success = false;
                    
                    if (isEdit) {
                      success = await _model.updateUser();
                    } else {
                      success = await _model.createUser();
                    }
                    
                    if (success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(isEdit ? 'Usuário atualizado com sucesso!' : 'Usuário criado com sucesso!'),
                          backgroundColor: FlutterFlowTheme.of(context).primary,
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Erro ao ${isEdit ? 'atualizar' : 'criar'} usuário!'),
                          backgroundColor: FlutterFlowTheme.of(context).error,
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: FlutterFlowTheme.of(context).primary,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 18.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    elevation: 4.0,
                    shadowColor: FlutterFlowTheme.of(context).primary.withOpacity(0.3),
                  ),
                  child: Text(
                    isEdit ? 'Atualizar' : 'Criar',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ),
              
              SizedBox(width: 12.0),
              
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      _model.hideForms();
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: FlutterFlowTheme.of(context).primaryText,
                    side: BorderSide(color: FlutterFlowTheme.of(context).alternate),
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: Text('Cancelar'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildUserCard(Map<String, dynamic> user) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.0),
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
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user['username'] ?? '',
                      style: FlutterFlowTheme.of(context).bodyLarge.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 4.0),
                    Text(
                      user['email'] ?? '',
                      style: FlutterFlowTheme.of(context).bodyMedium.copyWith(
                        color: FlutterFlowTheme.of(context).secondaryText,
                      ),
                    ),
                  ],
                ),
              ),
              
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _model.showEditUserForm(user);
                      });
                    },
                    icon: Icon(
                      Icons.edit,
                      color: FlutterFlowTheme.of(context).primary,
                      size: 20.0,
                    ),
                    style: IconButton.styleFrom(
                      backgroundColor: FlutterFlowTheme.of(context).primary.withOpacity(0.1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                    ),
                  ),
                  
                  SizedBox(width: 8.0),
                  
                  IconButton(
                    onPressed: () {
                      _showDeleteConfirmation(user['username'] ?? '');
                    },
                    icon: Icon(
                      Icons.delete,
                      color: FlutterFlowTheme.of(context).error,
                      size: 20.0,
                    ),
                    style: IconButton.styleFrom(
                      backgroundColor: FlutterFlowTheme.of(context).error.withOpacity(0.1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          
          SizedBox(height: 8.0),
          
          Text(
            'Função: ${user['role'] ?? 'N/A'}',
            style: FlutterFlowTheme.of(context).bodySmall.copyWith(
              color: FlutterFlowTheme.of(context).secondaryText,
            ),
          ),
        ],
      ),
    );
  }
  
  void _showDeleteConfirmation(String username) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          contentPadding: EdgeInsets.all(20.0),
          content: Container(
            width: 260.0, // Largura fixa menor
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon
                Container(
                  width: 60.0,
                  height: 60.0,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).error.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(24.0),
                  ),
                  child: Icon(
                    Icons.delete_outline,
                    color: FlutterFlowTheme.of(context).error,
                    size: 30.0,
                  ),
                ),

                SizedBox(height: 12.0),
                
                // Title
                Text(
                  'Confirmar Exclusão',
                  style: FlutterFlowTheme.of(context).headlineSmall.copyWith(
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.0,
                    fontSize: 20.0,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                SizedBox(height: 12.0),
                
                // Content
                Text(
                  'Excluir o usuário "$username"?\nEsta ação não pode ser desfeita.',
                  style: FlutterFlowTheme.of(context).bodyMedium.copyWith(
                    color: FlutterFlowTheme.of(context).secondaryText,
                    letterSpacing: 0.0,
                    fontSize: 16.0,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                SizedBox(height: 20.0),
                
                // Actions
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(dialogContext).pop();
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: FlutterFlowTheme.of(context).alternate,
                          foregroundColor: FlutterFlowTheme.of(context).primaryText,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 12.0),
                        ),
                        child: Text(
                          'Cancelar',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    ),
                    
                    SizedBox(width: 8.0),
                    
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          // Store the navigator before any async operations
                          final navigator = Navigator.of(dialogContext);
                          final scaffoldMessenger = ScaffoldMessenger.of(context);
                          final theme = FlutterFlowTheme.of(context);
                          
                          navigator.pop();
                          
                          // Show loading with a separate context
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext loadingContext) {
                              return Center(
                                child: Container(
                                  width: 80.0,
                                  height: 80.0,
                                  decoration: BoxDecoration(
                                    color: theme.secondaryBackground,
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        theme.primary,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                          
                          try {
                            final success = await _model.deleteUser(username);
                            
                            // Hide loading safely
                            if (mounted && Navigator.canPop(context)) {
                              Navigator.of(context).pop();
                            }
                            
                            if (mounted) {
                              if (success) {
                                scaffoldMessenger.showSnackBar(
                                  SnackBar(
                                    content: Row(
                                      children: [
                                        Icon(
                                          Icons.check_circle,
                                          color: Colors.white,
                                          size: 18.0,
                                        ),
                                        SizedBox(width: 8.0),
                                        Text('Usuário excluído com sucesso!'),
                                      ],
                                    ),
                                    backgroundColor: theme.primary,
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
                                );
                              } else {
                                scaffoldMessenger.showSnackBar(
                                  SnackBar(
                                    content: Row(
                                      children: [
                                        Icon(
                                          Icons.error_outline,
                                          color: Colors.white,
                                          size: 18.0,
                                        ),
                                        SizedBox(width: 8.0),
                                        Text('Erro ao excluir usuário!'),
                                      ],
                                    ),
                                    backgroundColor: theme.error,
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
                                );
                              }
                            }
                          } catch (e) {
                            // Hide loading safely
                            if (mounted && Navigator.canPop(context)) {
                              Navigator.of(context).pop();
                            }
                            
                            if (mounted) {
                              scaffoldMessenger.showSnackBar(
                                SnackBar(
                                  content: Row(
                                    children: [
                                      Icon(
                                        Icons.error_outline,
                                        color: Colors.white,
                                        size: 18.0,
                                      ),
                                      SizedBox(width: 8.0),
                                      Expanded(child: Text('Erro inesperado: $e')),
                                    ],
                                  ),
                                  backgroundColor: theme.error,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                              );
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: FlutterFlowTheme.of(context).error,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          elevation: 0.0,
                          padding: EdgeInsets.symmetric(vertical: 12.0),
                        ),
                        child: Text(
                          'Excluir',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16.0,
                          ),
                        ),
                      ),
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
  
  Widget _buildInfoField(String label, String value) {
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
            value,
            style: FlutterFlowTheme.of(context).bodyLarge.copyWith(
              letterSpacing: 0.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

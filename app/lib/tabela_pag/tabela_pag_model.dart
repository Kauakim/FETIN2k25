import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'dart:async';
import 'tabela_pag_widget.dart' show TabelaPagWidget;
import 'package:flutter/material.dart';

class TabelaPagModel extends FlutterFlowModel<TabelaPagWidget> {
  List<dynamic> allBeacons = [];
  void addToAllBeacons(dynamic item) => allBeacons.add(item);
  void removeFromAllBeacons(dynamic item) => allBeacons.remove(item);
  void removeAtIndexFromAllBeacons(int index) => allBeacons.removeAt(index);
  void insertAtIndexInAllBeacons(int index, dynamic item) =>
    allBeacons.insert(index, item);
  void updateAllBeaconsAtIndex(int index, Function(dynamic) updateFn) =>
    allBeacons[index] = updateFn(allBeacons[index]);

  List<dynamic> filteredBeacons = [];
  void addToFilteredBeacons(dynamic item) => filteredBeacons.add(item);
  void removeFromFilteredBeacons(dynamic item) => filteredBeacons.remove(item);
  void removeAtIndexFromFilteredBeacons(int index) =>
    filteredBeacons.removeAt(index);
  void insertAtIndexInFilteredBeacons(int index, dynamic item) =>
    filteredBeacons.insert(index, item);
  void updateFilteredBeaconsAtIndex(int index, Function(dynamic) updateFn) =>
    filteredBeacons[index] = updateFn(filteredBeacons[index]);

  String searchText = '.';
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;
  Completer<ApiCallResponse>? apiRequestCompleter;

  // Filter options
  bool showFilterMenu = false;
  
  // Machine filters
  bool filterEstacaoCarga = false;
  bool filterImpressora3d = false;
  bool filterImpressora = false;
  bool filterMaquinaCorrosao = false;
  bool filterEstacaoSolda = false;
  bool filterCNC = false;
  bool filterMaquinaCorte = false;
  bool filterBancadaReparos = false;
  
  // Beacon filters
  bool filterMultimetro = false;
  bool filterKitReparos = false;
  bool filterChapaMaterial = false;
  bool filterEstanho = false;
  bool filterComponentes = false;
  bool filterFilamento = false;
  
  // Type filters
  bool filterMaterial = false;
  bool filterFerramenta = false;
  bool filterMaquina = false;
  
  // Status filters
  bool filterEmUso = false;
  bool filterDisponivel = false;
  bool filterDescarregado = false;
  bool filterProcessado = false;
  bool filterIndisponivel = false;
  bool filterCarregando = false;
  bool filterCarregado = false;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();
  }

  /// Additional helper methods.
  Future waitForApiRequestCompleted({
    double minWait = 0,
    double maxWait = double.infinity,
  }) async {
    final stopwatch = Stopwatch()..start();
    while (true) {
      await Future.delayed(Duration(milliseconds: 50));
      final timeElapsed = stopwatch.elapsedMilliseconds;
      final requestComplete = apiRequestCompleter?.isCompleted ?? false;
      if (timeElapsed > maxWait || (requestComplete && timeElapsed > minWait)) {
        break;
      }
    }
  }

  // Filter methods
  void toggleFilterMenu() {
    showFilterMenu = !showFilterMenu;
  }

  void clearAllFilters() {
    // Machine filters
    filterEstacaoCarga = false;
    filterImpressora3d = false;
    filterImpressora = false;
    filterMaquinaCorrosao = false;
    filterEstacaoSolda = false;
    filterCNC = false;
    filterMaquinaCorte = false;
    filterBancadaReparos = false;
    
    // Beacon filters
    filterMultimetro = false;
    filterKitReparos = false;
    filterChapaMaterial = false;
    filterEstanho = false;
    filterComponentes = false;
    filterFilamento = false;
    
    // Type filters
    filterMaterial = false;
    filterFerramenta = false;
    filterMaquina = false;
    
    // Status filters
    filterEmUso = false;
    filterDisponivel = false;
    filterDescarregado = false;
    filterProcessado = false;
    filterIndisponivel = false;
    filterCarregando = false;
    filterCarregado = false;
  }

  bool hasActiveFilters() {
    return filterEstacaoCarga || filterImpressora3d || filterImpressora || 
           filterMaquinaCorrosao || filterEstacaoSolda || filterCNC || 
           filterMaquinaCorte || filterBancadaReparos || filterMultimetro || 
           filterKitReparos || filterChapaMaterial || filterEstanho || 
           filterComponentes || filterFilamento || filterMaterial || 
           filterFerramenta || filterMaquina || filterEmUso || filterDisponivel || 
           filterDescarregado || filterProcessado || filterIndisponivel || 
           filterCarregando || filterCarregado;
  }

  List<dynamic> getFilteredBeacons(List<dynamic> beacons) {
    if (!hasActiveFilters()) {
      return beacons;
    }

    return beacons.where((beacon) {
      // Machine filters
      if (filterEstacaoCarga || filterImpressora3d || filterImpressora || 
          filterMaquinaCorrosao || filterEstacaoSolda || filterCNC || 
          filterMaquinaCorte || filterBancadaReparos) {
        bool machineMatch = false;
        String maquina = (beacon['beacon'] ?? '').toString().toLowerCase();
        
        if (filterEstacaoCarga && maquina.contains('estacao de carga')) machineMatch = true;
        if (filterImpressora3d && maquina.contains('impressora 3d')) machineMatch = true;
        if (filterImpressora && maquina.contains('impressora') && !maquina.contains('3d')) machineMatch = true;
        if (filterMaquinaCorrosao && maquina.contains('maquina de corrosao')) machineMatch = true;
        if (filterEstacaoSolda && maquina.contains('estacao de solda')) machineMatch = true;
        if (filterCNC && maquina.contains('cnc')) machineMatch = true;
        if (filterMaquinaCorte && maquina.contains('maquina de corte')) machineMatch = true;
        if (filterBancadaReparos && maquina.contains('bancada de reparos e carga')) machineMatch = true;
        
        if (!machineMatch) return false;
      }

      // Beacon filters
      if (filterMultimetro || filterKitReparos || filterChapaMaterial || 
          filterEstanho || filterComponentes || filterFilamento) {
        bool beaconMatch = false;
        String beaconName = (beacon['beacon'] ?? '').toString().toLowerCase();
        
        if (filterMultimetro && beaconName.contains('multimetro')) beaconMatch = true;
        if (filterKitReparos && beaconName.contains('kit de reparos')) beaconMatch = true;
        if (filterChapaMaterial && beaconName.contains('chapa de material')) beaconMatch = true;
        if (filterEstanho && beaconName.contains('estanho')) beaconMatch = true;
        if (filterComponentes && beaconName.contains('componentes')) beaconMatch = true;
        if (filterFilamento && beaconName.contains('filamento')) beaconMatch = true;
        
        if (!beaconMatch) return false;
      }

      // Type filters
      if (filterMaterial || filterFerramenta || filterMaquina) {
        bool typeMatch = false;
        String tipo = (beacon['tipo'] ?? '').toString().toLowerCase();
        
        if (filterMaterial && tipo.contains('material')) typeMatch = true;
        if (filterFerramenta && tipo.contains('ferramenta')) typeMatch = true;
        if (filterMaquina && tipo.contains('maquina')) typeMatch = true;
        
        if (!typeMatch) return false;
      }

      // Status filters
      if (filterEmUso || filterDisponivel || filterDescarregado || 
          filterProcessado || filterIndisponivel || filterCarregando || filterCarregado) {
        bool statusMatch = false;
        String status = (beacon['status'] ?? '').toString().toLowerCase();
        
        if (filterEmUso && status.contains('em uso')) statusMatch = true;
        if (filterDisponivel && status.contains('disponivel')) statusMatch = true;
        if (filterDescarregado && status.contains('descarregado')) statusMatch = true;
        if (filterProcessado && status.contains('processado')) statusMatch = true;
        if (filterIndisponivel && status.contains('indisponível')) statusMatch = true;
        if (filterCarregando && status.contains('carregando')) statusMatch = true;
        if (filterCarregado && status.contains('carregado')) statusMatch = true;
        
        if (!statusMatch) return false;
      }

      return true;
    }).toList();
  }

  // Function to apply filters and close filter menu
  void confirmFilters() {
    showFilterMenu = false;
  }
}

import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'dart:async';
import 'relatorios_widget.dart' show RelatoriosWidget;
import 'package:flutter/material.dart';

class RelatoriosModel extends FlutterFlowModel<RelatoriosWidget> {
  List<dynamic> allReports = [];
  void addToAllReports(dynamic item) => allReports.add(item);
  void removeFromAllReports(dynamic item) => allReports.remove(item);
  void removeAtIndexFromAllReports(int index) => allReports.removeAt(index);
  void insertAtIndexInAllReports(int index, dynamic item) =>
    allReports.insert(index, item);
  void updateAllReportsAtIndex(int index, Function(dynamic) updateFn) =>
    allReports[index] = updateFn(allReports[index]);

  String searchText = '';
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;
  Completer<ApiCallResponse>? apiRequestCompleter;

  // Filter options
  bool showFilterMenu = false;
  String selectedPeriod = 'Todos';
  String selectedMachine = 'Todas';
  DateTime? startDate;
  DateTime? endDate;

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
    selectedPeriod = 'Todos';
    selectedMachine = 'Todas';
    startDate = null;
    endDate = null;
    searchText = '';
    textController?.clear();
  }

  bool hasActiveFilters() {
    return selectedPeriod != 'Todos' || 
           selectedMachine != 'Todas' ||
           startDate != null ||
           endDate != null ||
           searchText.isNotEmpty;
  }

  List<dynamic> getFilteredReports(List<dynamic> reports) {
    if (!hasActiveFilters()) {
      return reports;
    }

    return reports.where((report) {
      // Text search filter
      if (searchText.isNotEmpty) {
        String searchLower = searchText.toLowerCase();
        String machine = (report['maquina'] ?? '').toString().toLowerCase();
        if (!machine.contains(searchLower)) {
          return false;
        }
      }

      // Machine filter
      if (selectedMachine != 'Todas') {
        String machine = (report['maquina'] ?? '').toString();
        if (machine != selectedMachine) {
          return false;
        }
      }

      // Date filters
      if (startDate != null || endDate != null) {
        try {
          DateTime reportDate = DateTime.parse(report['data'] ?? '');
          if (startDate != null && reportDate.isBefore(startDate!)) {
            return false;
          }
          if (endDate != null && reportDate.isAfter(endDate!)) {
            return false;
          }
        } catch (e) {
          return false;
        }
      }

      // Period filter
      if (selectedPeriod != 'Todos') {
        try {
          DateTime reportDate = DateTime.parse(report['data'] ?? '');
          DateTime now = DateTime.now();
          
          switch (selectedPeriod) {
            case 'Hoje':
              if (!isSameDay(reportDate, now)) return false;
              break;
            case 'Última Semana':
              if (reportDate.isBefore(now.subtract(Duration(days: 7)))) return false;
              break;
            case 'Último Mês':
              if (reportDate.isBefore(now.subtract(Duration(days: 30)))) return false;
              break;
            case 'Últimos 3 Meses':
              if (reportDate.isBefore(now.subtract(Duration(days: 90)))) return false;
              break;
          }
        } catch (e) {
          return false;
        }
      }

      return true;
    }).toList();
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
           date1.month == date2.month &&
           date1.day == date2.day;
  }

  List<String> getUniqueMachines(List<dynamic> reports) {
    Set<String> machines = {'Todas'};
    for (var report in reports) {
      String machine = report['maquina']?.toString() ?? '';
      if (machine.isNotEmpty) {
        machines.add(machine);
      }
    }
    return machines.toList()..sort();
  }

  // Statistics calculations
  Map<String, dynamic> calculateStatistics(List<dynamic> reports) {
    if (reports.isEmpty) {
      return {
        'totalTasks': 0,
        'completedTasks': 0,
        'canceledTasks': 0,
        'totalHours': 0.0,
        'averageHours': 0.0,
        'completionRate': 0.0,
      };
    }

    int totalCompleted = 0;
    int totalCanceled = 0;
    double totalHours = 0.0;

    for (var report in reports) {
      totalCompleted += (report['tasksConcluidas'] ?? 0) as int;
      totalCanceled += (report['tasksCanceladas'] ?? 0) as int;
      totalHours += (report['horasTrabalhadas'] ?? 0.0) as double;
    }

    int totalTasks = totalCompleted + totalCanceled;
    double completionRate = totalTasks > 0 ? (totalCompleted / totalTasks) * 100 : 0.0;
    double averageHours = reports.isNotEmpty ? totalHours / reports.length : 0.0;

    return {
      'totalTasks': totalTasks,
      'completedTasks': totalCompleted,
      'canceledTasks': totalCanceled,
      'totalHours': totalHours,
      'averageHours': averageHours,
      'completionRate': completionRate,
    };
  }
}

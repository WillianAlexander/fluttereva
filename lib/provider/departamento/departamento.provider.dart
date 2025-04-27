import 'package:flutter/material.dart';
import 'package:fluttereva/provider/state/departamento.state.dart';

class DepartamentoProvider extends ChangeNotifier {
  List<Departamento> _departamentos = [];

  List<Departamento> get departamentos => List.unmodifiable(_departamentos);

  void cargarDesdeJson(List<dynamic> jsonList) {
    _departamentos =
        jsonList.map((json) => Departamento.fromJson(json)).toList();
    notifyListeners();
  }

  // Puedes agregar otros métodos si lo necesitas (ej: limpiar, agregar, eliminar)
}

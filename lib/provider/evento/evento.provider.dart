import 'package:flutter/material.dart';
import 'package:fluttereva/provider/state/evento.state.dart';

class EventoProvider with ChangeNotifier {
  EventoState? _evento;

  EventoState? get evento => _evento;

  void setEvento(EventoState evento) {
    _evento = evento;
    notifyListeners();
  }

  void actualizarDatos({
    required String titulo,
    required String fevento,
    required String observacion,
    String? estado,
  }) {
    if (_evento != null) {
      _evento = EventoState(
        titulo: titulo,
        fevento: fevento,
        observacion: observacion,
        estado: estado ?? _evento!.estado,
      );
      notifyListeners();
    }
  }

  void cargarDesdeJson(Map<String, dynamic> json) {
    _evento = EventoState.fromJson(json);
    notifyListeners();
  }
}

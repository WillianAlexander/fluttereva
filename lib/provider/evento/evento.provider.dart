import 'package:flutter/material.dart';
import 'package:fluttereva/provider/state/evento.state.dart';
import 'package:fluttereva/services/evento_service.dart';

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
        id: _evento!.id,
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

  Future<void> fetchActiveEvent() async {
    try {
      final eventoActivo = await EventoService().getActiveEvent();
      _evento = eventoActivo;
      notifyListeners();
    } catch (e) {
      _evento = null;
      notifyListeners();
      // Puedes manejar el error como prefieras
    }
  }

  Future<void> fetchEventById(int id) async {
    try {
      final evento = await EventoService().getEvento(id);
      _evento = EventoState(
        id: evento.id,
        titulo: evento.titulo,
        fevento: evento.fevento,
        observacion: evento.observacion,
        estado: evento.estado,
      );
      notifyListeners();
    } catch (e) {
      _evento = null;
      notifyListeners();
      // Puedes manejar el error como prefieras
    }
  }
}

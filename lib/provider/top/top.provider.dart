import 'package:flutter/material.dart';
import 'package:fluttereva/models/topevent.dart';
import 'package:fluttereva/services/evento_service.dart';

class TopProvider with ChangeNotifier {
  final EventoService _eventoService = EventoService();
  List<TopEvent> _topEvents = [];
  bool _loading = false;

  List<TopEvent> get topEvents => _topEvents;
  bool get loading => _loading;

  Future<void> fetchTopEvents() async {
    _loading = true;
    notifyListeners();
    try {
      final result = await _eventoService.getTopEvent();
      _topEvents = result;
    } catch (e) {
      _topEvents = [];
    }
    _loading = false;
    notifyListeners();
  }

  void clear() {
    _topEvents = [];
    notifyListeners();
  }
}

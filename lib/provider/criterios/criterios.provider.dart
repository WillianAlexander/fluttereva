import 'package:flutter/material.dart';
import 'package:fluttereva/services/criterios_service.dart';
import 'package:fluttereva/provider/state/criterio.state.dart';
import 'dart:convert';

class CriteriosProvider extends ChangeNotifier {
  List<Criterios> _criterios = [];

  List<Criterios> get criterios => _criterios;

  Future<void> fetchCriterios() async {
    try {
      _criterios = await CriteriosService().getCriterios();
      print(jsonEncode(_criterios));
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
}

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttereva/provider/state/user.state.dart';

class UsuarioProvider with ChangeNotifier {
  Usuario? _usuario;

  Usuario? get usuario => _usuario;

  void setUsuario(Usuario user) {
    _usuario = user;
    notifyListeners();
  }

  void actualizarDatos({
    required String nombres,
    required String apellidos,
    required String identificacion,
  }) {
    if (_usuario != null) {
      _usuario = Usuario(
        usuario: _usuario!.usuario,
        nombres: nombres,
        apellidos: apellidos,
        identificacion: identificacion,
        correo: _usuario!.correo,
        // password: _usuario!.password,
        estado: _usuario!.estado,
      );
      notifyListeners();
    }
  }

  void cargarDesdeJson(Map<String, dynamic> json) {
    _usuario = Usuario.fromJson(json);
    print('Estado: ${jsonEncode(usuario!.toJson())}');
    notifyListeners();
  }
}

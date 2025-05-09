import 'dart:convert';
import 'package:fluttereva/provider/state/departamento.state.dart';
import 'package:http/http.dart' as http;

class DepartamentService {
  final String baseUrl = 'https://apiseva.coopgualaquiza.fin.ec';

  Future<List<Departamento>> getDepartamentos() async {
    final url = Uri.parse('$baseUrl/departamentos');
    final response = await http.get(
      url,
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);

      return data.map((json) => Departamento.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener departamentos: ${response.body}');
    }
  }

  Future<bool> createDepartamento(Departamento departamento) async {
    final url = Uri.parse('$baseUrl/departamentos');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(departamento.toJson()),
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Error al crear departamento: ${response.body}');
    }
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fluttereva/provider/state/criterio.state.dart';

class CriteriosService {
  final String baseUrl = 'https://apiseva.coopgualaquiza.fin.ec';

  Future<List<Criterios>> getCriterios() async {
    final url = Uri.parse('$baseUrl/criterios-detalle');
    final response = await http.get(
      url,
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      return (jsonDecode(response.body) as List)
          .map((json) => Criterios.fromJson(json))
          .toList();
    } else {
      throw Exception('Error al obtener departamentos: ${response.body}');
    }
  }
}

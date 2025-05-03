import 'dart:convert';

import 'package:fluttereva/dto/evaluacion.dto.dart';
import 'package:fluttereva/services/auth/auth.dart';
import 'package:http/http.dart' as http;

class EvaluacionesSevice {
  final String baseUrl = 'http://192.168.0.128:3000';

  Future<EvaluacionDto?> createEvaluacion(EvaluacionDto evaluacion) async {
    final url = Uri.parse('$baseUrl/evaluaciones');
    final String token = generateToken();
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(evaluacion.toJson()),
    );
    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception('Error al crear evaluacion: ${response.body}');
    }
    return EvaluacionDto.fromJson(jsonDecode(response.body));
  }

  Future<List<EvaluacionDto>> getEvaluaciones(
    String fevaluacion,
    int eventoId,
    String evaluadorId,
  ) async {
    final url = Uri.parse('$baseUrl/evaluaciones/find');
    final String token = generateToken();
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'fevaluacion': fevaluacion,
        'evento_id': eventoId,
        'evaluador_id': evaluadorId,
      }),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Error al obtener evaluaciones: ${response.body}');
    }
    return (jsonDecode(response.body) as List)
        .map((e) => EvaluacionDto.fromJson(e))
        .toList();
  }
}

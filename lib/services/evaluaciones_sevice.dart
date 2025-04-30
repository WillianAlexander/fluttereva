import 'dart:convert';

import 'package:fluttereva/dto/evaluacion.dto.dart';
import 'package:fluttereva/services/auth/auth.dart';
import 'package:http/http.dart' as http;

class EvaluacionesSevice {
  final String baseUrl = 'http://192.168.112.131:3000';

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
    DateTime fevaluacion,
    int eventoId,
    String evaluadorId,
  ) async {
    final url = Uri.parse(
      '$baseUrl/evaluaciones?eventoId=$eventoId&evaluadorId=$evaluadorId&fevaluacion=${fevaluacion.toIso8601String()}',
    );
    final String token = generateToken();
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode != 200) {
      throw Exception('Error al obtener evaluaciones: ${response.body}');
    }
    return (jsonDecode(response.body) as List)
        .map((e) => EvaluacionDto.fromJson(e))
        .toList();
  }
}

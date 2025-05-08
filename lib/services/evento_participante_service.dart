import 'dart:convert';
import 'package:fluttereva/dto/evento-participantes.dto.dart';
import 'package:fluttereva/models/participantes.dart';
import 'package:http/http.dart' as http;

class EventoParticipanteService {
  final String baseUrl = 'http://192.168.112.131:3000';

  Future<List<Participantes>> getEventoParticipantes(int id) async {
    final url = Uri.parse('$baseUrl/eventoparticipantes/$id');
    final response = await http.get(
      url,
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      print('data getEventoParticipantes: $data');
      return data.map((json) => Participantes.fromJson(json)).toList();
    } else {
      throw Exception(
        'Error al obtener participantes de eventos: ${response.body}',
      );
    }
  }

  Future<Participantes> createEventoParticipante(
    EventoParticipantesDto dto,
  ) async {
    final url = Uri.parse('$baseUrl/eventoparticipantes');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(dto.toJson()),
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      print('createEventoParticipante: ${response.body}');
      return Participantes.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(
        'Error al crear registro evento-participante: ${response.body}',
      );
    }
  }

  Future<String> deleteEventoParticipante(
    int eventoId,
    int participanteId,
  ) async {
    final url = Uri.parse(
      '$baseUrl/eventoparticipantes/$eventoId/$participanteId',
    );
    final response = await http.delete(
      url,
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200 || response.statusCode == 204) {
      // Si hay body, retorna el mensaje; si no, retorna vacío.
      if (response.body.isNotEmpty) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return data['message'] ?? '';
      }
      return '';
    } else {
      throw Exception(
        'Error al eliminar registro evento-participante: ${response.body}',
      );
    }
  }
}

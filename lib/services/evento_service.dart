import 'dart:convert';
import 'package:fluttereva/models/evento.dto.dart';
import 'package:fluttereva/provider/state/evento.state.dart';
import 'package:http/http.dart' as http;

class EventoService {
  final String baseUrl = 'http://192.168.112.131:3000';

  Future<List<EventoState>> getEventos() async {
    final url = Uri.parse('$baseUrl/eventos');
    final response = await http.get(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    print('EventoService.body: ${response.body}');

    if (response.statusCode == 201 || response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => EventoState.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener eventos: ${response.body}');
    }
  }

  Future<EventoState> getActiveEvent() async {
    final url = Uri.parse('$baseUrl/eventos/estado/ACTIVO');
    final response = await http.get(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    print('EventoService.body: ${response.body}');

    if (response.statusCode == 201 || response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return EventoState.fromJson(data.first);
    } else {
      throw Exception('Error al obtener eventos: ${response.body}');
    }
  }

  Future<EventoDto> createEvento(EventoDto dto) async {
    final url = Uri.parse('$baseUrl/eventos');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(dto.toJson()),
    );
    print('response.body: ${response.body}');
    if (response.statusCode == 201 || response.statusCode == 200) {
      return EventoDto.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error al crear evento: ${response.body}');
    }
  }
}

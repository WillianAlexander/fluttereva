import 'dart:convert';
import 'package:fluttereva/models/evento-participantes.dto.dart';
import 'package:fluttereva/provider/state/evento-participantes.state.dart';
import 'package:fluttereva/provider/state/user.state.dart';
import 'package:http/http.dart' as http;

class EventoParticipanteService {
  final String baseUrl = 'http://192.168.0.128:3000';

  // Future<List<EventoParticipantesState>> getEventoParticipantes() async {
  //   final url = Uri.parse('$baseUrl/eventoparticipantes');
  //   final response = await http.get(
  //     url,
  //     headers: {'Content-Type': 'application/json'},
  //   );
  //   if (response.statusCode == 201 || response.statusCode == 200) {
  //     final List<dynamic> data = jsonDecode(response.body);
  //     return data
  //         .map((json) => EventoParticipantesState.fromJson(json))
  //         .toList();
  //   } else {
  //     throw Exception(
  //       'Error al obtener participantes de eventos: ${response.body}',
  //     );
  //   }
  // }

  Future<EventoParticipantesState> createEventoParticipante(
    EventoParticipantesDto dto,
  ) async {
    final url = Uri.parse('$baseUrl/eventoparticipantes');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(dto.toJson()),
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      return EventoParticipantesState.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(
        'Error al crear registro evento-participante: ${response.body}',
      );
    }
  }

  Future<Usuario> getUsuarioPorDepartamento(int departamentoId) async {
    final url = Uri.parse('$baseUrl/usuarios/departamento/$departamentoId');
    final response = await http.get(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      print('GetUsuarioPorDepartamento: ${response.body}');
      // return Usuario.fromJson(jsonDecode(response.body));
      return Usuario.fromJson(jsonDecode(response.body)[0]);
    } else {
      throw Exception(
        'Error al obtener usuario por departamento: ${response.body}',
      );
    }
  }
}

import 'dart:convert';
import 'package:fluttereva/dto/evento.dto.dart';
import 'package:fluttereva/models/departamento_progreso.dart';
import 'package:fluttereva/models/detalle_evento.dart';
import 'package:fluttereva/models/evento.dart';
import 'package:fluttereva/models/topevent.dart';
import 'package:fluttereva/provider/state/evento.state.dart';
import 'package:http/http.dart' as http;

class EventoService {
  final String baseUrl = 'https://apiseva.coopgualaquiza.fin.ec';

  Future<List<EventoState>> getEventos() async {
    final url = Uri.parse('$baseUrl/eventos');
    final response = await http.get(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    print('getEventos: ${response.body}');

    if (response.statusCode == 201 || response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => EventoState.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener eventos: ${response.body}');
    }
  }

  Future<EventoState?> getActiveEvent() async {
    final url = Uri.parse('$baseUrl/eventos/estado/ACTIVO');
    final response = await http.get(
      url,
      headers: {'Content-Type': 'application/json'},
    );
    print('getActiveEvent: ${response.body}');
    if (response.statusCode == 201 || response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      if (data.isEmpty) {
        return null;
      }
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
    print('createEvento: ${response.body}');
    if (response.statusCode == 201 || response.statusCode == 200) {
      return EventoDto.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error al crear evento: ${response.body}');
    }
  }

  Future<List<DetalleEvento>> getDetalleEvento(int id) async {
    final url = Uri.parse('$baseUrl/eventos/detalles/$id');
    final response = await http.get(
      url,
      headers: {'Content-Type': 'application/json'},
    );
    print('getDetalleEvento $id: ${response.body}');
    if (response.statusCode == 201 || response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => DetalleEvento.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener detalle de evento: ${response.body}');
    }
  }

  Future<List<TopEvent>> getTopEvent() async {
    final url = Uri.parse('$baseUrl/eventos/rates');
    final response = await http.get(
      url,
      headers: {'Content-Type': 'application/json'},
    );
    print('getTopEvent: ${response.body}');
    if (response.statusCode == 201 || response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => TopEvent.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener top de eventos: ${response.body}');
    }
  }

  Future<void> closeEvent(int id) async {
    final url = Uri.parse('$baseUrl/eventos/cerrar/$id');
    final response = await http.patch(
      url,
      headers: {'Content-Type': 'application/json'},
    );
    print('closeEvent $id: ${response.body}');
    if (response.statusCode == 201 || response.statusCode == 200) {
      return;
    } else {
      throw Exception('Error al cerrar evento: ${response.body}');
    }
  }

  Future<void> updateEvento(int id, Map<String, dynamic> cambios) async {
    final url = Uri.parse('$baseUrl/eventos/actualizar/$id');
    final response = await http.patch(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(cambios),
    );
    print('updateEvento: ${response.body}');
    if (response.statusCode == 201 || response.statusCode == 200) {
      return;
    } else {
      throw Exception('Error al actualizar evento: ${response.body}');
    }
  }

  Future<Evento> getEvento(int id) async {
    final url = Uri.parse('$baseUrl/eventos/$id');
    final response = await http.get(
      url,
      headers: {'Content-Type': 'application/json'},
    );
    print('getEvento $id: ${response.body}');
    if (response.statusCode == 201 || response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return Evento.fromJson(data);
    } else {
      throw Exception('Error al obtener evento: ${response.body}');
    }
  }

  Future<bool> isEventReadyToClose(int id) async {
    final url = Uri.parse('$baseUrl/eventos/ready-to-close/$id');
    final response = await http.get(
      url,
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return data['readyToClose'] as bool;
    } else {
      throw Exception('Error al obtener evento: ${response.body}');
    }
  }

  Future<DepartamentoProgresoModel> getDepartamentoProgreso(int id) async {
    final url = Uri.parse('$baseUrl/eventos/departments-progress/$id');
    final response = await http.get(
      url,
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return DepartamentoProgresoModel.fromJson(data);
    } else {
      throw Exception('Error al obtener evento: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> getUnRatedDepartments(
    int eventoId,
    int idDep,
    String usuario,
  ) async {
    final url = Uri.parse(
      '$baseUrl/eventos/unrated-departments/$eventoId/$usuario/$idDep',
    );
    final response = await http.get(
      url,
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception('Error al obtener evento: ${response.body}');
    }
  }
}

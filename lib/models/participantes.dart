import 'package:fluttereva/provider/state/departamento.state.dart';
import 'package:fluttereva/models/evento.dart';

class Participantes {
  final int id;
  final int eventoId;
  final int participanteId;
  final Evento evento;
  final Departamento departamento;

  Participantes({
    required this.id,
    required this.eventoId,
    required this.participanteId,
    required this.evento,
    required this.departamento,
  });

  factory Participantes.fromJson(Map<String, dynamic> json) {
    return Participantes(
      id: json['id'] as int,
      eventoId: json['evento_id'] as int,
      participanteId: json['participante_id'] as int,
      evento: Evento.fromJson(json['evento']),
      departamento: Departamento.fromJson(json['departamento']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'evento_id': eventoId,
      'participante_id': participanteId,
      'evento': evento.toJson(),
      'departamento': departamento.toJson(),
    };
  }
}

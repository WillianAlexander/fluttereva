import 'package:fluttereva/provider/state/departamento.state.dart';
import 'package:fluttereva/provider/state/evento.state.dart';

class EventoParticipantesState {
  final int id;
  final int eventoId;
  final int participanteId;
  final EventoState evento;
  final Departamento departamento;

  EventoParticipantesState({
    required this.id,
    required this.eventoId,
    required this.participanteId,
    required this.evento,
    required this.departamento,
  });

  factory EventoParticipantesState.fromJson(Map<String, dynamic> json) {
    print('json: $json');
    return EventoParticipantesState(
      id: json['id'],
      eventoId: json['evento_id'],
      participanteId: json['participante_id'],
      evento: EventoState.fromJson(json['evento']),
      departamento: Departamento.fromJson(json['departamento']),
    );
  }
}

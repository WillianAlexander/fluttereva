class EventoParticipantesState {
  final int eventoId;
  final int participanteId;

  EventoParticipantesState({
    required this.eventoId,
    required this.participanteId,
  });

  factory EventoParticipantesState.fromJson(Map<String, dynamic> json) {
    return EventoParticipantesState(
      eventoId: json['evento_id'],
      participanteId: json['participante_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'evento_id': eventoId, 'participante_id': participanteId};
  }
}

class EventoParticipantesDto {
  final int eventoId;
  final int participanteId;

  EventoParticipantesDto({
    required this.eventoId,
    required this.participanteId,
  });

  factory EventoParticipantesDto.fromJson(Map<String, dynamic> json) {
    return EventoParticipantesDto(
      eventoId: json['evento_id'],
      participanteId: json['participante_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'evento_id': eventoId, 'participante_id': participanteId};
  }
}

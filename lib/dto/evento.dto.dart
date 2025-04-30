class EventoDto {
  final int? id;
  final String titulo;
  final String fevento;
  final String observacion;
  final String estado;

  EventoDto({
    this.id,
    required this.titulo,
    required this.fevento,
    required this.observacion,
    this.estado = 'ACTIVO',
  });

  factory EventoDto.fromJson(Map<String, dynamic> json) {
    return EventoDto(
      id: json['id'],
      titulo: json['titulo'],
      fevento: json['fevento'],
      observacion: json['observacion'],
      estado: json['estado'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titulo': titulo,
      'fevento': fevento,
      'observacion': observacion,
      'estado': estado,
    };
  }
}

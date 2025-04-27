class EventoState {
  final String titulo;
  final String fevento;
  final String observacion;
  final String estado;

  EventoState({
    required this.titulo,
    required this.fevento,
    required this.observacion,
    this.estado = 'ACTIVO',
  });

  factory EventoState.fromJson(Map<String, dynamic> json) {
    return EventoState(
      titulo: json['titulo'] ?? '',
      fevento: json['fevento'] ?? '',
      observacion: json['observacion'] ?? '',
      estado: json['estado'] ?? 'ACTIVO',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'titulo': titulo,
      'fevento': fevento,
      'observacion': observacion,
      'estado': estado,
    };
  }
}

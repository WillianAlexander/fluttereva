class EventoState {
  final int id;
  final String titulo;
  final String fevento;
  final String observacion;
  final String estado;

  EventoState({
    required this.id,
    required this.titulo,
    required this.fevento,
    required this.observacion,
    required this.estado,
  });

  factory EventoState.fromJson(Map<String, dynamic> json) {
    return EventoState(
      id: json['id'] ?? 0,
      titulo: json['titulo'] ?? '',
      fevento: json['fevento'] ?? '',
      observacion: json['observacion'] ?? '',
      estado: json['estado'] ?? '',
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

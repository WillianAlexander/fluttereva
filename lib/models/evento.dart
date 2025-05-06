class Evento {
  final int id;
  final String titulo;
  final String fevento;
  final String observacion;
  final String estado;
  final String fhasta;
  final String fdesde;
  final int version;

  Evento({
    required this.id,
    required this.titulo,
    required this.fevento,
    required this.observacion,
    required this.estado,
    required this.fhasta,
    required this.fdesde,
    required this.version,
  });

  factory Evento.fromJson(Map<String, dynamic> json) {
    return Evento(
      id: json['id'] as int,
      titulo: json['titulo'] as String,
      fevento: json['fevento'] as String,
      observacion: json['observacion'] as String,
      estado: json['estado'] as String,
      fhasta: json['fhasta'] as String,
      fdesde: json['fdesde'] as String,
      version: json['version'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titulo': titulo,
      'fevento': fevento,
      'observacion': observacion,
      'estado': estado,
      'fhasta': fhasta,
      'fdesde': fdesde,
      'version': version,
    };
  }
}

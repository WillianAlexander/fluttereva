class Criterios {
  final int id;
  final String descripcion;
  final DateTime fhasta;
  final DateTime fdesde;
  final int version;

  Criterios({
    required this.id,
    required this.descripcion,
    required this.fhasta,
    required this.fdesde,
    required this.version,
  });

  factory Criterios.fromJson(Map<String, dynamic> json) {
    return Criterios(
      id: json['id'],
      descripcion: json['descripcion'],
      fhasta: DateTime.parse(json['fhasta']),
      fdesde: DateTime.parse(json['fdesde']),
      version: json['version'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'descripcion': descripcion,
      'fhasta': fhasta.toIso8601String(),
      'fdesde': fdesde.toIso8601String(),
      'version': version,
    };
  }
}

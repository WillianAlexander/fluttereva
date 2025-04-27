class Departamento {
  final int id;
  final String nombre;
  final DateTime fhasta;
  final DateTime fdesde;
  final int version;

  Departamento({
    required this.id,
    required this.nombre,
    required this.fhasta,
    required this.fdesde,
    required this.version,
  });

  factory Departamento.fromJson(Map<String, dynamic> json) {
    return Departamento(
      id: json['id'],
      nombre: json['nombre'],
      fhasta: DateTime.parse(json['fhasta']),
      fdesde: DateTime.parse(json['fdesde']),
      version: json['version'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'fhasta': fhasta.toIso8601String(),
      'fdesde': fdesde.toIso8601String(),
      'version': version,
    };
  }
}

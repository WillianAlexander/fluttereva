class Departamento {
  final String id;
  final String nombre;
  final String fhasta;
  final String fdesde;
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
      id: json['id'] as String,
      nombre: json['nombre'] as String,
      fhasta: json['fhasta'] as String,
      fdesde: json['fdesde'] as String,
      version: json['version'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'fhasta': fhasta,
      'fdesde': fdesde,
      'version': version,
    };
  }
}

// "departamento": {
//             "id": 9,
//             "nombre": "TALENTO HUMANO",
//             "fhasta": "2999-12-31T05:00:00.000Z",
//             "fdesde": "2025-04-25T14:03:46.656Z",
//             "version": 0
//         }

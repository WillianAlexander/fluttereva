class Usuario {
  final String usuario;
  final String nombres;
  final String apellidos;
  final String identificacion;
  final String correo;
  // final String? password;
  final int? rolId;
  final int? departamentoId;
  final String estado;
  final DateTime? fdesde;
  final DateTime? fhasta;
  final int? version;

  Usuario({
    required this.usuario,
    required this.nombres,
    required this.apellidos,
    required this.identificacion,
    required this.correo,
    // this.password,
    this.rolId,
    this.departamentoId,
    required this.estado,
    this.fdesde,
    this.fhasta,
    this.version,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      usuario: json['usuario'] ?? '', // Valor predeterminado si es null.
      nombres: json['nombres'] ?? '',
      apellidos: json['apellidos'] ?? '',
      identificacion: json['identificacion'] ?? '',
      correo: json['correo'] ?? '', // Manejo de null para correo.
      rolId: json['rol_id'] ?? 0,
      departamentoId: json['departamento_id'] ?? 0,
      estado: json['estado_usuario'] ?? '', // Manejo de null para estado.
      fdesde:
          json['fdesde'] != null
              ? DateTime.parse(json['fdesde'])
              : null, // Validación para fechas.
      fhasta:
          json['fhasta'] != null
              ? DateTime.parse(json['fhasta'])
              : null, // Validación para fechas.
      version: json['version'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'usuario': usuario,
      'nombres': nombres,
      'apellidos': apellidos,
      'identificacion': identificacion,
      'correo': correo,
      // 'password': password,
      'rol_id': rolId,
      'departamento_id': departamentoId,
      'estado': estado,
      'fdesde': fdesde?.toIso8601String(),
      'fhasta': fhasta?.toIso8601String(),
      'version': version,
    };
  }
}

import 'package:firebase_auth/firebase_auth.dart';

class UsuarioDto {
  final String usuario;
  final String nombres;
  final String apellidos;
  final String identificacion;
  final String correo;

  UsuarioDto({
    required this.usuario,
    required this.nombres,
    required this.apellidos,
    required this.identificacion,
    required this.correo,
  });

  // Constructor de fábrica para crear el DTO desde un User de Firebase
  factory UsuarioDto.fromFirebaseUser({
    required User user,
    required String nombres,
    required String apellidos,
    required String identificacion,
  }) {
    return UsuarioDto(
      usuario: user.email!.split('@')[0].toUpperCase(),
      nombres: nombres,
      apellidos: apellidos,
      identificacion: identificacion,
      correo: user.email!,
    );
  }

  // Método para convertir la clase a un mapa JSON
  Map<String, dynamic> toJson() {
    return {
      'usuario': usuario,
      'nombres': nombres,
      'apellidos': apellidos,
      'identificacion': identificacion,
      'correo': correo,
    };
  }
}

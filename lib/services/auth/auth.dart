import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

String generateToken({String id = 'user123', String role = 'admin'}) {
  final jwt = JWT({'id': id, 'role': role}, issuer: 'flutter-app');

  // Firma con una clave secreta
  return jwt.sign(SecretKey('cacpeg1*'));
}

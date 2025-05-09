import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

String generateToken({String id = 'user123', String role = 'admin'}) {
  final jwt = JWT({'id': id, 'role': role}, issuer: 'flutter-app');

  // Firma con una clave secreta
  return jwt.sign(
    SecretKey(
      'c29b98187ead69681d9f27997ba6314117e62428b5afcdef340250ff80392078363e34be3bdc6f414e3f2fb5c10458fc0b4f636a101c7a8598497d424baf794a',
    ),
  );
}

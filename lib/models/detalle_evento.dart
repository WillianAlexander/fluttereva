class DetalleEvento {
  final String evaluadoId;
  final int actual;
  final String posicionActual;
  final int anterior;
  final String posicionAnterior;
  final int anterior2;
  final String posicionAnterior2;

  DetalleEvento({
    required this.evaluadoId,
    required this.actual,
    required this.posicionActual,
    required this.anterior,
    required this.posicionAnterior,
    required this.anterior2,
    required this.posicionAnterior2,
  });

  factory DetalleEvento.fromJson(Map<String, dynamic> json) {
    return DetalleEvento(
      evaluadoId: json['evaluado_id'] as String,
      actual: json['actual'] as int,
      posicionActual: json['posicion_actual'] as String,
      anterior: json['anterior'] as int,
      posicionAnterior: json['posicion_anterior'] as String,
      anterior2: json['anterior2'] as int,
      posicionAnterior2: json['posicion_anterior2'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'evaluado_id': evaluadoId,
      'actual': actual,
      'posicion_actual': posicionActual,
      'anterior': anterior,
      'posicion_anterior': posicionAnterior,
      'anterior2': anterior2,
      'posicion_anterior2': posicionAnterior2,
    };
  }
}

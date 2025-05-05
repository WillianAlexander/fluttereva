class TopEvent {
  final String departamento;
  final String total;
  final String promedio;
  final String mes;

  TopEvent({
    required this.departamento,
    required this.total,
    required this.promedio,
    required this.mes,
  });

  factory TopEvent.fromJson(Map<String, dynamic> json) {
    return TopEvent(
      departamento: json['departamento'] as String,
      total: json['total'] as String,
      promedio: json['promedio'] as String,
      mes: json['mes'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'departamento': departamento,
      'total': total,
      'promedio': promedio,
      'mes': mes,
    };
  }
}

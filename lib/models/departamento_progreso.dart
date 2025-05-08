class DepartamentoProgresoModel {
  final String eventId;
  final List<DepartamentoProgresoItem> progress;

  DepartamentoProgresoModel({required this.eventId, required this.progress});

  factory DepartamentoProgresoModel.fromJson(Map<String, dynamic> json) {
    return DepartamentoProgresoModel(
      eventId: json['eventId'],
      progress:
          (json['progress'] as List<dynamic>?)
              ?.map((x) => DepartamentoProgresoItem.fromJson(x))
              .toList() ??
          [],
    );
  }
}

class DepartamentoProgresoItem {
  final String usuario;
  final int id;
  final String departamento;
  final String porcentaje;

  DepartamentoProgresoItem({
    required this.usuario,
    required this.id,
    required this.departamento,
    required this.porcentaje,
  });

  factory DepartamentoProgresoItem.fromJson(Map<String, dynamic> json) {
    return DepartamentoProgresoItem(
      usuario: json['usuario'],
      id: json['id'],
      departamento: json['departamento'],
      porcentaje: json['porcentaje'],
    );
  }
}

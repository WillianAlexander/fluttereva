class EvaluacionDto {
  final DateTime fevaluacion;
  final int evento_id;
  final String evaluador_id;
  final int evaluado_id;
  final int? criterio1;
  final int? criterio2;
  final int? criterio3;
  final int? criterio4;
  final int? criterio5;
  final int? criterio6;
  final int? criterio7;
  final int? criterio8;
  final int? criterio9;
  final int? criterio10;
  final String? comentario;

  EvaluacionDto({
    required this.fevaluacion,
    required this.evento_id,
    required this.evaluador_id,
    required this.evaluado_id,
    this.criterio1,
    this.criterio2,
    this.criterio3,
    this.criterio4,
    this.criterio5,
    this.criterio6,
    this.criterio7,
    this.criterio8,
    this.criterio9,
    this.criterio10,
    this.comentario,
  });
  factory EvaluacionDto.fromJson(Map<String, dynamic> json) {
    if (json['fevaluacion'] == null ||
        json['evento_id'] == null ||
        json['evaluador_id'] == null ||
        json['evaluado_id'] == null) {
      throw Exception('Faltan campos requeridos en el JSON');
    }

    return EvaluacionDto(
      fevaluacion: DateTime.parse(json['fevaluacion']),
      evento_id: json['evento_id'],
      evaluador_id: json['evaluador_id'],
      evaluado_id: json['evaluado_id'],
      criterio1: json['criterio1'],
      criterio2: json['criterio2'],
      criterio3: json['criterio3'],
      criterio4: json['criterio4'],
      criterio5: json['criterio5'],
      criterio6: json['criterio6'],
      criterio7: json['criterio7'],
      criterio8: json['criterio8'],
      criterio9: json['criterio9'],
      criterio10: json['criterio10'],
      comentario: json['comentario'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fevaluacion': fevaluacion.toIso8601String(),
      'evento_id': evento_id,
      'evaluador_id': evaluador_id,
      'evaluado_id': evaluado_id,
      'criterio1': criterio1,
      'criterio2': criterio2,
      'criterio3': criterio3,
      'criterio4': criterio4,
      'criterio5': criterio5,
      'criterio6': criterio6,
      'criterio7': criterio7,
      'criterio8': criterio8,
      'criterio9': criterio9,
      'criterio10': criterio10,
      'comentario': comentario,
    };
  }
}

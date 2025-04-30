import 'package:fluttereva/dto/evaluacion.dto.dart';

class EvaluacionState {
  final List<EvaluacionDto> evaluaciones;
  final bool loading;
  final String? error;

  EvaluacionState({
    required this.evaluaciones,
    this.loading = false,
    this.error,
  });

  EvaluacionState copyWith({
    List<EvaluacionDto>? evaluaciones,
    bool? loading,
    String? error,
  }) {
    return EvaluacionState(
      evaluaciones: evaluaciones ?? this.evaluaciones,
      loading: loading ?? this.loading,
      error: error,
    );
  }
}

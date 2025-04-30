import 'package:flutter/material.dart';
import 'package:fluttereva/dto/evaluacion.dto.dart';
import 'package:fluttereva/services/evaluaciones_sevice.dart';

class CalificacionProvider extends ChangeNotifier {
  final List<EvaluacionDto> _calificados = [];

  List<EvaluacionDto> get calificados => _calificados;

  Future<void> fetchCalificados(
    DateTime fevaluacion,
    int eventoId,
    String evaluadorId,
  ) async {
    // Llama al backend y actualiza _calificados
    final nuevosCalificados = await EvaluacionesSevice().getEvaluaciones(
      fevaluacion,
      eventoId,
      evaluadorId,
    );
    _calificados.clear();
    _calificados.addAll(nuevosCalificados);
    notifyListeners();
  }

  Future<EvaluacionDto?> calificarDepartamento(EvaluacionDto evaluacion) async {
    // Lógica para calificar y luego refrescar el estado
    try {
      final evaluacionCreada = await EvaluacionesSevice().createEvaluacion(
        evaluacion,
      );

      await fetchCalificados(
        evaluacion.fevaluacion,
        evaluacion.evento_id,
        evaluacion.evaluador_id,
      ); // refresca el estado

      return evaluacionCreada;
    } catch (e) {
      throw Exception('Error al crear evaluacion: $e');
    }
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttereva/dto/evaluacion.dto.dart';
import 'package:fluttereva/services/evaluaciones_sevice.dart';
import 'package:fluttereva/utils/date_formater.dart';

class CalificacionProvider extends ChangeNotifier {
  final List<EvaluacionDto> _calificados = [];

  List<EvaluacionDto> get calificados => _calificados;

  Future<void> fetchCalificados(
    String fevaluacion,
    int eventoId,
    String evaluadorId,
  ) async {
    // Llama al backend y actualiza _calificados
    print('Fetching calificados for $fevaluacion, $eventoId, $evaluadorId');
    final nuevosCalificados = await EvaluacionesSevice().getEvaluaciones(
      fevaluacion,
      eventoId,
      evaluadorId,
    );
    _calificados.clear();
    _calificados.addAll(nuevosCalificados);
    print('Calificados: ${jsonEncode(_calificados)}');
    notifyListeners();
  }

  Future<EvaluacionDto?> calificarDepartamento(EvaluacionDto evaluacion) async {
    // Lógica para calificar y luego refrescar el estado
    try {
      final evaluacionCreada = await EvaluacionesSevice().createEvaluacion(
        evaluacion,
      );

      if (evaluacionCreada != null) {
        await fetchCalificados(
          DateFormatter.format(evaluacionCreada.fevaluacion),
          evaluacionCreada.evento_id,
          evaluacionCreada.evaluador_id,
        ); // refresca el estado
      }

      return evaluacionCreada;
    } catch (e) {
      throw Exception('Error al crear evaluacion: $e');
    }
  }
}

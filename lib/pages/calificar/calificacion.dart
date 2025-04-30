import 'package:flutter/material.dart';
import 'package:fluttereva/dto/evaluacion.dto.dart';
import 'package:fluttereva/provider/evaluacion/evaluacion.provider.dart';
import 'package:fluttereva/provider/evento/evento.provider.dart';
import 'package:fluttereva/provider/state/evento-participantes.state.dart';
import 'package:fluttereva/provider/usuario/user.provider.dart';
import 'package:fluttereva/services/evaluaciones_sevice.dart';
import 'package:fluttereva/services/evento_participante_service.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

class Calificacion extends StatefulWidget {
  const Calificacion({super.key});

  @override
  State<Calificacion> createState() => _CalificacionState();
}

class _CalificacionState extends State<Calificacion> {
  // Guarda los IDs de los departamentos calificados
  final Map<String, dynamic> calificados = {};

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final eventoActivo = context.watch<EventoProvider>().evento;
    return Scaffold(
      appBar: AppBar(title: const Text('Calificar'), centerTitle: true),
      body:
          eventoActivo == null
              ? const Center(child: CircularProgressIndicator())
              : FutureBuilder<List<EventoParticipantesState>>(
                future: EventoParticipanteService().getEventoParticipantes(
                  eventoActivo.id,
                ),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No hay participantes'));
                  }
                  final participantes = snapshot.data!;
                  final evaluadorId =
                      Provider.of<UsuarioProvider>(
                        context,
                        listen: false,
                      ).usuario?.usuario;
                  final miDepartamento =
                      Provider.of<UsuarioProvider>(
                        context,
                        listen: false,
                      ).usuario?.departamentoId;
                  final participantesFiltrados =
                      participantes
                          .where((p) => p.departamento.id != miDepartamento)
                          .toList();

                  return ListView.builder(
                    itemCount: participantesFiltrados.length,
                    itemBuilder: (context, index) {
                      final participante = participantesFiltrados[index];
                      final depto = participante.departamento.nombre;
                      final bool estaCalificado = calificados.containsKey(
                        depto,
                      );
                      return Card(
                        child: ListTile(
                          title: Text(depto),
                          trailing: Icon(
                            estaCalificado
                                ? Icons.check_circle
                                : Icons.chevron_right,
                            color: estaCalificado ? Colors.green : null,
                          ),
                          onTap:
                              estaCalificado
                                  ? null
                                  : () async {
                                    final resultado =
                                        await showDialog<Map<String, dynamic>>(
                                          context: context,
                                          builder:
                                              (context) => _DepartamentoDialog(
                                                nombre: depto,
                                              ),
                                        );
                                    if (resultado != null) {
                                      final evaluacion = EvaluacionDto(
                                        fevaluacion: DateTime.now(),
                                        evento_id: eventoActivo.id,
                                        evaluador_id: evaluadorId!,
                                        evaluado_id:
                                            participante.departamento.id,
                                        criterio1: resultado['slider1'],
                                        criterio2: resultado['slider2'],
                                        criterio3: resultado['slider3'],
                                        comentario: resultado['comentario'],
                                      );
                                      try {
                                        // Llama al servicio para crear la evaluación
                                        // final evaluacionCreada =
                                        //     await EvaluacionesSevice()
                                        //         .createEvaluacion(evaluacion);

                                        final evaluacionCreada =
                                            await Provider.of<
                                              CalificacionProvider
                                            >(
                                              context,
                                              listen: false,
                                            ).calificarDepartamento(evaluacion);
                                        print(
                                          'Evaluación creada desde provider: $evaluacionCreada',
                                        );
                                        if (!mounted) return;
                                        if (evaluacionCreada != null) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'Evaluación creada exitosamente',
                                              ),
                                              backgroundColor: Colors.green,
                                            ),
                                          );
                                        }
                                      } catch (e) {
                                        print('Error al crear evaluación: $e');
                                        if (!mounted) return;
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'Error al crear evaluación',
                                            ),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                      }
                                      setState(() {
                                        calificados[depto] = resultado;
                                        print(calificados);
                                      });
                                    }
                                  },
                        ),
                      );
                    },
                  );
                },
              ),
    );
  }
}

class _DepartamentoDialog extends StatefulWidget {
  final String nombre;
  const _DepartamentoDialog({required this.nombre});

  @override
  State<_DepartamentoDialog> createState() => _DepartamentoDialogState();
}

class _DepartamentoDialogState extends State<_DepartamentoDialog> {
  double slider1 = 5;
  double slider2 = 5;
  double slider3 = 5;
  final TextEditingController comentarioController = TextEditingController();

  @override
  void dispose() {
    comentarioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.nombre,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 20),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
            const Text('Criterio 1', textAlign: TextAlign.center),
            Slider(
              value: slider1,
              min: 0,
              max: 10,
              divisions: 10,
              label: slider1.round().toString(),
              onChanged: (value) => setState(() => slider1 = value),
            ),
            const SizedBox(height: 16),
            const Text('Criterio 2', textAlign: TextAlign.center),
            Slider(
              value: slider2,
              min: 0,
              max: 10,
              divisions: 10,
              label: slider2.round().toString(),
              onChanged: (value) => setState(() => slider2 = value),
            ),
            const SizedBox(height: 16),
            const Text('Criterio 3', textAlign: TextAlign.center),
            Slider(
              value: slider3,
              min: 0,
              max: 10,
              divisions: 10,
              label: slider3.round().toString(),
              onChanged: (value) => setState(() => slider3 = value),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: comentarioController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Comentario',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          child: const Text('Cancelar', textAlign: TextAlign.center),
          onPressed: () => Navigator.of(context).pop(null),
        ),
        ElevatedButton(
          child: const Text('Calificar', textAlign: TextAlign.center),
          onPressed: () {
            Navigator.of(context).pop({
              'slider1': slider1.round(),
              'slider2': slider2.round(),
              'slider3': slider3.round(),
              'comentario': comentarioController.text,
            });
          },
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:fluttereva/dto/evaluacion.dto.dart';
import 'package:fluttereva/models/participantes.dart';
import 'package:fluttereva/provider/criterios/criterios.provider.dart';
import 'package:fluttereva/provider/evaluacion/evaluacion.provider.dart';
import 'package:fluttereva/provider/evento/evento.provider.dart';
import 'package:fluttereva/provider/state/criterio.state.dart';
import 'package:fluttereva/provider/usuario/user.provider.dart';
import 'package:fluttereva/services/evento_participante_service.dart';
import 'package:fluttereva/utils/date_formater.dart';
import 'package:provider/provider.dart';

class Calificacion extends StatefulWidget {
  const Calificacion({super.key});

  @override
  State<Calificacion> createState() => _CalificacionState();
}

class _CalificacionState extends State<Calificacion> {
  bool _loadingCalificados = true;

  @override
  void initState() {
    super.initState();
    _fetchCalificadosInicial();
    Provider.of<CriteriosProvider>(context, listen: false).fetchCriterios();
  }

  Future<void> _fetchCalificadosInicial() async {
    final eventoActivo =
        Provider.of<EventoProvider>(context, listen: false).evento;
    final usuario =
        Provider.of<UsuarioProvider>(context, listen: false).usuario;
    if (eventoActivo != null && usuario != null) {
      await Provider.of<CalificacionProvider>(
        context,
        listen: false,
      ).fetchCalificados(
        DateFormatter.format(
          DateTime.parse(eventoActivo.fevento),
        ), // O la fecha que corresponda
        eventoActivo.id,
        usuario.usuario,
      );
    }
    setState(() {
      _loadingCalificados = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final eventoActivo = context.watch<EventoProvider>().evento;
    final calificadosProvider =
        context.watch<CalificacionProvider>().calificados;
    final criteriosProvider = context.watch<CriteriosProvider>().criterios;
    if (_loadingCalificados) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      appBar: AppBar(
        leading: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            Container(
              width: 1.5,
              height: 35,
              color: Colors.grey[300],
              margin: const EdgeInsets.symmetric(vertical: 10),
            ),
          ],
        ),
        title: const Text('Calificar'),
        centerTitle: true,
      ),
      body:
          eventoActivo == null
              ? const Center(child: CircularProgressIndicator())
              : FutureBuilder<List<Participantes>>(
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

                      final bool estaCalificado = calificadosProvider.any(
                        (e) => e.evaluado_id == participante.departamento.id,
                      );
                      return Card(
                        elevation: 4,
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        color: estaCalificado ? Colors.green[50] : null,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
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
                                                criterios: criteriosProvider,
                                              ),
                                        );
                                    if (resultado != null) {
                                      final evaluacion = EvaluacionDto(
                                        fevaluacion: DateTime.parse(
                                          eventoActivo.fevento,
                                        ),
                                        evento_id: eventoActivo.id,
                                        evaluador_id: evaluadorId!,
                                        evaluado_id:
                                            participante.departamento.id,
                                        criterio1: resultado['slider1'],
                                        criterio2: resultado['slider2'],
                                        criterio3: resultado['slider3'],
                                        criterio4: resultado['slider4'],
                                        comentario: resultado['comentario'],
                                      );
                                      try {
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
                                            SnackBar(
                                              content: Text(
                                                'Evaluación creada exitosamente',
                                              ),
                                              backgroundColor:
                                                  Theme.of(context)
                                                      .colorScheme
                                                      .primaryContainer,
                                            ),
                                          );
                                        }
                                      } catch (e) {
                                        print(e);
                                        if (!mounted) return;
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'Error al crear evaluación',
                                            ),
                                            backgroundColor:
                                                Theme.of(
                                                  context,
                                                ).colorScheme.error,
                                          ),
                                        );
                                      }
                                    }
                                  },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 8,
                            ),
                            child: Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color:
                                          Theme.of(
                                            context,
                                          ).colorScheme.primaryContainer,
                                      width: 1,
                                    ),
                                  ),
                                  child: CircleAvatar(
                                    radius: 16,
                                    backgroundColor:
                                        Theme.of(context).colorScheme.surface,
                                    child: Text(
                                      '${index + 1}',
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    depto,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey[900],
                                    ),
                                  ),
                                ),
                                Icon(
                                  estaCalificado
                                      ? Icons.check_circle
                                      : Icons.rate_review_outlined,
                                  color:
                                      estaCalificado
                                          ? Theme.of(
                                            context,
                                          ).colorScheme.primaryContainer
                                          : Theme.of(
                                            context,
                                          ).colorScheme.secondary,
                                  size: 28,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    padding: const EdgeInsets.only(bottom: 50),
                  );
                },
              ),
    );
  }
}

class _DepartamentoDialog extends StatefulWidget {
  final String nombre;
  final List<Criterios> criterios;
  const _DepartamentoDialog({required this.nombre, required this.criterios});

  @override
  State<_DepartamentoDialog> createState() => _DepartamentoDialogState();
}

class _DepartamentoDialogState extends State<_DepartamentoDialog> {
  double slider1 = 0;
  double slider2 = 0;
  double slider3 = 0;
  double slider4 = 0;
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
            Text(widget.criterios[0].descripcion, textAlign: TextAlign.center),
            Slider(
              value: slider1,
              min: 0,
              max: 10,
              divisions: 10,
              label: slider1.round().toString(),
              onChanged: (value) => setState(() => slider1 = value),
            ),
            const SizedBox(height: 16),
            Text(widget.criterios[1].descripcion, textAlign: TextAlign.center),
            Slider(
              value: slider2,
              min: 0,
              max: 10,
              divisions: 10,
              label: slider2.round().toString(),
              onChanged: (value) => setState(() => slider2 = value),
            ),
            const SizedBox(height: 16),
            Text(widget.criterios[2].descripcion, textAlign: TextAlign.center),
            Slider(
              value: slider3,
              min: 0,
              max: 10,
              divisions: 10,
              label: slider3.round().toString(),
              onChanged: (value) => setState(() => slider3 = value),
            ),
            const SizedBox(height: 16),
            Text(widget.criterios[3].descripcion, textAlign: TextAlign.center),
            Slider(
              value: slider4,
              min: 0,
              max: 10,
              divisions: 10,
              label: slider4.round().toString(),
              onChanged: (value) => setState(() => slider4 = value),
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
              'slider4': slider4.round(),
              'comentario': comentarioController.text,
            });
          },
        ),
      ],
    );
  }
}

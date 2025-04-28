import 'package:flutter/material.dart';
import 'package:fluttereva/provider/state/evento-participantes.state.dart';
import 'package:fluttereva/provider/state/evento.state.dart';
import 'package:fluttereva/services/evento_participante_service.dart';
import 'package:fluttereva/services/evento_service.dart';

class Calificacion extends StatefulWidget {
  // final EventoState evento;
  Calificacion({Key? key}) : super(key: key);

  @override
  State<Calificacion> createState() => _CalificacionState();
}

class _CalificacionState extends State<Calificacion> {
  // Guarda los IDs de los departamentos calificados
  final Set<String> calificados = {};
  late Future<List<EventoParticipantesState>> _participantesFuturo;
  late Future<EventoState> _eventosFuturo;

  @override
  void initState() {
    super.initState();
    _eventosFuturo =
        EventoService()
            .getActiveEvent(); // O getEventosActivos() si lo implementas
    print('Evento id: ${_eventosFuturo}');
    _participantesFuturo = _eventosFuturo.then(
      (evento) => EventoParticipanteService().getEventoParticipantes(evento.id),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calificar'), centerTitle: true),
      body: FutureBuilder<List<EventoParticipantesState>>(
        future: _participantesFuturo,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay participantes'));
          }
          final participantes = snapshot.data!;
          print('Participantes: ${participantes}');

          return ListView.builder(
            itemCount: participantes.length,
            itemBuilder: (context, index) {
              final participante = participantes[index];
              final depto = participante.departamento.nombre;
              final bool estaCalificado = calificados.contains(depto);
              return Card(
                child: ListTile(
                  title: Text(depto),
                  trailing: Icon(
                    estaCalificado ? Icons.check_circle : Icons.chevron_right,
                    color: estaCalificado ? Colors.green : null,
                  ),
                  onTap:
                      estaCalificado
                          ? null
                          : () async {
                            final resultado = await showDialog<bool>(
                              context: context,
                              builder:
                                  (context) =>
                                      _DepartamentoDialog(nombre: depto),
                            );
                            if (resultado == true) {
                              setState(() {
                                calificados.add(depto);
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
          onPressed: () => Navigator.of(context).pop(false),
        ),
        ElevatedButton(
          child: const Text('Calificar', textAlign: TextAlign.center),
          onPressed: () {
            // Puedes acceder al comentario con comentarioController.text
            Navigator.of(context).pop(true);
          },
        ),
      ],
    );
  }
}

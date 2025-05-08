import 'package:flutter/material.dart';
import 'package:fluttereva/pages/evento/departamento_progreso.dart';
import 'package:fluttereva/pages/evento/detalle_evento.dart';
import 'package:fluttereva/pages/evento/editar_evento.dart';
import 'package:fluttereva/provider/state/evento.state.dart';
import 'package:fluttereva/provider/usuario/user.provider.dart';
import 'package:fluttereva/services/evento_service.dart';
import 'package:provider/provider.dart';

class ConsultarEvento extends StatefulWidget {
  const ConsultarEvento({super.key});

  @override
  State<ConsultarEvento> createState() => _ConsultarEventoState();
}

class _ConsultarEventoState extends State<ConsultarEvento> {
  late Future<List<EventoState>> _eventosFuturo;

  @override
  void initState() {
    super.initState();
    _eventosFuturo =
        EventoService().getEventos(); // O getEventosActivos() si lo implementas
  }

  // Dentro de _ConsultarEventoState

  @override
  Widget build(BuildContext context) {
    final usuarioProvider = Provider.of<UsuarioProvider>(context).usuario;
    return Scaffold(
      appBar: AppBar(
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).maybePop(),
            ),
            Container(
              width: 1.5,
              height: 35,
              color: Colors.grey[300],
              margin: const EdgeInsets.symmetric(vertical: 10),
            ),
          ],
        ),
        title: const Text('Consultar evento'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<EventoState>>(
        future: _eventosFuturo,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay eventos registrados.'));
          }
          final eventos = snapshot.data!;
          return ListView.builder(
            itemCount: eventos.length,
            itemBuilder: (context, index) {
              final evento = eventos[index];
              return Card(
                color:
                    evento.estado == 'ACTIVO'
                        ? Colors.green[50]
                        : Colors.grey[200],
                child: ListTile(
                  title: Padding(
                    padding: const EdgeInsets.only(bottom: 2.0),
                    child: Text(
                      evento.titulo,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Fecha: ${evento.fevento}'),
                      const SizedBox(height: 4),
                      Container(
                        width: 80,
                        padding: const EdgeInsets.all(2.0),
                        decoration: BoxDecoration(
                          color:
                              evento.estado == 'ACTIVO'
                                  ? Theme.of(
                                    context,
                                  ).colorScheme.primaryContainer
                                  : Theme.of(context).colorScheme.error,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Text(
                          textAlign: TextAlign.center,
                          evento.estado == 'ACTIVO' ? 'Activo' : 'Cerrado',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  leading: Icon(
                    Icons.event,
                    color:
                        evento.estado == 'ACTIVO'
                            ? Theme.of(context).colorScheme.primaryContainer
                            : Theme.of(context).colorScheme.error,
                  ),
                  trailing:
                      (usuarioProvider?.rolId == 1 && evento.estado == 'ACTIVO')
                          ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.info_outline,
                                  color:
                                      Theme.of(
                                        context,
                                      ).colorScheme.primaryFixed,
                                ),
                                tooltip: 'Revisar',
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => DepartamentoProgreso(
                                            evento: evento,
                                          ),
                                    ),
                                  );
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.cancel, color: Colors.red),
                                tooltip: 'Finalizar',
                                onPressed: () async {
                                  final isReady = await EventoService()
                                      .isEventReadyToClose(evento.id);
                                  if (!isReady) {
                                    await showDialog(
                                      context: context,
                                      builder:
                                          (context) => AlertDialog(
                                            title: Text(
                                              'No se puede finalizar',
                                            ),
                                            content: Text(
                                              'Aún faltan departamentos por calificar.',
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed:
                                                    () =>
                                                        Navigator.pop(context),
                                                child: Text('Aceptar'),
                                              ),
                                            ],
                                          ),
                                    );
                                    return;
                                  }
                                  final confirm = await showDialog<bool>(
                                    context: context,
                                    builder:
                                        (context) => AlertDialog(
                                          title: Text('Finalizar evento'),
                                          content: Text(
                                            '¿Estás seguro de que quieres finalizar este evento?',
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed:
                                                  () => Navigator.pop(
                                                    context,
                                                    false,
                                                  ),
                                              child: Text('Cancelar'),
                                            ),
                                            TextButton(
                                              onPressed:
                                                  () => Navigator.pop(
                                                    context,
                                                    true,
                                                  ),
                                              child: Text(
                                                'Finalizar',
                                                style: TextStyle(
                                                  color: Colors.red,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                  );
                                  if (confirm == true) {
                                    await EventoService().closeEvent(evento.id);
                                    setState(() {
                                      _eventosFuturo =
                                          EventoService().getEventos();
                                    });
                                  }
                                },
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.edit,
                                  color:
                                      Theme.of(
                                        context,
                                      ).colorScheme.primaryFixed,
                                ),
                                tooltip: 'Editar',
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) =>
                                              EditarEvento(eventoId: evento.id),
                                    ),
                                  ).then((value) {
                                    setState(() {
                                      _eventosFuturo =
                                          EventoService().getEventos();
                                    });
                                  });
                                },
                              ),
                            ],
                          )
                          : (evento.estado == 'CERRADO')
                          ? IconButton(
                            icon: Icon(
                              Icons.bar_chart,
                              color: Theme.of(context).colorScheme.primaryFixed,
                            ),
                            tooltip: 'Ver resultados',
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) =>
                                          DetalleEvento(evento: evento),
                                ),
                              );
                            },
                          )
                          : null,
                ),
              );
            },
          );
        },
      ),
    );
  }
}

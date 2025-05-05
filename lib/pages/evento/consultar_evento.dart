import 'package:flutter/material.dart';
import 'package:fluttereva/pages/evento/detalle_evento.dart';
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
      appBar: AppBar(title: const Text('Consultar evento'), centerTitle: true),
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
                  title: Text(evento.titulo),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Fecha: ${evento.fevento}'),
                      const SizedBox(height: 4),
                      Text(
                        evento.estado == 'ACTIVO' ? 'Activo' : 'Cerrado',
                        style: TextStyle(
                          color:
                              evento.estado == 'ACTIVO'
                                  ? Colors.green
                                  : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  leading: Icon(
                    Icons.event,
                    color:
                        evento.estado == 'ACTIVO' ? Colors.green : Colors.red,
                  ),
                  trailing: PopupMenuButton<int>(
                    icon: Icon(Icons.more_vert),
                    onSelected: (int value) async {
                      if (value == 1) {
                        // Confirmar antes de cerrar
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
                                        () => Navigator.pop(context, false),
                                    child: Text('Cancelar'),
                                  ),
                                  TextButton(
                                    onPressed:
                                        () => Navigator.pop(context, true),
                                    child: Text(
                                      'Finalizar',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ],
                              ),
                        );
                        if (confirm == true) {
                          await EventoService().closeEvent(evento.id);
                          setState(() {
                            _eventosFuturo = EventoService().getEventos();
                          });
                        }
                      } else if (value == 2) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetalleEvento(evento: evento),
                          ),
                        );
                      }
                    },
                    itemBuilder:
                        (BuildContext context) => [
                          if (usuarioProvider?.rolId == 1 &&
                              evento.estado == 'ACTIVO')
                            PopupMenuItem(
                              value: 1,
                              child: ListTile(
                                leading: Icon(Icons.cancel, color: Colors.red),
                                title: Text(
                                  'Finalizar',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          if (evento.estado == 'CERRADO')
                            PopupMenuItem(
                              value: 2,
                              child: ListTile(
                                leading: Icon(
                                  Icons.info_outline,
                                  color: Colors.blue,
                                ),
                                title: Text(
                                  'Detalles',
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                        ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

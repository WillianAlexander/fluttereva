import 'package:flutter/material.dart';
import 'package:fluttereva/provider/state/evento.state.dart';
import 'package:fluttereva/services/evento_service.dart';

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

  @override
  Widget build(BuildContext context) {
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
                  // Puedes agregar onTap aquí si quieres ver detalles
                ),
              );
            },
          );
        },
      ),
    );
  }
}

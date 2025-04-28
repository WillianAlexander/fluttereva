import 'package:flutter/material.dart';
import 'package:fluttereva/services/evento_service.dart';
import 'package:fluttereva/provider/state/evento.state.dart';
import 'package:fluttereva/pages/calificar/calificacion.dart'; // Ajusta el import según tu estructura

class ListaEventos extends StatefulWidget {
  @override
  _ListaEventosState createState() => _ListaEventosState();
}

class _ListaEventosState extends State<ListaEventos> {
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
      appBar: AppBar(title: Text('Eventos Activos')),
      body: FutureBuilder<List<EventoState>>(
        future: _eventosFuturo,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final eventos = snapshot.data ?? [];
          if (eventos.isEmpty) {
            return Center(child: Text('No hay eventos activos.'));
          }
          return ListView.builder(
            itemCount: eventos.length,
            itemBuilder: (context, index) {
              final evento = eventos[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  title: Text(evento.titulo),
                  subtitle: Text('Fecha: ${evento.fevento}'),
                  trailing: Icon(Icons.arrow_forward),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => Calificacion()),
                    );
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

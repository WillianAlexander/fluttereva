import 'package:flutter/material.dart';

class ConsultarEvento extends StatefulWidget {
  const ConsultarEvento({super.key});

  @override
  State<ConsultarEvento> createState() => _ConsultarEventoState();
}

class _ConsultarEventoState extends State<ConsultarEvento> {
  late Future<List<Map<String, dynamic>>> eventosFuture;

  @override
  void initState() {
    super.initState();
    eventosFuture = obtenerEventos();
  }

  Future<List<Map<String, dynamic>>> obtenerEventos() async {
    // Simula una llamada a un servicio o base de datos
    await Future.delayed(const Duration(seconds: 1));
    return [
      {'id': 1, 'nombre': 'Evento de Tecnología', 'fecha': '2025-04-30'},
      {'id': 2, 'nombre': 'Jornada de Seguridad', 'fecha': '2025-05-02'},
      {'id': 3, 'nombre': 'Capacitación Financiera', 'fecha': '2025-05-10'},
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Consultar evento'), centerTitle: true),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: eventosFuture,
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
                child: ListTile(
                  title: Text(evento['nombre']),
                  subtitle: Text('Fecha: ${evento['fecha']}'),
                  leading: const Icon(Icons.event),
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

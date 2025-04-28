import 'package:flutter/material.dart';

class Calificacion extends StatefulWidget {
  Calificacion({Key? key}) : super(key: key);

  final List<Map<String, String>> departamentos = [
    {'id': '1', 'nombre': 'TECNOLOGIA'},
    {'id': '2', 'nombre': 'INVERSIONES - CAPTACIONES'},
    {'id': '3', 'nombre': 'OPERACIONES'},
    {'id': '4', 'nombre': 'SEGURIDAD FISICA Y ELECTRONICA'},
    {'id': '5', 'nombre': 'PROCESOS'},
    {'id': '6', 'nombre': 'FINANCIERO'},
    {'id': '7', 'nombre': 'CREDITO Y COBRANZAS'},
    {'id': '8', 'nombre': 'TALENTO HUMANO'},
    {'id': '9', 'nombre': 'TESORERIA'},
    {'id': '10', 'nombre': 'RIESGOS'},
    {'id': '11', 'nombre': 'CUMPLIMIENTO'},
    {'id': '12', 'nombre': 'COMUNICACION'},
    {'id': '13', 'nombre': 'JURIDICO'},
    {'id': '14', 'nombre': 'SEGUROS'},
  ];

  @override
  State<Calificacion> createState() => _CalificacionState();
}

class _CalificacionState extends State<Calificacion> {
  // Guarda los IDs de los departamentos calificados
  final Set<String> calificados = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calificar'), centerTitle: true),
      body: ListView.builder(
        itemCount: widget.departamentos.length,
        itemBuilder: (context, index) {
          final depto = widget.departamentos[index];
          final bool estaCalificado = calificados.contains(depto['id']);
          return Card(
            child: ListTile(
              title: Text(depto['nombre']!),
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
                                  _DepartamentoDialog(nombre: depto['nombre']!),
                        );
                        if (resultado == true) {
                          setState(() {
                            calificados.add(depto['id']!);
                          });
                        }
                      },
            ),
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

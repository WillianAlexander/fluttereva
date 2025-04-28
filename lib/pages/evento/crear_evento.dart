import 'package:flutter/material.dart';
import 'package:fluttereva/models/evento-participantes.dto.dart';
import 'package:fluttereva/models/evento.dto.dart';
import 'package:fluttereva/provider/state/departamento.state.dart';
import 'package:fluttereva/services/departament_service.dart';
import 'package:fluttereva/services/evento_participante_service.dart';
import 'package:fluttereva/services/evento_service.dart';
import 'package:fluttereva/utils/date_formater.dart';

class CrearEvento extends StatefulWidget {
  const CrearEvento({super.key});

  @override
  State<CrearEvento> createState() => _CrearEventoState();
}

class _CrearEventoState extends State<CrearEvento> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _selectedDate;
  List<Departamento> _departamentos = [];
  List<bool> isCheckedList = [];
  final TextEditingController _observacionController = TextEditingController();
  final TextEditingController _tituloController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      locale: const Locale('es'),
      cancelText: 'Cancelar',
      confirmText: 'Aceptar',
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    loadDepartamentos();
  }

  void loadDepartamentos() async {
    List<Departamento> departamentos =
        await DepartamentService().getDepartamentos();
    setState(() {
      _departamentos = departamentos;
      isCheckedList = List.generate(_departamentos.length, (_) => false);
    });
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    _tituloController.clear();
    _observacionController.clear();
    setState(() {
      _selectedDate = null;
      isCheckedList = List<bool>.filled(_departamentos.length, false);
      // Si tienes otros estados, reinícialos aquí también
    });
  }

  @override
  void dispose() {
    _observacionController.dispose();
    _tituloController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crear evento'), centerTitle: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Titulo:', style: Theme.of(context).textTheme.bodyLarge),
                const SizedBox(height: 8),
                TextField(
                  maxLength: 100,
                  maxLines: 1,
                  cursorHeight: 18,
                  controller: _tituloController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Ingrese el titulo',
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Fecha de evento:',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _selectedDate != null
                          ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                          : 'No seleccionada',
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: () => _selectDate(context),
                      child: const Icon(Icons.calendar_month),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'Departamentos:',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 8),
                Column(
                  children: List.generate(_departamentos.length, (index) {
                    return ListTile(
                      contentPadding: const EdgeInsets.only(right: 8.0),
                      trailing: Checkbox(
                        value: isCheckedList[index],
                        onChanged: (value) {
                          setState(() {
                            isCheckedList[index] = value!;
                          });
                        },
                      ),
                      title: Text(
                        _departamentos[index].nombre,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 16),
                Text(
                  'Observación:',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 16),
                TextField(
                  maxLength: 500,
                  maxLines: 5,
                  cursorHeight: 18,
                  controller: _observacionController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Ingrese observación',
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      if (_formKey.currentState!.validate() &&
                          _selectedDate != null &&
                          isCheckedList.contains(true)) {
                        final dto = EventoDto(
                          titulo: _tituloController.text,
                          fevento: DateFormatter.format(_selectedDate),
                          observacion: _observacionController.text,
                        );
                        final eventResponse = await EventoService()
                            .createEvento(dto);
                        // Procesar el formulario
                        final selectedDepartments =
                            isCheckedList.map((e) => e ? 1 : 0).toList();
                        for (int i = 0; i < selectedDepartments.length; i++) {
                          if (selectedDepartments[i] == 1) {
                            EventoParticipanteService()
                                .createEventoParticipante(
                                  EventoParticipantesDto(
                                    eventoId: eventResponse.id!,
                                    participanteId: _departamentos[i].id,
                                  ),
                                );
                          }
                        }

                        _resetForm();

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Evento creado exitosamente'),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Por favor, complete todos los campos',
                            ),
                          ),
                        );
                      }
                    },
                    label: const Text('Crear evento'),
                    icon: const Icon(Icons.add_box),
                  ),
                ),
                const SizedBox(height: 35),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

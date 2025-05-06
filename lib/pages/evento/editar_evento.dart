import 'package:flutter/material.dart';
import 'package:fluttereva/dto/evento-participantes.dto.dart';
import 'package:fluttereva/provider/departamento/departamento.provider.dart';
import 'package:fluttereva/provider/evento/evento.provider.dart';
import 'package:fluttereva/provider/state/departamento.state.dart';
import 'package:fluttereva/provider/state/evento.state.dart';
import 'package:fluttereva/services/evento_participante_service.dart';
import 'package:fluttereva/services/evento_service.dart';
import 'package:fluttereva/utils/date_formater.dart';
import 'package:provider/provider.dart';

class EditarEvento extends StatefulWidget {
  final int eventoId;
  const EditarEvento({super.key, required this.eventoId});

  @override
  State<EditarEvento> createState() => _EditarEventoState();
}

class _EditarEventoState extends State<EditarEvento> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _selectedDate;
  List<Departamento> departamentos = [];
  List<bool> isCheckedList = [];
  late TextEditingController _observacionController;
  late TextEditingController _tituloController;
  bool _initialized = false;

  Future<Map<String, dynamic>> _loadData(BuildContext context) async {
    await context.read<EventoProvider>().fetchEventById(widget.eventoId);
    final evento = context.read<EventoProvider>().evento!;
    final departamentosList =
        Provider.of<DepartamentoProvider>(context, listen: false).departamentos;
    final participantes = await EventoParticipanteService()
        .getEventoParticipantes(evento.id);

    if (!_initialized) {
      _selectedDate = DateFormatter.parse(evento.fevento);
      _tituloController = TextEditingController(text: evento.titulo);
      _observacionController = TextEditingController(text: evento.observacion);
      isCheckedList =
          departamentosList
              .map<bool>(
                (d) => participantes.any((p) => p.departamento.id == d.id),
              )
              .toList();
      _initialized = true;
    }

    return {
      'evento': evento,
      'departamentos': departamentosList,
      'participantes': participantes,
    };
  }

  @override
  void dispose() {
    _observacionController.dispose();
    _tituloController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editar evento'), centerTitle: true),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _loadData(context),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          final evento = snapshot.data!['evento'] as EventoState;
          final departamentos =
              snapshot.data!['departamentos'] as List<Departamento>;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Titulo:',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      maxLength: 100,
                      maxLines: 1,
                      cursorHeight: 18,
                      controller: _tituloController,
                      decoration: const InputDecoration(
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
                      children: List.generate(departamentos.length, (index) {
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
                            departamentos[index].nombre,
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
                      decoration: const InputDecoration(
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
                            final cambios = <String, dynamic>{};
                            if (_tituloController.text != evento.titulo) {
                              cambios['titulo'] = _tituloController.text;
                            }
                            if (DateFormatter.format(_selectedDate) !=
                                evento.fevento) {
                              cambios['fevento'] = DateFormatter.format(
                                _selectedDate,
                              );
                            }
                            if (_observacionController.text !=
                                evento.observacion) {
                              cambios['observacion'] =
                                  _observacionController.text;
                            }

                            final participantesOriginales =
                                await EventoParticipanteService()
                                    .getEventoParticipantes(evento.id);
                            final originalDeptos =
                                participantesOriginales
                                    .map((p) => p.departamento.id)
                                    .toList();
                            final nuevosDeptos = <int>[];
                            for (int i = 0; i < departamentos.length; i++) {
                              if (isCheckedList[i]) {
                                nuevosDeptos.add(departamentos[i].id);
                              }
                            }
                            final departamentosAgregados =
                                nuevosDeptos
                                    .where((id) => !originalDeptos.contains(id))
                                    .toList();
                            final departamentosEliminados =
                                originalDeptos
                                    .where((id) => !nuevosDeptos.contains(id))
                                    .toList();

                            // Verifica si hay cambios en datos o departamentos
                            final hayCambios =
                                cambios.isNotEmpty ||
                                departamentosAgregados.isNotEmpty ||
                                departamentosEliminados.isNotEmpty;

                            if (!hayCambios) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'No se detectaron cambios para actualizar.',
                                  ),
                                ),
                              );
                              return;
                            }

                            if (cambios.isNotEmpty) {
                              await EventoService().updateEvento(
                                evento.id,
                                cambios,
                              );
                            }

                            for (final id in departamentosAgregados) {
                              EventoParticipanteService()
                                  .createEventoParticipante(
                                    EventoParticipantesDto(
                                      eventoId: evento.id,
                                      participanteId: id,
                                    ),
                                  );
                            }
                            for (final id in departamentosEliminados) {
                              EventoParticipanteService()
                                  .deleteEventoParticipante(evento.id, id);
                            }

                            if (context.mounted) {
                              await context
                                  .read<EventoProvider>()
                                  .fetchEventById(evento.id);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Evento actualizado exitosamente',
                                  ),
                                ),
                              );
                              Navigator.pop(
                                context,
                                true,
                              ); // Devuelve true para refrescar la lista
                            }
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
                        label: const Text('Actualizar evento'),
                        icon: const Icon(Icons.save),
                      ),
                    ),
                    const SizedBox(height: 35),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

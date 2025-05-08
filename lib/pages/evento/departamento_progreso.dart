import 'package:flutter/material.dart';
import 'package:fluttereva/models/departamento_progreso.dart';
import 'package:fluttereva/provider/state/evento.state.dart';
import 'package:fluttereva/services/evento_service.dart';

class DepartamentoProgreso extends StatefulWidget {
  final EventoState evento;
  const DepartamentoProgreso({super.key, required this.evento});

  @override
  State<DepartamentoProgreso> createState() => _DepartamentoProgresoState();
}

class _DepartamentoProgresoState extends State<DepartamentoProgreso>
    with TickerProviderStateMixin {
  int? expandedIndex;
  late final Future<DepartamentoProgresoModel> _progresoFuture;

  // Mapa para cachear resultados por id de item
  final Map<int, Future<List<String>>> _unratedDepartmentsFutures = {};

  @override
  void initState() {
    super.initState();
    _progresoFuture = EventoService().getDepartamentoProgreso(widget.evento.id);
  }

  Future<List<String>> _fetchUnratedDepartments(
    int eventoId,
    int idDep,
    String usuario,
  ) async {
    final result = await EventoService().getUnRatedDepartments(
      eventoId,
      idDep,
      usuario,
    );
    final List<dynamic> data = result['data'] ?? [];
    return data.map<String>((e) => e['departamento'] as String).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Progreso',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<DepartamentoProgresoModel>(
        future: _progresoFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final progreso = snapshot.data;
          if (progreso == null || progreso.progress.isEmpty) {
            return const Center(child: Text('No hay progreso registrado.'));
          }
          return ListView.separated(
            itemCount: progreso.progress.length,
            separatorBuilder: (_, __) => Divider(height: 1),
            itemBuilder: (context, index) {
              final item = progreso.progress[index];
              final isExpanded = expandedIndex == index;
              return Column(
                children: [
                  ListTile(
                    onTap: () {
                      setState(() {
                        expandedIndex = isExpanded ? null : index;
                        // Solo carga si no existe el future
                        if (!_unratedDepartmentsFutures.containsKey(item.id)) {
                          _unratedDepartmentsFutures[item
                              .id] = _fetchUnratedDepartments(
                            widget.evento.id,
                            item.id,
                            item.usuario,
                          );
                        }
                      });
                    },
                    title: Text(
                      item.departamento,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[900],
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        LinearProgressIndicator(
                          borderRadius: BorderRadius.circular(10),
                          value: double.parse(item.porcentaje) / 100,
                          minHeight: 8,
                          backgroundColor: const Color(0xFFE5E0E0),
                          color: Colors.amber,
                        ),
                        SizedBox(height: 4),
                        Text(
                          '${item.porcentaje}%',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[900],
                          ),
                        ),
                      ],
                    ),
                  ),
                  AnimatedSize(
                    duration: Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                    child:
                        isExpanded
                            ? Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16.0,
                                vertical: 8.0,
                              ),
                              child: FutureBuilder<List<String>>(
                                future: _unratedDepartmentsFutures[item.id],
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                  if (snapshot.hasError) {
                                    return Text(
                                      'Error al cargar departamentos.',
                                    );
                                  }
                                  final departamentos = snapshot.data ?? [];
                                  if (departamentos.isEmpty) {
                                    return Text(
                                      'Todos los departamentos han sido calificados.',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey[900],
                                      ),
                                    );
                                  }
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Departamentos por calificar:',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.grey[900],
                                        ),
                                      ),
                                      ...departamentos.map(
                                        (dep) => ListTile(
                                          dense: true,
                                          leading: Icon(
                                            Icons.business,
                                            size: 18,
                                          ),
                                          title: Text(
                                            dep,
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.grey[900],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            )
                            : SizedBox.shrink(),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

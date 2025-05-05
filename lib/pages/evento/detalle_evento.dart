import 'package:flutter/material.dart';
import 'package:fluttereva/provider/state/evento.state.dart';
import 'package:fluttereva/services/evento_service.dart';
import 'package:fluttereva/theme/apptheme.dart';
import 'package:fluttereva/utils/date_formater.dart';

class DetalleEvento extends StatelessWidget {
  final EventoState evento;
  const DetalleEvento({super.key, required this.evento});

  bool _isPosicionActualEnTop5(String posicion) {
    final pos = int.tryParse(posicion);
    return pos != null && pos >= 1 && pos <= 5;
  }

  bool _isPosicionActualEnTop12(String posicion) {
    final pos = int.tryParse(posicion);
    return pos != null && pos >= 6 && pos <= 12;
  }

  bool _isPosicionActualEnTop16(String posicion) {
    final pos = int.tryParse(posicion);
    return pos != null && pos >= 13 && pos <= 16;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(evento.titulo), centerTitle: true),
      body: FutureBuilder(
        future: EventoService().getDetalleEvento(evento.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          // Suponiendo que snapshot.data contiene los datos necesarios
          final detalleEvento = snapshot.data;
          // Puedes usar detalleEvento para poblar la tabla dinámicamente
          final anterior = DateFormatter.subtractOneMonth(evento.fevento);
          final nombreMesAnterior = DateFormatter.monthName(
            anterior.toString(),
          );
          return Table(
            border: TableBorder.all(
              color: const Color.fromARGB(255, 227, 223, 223),
            ),
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            columnWidths: const {
              0: IntrinsicColumnWidth(),
              1: IntrinsicColumnWidth(),
              2: FixedColumnWidth(200),
            },
            children: [
              // ENCABEZADO
              TableRow(
                decoration: BoxDecoration(
                  color: AppTheme.light.colorScheme.primaryFixed,
                ),
                children: [
                  TableCell(
                    child: Text(
                      'RANKIN ANTERIOR ${nombreMesAnterior.toUpperCase()}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  TableCell(
                    child: Text(
                      'RANKIN NUEVO ${DateFormatter.monthName(evento.fevento).toUpperCase()}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  TableCell(
                    child: Text(
                      'DEPARTAMENTO',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              // DATOS
              ...detalleEvento!.map<TableRow>((item) {
                return TableRow(
                  children: [
                    TableCell(
                      child: Text(
                        item.posicionAnterior == '0'
                            ? ''
                            : item.posicionAnterior,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.fill,
                      child: Container(
                        alignment: Alignment.center,
                        color:
                            _isPosicionActualEnTop5(item.posicionActual)
                                ? Theme.of(context).colorScheme.primary
                                : _isPosicionActualEnTop12(item.posicionActual)
                                ? Colors.orange
                                : _isPosicionActualEnTop16(item.posicionActual)
                                ? Colors.red
                                : null,
                        child: Text(
                          item.posicionActual == '0' ? '' : item.posicionActual,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    TableCell(
                      child: Text(
                        item.evaluadoId,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                );
              }),
            ],
          );
        },
      ),
    );
  }
}

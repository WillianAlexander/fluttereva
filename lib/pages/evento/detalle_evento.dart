import 'package:flutter/material.dart';
import 'package:fluttereva/provider/state/evento.state.dart';
import 'package:fluttereva/services/evento_service.dart';
import 'package:fluttereva/theme/apptheme.dart';
import 'package:fluttereva/utils/date_formater.dart';
import 'package:fluttereva/utils/table_to_pdf.dart';

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
    final theme = Theme.of(context).colorScheme;
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
        title: Text(evento.titulo),
        backgroundColor: theme.primaryFixed,
        centerTitle: true,
        actions: [
          Container(
            width: 1.5,
            height: 35,
            color: Colors.grey[300],
            margin: const EdgeInsets.symmetric(vertical: 10),
          ),
          IconButton(
            icon: Icon(Icons.picture_as_pdf),
            onPressed: () async {
              final detalleEvento = await EventoService().getDetalleEvento(
                evento.id,
              );
              if (context.mounted) {
                await exportarTablaComoPDF(context, detalleEvento, evento);
              }
            },
          ),
          SizedBox(width: 16),
        ],
      ),
      backgroundColor: theme.surface,
      body: FutureBuilder(
        future: EventoService().getDetalleEvento(evento.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final detalleEvento = snapshot.data;
          final anterior = DateFormatter.subtractMonth(evento.fevento, 2);
          final nombreMesAnterior = DateFormatter.monthName(
            anterior.toString(),
          );
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Table(
                // border: TableBorder.all(color: const Color(0xFFE3DFDF)),
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                columnWidths: const {
                  0: FlexColumnWidth(1), // Posición anterior
                  1: FlexColumnWidth(1), // Posición actual
                  2: FlexColumnWidth(2.5), // Departamento (más espacio)
                },
                children: [
                  // ENCABEZADO
                  TableRow(
                    decoration: BoxDecoration(color: theme.surface),
                    children: [
                      TableCell(
                        child: Container(
                          margin: const EdgeInsets.all(10),
                          color: theme.surface,
                          alignment: Alignment.center,
                          child: Container(
                            padding: const EdgeInsets.only(
                              left: 10,
                              right: 10,
                              top: 2,
                              bottom: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Text(
                              nombreMesAnterior.toUpperCase().substring(0, 3),
                              style: TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 13,
                                color: Colors.grey[700],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                      TableCell(
                        child: Container(
                          margin: const EdgeInsets.all(5),
                          alignment: Alignment.center,
                          color: theme.surface,
                          child: Container(
                            padding: const EdgeInsets.only(
                              left: 10,
                              right: 10,
                              top: 2,
                              bottom: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Text(
                              DateFormatter.monthName(
                                DateFormatter.subtractMonth(
                                  evento.fevento,
                                  1,
                                ).toString(),
                              ).toUpperCase().substring(0, 3),
                              style: TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 13,
                                color: Colors.grey[700],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                      TableCell(
                        child: Container(
                          alignment: Alignment.center,
                          color: theme.surface,
                          child: Container(
                            padding: const EdgeInsets.only(
                              left: 10,
                              right: 10,
                              top: 2,
                              bottom: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Text(
                              'DEPARTAMENTO',
                              style: TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 13,
                                color:
                                    Theme.of(context).colorScheme.primaryFixed,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  // DATOS
                  ...detalleEvento!.map<TableRow>((item) {
                    return TableRow(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.grey[300]!),
                        ),
                      ),
                      children: [
                        TableCell(
                          child: Container(
                            margin: const EdgeInsets.all(5),
                            alignment: Alignment.center,
                            color: theme.surface,
                            child: Container(
                              padding: const EdgeInsets.only(
                                left: 10,
                                right: 10,
                                top: 2,
                                bottom: 2,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    item.posicionAnterior == '0'
                                        ? theme.surface
                                        : Colors.white,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text(
                                item.posicionAnterior == '0'
                                    ? ''
                                    : item.posicionAnterior,
                                style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 13,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                        TableCell(
                          verticalAlignment: TableCellVerticalAlignment.fill,
                          child: Container(
                            margin: const EdgeInsets.all(5),
                            alignment: Alignment.center,
                            color: theme.surface,
                            child: Container(
                              padding: const EdgeInsets.only(
                                left: 20,
                                right: 20,
                                top: 2,
                                bottom: 2,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    _isPosicionActualEnTop5(item.posicionActual)
                                        ? Theme.of(context).colorScheme.primary
                                        : _isPosicionActualEnTop12(
                                          item.posicionActual,
                                        )
                                        ? theme.primaryContainer
                                        : _isPosicionActualEnTop16(
                                          item.posicionActual,
                                        )
                                        ? Colors.red
                                        : null,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                item.posicionActual == '0'
                                    ? ''
                                    : item.posicionActual,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 13,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                        TableCell(
                          child: Text(
                            item.evaluadoId,
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontWeight: FontWeight.w900,
                              fontSize: 13,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ],
                    );
                  }),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttereva/provider/state/evento.state.dart';
import 'package:fluttereva/services/evento_service.dart';
import 'package:fluttereva/theme/apptheme.dart';
import 'package:fluttereva/utils/date_formater.dart';

class DetalleEvento extends StatelessWidget {
  final EventoState evento;
  const DetalleEvento({super.key, required this.evento});

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
          print('detalleEvento json: ${jsonEncode(detalleEvento)}');
          // Puedes usar detalleEvento para poblar la tabla dinámicamente
          final anterior = DateFormatter.subtractOneMonth(evento.fevento);
          final nombreMesAnterior = DateFormatter.monthName(
            anterior.toString(),
          );
          return Table(
            border: TableBorder.all(color: Colors.grey),
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
                        fontSize: 12,
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
                        fontSize: 12,
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
                        fontSize: 12,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              ...detalleEvento!.map<TableRow>((item) {
                return TableRow(
                  children: [
                    TableCell(
                      child: Text(
                        item.posicionAnterior,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    TableCell(
                      child: Text(
                        item.posicionActual,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    TableCell(
                      child: Text(
                        item.evaluadoId,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
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

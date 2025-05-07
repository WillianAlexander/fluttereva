import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttereva/provider/state/evento.state.dart';
import 'package:fluttereva/utils/date_formater.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

Future<void> exportarTablaComoPDF(
  BuildContext context,
  List<dynamic> detalleEvento,
  EventoState evento,
) async {
  final pdf = pw.Document();

  final anterior = DateFormatter.subtractOneMonth(evento.fevento);
  final nombreMesAnterior = DateFormatter.monthName(anterior.toString());
  final nombreMesActual = DateFormatter.monthName(evento.fevento);

  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        return pw.Table(
          border: pw.TableBorder.all(color: PdfColor.fromInt(0xFFE3DFDF)),
          defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
          columnWidths: {
            0: const pw.IntrinsicColumnWidth(),
            1: const pw.IntrinsicColumnWidth(),
            2: const pw.FixedColumnWidth(200),
          },
          children: [
            // ENCABEZADO
            pw.TableRow(
              decoration: pw.BoxDecoration(color: PdfColor.fromInt(0xFF80b029)),
              children: [
                pw.Container(
                  alignment: pw.Alignment.center,
                  padding: const pw.EdgeInsets.all(4),
                  child: pw.Text(
                    'RANKIN ANTERIOR ${nombreMesAnterior.toUpperCase()}',
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                      fontSize: 12,
                      color: PdfColor.fromInt(0xFFFFFFFF),
                    ),
                    textAlign: pw.TextAlign.center,
                  ),
                ),
                pw.Container(
                  alignment: pw.Alignment.center,
                  padding: const pw.EdgeInsets.all(4),
                  child: pw.Text(
                    'RANKIN NUEVO ${nombreMesActual.toUpperCase()}',
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                      fontSize: 12,
                      color: PdfColor.fromInt(0xFFFFFFFF),
                    ),
                    textAlign: pw.TextAlign.center,
                  ),
                ),
                pw.Container(
                  alignment: pw.Alignment.center,
                  padding: const pw.EdgeInsets.all(4),
                  child: pw.Text(
                    'DEPARTAMENTO',
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                      fontSize: 12,
                      color: PdfColor.fromInt(0xFFFFFFFF),
                    ),
                    textAlign: pw.TextAlign.center,
                  ),
                ),
              ],
            ),
            // DATOS
            ...detalleEvento.map<pw.TableRow>((item) {
              PdfColor? cellColor;
              final pos = int.tryParse(item.posicionActual ?? '');
              if (pos != null) {
                if (pos >= 1 && pos <= 5) {
                  cellColor = PdfColor.fromInt(0xFF008e3c); // primary
                } else if (pos >= 6 && pos <= 12) {
                  cellColor = PdfColor.fromInt(0xFFFFA500); // orange
                } else if (pos >= 13 && pos <= 16) {
                  cellColor = PdfColor.fromInt(0xFFFF0000); // red
                }
              }
              return pw.TableRow(
                children: [
                  pw.Container(
                    height: 35,
                    alignment: pw.Alignment.center,
                    padding: const pw.EdgeInsets.all(0),
                    margin: const pw.EdgeInsets.all(0),
                    child: pw.Text(
                      item.posicionAnterior == '0' ? '' : item.posicionAnterior,
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 10,
                      ),
                      textAlign: pw.TextAlign.center,
                    ),
                  ),
                  pw.Container(
                    height: 35,
                    alignment: pw.Alignment.center,
                    color: cellColor,
                    padding: const pw.EdgeInsets.all(0),
                    margin: const pw.EdgeInsets.all(0),
                    child: pw.Text(
                      item.posicionActual == '0' ? '' : item.posicionActual,
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 10,
                        color:
                            cellColor != null
                                ? PdfColor.fromInt(0xFFFFFFFF)
                                : PdfColor.fromInt(0xFF000000),
                      ),
                      textAlign: pw.TextAlign.center,
                    ),
                  ),
                  pw.Container(
                    alignment: pw.Alignment.center,
                    padding: const pw.EdgeInsets.all(0),
                    margin: const pw.EdgeInsets.all(0),
                    child: pw.Text(
                      item.evaluadoId,
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 10,
                      ),
                      textAlign: pw.TextAlign.center,
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

  final file = await getTemporaryDirectory();
  final filePath = '${file.path}/ranking.pdf';
  final filePdf = File(filePath);
  await filePdf.writeAsBytes(await pdf.save());
  await OpenFile.open(filePath);
  // Mostrar el PDF con el visor
  // await Printing.layoutPdf(
  //   onLayout: (PdfPageFormat format) async => pdf.save(),
  // );
}

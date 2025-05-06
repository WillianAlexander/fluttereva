import 'package:flutter/material.dart';
import 'package:fluttereva/custom_widgets/podium.dart';
import 'package:fluttereva/models/topevent.dart';
import 'package:fluttereva/provider/top/top.provider.dart';
import 'package:fluttereva/services/evento_service.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class BarChar extends StatefulWidget {
  const BarChar({super.key});

  @override
  State<BarChar> createState() => _BarCharState();
}

class _BarCharState extends State<BarChar> {
  late List<_ChartData> data;
  late TooltipBehavior _tooltip;
  int maxIndex = 0;

  @override
  void initState() {
    super.initState();
    data = [];
    _tooltip = TooltipBehavior(enable: false, header: '', format: 'point.x');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TopProvider>(context, listen: false).fetchTopEvents();
    });
  }

  double calcularPosicionX(int index, BuildContext context) {
    // Ajusta estos valores según el padding/margins de tu gráfico
    double chartWidth =
        MediaQuery.of(context).size.width; // o el ancho real del widget
    double leftPadding =
        0; // Si tu gráfico tiene padding a la izquierda, ajústalo aquí
    int barCount = data.length;
    double barWidth = chartWidth / barCount;
    // Centra la corona sobre la barra
    return leftPadding +
        barWidth * index +
        barWidth / 2 -
        14; // 14 es la mitad del icono (size: 28)
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TopProvider>(
      builder: (context, topProvider, child) {
        if (topProvider.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        final topEvents = topProvider.topEvents;
        if (topEvents.isEmpty) {
          return const Center(child: Text('No hay datos'));
        }

        data = [
          _ChartData(
            topEvents[1].departamento,
            double.parse(topEvents[1].total),
            Colors.amber,
          ),
          _ChartData(
            topEvents[0].departamento,
            double.parse(topEvents[0].total),
            Colors.green,
          ),
          _ChartData(
            topEvents[2].departamento,
            double.parse(topEvents[2].total),
            Colors.orange,
          ),
        ];

        // Encuentra el índice del valor máximo
        maxIndex = 0;
        double maxScore = data.isNotEmpty ? data[0].y : 0;
        for (int i = 1; i < data.length; i++) {
          if (data[i].y > maxScore) {
            maxScore = data[i].y;
            maxIndex = i;
          }
        }
        return Column(
          children: [
            Text(
              'PODIO DE INFORMES DE ${topEvents[0].mes} 2025',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Stack(
                    children: [
                      Podium(
                        values: [
                          data[0].y,
                          data[1].y,
                          data[2].y,
                        ], // los valores para cada puesto
                        colors: [Colors.amber, Colors.green, Colors.orange],
                        labels: ['2', '1', '3'],
                        icons: [
                          Icons.emoji_events,
                          Icons.emoji_events,
                          Icons.emoji_events,
                        ],
                        iconColors: [Colors.grey, Colors.amber, Colors.brown],
                        names: [data[0].x, data[1].x, data[2].x],
                        totalHeight: 200,
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ChartData {
  _ChartData(this.x, this.y, this.color);

  final String x;
  final double y;
  final Color color;
}

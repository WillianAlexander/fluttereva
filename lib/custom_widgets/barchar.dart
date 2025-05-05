import 'package:flutter/material.dart';
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
    _tooltip = TooltipBehavior(enable: true, header: '', format: 'point.x');
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
            topEvents[1].departamento ?? 'Sin departamento',
            double.parse(topEvents[1].promedio ?? '0'),
            Colors.amber,
          ),
          _ChartData(
            topEvents[0].departamento ?? 'Sin departamento',
            double.parse(topEvents[0].promedio ?? '0'),
            Colors.green,
          ),
          _ChartData(
            topEvents[2].departamento ?? 'Sin departamento',
            double.parse(topEvents[2].promedio ?? '0'),
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
            SizedBox(
              height: 200,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  double chartWidth = constraints.maxWidth;
                  int barCount = data.length;
                  double barWidth = chartWidth / barCount;
                  // Ajusta el factor de centrado si las barras son más delgadas
                  double coronaLeft = barWidth * maxIndex + barWidth / 2 - 18;
                  double chartHeight = 200; // El alto de tu SizedBox
                  double baseHeight =
                      14 + 10; // altura del podio + margen inferior
                  double availableHeight =
                      chartHeight -
                      baseHeight -
                      35; // 35 es el size de la corona

                  double maxY = 50; // El máximo del eje Y
                  double barValue = data.isNotEmpty ? data[maxIndex].y : 0;
                  double barProportion = barValue / maxY;
                  double coronaTop = (0.90 - barProportion) * availableHeight;

                  double positionTopForIndex(int i) {
                    double barValue = data[i].y;
                    double barProportion = barValue / maxY;
                    return (0.90 - barProportion) * availableHeight;
                  }

                  return Stack(
                    children: [
                      // Base/podio para las barras
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom:
                            10, // Ajusta según el margen inferior que desees
                        child: Container(
                          height: 14, // Grosor de la base
                          margin: const EdgeInsets.symmetric(
                            horizontal: 12,
                          ), // Opcional: margen lateral
                          decoration: BoxDecoration(
                            color: Colors.blueGrey[200], // Color de la base
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                      Positioned(
                        left: coronaLeft,
                        top: coronaTop,
                        child: const Icon(
                          Icons.emoji_events,
                          color: Colors.amber,
                          size: 35,
                        ),
                      ),
                      ...[
                        for (int i = 0; i < data.length; i++)
                          if (i != 1) // Solo para las posiciones 0 y 2
                            Positioned(
                              left:
                                  (i == 0)
                                      ? 12 + barWidth * i + barWidth / 2 - 14
                                      : barWidth * i + barWidth / 2 - 14,
                              top: positionTopForIndex(i),
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.blueGrey[100],
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  // Muestra 2 para la izquierda (i==0) y 3 para la derecha (i==2)
                                  '${i == 0 ? 2 : 3}',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                      ],
                      SfCartesianChart(
                        primaryXAxis: CategoryAxis(isVisible: false),
                        primaryYAxis: NumericAxis(
                          isVisible: false,
                          minimum: 0,
                          maximum: 50,
                          interval: 1,
                        ),
                        tooltipBehavior: _tooltip,
                        series: <CartesianSeries<_ChartData, String>>[
                          ColumnSeries<_ChartData, String>(
                            dataSource: data,
                            xValueMapper: (_ChartData data, _) => data.x,
                            yValueMapper: (_ChartData data, _) => data.y,
                            name: 'Puntaje',
                            pointColorMapper:
                                (_ChartData data, _) => data.color,
                            width: 0.5,
                            dataLabelSettings: DataLabelSettings(
                              isVisible: true,
                              labelAlignment: ChartDataLabelAlignment.top,
                              textStyle: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
            Text(
              'RANKING CALIFICACION DE INFORMES GERENCIALES ${topEvents[0].mes} 2025',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
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

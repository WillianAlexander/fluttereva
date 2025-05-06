import 'package:flutter/material.dart';
import 'package:fluttereva/custom_widgets/podium.dart';
import 'package:fluttereva/custom_widgets/ribbon.dart';
import 'package:fluttereva/provider/top/top.provider.dart';
import 'package:provider/provider.dart';

class BarChar extends StatefulWidget {
  const BarChar({super.key});

  @override
  State<BarChar> createState() => _BarCharState();
}

class _BarCharState extends State<BarChar> {
  late List<_ChartData> data;

  @override
  void initState() {
    super.initState();
    data = [];
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TopProvider>(context, listen: false).fetchTopEvents();
    });
  }

  double calcularPosicionX(int index, BuildContext context) {
    double chartWidth = MediaQuery.of(context).size.width;
    double leftPadding = 0;
    int barCount = data.length;
    double barWidth = chartWidth / barCount;
    return leftPadding + barWidth * index + barWidth / 2 - 14;
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

        return Column(
          children: [
            RibbonLabel(
              title: 'PODIO DE INFORMES DE ${topEvents[0].mes} 2025',
              height: 50,
            ),
            // Text(
            //   'PODIO DE INFORMES DE ${topEvents[0].mes} 2025',
            //   textAlign: TextAlign.center,
            //   style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            // ),
            SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Stack(
                    children: [
                      Podium(
                        values: [data[0].y, data[1].y, data[2].y],
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

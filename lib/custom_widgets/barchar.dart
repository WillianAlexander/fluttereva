import 'package:flutter/material.dart';
import 'package:fluttereva/custom_widgets/podium.dart';
import 'package:fluttereva/custom_widgets/ribbon.dart';
import 'package:fluttereva/models/topevent.dart';
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return Consumer<TopProvider>(
      builder: (context, topProvider, child) {
        if (topProvider.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        final topEvents = topProvider.topEvents;
        if (topEvents.isEmpty) {
          return const Center(child: Text('No hay datos'));
        }

        final colors = [Colors.amber, Colors.green, Colors.orange];

        final fixedTopEvents = List<TopEvent>.from(topEvents);
        while (fixedTopEvents.length < 3) {
          fixedTopEvents.add(
            TopEvent(departamento: '', total: '0', promedio: '0', mes: ''),
          );
        }

        fixedTopEvents.sort(
          (a, b) =>
              double.tryParse(
                b.total,
              )?.compareTo(double.tryParse(a.total) ?? 0) ??
              0,
        );

        final podiumOrder = [1, 0, 2];

        data = List.generate(
          3,
          (i) => _ChartData(
            fixedTopEvents.length > podiumOrder[i]
                ? fixedTopEvents[podiumOrder[i]].departamento
                : '',
            fixedTopEvents.length > podiumOrder[i]
                ? double.tryParse(fixedTopEvents[podiumOrder[i]].total) ?? 0
                : 0,
            colors[i],
          ),
        );

        String mes = topEvents[0].mes;
        String mesCapitalizado =
            mes.isNotEmpty
                ? mes[0].toUpperCase() + mes.substring(1).toLowerCase()
                : '';

        return Column(
          children: [
            // RibbonLabel(
            //   title: 'PODIO DE INFORMES DE ${topEvents[0].mes} 2025',
            //   height: 50,
            // ),
            Container(
              padding: const EdgeInsets.only(
                left: 18,
                right: 18,
                top: 10,
                bottom: 10,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Ranking de informes del mes de $mesCapitalizado',
                style: TextStyle(
                  color: Colors.grey[700],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 18, right: 18),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey.shade300, width: 1),
                ),
                child: SizedBox(
                  height: 200,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return Stack(
                        children: [
                          Podium(
                            values: [data[0].y, data[1].y, data[2].y],
                            colors: [
                              theme.primaryContainer,
                              theme.primaryFixed,
                              theme.primary,
                            ],
                            labels: ['2', '1', '3'],
                            icons: [
                              Icons.emoji_events,
                              Icons.emoji_events,
                              Icons.emoji_events,
                            ],
                            iconColors: [
                              Colors.grey,
                              Colors.amber,
                              Colors.brown,
                            ],
                            names: [data[0].x, data[1].x, data[2].x],
                            totalHeight: 200,
                          ),
                        ],
                      );
                    },
                  ),
                ),
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

import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:fluttereva/custom_widgets/resources/app_resources.dart';

class TopBars extends StatefulWidget {
  TopBars({super.key});

  final shadowColor = const Color.fromARGB(255, 221, 221, 221);
  final dataList = [
    const _BarData(AppColors.contentColorPink, 20, 20, 'TECNOLOGIA'),
    const _BarData(
      AppColors.contentColorGreen,
      15,
      15,
      'INVERSIONES - CAPTACIONES',
    ),
    const _BarData(AppColors.contentColorBlue, 10, 10, 'OPERACIONES'),
    const _BarData(Color(0xFF42BE9F), 7, 7, 'TALENTO HUMANO'),
    const _BarData(AppColors.contentColorOrange, 5, 5, 'RIESGOS'),
    // const _BarData(AppColors.contentColorRed, 2, 2),
  ];

  @override
  State<TopBars> createState() => _TopBarsState();
}

class _TopBarsState extends State<TopBars> {
  BarChartGroupData generateBarGroup(
    int x,
    Color color,
    double value,
    double shadowValue,
  ) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: value,
          color: color,
          width: 20,
          borderRadius: BorderRadius.vertical(),
        ),
        BarChartRodData(
          toY: shadowValue,
          color: widget.shadowColor,
          width: 5,
          borderRadius: BorderRadius.only(
            topLeft: Radius.elliptical(0, 0),
            topRight: Radius.elliptical(10, 25),
          ),
        ),
      ],
      showingTooltipIndicators: touchedGroupIndex == x ? [0] : [],
    );
  }

  int touchedGroupIndex = -1;

  // int rotationTurns = 1;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: Container()),
              // const Text(
              //   'Horizontal Bar Chart',
              //   style: TextStyle(
              //     color: Color.fromARGB(255, 168, 30, 30),
              //     fontSize: 20,
              //   ),
              // ),
              // Expanded(
              //   child: Align(
              //     alignment: Alignment.centerRight,
              //     child: Tooltip(
              //       message: 'Rotate the chart 90 degrees (cw)',
              //       child: IconButton(
              //         onPressed: () {
              //           setState(() {
              //             rotationTurns += 1;
              //           });
              //         },
              //         icon: RotatedBox(
              //           quarterTurns: rotationTurns - 1,
              //           child: const Icon(Icons.rotate_90_degrees_cw),
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
          const SizedBox(height: 18),
          AspectRatio(
            aspectRatio: 1.4,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceBetween,
                rotationQuarterTurns: 4,
                borderData: FlBorderData(
                  show: true,
                  border: Border.symmetric(
                    horizontal: BorderSide(
                      color: AppColors.borderColor.withValues(alpha: 0.2),
                    ),
                  ),
                ),

                // titlesData: FlTitlesData(
                //   show: true,
                //   leftTitles: const AxisTitles(
                //     drawBelowEverything: true,
                //     sideTitles: SideTitles(showTitles: false, reservedSize: 30),
                //   ),
                //   bottomTitles: AxisTitles(
                //     sideTitles: SideTitles(
                //       showTitles: true,
                //       reservedSize: 36,
                //       getTitlesWidget: (value, meta) {
                //         final index = value.toInt();
                //         return SideTitleWidget(
                //           meta: meta,
                //           child: _IconWidget(
                //             color: widget.dataList[index].color,
                //             isSelected: touchedGroupIndex == index,
                //           ),
                //         );
                //       },
                //     ),
                //   ),
                //   rightTitles: const AxisTitles(),
                //   topTitles: const AxisTitles(),
                // ),
                titlesData: FlTitlesData(
                  show: true,
                  leftTitles: const AxisTitles(),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (double value, TitleMeta meta) {
                        // value es el índice de la barra
                        final int index = value.toInt();
                        // Asegúrate de que el índice esté en rango
                        if (index < 0 || index >= widget.dataList.length) {
                          return const SizedBox.shrink();
                        }
                        final data = widget.dataList[index];
                        return Text(
                          '${data.value.toInt()}%', // Muestra el valor de la barra
                          style: TextStyle(
                            color: widget.dataList[index].color,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        );
                      },
                      reservedSize: 20,
                    ),
                  ),
                  // bottomTitles: AxisTitles(
                  //   sideTitles: SideTitles(
                  //     showTitles: true,
                  //     reservedSize: 36,
                  //     getTitlesWidget: (value, meta) {
                  //       final index = value.toInt();
                  //       return SideTitleWidget(
                  //         meta: meta,
                  //         child: _IconWidget(
                  //           color: widget.dataList[index].color,
                  //           isSelected: touchedGroupIndex == index,
                  //         ),
                  //       );
                  //     },
                  //   ),
                  // ),
                  topTitles: const AxisTitles(),
                  rightTitles: const AxisTitles(),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine:
                      (value) => FlLine(
                        color: AppColors.borderColor.withValues(alpha: 0.2),
                        strokeWidth: 1,
                      ),
                ),
                barGroups:
                    widget.dataList.asMap().entries.map((e) {
                      final index = e.key;
                      final data = e.value;
                      return generateBarGroup(
                        index,
                        data.color,
                        data.value,
                        data.shadowValue,
                      );
                    }).toList(),
                maxY: 20,
                barTouchData: BarTouchData(
                  enabled: true,
                  handleBuiltInTouches: false,
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipColor: (group) => Colors.transparent,
                    tooltipMargin: 25,
                    getTooltipItem: (
                      BarChartGroupData group,
                      int groupIndex,
                      BarChartRodData rod,
                      int rodIndex,
                    ) {
                      final department = widget.dataList[groupIndex].department;
                      return BarTooltipItem(
                        department,
                        TextStyle(
                          fontWeight: FontWeight.bold,
                          color: rod.color,
                          fontSize: 13,
                          // shadows: const [
                          //   Shadow(color: Colors.black26, blurRadius: 12),
                          // ],
                        ),
                      );
                    },
                  ),
                  touchCallback: (event, response) {
                    if (event.isInterestedForInteractions &&
                        response != null &&
                        response.spot != null) {
                      setState(() {
                        touchedGroupIndex = response.spot!.touchedBarGroupIndex;
                      });
                    } else {
                      setState(() {
                        touchedGroupIndex = -1;
                      });
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BarData {
  const _BarData(this.color, this.value, this.shadowValue, this.department);
  final Color color;
  final double value;
  final double shadowValue;
  final String department;
}

class _IconWidget extends ImplicitlyAnimatedWidget {
  const _IconWidget({required this.color, required this.isSelected})
    : super(duration: const Duration(milliseconds: 300));
  final Color color;
  final bool isSelected;

  @override
  ImplicitlyAnimatedWidgetState<ImplicitlyAnimatedWidget> createState() =>
      _IconWidgetState();
}

class _IconWidgetState extends AnimatedWidgetBaseState<_IconWidget> {
  Tween<double>? _rotationTween;

  @override
  Widget build(BuildContext context) {
    final rotation = math.pi * 4 * _rotationTween!.evaluate(animation);
    final scale = 1 + _rotationTween!.evaluate(animation) * 0.5;
    return Transform(
      transform: Matrix4.rotationZ(rotation).scaled(scale, scale),
      origin: const Offset(14, 14),
      child: Icon(
        widget.isSelected ? Icons.face_retouching_natural : Icons.face,
        color: widget.color,
        size: 28,
      ),
    );
  }

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _rotationTween =
        visitor(
              _rotationTween,
              widget.isSelected ? 1.0 : 0.0,
              (dynamic value) => Tween<double>(
                begin: value as double,
                end: widget.isSelected ? 1.0 : 0.0,
              ),
            )
            as Tween<double>?;
  }
}

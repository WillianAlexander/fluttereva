import 'package:flutter/material.dart';

class Podium extends StatelessWidget {
  final List<double> values;
  final List<Color> colors;
  final List<String> labels;
  final List<IconData> icons;
  final List<Color> iconColors;
  final List<String> names;
  final double totalHeight;

  const Podium({
    Key? key,
    required this.values,
    required this.colors,
    required this.labels,
    required this.icons,
    required this.iconColors,
    required this.names,
    this.totalHeight = 200,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Ajusta estos valores si cambias el diseño visual:
    final double iconHeight = 40; // tamaño del icono/círculo
    final double iconSpacing = 6;
    final double footerHeight = 20; // alto del nombre
    final double footerSpacing = 8;
    final double baseHeight = 20; // alto de la base del podio
    final double verticalPadding = iconSpacing + footerSpacing;
    final double maxBarHeight =
        totalHeight - iconHeight - footerHeight - verticalPadding - baseHeight;

    final double maxValue = values.reduce((a, b) => a > b ? a : b);
    final List<double> barHeights =
        values.map((v) => maxBarHeight * (v / maxValue)).toList();

    return SizedBox(
      height: totalHeight,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              PodiumBar(
                height: barHeights[0],
                color: colors[0],
                label: labels[0],
                icon: icons[0],
                iconColor: iconColors[0],
                position: int.parse(labels[0]),
                score: values[0],
                footer: names[0],
                animationDelay: const Duration(milliseconds: 0),
              ),
              SizedBox(width: 10),
              PodiumBar(
                height: barHeights[1],
                color: colors[1],
                label: labels[1],
                icon: icons[1],
                iconColor: iconColors[1],
                position: int.parse(labels[1]),
                score: values[1],
                footer: names[1],
                animationDelay: const Duration(milliseconds: 300),
              ),
              SizedBox(width: 10),
              PodiumBar(
                height: barHeights[2],
                color: colors[2],
                label: labels[2],
                icon: icons[2],
                iconColor: iconColors[2],
                position: int.parse(labels[2]),
                score: values[2],
                footer: names[2],
                animationDelay: const Duration(milliseconds: 600),
              ),
            ],
          ),
          // BASE DEL PODIO
          // Container(
          //   margin: const EdgeInsets.symmetric(horizontal: 16),
          //   height: baseHeight,
          //   decoration: BoxDecoration(
          //     color: Colors.grey[300],
          //     borderRadius: const BorderRadius.vertical(
          //       top: Radius.circular(12),
          //     ),
          //     boxShadow: [
          //       BoxShadow(
          //         color: Colors.black.withValues(alpha: 0.08),
          //         blurRadius: 4,
          //         offset: const Offset(0, -2),
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}

class PodiumBar extends StatefulWidget {
  final double height;
  final Color color;
  final String label;
  final IconData icon;
  final Color iconColor;
  final int position;
  final double score;
  final String footer;
  final Duration animationDelay;

  const PodiumBar({
    Key? key,
    required this.height,
    required this.color,
    required this.label,
    required this.icon,
    required this.iconColor,
    required this.position,
    required this.score,
    required this.footer,
    required this.animationDelay,
  }) : super(key: key);

  @override
  State<PodiumBar> createState() => _PodiumBarState();
}

class _PodiumBarState extends State<PodiumBar> {
  double _animatedHeight = 0;

  @override
  void initState() {
    super.initState();
    Future.delayed(widget.animationDelay, () {
      if (mounted) {
        setState(() {
          _animatedHeight = widget.height;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isZero = widget.score == 0;
    String footer = widget.footer.trim();
    String footerLower;
    if (footer.isEmpty) {
      footerLower = '';
    } else {
      List<String> words = footer.split(RegExp(r'\s+'));
      if (words.length == 1) {
        // Una sola palabra: inicial mayúscula, resto minúscula
        footerLower =
            words[0][0].toUpperCase() + words[0].substring(1).toLowerCase();
      } else {
        // Buscar palabra > 3 caracteres (excluyendo la primera)
        String? longWord = words
            .skip(1)
            .firstWhere(
              (w) => w.length > 3,
              orElse: () => words[1], // Si no hay, usa la segunda palabra
            );
        footerLower = words[0][0].toUpperCase() + '. ' + longWord.toLowerCase();
      }
    }
    return Column(
      children: [
        SizedBox(
          width: 50,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (widget.position == 1 && !isZero)
                Icon(widget.icon, color: widget.iconColor, size: 40)
              else if (!isZero)
                rankingBadge(widget.label),
              // CircleAvatar(
              //   backgroundColor: Colors.blueGrey[100],
              //   radius: 12,
              //   child: Text(
              //     widget.label,
              //     style: const TextStyle(
              //       color: Colors.black,
              //       fontWeight: FontWeight.bold,
              //       fontSize: 16,
              //     ),
              //   ),
              // ),
              if (!isZero) const SizedBox(height: 6),
              Stack(
                alignment: Alignment.center,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 800),
                    curve: Curves.easeOutCubic,
                    width: 40,
                    height: isZero ? 0 : _animatedHeight,
                    decoration: BoxDecoration(
                      color: isZero ? Colors.transparent : widget.color,
                      borderRadius: BorderRadius.circular(0),
                    ),
                  ),
                  if (!isZero)
                    Text(
                      widget.score.toStringAsFixed(0),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        shadows: [
                          Shadow(
                            color: Colors.black26,
                            blurRadius: 2,
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 2),
        SizedBox(
          height: 40,
          width: 75,
          child: Text(
            textAlign: TextAlign.center,
            footerLower,
            style: TextStyle(
              color: Colors.grey[700],
              fontWeight: FontWeight.w900,
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }
}

Widget rankingBadge(String number) {
  return Container(
    width: 25,
    height: 25,
    decoration: BoxDecoration(
      color: Colors.white, // Fondo blanco
      shape: BoxShape.circle,
      border: Border.all(
        color: const Color(0xFF9B9A9A),
        width: 2,
      ), // Borde gris
    ),
    child: Center(
      child: Text(
        number,
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
      ),
    ),
  );
}

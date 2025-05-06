import 'package:flutter/material.dart';

class RibbonLabel extends StatelessWidget {
  final String title;
  final Color color;
  final double height;

  const RibbonLabel({
    Key? key,
    required this.title,
    this.color = Colors.red,
    this.height = 50.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Cuerpo de la etiqueta
          Container(
            padding: EdgeInsets.symmetric(horizontal: 40),
            height: height * 0.6,
            decoration: BoxDecoration(color: color),
          ),
          // Extremo izquierdo
          Positioned(
            left: 0,
            child: ClipPath(
              clipper: TriangleClipper(flip: true),
              child: Container(
                width: 10,
                height: height * 0.6,
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
            ),
          ),
          // Extremo derecho
          Positioned(
            right: 0,
            child: ClipPath(
              clipper: TriangleClipper(),
              child: Container(
                width: 10,
                height: height * 0.6,
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
            ),
          ),
          // Texto centrado
          Text(
            title,
            style: TextStyle(
              color: Theme.of(context).scaffoldBackgroundColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

// Clipper para los triángulos en los extremos
class TriangleClipper extends CustomClipper<Path> {
  final bool flip;

  TriangleClipper({this.flip = false});

  @override
  Path getClip(Size size) {
    Path path = Path();
    if (flip) {
      path.moveTo(0, 0);
      path.lineTo(size.width, size.height / 2);
      path.lineTo(0, size.height);
    } else {
      path.moveTo(size.width, 0);
      path.lineTo(0, size.height / 2);
      path.lineTo(size.width, size.height);
    }
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

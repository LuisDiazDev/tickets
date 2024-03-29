import 'package:flutter/material.dart';

import 'colors.dart';

class StarlinkProgressCircle extends StatefulWidget {
  final int percent;
  const StarlinkProgressCircle({
    super.key,
    required this.percent,
  });

  @override
  StarlinkProgressCircleState createState() => StarlinkProgressCircleState();
}

class StarlinkProgressCircleState extends State<StarlinkProgressCircle> {

  @override
  Widget build(BuildContext context) {
    var percent = widget.percent;
    if (percent > 100) {
      percent = 100;
    }else if (percent < 0) {
      percent = 0;
    }
    return SizedBox(
        width: 160,
        height: 160,
        child: CustomPaint(
          painter: CircleProgressPainter(percent.floorToDouble(), 155),
          child: Center(
            child: Text(
              '$percent%',
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: StarlinkColors.white,
                fontFamily: 'DDIN',
              ),
            ),
          ),
        )
    );
  }


}

class CircleProgressPainter extends CustomPainter {
  final double percent;

  double diameter;

  CircleProgressPainter(this.percent, this.diameter);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = StarlinkColors.black
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    Offset center = Offset(size.width / 2.0, size.height / 2.0);
    double radius = diameter / 2.0;

    canvas.drawCircle(center, radius, paint);

    var pi = 3.1415926;
    double arcAngle = 2.0 * pi * (percent / 100.0);

    paint.color = StarlinkColors.white;
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -pi / 2.0,
        arcAngle, false, paint);

    paint.color = StarlinkColors.darkGray;
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), arcAngle - pi / 2.0,
        2.0 * pi - arcAngle, false, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

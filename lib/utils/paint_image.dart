import 'dart:ui';
import 'package:flutter/cupertino.dart';

class ImagePainter extends CustomPainter {
  ImagePainter({required this.pointsList});

  List pointsList;
  List<Offset> offsetPoints = [];

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < pointsList.length - 1; i++) {
      if (pointsList[i] != null && pointsList[i + 1] != null) {
        canvas.drawLine(pointsList[i].offsetPoints,
            pointsList[i + 1].offsetPoints, pointsList[i].paint);
      } else if (pointsList[i] != null && pointsList[i + 1] == null) {
        offsetPoints.clear();
        offsetPoints.add(pointsList[i].offsetPoints);
        offsetPoints.add(Offset(pointsList[i].offsetPoints.dx + 0.1,
            pointsList[i].offsetPoints.dy + 0.1));
        canvas.drawPoints(PointMode.points, offsetPoints, pointsList[i].paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

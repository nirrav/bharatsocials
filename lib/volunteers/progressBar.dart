import 'dart:math';
import 'package:flutter/material.dart';

class CircularProgressPainter extends CustomPainter {
  final double progress;
  final double total;

  CircularProgressPainter({required this.progress, required this.total});

  @override
  void paint(Canvas canvas, Size size) {
    const double strokeWidth = 18.0; // Thicker stroke width
    final double radius =
        min(size.width / 2, size.height / 2) - strokeWidth / 2;

    final Paint backgroundPaint = Paint()
      ..color = Colors.grey
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final Paint progressPaint = Paint()
      ..color = const Color.fromARGB(255, 33, 246, 5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final double angle = 2 * pi * (progress / total);

    // Draw the background circle
    canvas.drawCircle(size.center(Offset.zero), radius, backgroundPaint);

    // Draw the progress arc
    canvas.drawArc(
      Rect.fromCenter(
          center: size.center(Offset.zero),
          width: 2 * radius,
          height: 2 * radius),
      -pi / 2,
      angle,
      false,
      progressPaint,
    );

    // Draw the text in the center
    final TextSpan textSpan = TextSpan(
      text: '${progress.toInt()}/${total.toInt()}\nhours',
      style: const TextStyle(
        color: Colors.black,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );

    final TextPainter textPainter = TextPainter(
      text: textSpan,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();
    final Offset textOffset = size.center(Offset.zero) -
        Offset(textPainter.width / 2, textPainter.height / 2);
    textPainter.paint(canvas, textOffset);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

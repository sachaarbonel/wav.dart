import 'package:flutter/material.dart';

class WavPainter extends CustomPainter {
  final int samplePeak;
  final List<int> data;

  const WavPainter({
    @required this.data,
    this.samplePeak = 256,
  });

  @override
  void paint(Canvas canvas, Size size) {
    /// draw center line
    canvas.drawLine(
      Offset(0.0, size.height / 2),
      Offset(size.width, size.height / 2),
      Paint()
        ..color = Colors.grey[800]
        ..strokeWidth = 1.5,
    );

    /// draw wave
    data
        .asMap()
        .entries
        .map((entry) {
          return Offset(
              size.width * (entry.key / data.length),
              (size.height / 2) +
                  ((entry.value.toDouble() / samplePeak) - 0.5) * size.height);
        })
        .toList()
        .fold<Offset>(null, (previous, current) {
          if (previous != null) {
            canvas.drawLine(
              previous,
              current,
              Paint()..color = Colors.yellow[300],
            );
          }
          return current;
        });
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

import 'package:flutter/material.dart';

class LiquidCircularProgress extends StatelessWidget {
  final double currentLiters;
  final double capacity;
  final Size size;

  const LiquidCircularProgress({
    super.key,
    required this.currentLiters,
    this.capacity = 1000.0,
    this.size = const Size(288, 288),
  });

  @override
  Widget build(BuildContext context) {
    double percentage = (currentLiters / capacity).clamp(0.0, 1.0);

    return Container(
      width: size.width,
      height: size.height,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        border: Border.all(color: const Color(0xFF0077B6), width: 2),
      ),
      child: ClipOval(
        child: Stack(
          alignment: Alignment.center,
          children: [
            // The Liquid Fill
            Positioned.fill(
              child: CustomPaint(
                painter: _LiquidPainter(percentage: percentage),
              ),
            ),
            // The Text Info
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${currentLiters.toInt()}',
                  style: const TextStyle(
                    fontSize: 64,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const Text(
                  'LITERS',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF444444),
                  ),
                ),
                Text(
                  'CAPACITY: ${capacity.toInt()}L',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF888888),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _LiquidPainter extends CustomPainter {
  final double percentage;

  _LiquidPainter({required this.percentage});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF0077B6), Color(0xFF005D90)],
      ).createShader(Offset.zero & size);

    final path = Path();

    // Calculate the Y level of the water
    // 0% is at the bottom (size.height), 100% is at top (0)
    double yLevel = size.height * (1 - percentage);

    path.moveTo(0, yLevel);
    path.lineTo(size.width, yLevel);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _LiquidPainter oldDelegate) =>
      oldDelegate.percentage != percentage;
}

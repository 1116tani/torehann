// lib/widgets/home/map_overlay.dart
import 'package:flutter/material.dart';

class MapOverlay extends StatelessWidget {
  const MapOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Positioned.fill(
      child: Opacity(
        opacity: 0.15,
        child: Container(
          decoration: BoxDecoration(
            // ⚠️ radialGradient: ではなく、gradient: に直したよ！
            gradient: RadialGradient(
              center: Alignment.center,
              radius: 1.2,
              colors: [
                theme.colorScheme.primary.withValues(alpha: 0.3),
                Colors.transparent,
              ],
            ),
          ),
          child: Stack(
            children: [
              CustomPaint(
                size: Size.infinite,
                painter: _GridPainter(gridColor: theme.colorScheme.primary),
              ),
              Center(
                child: Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: theme.colorScheme.primary.withValues(alpha: 0.4),
                      width: 1.5,
                    ),
                  ),
                ),
              ),
              Center(
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: theme.colorScheme.primary.withValues(alpha: 0.2),
                      width: 1.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  final Color gridColor;
  _GridPainter({required this.gridColor});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = gridColor.withValues(alpha: 0.2)
      ..strokeWidth = 0.5;

    const double step = 40.0;

    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

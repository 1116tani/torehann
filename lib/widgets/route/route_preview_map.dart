// lib/widgets/route/route_preview_map.dart

import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../constants/app_sizes.dart';
import '../../models/route_model.dart';
import '../../models/spot_model.dart';

class RoutePreviewMap extends StatelessWidget {
  final RouteModel route;
  final Map<String, SpotModel> spots;
  final bool isSelected;
  final double height;

  const RoutePreviewMap({
    super.key,
    required this.route,
    required this.spots,
    this.isSelected = false,
    this.height = 160,
  });

  List<SpotModel> get _routeSpots {
    return route.spotIds
        .map((spotId) => spots[spotId])
        .whereType<SpotModel>()
        .toList(growable: false);
  }

  @override
  Widget build(BuildContext context) {
    final routeSpots = _routeSpots;
    final startSpot = routeSpots.isEmpty ? null : routeSpots.first;
    final goalSpot = routeSpots.length < 2 ? null : routeSpots.last;

    return ClipRRect(
      borderRadius: BorderRadius.circular(AppSizes.radiusM),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: height,
        decoration: BoxDecoration(
          color: const Color(0xFF2C2318),
          border: Border.all(
            color: isSelected
                ? const Color(0xFFB8860B)
                : const Color(0xFFC8A97A),
            width: isSelected ? 1.5 : 0.5,
          ),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(
                painter: _RoutePreviewPainter(
                  spots: routeSpots,
                  isSelected: isSelected,
                ),
              ),
            ),
            Positioned(
              top: AppSizes.p8,
              left: AppSizes.p8,
              child: _MapBadge(
                icon: Icons.explore,
                label: 'ROUTE PREVIEW',
                isActive: isSelected,
              ),
            ),
            Positioned(
              top: AppSizes.p8,
              right: AppSizes.p8,
              child: _MapBadge(
                icon: Icons.place,
                label: '${routeSpots.length} SPOTS',
                isActive: isSelected,
              ),
            ),
            if (routeSpots.isEmpty) const _EmptyPreviewMessage(),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: _RouteSummaryStrip(
                distance: route.totalDistance,
                estimatedTime: route.estimatedTime,
                startName: startSpot?.name,
                goalName: goalSpot?.name,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RoutePreviewPainter extends CustomPainter {
  final List<SpotModel> spots;
  final bool isSelected;

  const _RoutePreviewPainter({required this.spots, required this.isSelected});

  @override
  void paint(Canvas canvas, Size size) {
    _drawBackground(canvas, size);

    final points = _projectSpots(size);
    if (points.isEmpty) {
      _drawEmptyPath(canvas, size);
      return;
    }

    _drawRouteLine(canvas, points);
    _drawPins(canvas, points);
  }

  void _drawBackground(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final basePaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF3D2B1F), Color(0xFF1F1A14)],
      ).createShader(rect);

    canvas.drawRect(rect, basePaint);

    final gridPaint = Paint()
      ..color = const Color(0xFFC8A97A).withValues(alpha: 0.08)
      ..strokeWidth = 1;

    const gridSize = 28.0;
    for (var x = gridSize; x < size.width; x += gridSize) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (var y = gridSize; y < size.height; y += gridSize) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final streetPaint = Paint()
      ..color = const Color(0xFFF5EDD8).withValues(alpha: 0.08)
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      Offset(-20, size.height * 0.28),
      Offset(size.width * 0.74, -12),
      streetPaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.18, size.height + 18),
      Offset(size.width + 24, size.height * 0.38),
      streetPaint,
    );
    canvas.drawLine(
      Offset(-16, size.height * 0.76),
      Offset(size.width + 16, size.height * 0.58),
      streetPaint,
    );
  }

  void _drawEmptyPath(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFC8A97A).withValues(alpha: 0.38)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    final path = Path()
      ..moveTo(size.width * 0.2, size.height * 0.56)
      ..quadraticBezierTo(
        size.width * 0.46,
        size.height * 0.28,
        size.width * 0.8,
        size.height * 0.5,
      );

    _drawDashedPath(canvas, path, paint);
  }

  void _drawRouteLine(Canvas canvas, List<Offset> points) {
    if (points.length == 1) {
      _drawPulse(canvas, points.first);
      return;
    }

    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (var i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }

    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final routePaint = Paint()
      ..color = isSelected ? const Color(0xFF57D6C9) : const Color(0xFFC8A97A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(path, shadowPaint);
    canvas.drawPath(path, routePaint);
  }

  void _drawPins(Canvas canvas, List<Offset> points) {
    for (var i = 0; i < points.length; i++) {
      final point = points[i];
      final isStart = i == 0;
      final isGoal = i == points.length - 1 && points.length > 1;
      final fillColor = isStart
          ? const Color(0xFF57D6C9)
          : isGoal
          ? const Color(0xFFFFB15C)
          : const Color(0xFFB8860B);

      canvas.drawCircle(
        point,
        isSelected ? 18 : 15,
        Paint()..color = fillColor.withValues(alpha: 0.16),
      );
      canvas.drawCircle(
        point,
        9,
        Paint()
          ..color = Colors.black.withValues(alpha: 0.42)
          ..style = PaintingStyle.fill,
      );
      canvas.drawCircle(point, 7, Paint()..color = fillColor);

      final label = isStart
          ? 'S'
          : isGoal
          ? 'G'
          : '${i + 1}';
      final textPainter = TextPainter(
        text: TextSpan(
          text: label,
          style: const TextStyle(
            color: Color(0xFF1F1A14),
            fontSize: 9,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      textPainter.paint(
        canvas,
        point - Offset(textPainter.width / 2, textPainter.height / 2),
      );
    }
  }

  void _drawPulse(Canvas canvas, Offset point) {
    canvas.drawCircle(
      point,
      22,
      Paint()..color = const Color(0xFF57D6C9).withValues(alpha: 0.14),
    );
  }

  void _drawDashedPath(Canvas canvas, Path path, Paint paint) {
    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      const dashLength = 8.0;
      const gapLength = 6.0;

      while (distance < metric.length) {
        final nextDistance = math.min(distance + dashLength, metric.length);
        canvas.drawPath(metric.extractPath(distance, nextDistance), paint);
        distance = nextDistance + gapLength;
      }
    }
  }

  List<Offset> _projectSpots(Size size) {
    if (spots.isEmpty) return const [];
    if (spots.length == 1) {
      return [Offset(size.width / 2, size.height / 2)];
    }

    final minLat = spots.map((spot) => spot.lat).reduce(math.min);
    final maxLat = spots.map((spot) => spot.lat).reduce(math.max);
    final minLng = spots.map((spot) => spot.lng).reduce(math.min);
    final maxLng = spots.map((spot) => spot.lng).reduce(math.max);

    final latRange = maxLat - minLat;
    final lngRange = maxLng - minLng;
    const padding = 30.0;
    final drawableWidth = math.max(1.0, size.width - padding * 2);
    final drawableHeight = math.max(1.0, size.height - padding * 2 - 24);

    return spots
        .map((spot) {
          final normalizedX = lngRange == 0
              ? 0.5
              : (spot.lng - minLng) / lngRange;
          final normalizedY = latRange == 0
              ? 0.5
              : 1 - (spot.lat - minLat) / latRange;

          return Offset(
            padding + normalizedX * drawableWidth,
            padding + normalizedY * drawableHeight,
          );
        })
        .toList(growable: false);
  }

  @override
  bool shouldRepaint(covariant _RoutePreviewPainter oldDelegate) {
    return oldDelegate.spots != spots || oldDelegate.isSelected != isSelected;
  }
}

class _MapBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;

  const _MapBadge({
    required this.icon,
    required this.label,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFF1F1A14).withValues(alpha: 0.78),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: isActive
              ? const Color(0xFF57D6C9).withValues(alpha: 0.7)
              : const Color(0xFFC8A97A).withValues(alpha: 0.35),
          width: 0.7,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 12,
              color: isActive
                  ? const Color(0xFF57D6C9)
                  : const Color(0xFFC8A97A),
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(
                color: Color(0xFFF5EDD8),
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RouteSummaryStrip extends StatelessWidget {
  final double distance;
  final int estimatedTime;
  final String? startName;
  final String? goalName;

  const _RouteSummaryStrip({
    required this.distance,
    required this.estimatedTime,
    required this.startName,
    required this.goalName,
  });

  @override
  Widget build(BuildContext context) {
    final routeLabel = switch ((startName, goalName)) {
      (final String start, final String goal) => '$start → $goal',
      (final String start, null) => start,
      _ => 'ルート生成待ち',
    };

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.transparent, Colors.black.withValues(alpha: 0.72)],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 24, 12, 10),
        child: Row(
          children: [
            Expanded(
              child: Text(
                routeLabel,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Color(0xFFF5EDD8),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: AppSizes.p8),
            _MiniStat(
              icon: Icons.route,
              label: '${distance.toStringAsFixed(1)}km',
            ),
            const SizedBox(width: AppSizes.p8),
            _MiniStat(icon: Icons.schedule, label: '$estimatedTime分'),
          ],
        ),
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final IconData icon;
  final String label;

  const _MiniStat({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: const Color(0xFFC8A97A)),
        const SizedBox(width: 3),
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFFC8A97A),
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _EmptyPreviewMessage extends StatelessWidget {
  const _EmptyPreviewMessage();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'スポットを解析中...',
        style: TextStyle(
          color: Color(0xFFC8A97A),
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

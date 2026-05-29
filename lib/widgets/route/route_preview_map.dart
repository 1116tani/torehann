// lib/widgets/route/route_preview_map.dart

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../constants/app_sizes.dart';
import '../../models/route_model.dart';
import '../../models/spot_model.dart';
import '../../services/directions_service.dart';

class RoutePreviewMap extends ConsumerStatefulWidget {
  final RouteModel route;
  final Map<String, SpotModel> spots;
  final bool isSelected;
  final double height;
  final bool showDetails;

  const RoutePreviewMap({
    super.key,
    required this.route,
    required this.spots,
    this.isSelected = false,
    this.height = 110,
    this.showDetails = false,
  });

  @override
  ConsumerState<RoutePreviewMap> createState() => _RoutePreviewMapState();
}

class _RoutePreviewMapState extends ConsumerState<RoutePreviewMap> {
  List<LatLng> _routeLine = const [];

  List<SpotModel> get _routeSpots {
    return widget.route.spotIds
        .map((spotId) => widget.spots[spotId])
        .whereType<SpotModel>()
        .toList(growable: false);
  }

  @override
  void initState() {
    super.initState();
    _fetchPreviewRoute();
  }

  @override
  void didUpdateWidget(covariant RoutePreviewMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.route.id != widget.route.id ||
        oldWidget.route.spotIds.join(',') != widget.route.spotIds.join(',')) {
      _fetchPreviewRoute();
    }
  }

  Future<void> _fetchPreviewRoute() async {
    final routeSpots = _routeSpots;
    if (routeSpots.length < 2) {
      if (mounted) setState(() => _routeLine = const []);
      return;
    }

    final origin = LatLng(routeSpots.first.lat, routeSpots.first.lng);
    final destination = LatLng(routeSpots.last.lat, routeSpots.last.lng);
    final waypoints = routeSpots
        .sublist(1, routeSpots.length - 1)
        .map((spot) => LatLng(spot.lat, spot.lng))
        .toList(growable: false);

    final points = await ref
        .read(directionsServiceProvider)
        .getDirectionsRoute(
          origin: origin,
          destination: destination,
          waypoints: waypoints,
        );

    if (!mounted) return;
    setState(() => _routeLine = points);
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
        height: widget.height,
        decoration: BoxDecoration(
          color: const Color(0xFF2C2318),
          border: Border.all(
            color: widget.isSelected
                ? const Color(0xFFB8860B)
                : const Color(0xFFC8A97A),
            width: widget.isSelected ? 1.5 : 0.5,
          ),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(
                painter: _RoutePreviewPainter(
                  spots: routeSpots,
                  routeLine: _routeLine,
                  isSelected: widget.isSelected,
                ),
              ),
            ),
            if (widget.showDetails) ...[
              Positioned(
                top: AppSizes.p8,
                left: AppSizes.p8,
                child: _MapBadge(
                  icon: Icons.explore,
                  label: 'ROUTE PREVIEW',
                  isActive: widget.isSelected,
                ),
              ),
              Positioned(
                top: AppSizes.p8,
                right: AppSizes.p8,
                child: _MapBadge(
                  icon: Icons.place,
                  label: '${routeSpots.length} SPOTS',
                  isActive: widget.isSelected,
                ),
              ),
            ],
            if (routeSpots.isEmpty) const _EmptyPreviewMessage(),
            if (widget.showDetails)
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: _RouteSummaryStrip(
                  distance: widget.route.totalDistance,
                  estimatedTime: widget.route.estimatedTime,
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
  final List<LatLng> routeLine;
  final bool isSelected;

  const _RoutePreviewPainter({
    required this.spots,
    required this.routeLine,
    required this.isSelected,
  });

  @override
  void paint(Canvas canvas, Size size) {
    _drawBackground(canvas, size);

    final projected = _projectPoints(size);
    if (projected.pinPoints.isEmpty) {
      _drawEmptyPath(canvas, size);
      return;
    }

    _drawRouteLine(canvas, projected.routePoints);
    _drawPins(canvas, projected.pinPoints);
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

    final minorRoadPaint = Paint()
      ..color = const Color(0xFFF5EDD8).withValues(alpha: 0.08)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    for (var y = size.height * 0.22; y < size.height; y += 24) {
      canvas.drawLine(
        Offset(-20, y),
        Offset(size.width + 18, y - size.height * 0.12),
        minorRoadPaint,
      );
    }
    for (var x = size.width * 0.12; x < size.width; x += 46) {
      canvas.drawLine(
        Offset(x, -18),
        Offset(x + size.width * 0.12, size.height + 18),
        minorRoadPaint,
      );
    }

    final mainRoadPaint = Paint()
      ..color = const Color(0xFFC8A97A).withValues(alpha: 0.13)
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      Offset(-16, size.height * 0.72),
      Offset(size.width + 16, size.height * 0.44),
      mainRoadPaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.22, size.height + 18),
      Offset(size.width * 0.72, -12),
      mainRoadPaint,
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
    if (points.isEmpty) return;
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
      ..color = const Color(0xFF34F26A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
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

  _ProjectedRoute _projectPoints(Size size) {
    if (spots.isEmpty) {
      return const _ProjectedRoute(routePoints: [], pinPoints: []);
    }
    if (spots.length == 1) {
      final center = Offset(size.width / 2, size.height / 2);
      return _ProjectedRoute(routePoints: [center], pinPoints: [center]);
    }

    final allPoints = <LatLng>[
      ...spots.map((spot) => LatLng(spot.lat, spot.lng)),
      ...routeLine,
    ];

    final centerLat =
        allPoints.map((point) => point.latitude).reduce((a, b) => a + b) /
        allPoints.length;
    final centerLng =
        allPoints.map((point) => point.longitude).reduce((a, b) => a + b) /
        allPoints.length;
    const metersPerLat = 111320.0;
    final metersPerLng =
        111320.0 * math.cos(centerLat * math.pi / 180).abs().clamp(0.2, 1.0);

    final meterPoints = allPoints
        .map((point) {
          return Offset(
            (point.longitude - centerLng) * metersPerLng,
            -(point.latitude - centerLat) * metersPerLat,
          );
        })
        .toList(growable: false);

    final minX = meterPoints.map((point) => point.dx).reduce(math.min);
    final maxX = meterPoints.map((point) => point.dx).reduce(math.max);
    final minY = meterPoints.map((point) => point.dy).reduce(math.min);
    final maxY = meterPoints.map((point) => point.dy).reduce(math.max);

    const padding = 24.0;
    final drawableWidth = math.max(1.0, size.width - padding * 2);
    final drawableHeight = math.max(1.0, size.height - padding * 2 - 12);
    final meterWidth = math.max(1.0, maxX - minX);
    final meterHeight = math.max(1.0, maxY - minY);
    final scale = math.min(
      drawableWidth / meterWidth,
      drawableHeight / meterHeight,
    );
    final usedWidth = meterWidth * scale;
    final usedHeight = meterHeight * scale;
    final offsetX = (size.width - usedWidth) / 2;
    final offsetY = (size.height - usedHeight) / 2;

    Offset project(LatLng point) {
      final meterX = (point.longitude - centerLng) * metersPerLng;
      final meterY = -(point.latitude - centerLat) * metersPerLat;

      return Offset(
        offsetX + (meterX - minX) * scale,
        offsetY + (meterY - minY) * scale,
      );
    }

    final pinPoints = spots
        .map((spot) => project(LatLng(spot.lat, spot.lng)))
        .toList(growable: false);
    final routePoints =
        (routeLine.length >= 2
                ? routeLine
                : spots.map((spot) => LatLng(spot.lat, spot.lng)))
            .map(project)
            .toList(growable: false);

    return _ProjectedRoute(routePoints: routePoints, pinPoints: pinPoints);
  }

  @override
  bool shouldRepaint(covariant _RoutePreviewPainter oldDelegate) {
    return oldDelegate.spots != spots ||
        oldDelegate.routeLine != routeLine ||
        oldDelegate.isSelected != isSelected;
  }
}

class _ProjectedRoute {
  final List<Offset> routePoints;
  final List<Offset> pinPoints;

  const _ProjectedRoute({required this.routePoints, required this.pinPoints});
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

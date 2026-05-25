// lib/models/health_model.dart

class HealthModel {
  final int steps;
  final double distanceKm;
  final int calories;
  final int activeMinutes;
  final DateTime date;

  const HealthModel({
    required this.steps,
    required this.distanceKm,
    required this.calories,
    required this.activeMinutes,
    required this.date,
  });

  HealthModel copyWith({
    int? steps,
    double? distanceKm,
    int? calories,
    int? activeMinutes,
    DateTime? date,
  }) {
    return HealthModel(
      steps: steps ?? this.steps,
      distanceKm: distanceKm ?? this.distanceKm,
      calories: calories ?? this.calories,
      activeMinutes: activeMinutes ?? this.activeMinutes,
      date: date ?? this.date,
    );
  }
}

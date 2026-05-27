// lib/models/health/health_record_model.dart

class HealthRecordModel {
  final DateTime date;
  final int steps;
  final double distanceKm;
  final int calories;

  const HealthRecordModel({
    required this.date,
    required this.steps,
    required this.distanceKm,
    required this.calories,
  });
}

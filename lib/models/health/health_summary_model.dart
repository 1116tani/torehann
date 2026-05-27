// lib/models/health/health_summary_model.dart

class HealthSummaryModel {
  final int totalSteps;
  final double totalDistanceKm;
  final int totalCalories;

  const HealthSummaryModel({
    required this.totalSteps,
    required this.totalDistanceKm,
    required this.totalCalories,
  });
}

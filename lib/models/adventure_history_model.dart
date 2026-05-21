class AdventureHistoryModel {
  final String id;
  final String themeName;
  final String themeDescription;
  final double totalDistance;
  final int estimatedTime;
  final String aiReport;
  final List<String> imageUrls;
  final DateTime createdAt;

  const AdventureHistoryModel({
    required this.id,
    required this.themeName,
    required this.themeDescription,
    required this.totalDistance,
    required this.estimatedTime,
    required this.aiReport,
    required this.imageUrls,
    required this.createdAt,
  });
}

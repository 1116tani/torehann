import '../models/health_model.dart';

class HealthDummyData {
  // 今日のデータ
  static final HealthModel todayData = HealthModel(
    steps: 8240,
    distanceKm: 6.4,
    calories: 412,
    activeMinutes: 78,
    date: DateTime.now(),
  );

  // 週間歩数
  static final List<double> weeklySteps = [
    4200,
    6800,
    7200,
    8100,
    5300,
    9100,
    8240,
  ];

  // 月間歩数
  static final List<double> monthlySteps = [
    5200,
    6400,
    7200,
    8500,
    7900,
    10200,
    9300,
    7000,
    6800,
    8800,
  ];

  // 年間歩数
  static final List<double> yearlySteps = [
    120000,
    142000,
    131000,
    165000,
    172000,
    181000,
    176000,
    168000,
    149000,
    158000,
    162000,
    170000,
  ];
}
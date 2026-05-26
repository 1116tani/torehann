//lib/services/health_service.dart
import '../models/health_model.dart';
import '../utils/health_dummy_data.dart';

class HealthService {
  // 今日の健康データを取得
  Future<HealthModel> fetchTodayHealth() async {
    await Future.delayed(const Duration(milliseconds: 500));

    return HealthDummyData.todayData;
  }

  // 週間データ取得
  Future<List<double>> fetchWeeklySteps() async {
    await Future.delayed(const Duration(milliseconds: 400));

    return HealthDummyData.weeklySteps;
  }

  // 月間データ取得
  Future<List<double>> fetchMonthlySteps() async {
    await Future.delayed(const Duration(milliseconds: 400));

    return HealthDummyData.monthlySteps;
  }

  // 年間データ取得
  Future<List<double>> fetchYearlySteps() async {
    await Future.delayed(const Duration(milliseconds: 400));

    return HealthDummyData.yearlySteps;
  }
}
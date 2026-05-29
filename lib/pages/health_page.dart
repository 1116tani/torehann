//lib/pages/health_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/health_provider.dart';
import '../providers/settings_provider.dart';
import '../../widgets/health/health_widgets.dart';
import '../widgets/common/custom_header.dart';

class HealthPage extends ConsumerWidget {
  const HealthPage({super.key});
  static const _scaffoldBackground = Color(0xFF1C1610);
  static const _titleColor = Color(0xFFF5EDD8);
  static const _defaultPadding = EdgeInsets.all(16);
  static const _sectionTitleStyle = TextStyle(
    color: _titleColor,
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final health = ref.watch(healthProvider.select((value) => value.health));
    final selectedPeriod = ref.watch(healthProvider.select((value) => value.selectedPeriod));
    final graphData = ref.watch(healthProvider.select((value) => value.graphData));
    final summary = ref.watch(healthProvider.select((value) => value.summary));
    final topics = ref.watch(healthProvider.select((value) => value.topics));
    final notifier = ref.read(healthProvider.notifier);

    final dailyStepGoal = ref.watch(settingsProvider.select((value) => value.dailyStepGoal));
    final dailyDistanceGoal = ref.watch(settingsProvider.select((value) => value.dailyGoalKm));
    final stepGoal = dailyStepGoal > 0 ? dailyStepGoal : 10000;
    final distanceGoal = dailyDistanceGoal > 0 ? dailyDistanceGoal : 8.0;
    const calorieGoal = 500.0;

    final stepProgress = (health.steps / stepGoal).clamp(0.0, 1.0);
    final distanceProgress = (health.distanceKm / distanceGoal).clamp(0.0, 1.0);
    final calorieProgress = (health.calories / calorieGoal).clamp(0.0, 1.0);

    // 冒険エネルギーの計算 (歩数目標の進捗に基づき算出)
    final energy = (stepProgress * 100).toInt();
    String energyMessage;
    if (energy >= 100) {
      energyMessage = 'エネルギー満タン！新しいエリアへ冒険に出発できます！';
    } else if (energy >= 60) {
      energyMessage = '順調にエネルギーが溜まっています。この調子で進みましょう！';
    } else if (energy >= 20) {
      energyMessage = '少しずつエネルギーがチャージされています。もう少し歩きましょう！';
    } else {
      energyMessage = 'まだ冒険エネルギーが少ないようです。歩いてチャージしましょう！';
    }

    return Scaffold(
      backgroundColor: _scaffoldBackground,
      body: SafeArea(
        child: Column(
          children: [
            const CustomHeader(
              title: '健康管理',
              subtitle: 'HEALTH MANAGEMENT',
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: _defaultPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
              HealthPeriodTab(
                selectedPeriod: selectedPeriod,
                onChanged: notifier.changePeriod,
              ),
              const SizedBox(height: 20),
              HealthEnergyBanner(
                energy: energy,
                message: energyMessage,
              ),
              const SizedBox(height: 24),
              Center(
                child: HealthRingChart(
                  stepProgress: stepProgress,
                  distanceProgress: distanceProgress,
                  calorieProgress: calorieProgress,
                ),
              ),
              const SizedBox(height: 32),
              const Text('今日の詳細情報', style: _sectionTitleStyle),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: HealthRecordCard(
                      title: '歩いた距離',
                      value: '${health.distanceKm.toStringAsFixed(1)} km',
                      subtitle: '今日の冒険距離',
                      icon: Icons.route,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: HealthRecordCard(
                      title: '消費カロリー',
                      value: '${health.calories} kcal',
                      subtitle: '消費エネルギー',
                      icon: Icons.local_fire_department,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              HealthRecordCard(
                title: 'アクティブ時間',
                value: '${health.activeMinutes} 分',
                subtitle: 'しっかり歩いた時間',
                icon: Icons.timer,
              ),
              const SizedBox(height: 32),
              const Text('期間の合計統計', style: _sectionTitleStyle),
              const SizedBox(height: 14),
              HealthSummaryRow(
                steps: summary.totalSteps,
                distanceKm: summary.totalDistanceKm,
                calories: summary.totalCalories,
              ),
              const SizedBox(height: 32),
              const Text('歩数グラフ', style: _sectionTitleStyle),
              const SizedBox(height: 14),
              HealthBarChart(values: graphData),
              const SizedBox(height: 32),
              const Text('獲得した記録', style: _sectionTitleStyle),
              const SizedBox(height: 14),
              ...topics.map((topic) => HealthTopicCard(topic: topic)),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
          ],
        ),
      ),
    );
  }
}

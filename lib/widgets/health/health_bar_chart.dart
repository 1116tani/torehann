//lib/widgets/health/health_bar_chart.dart
import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

class HealthBarChart extends StatelessWidget {
  final List<double> values;

  const HealthBarChart({
    super.key,
    required this.values,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final maxValue = values.reduce((a, b) => a > b ? a : b);

    return Container(
      height: 220,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: values.map((value) {
          final ratio = value / maxValue;

          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    height: 140 * ratio,
                    decoration: BoxDecoration(
                      color: colors.primary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    value.toInt().toString(),
                    style: TextStyle(
                      color: colors.secondary,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
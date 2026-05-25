// lib/widgets/health/health_period_tab.dart

import 'package:flutter/material.dart';
import '../../providers/health_provider.dart';

class HealthPeriodTab extends StatelessWidget {
  final HealthPeriod selectedPeriod;
  final Function(HealthPeriod) onChanged;

  const HealthPeriodTab({
    super.key,
    required this.selectedPeriod,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2318),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF5C4033),
          width: 0.6,
        ),
      ),

      child: Row(
        children: HealthPeriod.values.map((period) {
          final isSelected = selectedPeriod == period;

          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(period),

              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),

                padding: const EdgeInsets.symmetric(vertical: 10),

                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFFB8860B)
                      : Colors.transparent,

                  borderRadius: BorderRadius.circular(12),

                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: const Color(
                              0xFFB8860B,
                            ).withValues(alpha: 0.25),
                            blurRadius: 8,
                          ),
                        ]
                      : null,
                ),

                child: Text(
                  _label(period),
                  textAlign: TextAlign.center,

                  style: TextStyle(
                    color: isSelected
                        ? Colors.white
                        : const Color(0xFFC8A97A),

                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  String _label(HealthPeriod period) {
    return switch (period) {
      HealthPeriod.day => '日',
      HealthPeriod.week => '週',
      HealthPeriod.month => '月',
      HealthPeriod.year => '年',
    };
  }
}
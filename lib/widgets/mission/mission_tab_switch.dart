// lib/widgets/mission/mission_tab_switch.dart

import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../models/mission_model.dart';

class MissionTabSwitch extends StatelessWidget {
  final MissionType currentTab;
  final Function(MissionType) onChanged;

  const MissionTabSwitch({
    super.key,
    required this.currentTab,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colors.border,
          width: 0.5,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: _TabButton(
              title: 'デイリー',
              subtitle: 'DAILY',
              isSelected: currentTab == MissionType.daily,
              onTap: () => onChanged(MissionType.daily),
            ),
          ),

          Expanded(
            child: _TabButton(
              title: 'ウィークリー',
              subtitle: 'WEEKLY',
              isSelected: currentTab == MissionType.weekly,
              onTap: () => onChanged(MissionType.weekly),
            ),
          ),
        ],
      ),
    );
  }
}

/// ── タブボタン ──────────────────────────
class _TabButton extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabButton({
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? colors.secondary.withValues(alpha: 0.15)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? colors.secondary.withValues(alpha: 0.55)
                : Colors.transparent,
            width: 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: TextStyle(
                color: isSelected
                    ? Colors.white
                    : colors.secondary,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 2),

            Text(
              subtitle,
              style: TextStyle(
                color: isSelected
                    ? Colors.white70
                    : colors.textMuted,
                fontSize: 11,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
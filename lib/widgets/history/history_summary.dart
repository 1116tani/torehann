// lib/widgets/history/history_summary.dart

import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_sizes.dart';

class HistorySummary extends StatelessWidget {
  final int totalCount;
  final double totalDistanceKm;

  const HistorySummary({
    super.key,
    required this.totalCount,
    required this.totalDistanceKm,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Container(
      margin: const EdgeInsets.fromLTRB(
        AppSizes.p16,
        AppSizes.p12,
        AppSizes.p16,
        AppSizes.p8,
      ),

      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.p20,
        vertical: AppSizes.p20,
      ),

      decoration: BoxDecoration(
        color: colors.surface,

        borderRadius: BorderRadius.circular(20),

        border: Border.all(
          color: colors.border,
          width: 1,
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.35),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        children: [
          // ── タイトル ──
          Text(
            'ADVENTURE LOG',

            style: TextStyle(
              color: colors.primary,
              fontSize: 14,
              fontWeight: FontWeight.bold,
              letterSpacing: 2.4,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            '冒険の軌跡',

            style: TextStyle(
              color: colors.textPrimary,
              fontSize: 13.5,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
            ),
          ),

          const SizedBox(height: 20),

          // ── サマリー本体 ──
          Row(
            children: [
              Expanded(
                child: _SummaryItem(
                  icon: Icons.auto_stories_rounded,
                  label: 'これまでの冒険',
                  value: '$totalCount',
                  unit: '回',
                ),
              ),

              Container(
                width: 1,
                height: 56,
                color: colors.divider,
              ),

              Expanded(
                child: _SummaryItem(
                  icon: Icons.route_rounded,
                  label: '総歩行距離',
                  value: totalDistanceKm
                      .toStringAsFixed(2),
                  unit: 'km',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────

class _SummaryItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String unit;

  const _SummaryItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Column(
      children: [
        Icon(
          icon,
          size: 24,
          color: colors.primary,
        ),

        const SizedBox(height: 8),

        Text(
          label,

          style: TextStyle(
            color: colors.textPrimary,
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.8,
          ),
        ),

        const SizedBox(height: 6),

        Row(
          mainAxisAlignment:
              MainAxisAlignment.center,

          crossAxisAlignment:
              CrossAxisAlignment.end,

          children: [
            Text(
              value,

              style: TextStyle(
                color: colors.textPrimary,
                fontSize: 28,
                fontWeight: FontWeight.bold,
                height: 1,
              ),
            ),

            const SizedBox(width: 4),

            Padding(
              padding:
                  const EdgeInsets.only(
                bottom: 3,
              ),

              child: Text(
                unit,

                style: TextStyle(
                  color: colors.secondary,
                  fontSize: 13,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
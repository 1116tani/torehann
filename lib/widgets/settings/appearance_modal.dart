// lib/widgets/settings/appearance_modal.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../constants/app_colors.dart';
import '../../providers/settings_provider.dart';
import 'base_dialog.dart';

class AppearanceModal extends ConsumerWidget {
  const AppearanceModal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);
    final colors = AppColors.of(context);

    return BaseDialog(
      title: '👁️ 見た目の設定',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── マップスタイル ──
          Text(
            'マップスタイル',
            style: TextStyle(
              color: colors.secondary,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          _buildSegmentedControl<String>(
            colors: colors,
            currentValue: settings.mapStyle,
            options: [
              {'value': 'game', 'label': 'ゲーム風'},
              {'value': 'satellite', 'label': '航空写真'},
              {'value': 'terrain', 'label': '地形'},
            ],
            onChanged: notifier.setMapStyle,
          ),
          const SizedBox(height: 24),

          // ── 文字サイズ ──
          Text(
            '文字サイズ',
            style: TextStyle(
              color: colors.secondary,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          _buildSegmentedControl<String>(
            colors: colors,
            currentValue: settings.textSize,
            options: [
              {'value': 'small', 'label': '小'},
              {'value': 'medium', 'label': 'デフォルト'},
              {'value': 'large', 'label': '大'},
            ],
            onChanged: notifier.setTextSize,
          ),
          const SizedBox(height: 24),

          // ── アプリテーマ ──
          Text(
            'アプリテーマ',
            style: TextStyle(
              color: colors.secondary,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          _buildSegmentedControl<String>(
            colors: colors,
            currentValue: settings.themeMode == 'daylight'
                ? 'daylight'
                : 'adventure',
            options: [
              {'value': 'adventure', 'label': 'ダーク'},
              {'value': 'daylight', 'label': 'ライト'},
            ],
            onChanged: notifier.setThemeMode,
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildSegmentedControl<T>({
    required AppColors colors,
    required T currentValue,
    required List<Map<String, dynamic>> options,
    required ValueChanged<T> onChanged,
  }) {
    return Row(
      children: options.map((opt) {
        final isSelected = currentValue == opt['value'];
        final fillColor = isSelected ? colors.primary : colors.surface;
        final borderColor = isSelected ? colors.primary : colors.border;
        final textColor = isSelected ? colors.surface : colors.textPrimary;
        return Expanded(
          child: GestureDetector(
            onTap: () => onChanged(opt['value'] as T),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: fillColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: borderColor),
              ),
              child: Center(
                child: Text(
                  opt['label'] as String,
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

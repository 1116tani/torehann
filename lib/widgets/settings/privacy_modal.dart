// lib/widgets/settings/privacy_modal.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../constants/app_colors.dart';
import '../../providers/settings_provider.dart';
import 'base_dialog.dart';

class PrivacyModal extends ConsumerWidget {
  const PrivacyModal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = AppColors.of(context);
    final settings = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);

    return BaseDialog(
      title: '🔒 プライバシー設定',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── 写真許可 ──
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colors.surfaceLight,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: colors.border),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '写真の位置情報除去',
                        style: TextStyle(
                          color: colors.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '写真シェア時にGPS座標を自動で除去し、プライバシーを保護します。',
                        style: TextStyle(
                          color: colors.textMuted,
                          fontSize: 12,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Switch(
                  value: settings.photoPermission,
                  onChanged: notifier.setPhotoPermission,
                  activeThumbColor: colors.primary,
                  activeTrackColor: colors.primaryDark,
                  inactiveThumbColor: colors.secondary,
                  inactiveTrackColor: colors.surface,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // ── 位置情報許可 ──
          Text(
            '位置情報のアクセス権限',
            style: TextStyle(color: colors.secondary, fontSize: 14, fontWeight: FontWeight.bold),
          ),          const SizedBox(height: 12),
          _buildRadioTile(
            context: context,
            title: '常に許可 (推奨)',
            value: 'always',
            groupValue: settings.locationPermission,
            onChanged: notifier.setLocationPermission,
          ),
          const SizedBox(height: 8),
          _buildRadioTile(
            context: context,
            title: 'アプリ使用中のみ',
            value: 'whenInUse',
            groupValue: settings.locationPermission,
            onChanged: notifier.setLocationPermission,
          ),
          const SizedBox(height: 8),
          _buildRadioTile(
            context: context,
            title: '許可しない',
            value: 'denied',
            groupValue: settings.locationPermission,
            onChanged: notifier.setLocationPermission,
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildRadioTile({
    required BuildContext context,
    required String title,
    required String value,
    required String groupValue,
    required ValueChanged<String> onChanged,
  }) {
    final colors = AppColors.of(context);
    final isSelected = value == groupValue;
    return InkWell(
      onTap: () => onChanged(value),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? colors.primary.withOpacity(0.12) : colors.surfaceLight,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? colors.primary : colors.border,
            width: 1.0,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                color: isSelected ? colors.primary : colors.textPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: isSelected ? colors.primary : colors.textMuted,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

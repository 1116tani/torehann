// lib/widgets/settings/notification_modal.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../constants/app_colors.dart';
import '../../providers/settings_provider.dart';
import 'base_dialog.dart';

class NotificationModal extends ConsumerWidget {
  const NotificationModal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = AppColors.of(context);
    final settings = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);

    return BaseDialog(
      title: '🔔 通知設定',
      child: Column(
        children: [
          _buildSwitchTile(
            context: context,
            title: '毎日のリマインド',
            subtitle: '「今日も歩こう」通知を受け取ります。',
            value: settings.reminderEnabled,
            onChanged: notifier.setReminderEnabled,
          ),
          const SizedBox(height: 16),
          _buildSwitchTile(
            context: context,
            title: 'バックグラウンド通知',
            subtitle: '冒険中に相棒が面白いものを見つけた時の通知など。',
            value: settings.backgroundNotificationEnabled,
            onChanged: notifier.setBackgroundNotificationEnabled,
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildSwitchTile({
    required BuildContext context,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    final colors = AppColors.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surfaceLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: colors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
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
            value: value,
            onChanged: onChanged,
            activeThumbColor: colors.primary,
            activeTrackColor: colors.primaryDark,
            inactiveThumbColor: colors.secondary,
            inactiveTrackColor: colors.surface,
          ),
        ],
      ),
    );
  }
}

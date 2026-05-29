// lib/widgets/settings/notification_modal.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/settings_provider.dart';
import 'base_dialog.dart';

class NotificationModal extends ConsumerWidget {
  const NotificationModal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);

    return BaseDialog(
      title: '🔔 通知設定',
      child: Column(
        children: [
          _buildSwitchTile(
            title: '毎日のリマインド',
            subtitle: '「今日も歩こう」通知を受け取ります。',
            value: settings.reminderEnabled,
            onChanged: notifier.setReminderEnabled,
          ),
          const SizedBox(height: 16),
          _buildSwitchTile(
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
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1610),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF4A3728)),
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
                  style: const TextStyle(
                    color: Color(0xFFF5EDD8),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Color(0xFF8B7355),
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
            activeThumbColor: const Color(0xFFC8A97A),
            activeTrackColor: const Color(0xFF5C4033),
            inactiveThumbColor: const Color(0xFF7A5C3A),
            inactiveTrackColor: const Color(0xFF1C1610),
          ),
        ],
      ),
    );
  }
}

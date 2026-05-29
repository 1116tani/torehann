// lib/widgets/settings/privacy_modal.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/settings_provider.dart';
import 'base_dialog.dart';

class PrivacyModal extends ConsumerWidget {
  const PrivacyModal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
              color: const Color(0xFF1C1610),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF4A3728)),
            ),
            child: Row(
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '写真の位置情報除去',
                        style: TextStyle(
                          color: Color(0xFFF5EDD8),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '写真シェア時にGPS座標を自動で除去し、プライバシーを保護します。',
                        style: TextStyle(
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
                  value: settings.photoPermission,
                  onChanged: notifier.setPhotoPermission,
                  activeThumbColor: const Color(0xFFC8A97A),
                  activeTrackColor: const Color(0xFF5C4033),
                  inactiveThumbColor: const Color(0xFF7A5C3A),
                  inactiveTrackColor: const Color(0xFF1C1610),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // ── 位置情報許可 ──
          const Text(
            '位置情報のアクセス権限',
            style: TextStyle(color: Color(0xFFC8A97A), fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _buildRadioTile(
            title: '常に許可 (推奨)',
            value: 'always',
            groupValue: settings.locationPermission,
            onChanged: notifier.setLocationPermission,
          ),
          const SizedBox(height: 8),
          _buildRadioTile(
            title: 'アプリ使用中のみ',
            value: 'whenInUse',
            groupValue: settings.locationPermission,
            onChanged: notifier.setLocationPermission,
          ),
          const SizedBox(height: 8),
          _buildRadioTile(
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
    required String title,
    required String value,
    required String groupValue,
    required ValueChanged<String> onChanged,
  }) {
    final isSelected = value == groupValue;
    return InkWell(
      onTap: () => onChanged(value),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFC8A97A).withValues(alpha: 0.1) : const Color(0xFF1C1610),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFFC8A97A) : const Color(0xFF4A3728),
            width: 1.0,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                color: isSelected ? const Color(0xFFC8A97A) : const Color(0xFFF5EDD8),
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: isSelected ? const Color(0xFFC8A97A) : const Color(0xFF7A5C3A),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

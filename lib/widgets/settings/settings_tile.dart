// lib/widgets/settings/settings_tile.dart

import 'package:flutter/material.dart';

class SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String? valueText; // 現在設定されている値を右側に表示（例：「デフォルト」「3.0 km」など）
  final VoidCallback onTap;
  final Color titleColor;

  const SettingsTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.valueText,
    required this.onTap,
    this.titleColor = const Color(0xFFF5EDD8), // 幻想的なオフホワイト
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2318), // 深いダークブラウン
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF4A3728), width: 1.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Container(
            constraints: const BoxConstraints(minHeight: 68), // 大きめタップ領域
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                // 左アイコン (少しファンタジー感のある背景付き)
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1C1610),
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFF5C4033), width: 0.5),
                  ),
                  child: Icon(
                    icon,
                    color: const Color(0xFFC8A97A), // 金色
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                // 中央テキスト
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: titleColor,
                          fontSize: 17, // 大きめ
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          color: Color(0xFF8B7355), // 落ち着いたくすんだブラウン
                          fontSize: 13,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                // 右側 (現在値 + 矢印)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (valueText != null)
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Text(
                          valueText!,
                          style: const TextStyle(
                            color: Color(0xFFC8A97A),
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    const Icon(
                      Icons.chevron_right,
                      color: Color(0xFF7A5C3A),
                      size: 20,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

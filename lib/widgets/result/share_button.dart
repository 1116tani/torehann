// lib/widgets/result/share_button.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ShareButton extends StatelessWidget {
  final String adventureTitle; // シェアするタイトル
  final double distanceKm; // 距離
  final int durationMinutes; // 時間
  final int spotCount; // スポット数

  const ShareButton({
    super.key,
    required this.adventureTitle,
    required this.distanceKm,
    required this.durationMinutes,
    required this.spotCount,
  });

  // シェアするテキストを生成
  String get _shareText {
    return '''
📜 $adventureTitle

🗺️ ${distanceKm.toStringAsFixed(1)}km を冒険しました！
⏱️ $durationMinutes分 / 📍 $spotCount スポット

#TaleTrace #街の記憶 #冒険ログ
''';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ── セクションラベル ──
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _GoldLine(),
            SizedBox(width: 8),
            Text(
              '冒険を記録に残す',
              style: TextStyle(
                color: Color(0xFFC8A97A),
                fontSize: 12,
                letterSpacing: 1,
              ),
            ),
            SizedBox(width: 8),
            _GoldLine(),
          ],
        ),
        const SizedBox(height: 16),

        // ── ボタン2つ横並び ──
        Row(
          children: [
            // SNSシェアボタン
            Expanded(
              child: _ActionButton(
                icon: Icons.share,
                label: 'シェアする',
                color: const Color(0xFF2D5A3D),
                borderColor: const Color(0xFF57D6C9),
                onTap: () => _onShare(context),
              ),
            ),
            const SizedBox(width: 12),

            // クリップボードコピーボタン
            Expanded(
              child: _ActionButton(
                icon: Icons.copy,
                label: 'コピー',
                color: const Color(0xFF3D2B1F),
                borderColor: const Color(0xFFC8A97A),
                onTap: () => _onCopy(context),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // ── 画像として保存ボタン（全幅） ──
        _ActionButton(
          icon: Icons.download,
          label: '冒険ログを保存する',
          color: const Color(0xFFB8860B),
          borderColor: const Color(0xFFB8860B),
          isFullWidth: true,
          onTap: () => _onSave(context),
        ),
      ],
    );
  }

  // ── シェア処理 ──
  void _onShare(BuildContext context) {
    // TODO: share_plus パッケージで本実装
    // Share.share(_shareText);

    // ハッカソン時はSnackBarで代用
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('シェア内容：\n$_shareText'),
        duration: const Duration(seconds: 3),
        backgroundColor: const Color(0xFF2D5A3D),
      ),
    );
  }

  // ── コピー処理 ──
  void _onCopy(BuildContext context) {
    Clipboard.setData(ClipboardData(text: _shareText));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('📋 クリップボードにコピーしました！'),
        duration: Duration(seconds: 2),
        backgroundColor: Color(0xFF3D2B1F),
      ),
    );
  }

  // ── 保存処理 ──
  void _onSave(BuildContext context) {
    // TODO: screenshot パッケージで本実装
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('💾 冒険ログを保存しました！（Tier A以降で実装）'),
        duration: Duration(seconds: 2),
        backgroundColor: Color(0xFFB8860B),
      ),
    );
  }
}

// ── アクションボタン共通パーツ ────────────────
class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final Color borderColor;
  final bool isFullWidth;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.borderColor,
    required this.onTap,
    this.isFullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: isFullWidth ? double.infinity : null,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor, width: 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16, color: Colors.white),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── 装飾ライン ──────────────────────────────
class _GoldLine extends StatelessWidget {
  const _GoldLine();

  @override
  Widget build(BuildContext context) {
    return Container(width: 40, height: 0.5, color: const Color(0xFFC8A97A));
  }
}

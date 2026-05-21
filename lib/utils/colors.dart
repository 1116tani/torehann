// lib/utils/colors.dart
import 'package:flutter/material.dart';

class AppColors {
  // ── ✨ メインカラー（セピア・ゴールド） ──
  static const Color primary = Color(0xFFC8A97A); // 高貴なアンティークゴールド（メイン）
  static const Color primaryDark = Color(0xFFB8860B); // 深みのあるダークゴールド
  static const Color primaryLight = Color(0xFFF5EDD8); // 羊皮紙のような温かみのある白（ハイライト）

  // ── 🏰 背景色（ダークセピア・ウッド） ──
  static const Color background = Color(0xFF2C2318); // 探索画面のベースになる濃い木色・闇色
  static const Color surface = Color(0xFF3D2B1F); // カード等で1段浮き上がらせるセピアブラウン
  static const Color border = Color(0xFF4A3728); // 枠線や区切り線に使うヴィンテージな茶色

  // ── 📜 文字色 ──
  static const Color textPrimary = Color(0xFFF5EDD8); // 読みやすい羊皮紙ホワイト
  static const Color textSecondary = Color(0xFF9E8465); // 落ち着いたセピアブラウン
  static const Color textMuted = Color(0xFF7A5C3A); // 補足説明や暗めの装飾テキスト

  // ── 🔮 特殊エフェクト用 ──
  static const Color glassSurface = Color(0x22FFFFFF); // ガラスエフェクト用の半透明白
  static const Color iconActive = Color(0xFFF5EDD8); // アクティブなアイコン
  static const Color iconDisabled = Color(0xFF7A5C3A); // 未開放メニュー等のアイコン
}

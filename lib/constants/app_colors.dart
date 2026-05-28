// lib/constants/app_colors.dart

import 'package:flutter/material.dart';

class AppColors {
  // ─────────────────────────────────
  // 🏰 背景・基盤（ダークセピア・ウッド）
  // ─────────────────────────────────

  /// アプリ全体のベースとなる濃い闇・木色（漆黒の夜）
  static const Color background = Color(0xFF15110D);

  /// 羊皮紙カードやダイアログ等のベースになるセピアブラウン
  static const Color surface = Color(0xFF33271D);

  /// 少し浮かせたいUIや、明るめのウッドパーツ
  static const Color surfaceLight = Color(0xFF463426);

  /// 枠線や区切り線に使うヴィンテージな茶色
  static const Color border = Color(0xFF5C4033);
  static const Color divider = Color(0xFF4A3728);

  // ─────────────────────────────────
  // ✨ メインカラー（アンティークゴールド）
  // ─────────────────────────────────

  /// 高貴なメインの金色（ロゴや重要ボタン用）
  static const Color primary = Color(0xFFD6B06A);

  /// ハイライトや光るエフェクトに使う明るめの金
  static const Color primaryLight = Color(0xFFF6D28F);

  /// 深みのあるダークゴールド（グラデーションの影用）
  static const Color primaryDark = Color(0xFFB8860B);

  /// サブで使う落ち着いたセピアゴールド
  static const Color secondary = Color(0xFFC8A97A);

  /// オトモ吹き出し
  static const Color speechBubble = Color(0xFFF1DFC2);

  /// 吹き出しタイトル
  static const Color speechAccent = Color(0xFFD6B06A);

  /// BottomSheet背景
  static const Color sheetBackground = Color(0xE62A1F18);

  // ─────────────────────────────────
  // 📜 Text Colors
  // 可読性最優先
  // ─────────────────────────────────

  /// メイン文字
  static const Color textPrimary = Color(0xFFF8F5EE);

  /// サブ文字
  static const Color textSecondary = Color(0xFFD2CCC2);

  /// 補助文字
  static const Color textMuted = Color(0xFF9E9689);

  /// 明るい背景上の文字
  static const Color textDark = Color(0xFF1A1A1A);

  /// 押せないボタン・グレーアウト（Tier B以降の機能）
  static const Color disabled = Color(0xFF4A4440);

  /// 無効テキスト
  static const Color textDisabled = Color(0xFF6B6560);

  /// 選択中のモード・気分ボタン背景
  static const Color selectedItem = Color(0xFF4A3520);

  /// 未選択の難易度テキスト（今より明るく）
  static const Color modeTextUnselected = Color(0xFFB8A898);

  /// おまかせ選択時の目的地入力を暗くする色
  static const Color inputDisabledBg = Color(0xFF1E1810);

  // ─────────────────────────────────
  // 🌍 Map / Adventure Accent
  // 地図・冒険感用
  // ─────────────────────────────────

  /// 水・魔力・ルート
  static const Color accentBlue = Color(0xFF6BA8FF);

  /// 成功・アクティブ
  static const Color accentGreen = Color(0xFF57D6C9);

  /// 発見・特殊地点
  static const Color accentPurple = Color(0xFF9D7CFF);

  // ─────────────────────────────────
  // ⚠ Status
  // ─────────────────────────────────

  static const Color success = Color(0xFF62E6B8);

  static const Color warning = Color(0xFFFFC857);

  static const Color error = Color(0xFFFF7B7B);

  // ─────────────────────────────────
  // 🏅 Rank Colors
  // ─────────────────────────────────

  static const Color bronze = Color(0xFFCD7F32);

  static const Color silver = Color(0xFFC0C0C0);

  static const Color gold = Color(0xFFFFD700);

  // ─────────────────────────────────
  // 🌫 Overlay / Glass
  // ─────────────────────────────────

  /// マップ暗転
  static const Color overlayDark = Color(0xAA000000);

  /// 強め暗転
  static const Color overlayHeavy = Color(0xDD000000);

  /// ガラスUI
  static const Color glass = Color(0x18FFFFFF);

  /// ガラス境界線
  static const Color glassBorder = Color(0x33FFFFFF);

  /// 薄い白サーフェス
  static const Color glassSurface = Color(0x10FFFFFF);

  // ─────────────────────────────────
  // 📜 Parchment
  // 絵巻物・Result用
  // ─────────────────────────────────

  /// 羊皮紙
  static const Color parchment = Color(0xFFF3E7C9);

  /// 古い紙
  static const Color parchmentDark = Color(0xFFE0D0AA);

  // ─────────────────────────────────
  // 🌅 Gradients
  // ─────────────────────────────────

  /// ゴールドUI
  static const List<Color> goldGradient = [
    Color(0xFFFFE0A3),
    Color(0xFFD6B06A),
  ];

  /// ダークカード
  static const List<Color> darkGradient = [
    Color(0xFF2A2A2A),
    Color(0xFF171717),
  ];

  /// 魔力・探索
  static const List<Color> adventureGradient = [
    Color(0xFF6BA8FF),
    Color(0xFF57D6C9),
  ];

  /// 危険地帯
  static const List<Color> dangerGradient = [
    Color(0xFFFF7B7B),
    Color(0xFF9E2A2B),
  ];
}

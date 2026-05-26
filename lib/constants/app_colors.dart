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

  // ─────────────────────────────────
  // 📜 文字色（羊皮紙ホワイト＆ブラウン）
  // ─────────────────────────────────

  /// 読みやすい温かみのある白（羊皮紙ホワイト）
  static const Color textPrimary = Color(0xFFF5EDD8);

  /// 落ち着いたセピア調のサブテキスト
  static const Color textSecondary = Color(0xFFE0C79A);

  /// 補足説明や暗めの装飾用テキスト
  static const Color textMuted = Color(0xFFA68B6B);

  /// 明るい背景（ゴールドや羊皮紙の上）に載せるための暗い文字色
  static const Color textDark = Color(0xFF2B1D14);

  // ─────────────────────────────────
  // 🔮 特殊エフェクト・UIカラー
  // ─────────────────────────────────

  /// 🌟 これがデモ画面の鍵！美しすぎるガラスエフェクト用の半透明白
  static const Color glass = Color(0x66FFFFFF);
  static const Color glassSurface = Color(0x22FFFFFF);

  /// 地図を夜っぽく・暗転させるためのマスク
  static const Color overlayDark = Color(0x99000000);
  static const Color overlayHeavy = Color(0xCC000000);

  /// 羊皮紙そのものの温かいスキン色
  static const Color parchment = Color(0xFFF3E7C9);

  // ─────────────────────────────────
  // 🏅 冒険者ランク・ステータス
  // ─────────────────────────────────

  /// フレンド画面でも使われている「冒険中」や「成功」のルミナスグリーン
  static const Color success = Color(0xFF57D6C9);

  /// 注意・警告
  static const Color warning = Color(0xFFFFB347);

  /// エラー（危険地帯・マナ不足など）
  static const Color error = Color(0xFFE57373);

  /// 実績・バッジ用の三種の神器カラー
  static const Color bronze = Color(0xFFCD7F32);
  static const Color silver = Color(0xFFC0C0C0);
  static const Color gold = Color(0xFFFFD700);

  // ─────────────────────────────────
  // 💎 魔法のグラデーション
  // ─────────────────────────────────

  /// レアお宝やリザルト画面で大活躍するゴールドグラデーション
  static const List<Color> goldGradient = [
    Color(0xFFF6D28F),
    Color(0xFFD6B06A),
  ];

  /// ダークUIに奥行きを出すためのウッドグラデーション
  static const List<Color> darkGradient = [
    Color(0xFF463426),
    Color(0xFF2B1D14),
  ];
}
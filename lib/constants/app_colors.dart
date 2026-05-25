// lib/constants/app_colors.dart

import 'package:flutter/material.dart';

class AppColors {
  // ─────────────────────────────────
  // 背景
  // ─────────────────────────────────

  /// アプリ全体の背景
  static const background = Color(0xFF15110D);

  /// カード・ボトムシート
  static const surface = Color(0xFF33271D);

  /// 少し浮かせたいUI
  static const surfaceLight = Color(0xFF463426);

  /// ガラス風
  static const glass = Color(0x66FFFFFF);

  // ─────────────────────────────────
  // メインカラー
  // ─────────────────────────────────

  /// メインの金色
  static const primary = Color(0xFFD6B06A);

  /// 明るめの金
  static const primaryLight = Color(0xFFF6D28F);

  /// サブカラー
  static const secondary = Color(0xFFC8A97A);

  // ─────────────────────────────────
  // テキスト
  // ─────────────────────────────────

  /// メイン文字
  static const textPrimary = Color(0xFFF5EDD8);

  /// サブ文字
  static const textSecondary = Color(0xFFE0C79A);

  /// 補助文字
  static const textMuted = Color(0xFFA68B6B);

  /// 暗背景用
  static const textDark = Color(0xFF2B1D14);

  // ─────────────────────────────────
  // ボーダー
  // ─────────────────────────────────

  static const border = Color(0xFF5C4033);

  static const divider = Color(0xFF4A3728);

  // ─────────────────────────────────
  // 状態カラー
  // ─────────────────────────────────

  /// 成功・探索
  static const success = Color(0xFF57D6C9);

  /// 注意
  static const warning = Color(0xFFFFB347);

  /// エラー
  static const error = Color(0xFFE57373);

  // ─────────────────────────────────
  // ランクカラー
  // ─────────────────────────────────

  static const bronze = Color(0xFFCD7F32);

  static const silver = Color(0xFFC0C0C0);

  static const gold = Color(0xFFFFD700);

  // ─────────────────────────────────
  // 特殊カラー
  // ─────────────────────────────────

  /// 羊皮紙っぽい色
  static const parchment = Color(0xFFF3E7C9);

  /// 地図暗転用
  static const overlayDark = Color(0x99000000);

  /// 強め暗転
  static const overlayHeavy = Color(0xCC000000);

  // ─────────────────────────────────
  // グラデーション
  // ─────────────────────────────────

  static const List<Color> goldGradient = [
    Color(0xFFF6D28F),
    Color(0xFFD6B06A),
  ];

  static const List<Color> darkGradient = [
    Color(0xFF463426),
    Color(0xFF2B1D14),
  ];
}
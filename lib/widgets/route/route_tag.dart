// lib/widgets/route/route_tag.dart

import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';

enum RouteTagType {
  standard, // 基本のタグ
  mood, // 気分（楽しい、落ち着く）
  difficulty, // 難易度
}

class RouteTag extends StatelessWidget {
  final String label;
  final RouteTagType type; // 種類を追加！

  const RouteTag({
    super.key,
    required this.label,
    this.type = RouteTagType.standard, // デフォルトはstandard
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    // タイプに合わせて色を出し分ける
    Color borderColor;
    Color backgroundColor;
    Color textColor;

    switch (type) {
      case RouteTagType.mood:
        borderColor = colors.secondary; // ゴールド系
        backgroundColor = colors.surfaceLight;
        textColor = colors.secondary;
        break;
      case RouteTagType.difficulty:
        borderColor = colors.primary; // 少し強い色
        backgroundColor = colors.surface;
        textColor = colors.textPrimary;
        break;
      default:
        borderColor = colors.border;
        backgroundColor = Colors.transparent;
        textColor = colors.secondary;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor, width: 0.5),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}


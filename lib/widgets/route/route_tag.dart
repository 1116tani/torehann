// lib/widgets/route/route_tag.dart

import 'package:flutter/material.dart';

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
    // タイプに合わせて色を出し分ける
    Color borderColor;
    Color backgroundColor;
    Color textColor;

    switch (type) {
      case RouteTagType.mood:
        borderColor = const Color(0xFFC8A97A); // ゴールド系
        backgroundColor = const Color(0xFF3D2B1F);
        textColor = const Color(0xFFC8A97A);
        break;
      case RouteTagType.difficulty:
        borderColor = const Color(0xFFB8860B); // 少し強い色
        backgroundColor = const Color(0xFF2C2318);
        textColor = const Color(0xFFFFFFFF);
        break;
      default:
        borderColor = const Color(0xFF7A5C3A);
        backgroundColor = Colors.transparent;
        textColor = const Color(0xFFC8A97A);
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

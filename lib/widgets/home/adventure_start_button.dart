// lib/widgets/home/adventure_start_button.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../router/route_names.dart';
// import '../common/custom_button.dart'; // 💡 今回はこの特大ボタン専用のスタイルにするから使わないよ
import '../../utils/colors.dart';

class AdventureStartButton extends StatelessWidget {
  const AdventureStartButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // 💡 みぃくんが作ってくれた、うっすらと光のオーラをまとわせる魔法はそのまま！
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.2),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFFB300), // ゴールド・オレンジ系
            foregroundColor: const Color(0xFF1C1610), // 文字色（ダークブラウン）
            // 💡 ここがポイント！横幅いっぱい＆縦幅を56pxに太くする！
            minimumSize: const Size(double.infinity, 56),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28),
            ),
            // 💡 光のオーラがあるから、ボタン自体の影（elevation）は0にすると綺麗だよ！
            elevation: 0, 
          ),
          onPressed: () {
            // 💡 みぃくんの書いた画面遷移コードをそのまま活かすよ！
            context.push(AppRoutes.adventureSetting);
          },
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.auto_awesome, size: 22), // 💡 魔法っぽいアイコン！
              SizedBox(width: 8),
              Text(
                '冒険を出発する',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2, // 文字の間隔を少し開けておしゃれに♡
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
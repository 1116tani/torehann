// lib/widgets/home/adventure_start_button.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../router/app_router.dart';
import '../common/custom_button.dart';
import '../../utils/colors.dart';

class AdventureStartButton extends StatelessWidget {
  const AdventureStartButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // 💡 ボタンの周りにうっすらと光のオーラをまとわせる
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
        child: CustomButton(
          text: '冒険を出発する',
          icon: Icons.auto_awesome, // 💡 exploreより少し魔法っぽくしてみたよ
          onPressed: () {
            // 💡 画面遷移の前に「読み込み中」のような演出を入れるとエモいよ
            context.push(AppRoutes.adventureSetting);
          },
        ),
      ),
    );
  }
}

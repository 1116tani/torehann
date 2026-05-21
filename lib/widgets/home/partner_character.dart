// lib/widgets/home/partner_character.dart
import 'package:flutter/material.dart';
import '../common/glass_card.dart';
import '../../utils/colors.dart'; // 💡 AppColorsを忘れずにインポート！

class PartnerCharacter extends StatelessWidget {
  final String characterName;
  final String currentMessage;
  final String imagePath;

  const PartnerCharacter({
    super.key,
    this.characterName = '案内妖精・アイリス', // 💡 ナビAIから、少しファンタジー寄りに♡
    this.currentMessage = '今日はどんな物語を紡ぎに行くの？\n準備はいつでもバッチリだよっ！',
    this.imagePath = '',
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GlassCard(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          borderRadius: 20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                characterName,
                style: TextStyle(
                  color: theme.colorScheme.primary,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                currentMessage,
                style: const TextStyle(
                  color: AppColors.textPrimary, // 💡 ここをセピアホワイトに！
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.primary.withValues(alpha: 0.2),
                    blurRadius: 30,
                    spreadRadius: 5,
                  ),
                ],
              ),
            ),
            imagePath.isEmpty
                ? Icon(
                    Icons.auto_awesome, // 💡 biotech(科学)から、魔法のキラキラに変更したよ！
                    size: 100,
                    color: theme.colorScheme.primary,
                  )
                : Image.asset(
                    imagePath,
                    width: 140,
                    height: 140,
                    fit: BoxFit.contain,
                  ),
          ],
        ),
      ],
    );
  }
}

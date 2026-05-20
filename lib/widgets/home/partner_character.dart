// lib/widgets/home/partner_character.dart
import 'package:flutter/material.dart';
import '../common/glass_card.dart';

class PartnerCharacter extends StatelessWidget {
  final String characterName;
  final String currentMessage;
  final String imagePath;

  const PartnerCharacter({
    super.key,
    this.characterName = 'ナビAI・アイリス',
    this.currentMessage = '今日はどんな冒険に出かける？\n準備はいつでもバッチリだよ！',
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
                  color: Colors.white,
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
                // ⚠️ ここにあった glowColor を消して boxShadow だけにしたよ！
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
                    Icons.biotech,
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

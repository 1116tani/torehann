// lib/widgets/result/adventure_title_card.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/result_model.dart';

class AdventureTitleCard extends StatelessWidget {
  final AdventureResult result;

  const AdventureTitleCard({
    super.key,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    final dateText = DateFormat(
      'yyyy.MM.dd',
    ).format(result.completedAt);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2318),
        border: Border.all(
          color: const Color(0xFF5C4033),
          width: 0.5,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ── 世界観アイコン ─────────────────
          Text(
            result.themeIcon,
            style: const TextStyle(fontSize: 30),
          ),

          const SizedBox(height: 12),

          // ── タイトル ─────────────────────
          Text(
            result.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFFF5EDD8),
              fontSize: 22,
              fontWeight: FontWeight.bold,
              height: 1.4,
            ),
          ),

          const SizedBox(height: 8),

          // ── サブタイトル ─────────────────
          Text(
            result.subTitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFFC8A97A),
              fontSize: 12,
              fontStyle: FontStyle.italic,
              height: 1.6,
            ),
          ),

          const SizedBox(height: 18),

          // ── 日付・天候 ───────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.calendar_month,
                size: 14,
                color: Color(0xFF7A5C3A),
              ),

              const SizedBox(width: 6),

              Text(
                dateText,
                style: const TextStyle(
                  color: Color(0xFF7A5C3A),
                  fontSize: 11,
                ),
              ),

              const SizedBox(width: 14),

              Text(
                result.weather,
                style: const TextStyle(
                  color: Color(0xFFC8A97A),
                  fontSize: 11,
                ),
              ),
            ],
          ),

          // ── フレンド ─────────────────────
          if (result.friends.isNotEmpty) ...[
            const SizedBox(height: 18),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: result.friends.map((friend) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3D2B1F),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFF5C4033),
                      width: 0.5,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        radius: 10,
                        backgroundColor: const Color(0xFFB8860B),

                        backgroundImage: friend.avatarUrl != null
                            ? NetworkImage(friend.avatarUrl!)
                            : null,

                        child: friend.avatarUrl == null
                            ? const Icon(
                                Icons.person,
                                size: 12,
                                color: Colors.white,
                              )
                            : null,
                      ),

                      const SizedBox(width: 6),

                      Text(
                        friend.name,
                        style: const TextStyle(
                          color: Color(0xFFF5EDD8),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }
}
// lib/widgets/result/friend_party_strip.dart

import 'package:flutter/material.dart';

class FriendPartyStrip extends StatelessWidget {
  final List<String> friendNames;

  const FriendPartyStrip({
    super.key,
    required this.friendNames,
  });

  @override
  Widget build(BuildContext context) {
    if (friendNames.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: const Color(0xFF2C2318),

        borderRadius: BorderRadius.circular(22),

        border: Border.all(
          color: const Color(0xFF5C4033),
          width: 0.6,
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── タイトル ───────────────────
          const Row(
            children: [
              Icon(
                Icons.groups_rounded,
                color: Color(0xFFB8860B),
                size: 18,
              ),

              SizedBox(width: 8),

              Text(
                '共に歩いた仲間たち',
                style: TextStyle(
                  color: Color(0xFFF5EDD8),
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          // ── フレンド一覧 ───────────────
          SizedBox(
            height: 72,

            child: ListView.separated(
              scrollDirection: Axis.horizontal,

              itemCount: friendNames.length,

              separatorBuilder: (_, _) =>
                  const SizedBox(width: 14),

              itemBuilder: (context, index) {
                final friend = friendNames[index];

                return _FriendAvatar(
                  name: friend,
                  index: index,
                );
              },
            ),
          ),

          const SizedBox(height: 14),

          // ── 雰囲気テキスト ─────────────
          const Text(
            '足音は重なり、冒険はひとつの物語になった。',
            style: TextStyle(
              color: Color(0xFF7A5C3A),
              fontSize: 11,
              fontStyle: FontStyle.italic,
              height: 1.7,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────
// 👤 フレンドアバター
// ─────────────────────────────────────

class _FriendAvatar extends StatelessWidget {
  final String name;
  final int index;

  const _FriendAvatar({
    required this.name,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final colors = [
      const Color(0xFF57D6C9),
      const Color(0xFFB8860B),
      const Color(0xFFC86B98),
      const Color(0xFF7A8CFF),
      const Color(0xFF78C26A),
    ];

    final accent = colors[index % colors.length];

    return Column(
      children: [
        Container(
          width: 48,
          height: 48,

          decoration: BoxDecoration(
            shape: BoxShape.circle,

            gradient: LinearGradient(
              colors: [
                accent,
                accent.withValues(alpha: 0.6),
              ],
            ),

            boxShadow: [
              BoxShadow(
                color: accent.withValues(alpha: 0.35),
                blurRadius: 10,
              ),
            ],
          ),

          child: Center(
            child: Text(
              _initial,

              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
        ),

        const SizedBox(height: 8),

        SizedBox(
          width: 64,

          child: Text(
            name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,

            style: const TextStyle(
              color: Color(0xFFC8A97A),
              fontSize: 11,
            ),
          ),
        ),
      ],
    );
  }

  String get _initial {
    if (name.isEmpty) return '?';
    return String.fromCharCode(name.runes.first);
  }
}

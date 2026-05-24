// lib/widgets/party/room_id_badge.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RoomIdBadge extends StatelessWidget {
  final String roomId;

  const RoomIdBadge({
    super.key,
    required this.roomId,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 16,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2318),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFB8860B),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFB8860B).withValues(alpha: 0.15),
            blurRadius: 14,
            spreadRadius: 1,
          ),
        ],
      ),

      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'ROOM ID',
            style: TextStyle(
              color: Color(0xFFC8A97A),
              fontSize: 11,
              letterSpacing: 2,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          // ── ルームコード ──
          GestureDetector(
            onTap: () async {
              await Clipboard.setData(
                ClipboardData(text: roomId),
              );

              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('ルームIDをコピーしたよ'),
                    duration: Duration(seconds: 1),
                    backgroundColor: Color(0xFF2C2318),
                  ),
                );
              }
            },

            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFF1C1610),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: const Color(0xFF5C4033),
                  width: 1,
                ),
              ),

              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    roomId,
                    style: const TextStyle(
                      color: Color(0xFFF5EDD8),
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 6,
                    ),
                  ),

                  const SizedBox(width: 10),

                  const Icon(
                    Icons.copy_rounded,
                    color: Color(0xFFC8A97A),
                    size: 18,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 10),

          const Text(
            'タップでコピー',
            style: TextStyle(
              color: Color(0xFF7A5C3A),
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}
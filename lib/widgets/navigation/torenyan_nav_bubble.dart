// lib/widgets/navigation/torenyan_nav_bubble.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants/navigation_ui_constants.dart';
import '../common/torenyan.dart';

enum TorenyanNavMode { moving, offRoute, arrived }

class TorenyanNavBubble extends StatelessWidget {
  final TorenyanNavMode mode;

  const TorenyanNavBubble({super.key, required this.mode});

  String get _message => switch (mode) {
        TorenyanNavMode.moving => 'この道を進めば、物語の続きが見えるよ',
        TorenyanNavMode.offRoute => '道から外れちゃった…戻ろうか',
        TorenyanNavMode.arrived => '着いたね！ここで何か見つかるかも',
      };

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Torenyan(
          size: 56,
          enableTap: false,
          showSpeechBubble: false,
          state: TorenyanState.idle,
        ),
        const SizedBox(width: 6),
        Flexible(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 200),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: NavigationUiConstants.cream,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: NavigationUiConstants.creamBorder),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.12),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              _message,
              style: GoogleFonts.notoSerifJp(
                fontSize: 13,
                color: NavigationUiConstants.textDark,
                height: 1.4,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

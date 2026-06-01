// lib/widgets/navigation/arrival_dialog.dart

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

import '../../constants/navigation_ui_constants.dart';
import '../../models/spot_model.dart';
import '../common/torenyan.dart';

class ArrivalDialog extends StatelessWidget {
  final SpotModel spot;
  final VoidCallback onContinue;
  final bool isLastSpot;

  const ArrivalDialog({
    super.key,
    required this.spot,
    required this.onContinue,
    this.isLastSpot = false,
  });

  @override
  Widget build(BuildContext context) {
    final navConstants = NavigationUiConstants.of(context);
    final title =
        spot.aiStoryName.isNotEmpty ? spot.aiStoryName : spot.name;
    final flavor = spot.aiFlavorText.isNotEmpty
        ? spot.aiFlavorText
        : 'ここで新しい記憶が生まれた。';

    return Dialog(
      backgroundColor: navConstants.cream,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: navConstants.creamBorder,
          width: 1.5,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Torenyan(
              size: 72,
              state: TorenyanState.success,
              enableTap: false,
              showSpeechBubble: false,
            ),
            const SizedBox(height: 16),
            Text('到着！', style: navConstants.serifTitle),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: navConstants.serifBody.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 72,
              child: AnimatedTextKit(
                animatedTexts: [
                  TypewriterAnimatedText(
                    flavor,
                    textStyle: navConstants.serifBody.copyWith(
                      fontStyle: FontStyle.italic,
                    ),
                    speed: const Duration(milliseconds: 40),
                  ),
                ],
                totalRepeatCount: 1,
                displayFullTextOnTap: true,
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onContinue,
                style: ElevatedButton.styleFrom(
                  backgroundColor: navConstants.sepia,
                  foregroundColor: navConstants.cream,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  isLastSpot ? 'リザルト画面へ' : '次へ進む',
                  style: navConstants.serifBody.copyWith(
                    color: navConstants.cream,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

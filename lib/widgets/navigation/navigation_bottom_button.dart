// lib/widgets/navigation/navigation_bottom_button.dart

import 'package:flutter/material.dart';

class NavigationBottomButton extends StatefulWidget {
  final bool isCompleted;

  final VoidCallback? onPressed;

  final String? completedText;

  final String? incompleteText;

  const NavigationBottomButton({
    super.key,
    required this.isCompleted,
    required this.onPressed,
    this.completedText,
    this.incompleteText,
  });

  @override
  State<NavigationBottomButton> createState() => _NavigationBottomButtonState();
}

class _NavigationBottomButtonState extends State<NavigationBottomButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _glowController;

  @override
  void initState() {
    super.initState();

    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _glowController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final enabled = widget.isCompleted && widget.onPressed != null;

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        child: AnimatedBuilder(
          animation: _glowController,
          builder: (context, child) {
            final glow = 0.4 + (_glowController.value * 0.6);

            return AnimatedContainer(
              duration: const Duration(milliseconds: 250),

              height: 62,

              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),

                gradient: enabled
                    ? const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFFD8BC84),
                          Color(0xFFC8A97A),
                          Color(0xFFB8860B),
                        ],
                      )
                    : LinearGradient(
                        colors: [
                          const Color(0xFF3D2B1F).withValues(alpha: 0.95),
                          const Color(0xFF2A2118).withValues(alpha: 0.95),
                        ],
                      ),

                border: Border.all(
                  color: enabled
                      ? const Color(0xFFFFE2A8).withValues(alpha: glow * 0.7)
                      : const Color(0xFF5A4638),

                  width: enabled ? 1.4 : 1,
                ),

                boxShadow: enabled
                    ? [
                        BoxShadow(
                          color: const Color(
                            0xFFC8A97A,
                          ).withValues(alpha: 0.28 * glow),

                          blurRadius: 20,

                          spreadRadius: 1,
                        ),

                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.35),

                          blurRadius: 10,

                          offset: const Offset(0, 6),
                        ),
                      ]
                    : [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.25),

                          blurRadius: 8,

                          offset: const Offset(0, 4),
                        ),
                      ],
              ),

              child: Material(
                color: Colors.transparent,

                child: InkWell(
                  borderRadius: BorderRadius.circular(18),

                  onTap: enabled ? widget.onPressed : null,

                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,

                      children: [
                        Icon(
                          enabled ? Icons.auto_awesome : Icons.lock_clock,

                          color: enabled
                              ? const Color(0xFF2C2318)
                              : const Color(0xFF8B7355),

                          size: 20,
                        ),

                        const SizedBox(width: 10),

                        Flexible(
                          child: Text(
                            enabled
                                ? (widget.completedText ?? '冒険の記録を報告する')
                                : (widget.incompleteText ??
                                      'すべてのスポットを調査してください'),

                            textAlign: TextAlign.center,

                            style: TextStyle(
                              color: enabled
                                  ? const Color(0xFF2C2318)
                                  : const Color(0xFF8B7355),

                              fontWeight: FontWeight.bold,

                              fontSize: 15,

                              letterSpacing: 0.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

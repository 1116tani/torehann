// lib/widgets/result/reward_popup.dart

import 'package:flutter/material.dart';

class RewardPopup extends StatefulWidget {
  final int exp;
  final int fragments;
  final VoidCallback? onFinished;

  const RewardPopup({
    super.key,
    required this.exp,
    required this.fragments,
    this.onFinished,
  });

  @override
  State<RewardPopup> createState() => _RewardPopupState();
}

class _RewardPopupState extends State<RewardPopup>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _scaleAnimation = Tween<double>(
      begin: 0.7,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutBack,
      ),
    );

    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );

    _glowAnimation = Tween<double>(
      begin: 8,
      end: 24,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _controller.forward();

    Future.delayed(
      const Duration(milliseconds: 2600),
      () {
        if (mounted) {
          widget.onFinished?.call();
        }
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withValues(alpha: 0.6),

      child: Center(
        child: AnimatedBuilder(
          animation: _controller,

          builder: (context, child) {
            return Opacity(
              opacity: _fadeAnimation.value,

              child: Transform.scale(
                scale: _scaleAnimation.value,

                child: Container(
                  width: 300,
                  padding: const EdgeInsets.all(24),

                  decoration: BoxDecoration(
                    color: const Color(0xFF2C2318),

                    borderRadius: BorderRadius.circular(24),

                    border: Border.all(
                      color: const Color(0xFFB8860B),
                      width: 1,
                    ),

                    boxShadow: [
                      BoxShadow(
                        color: const Color(
                          0xFFB8860B,
                        ).withValues(alpha: 0.45),

                        blurRadius: _glowAnimation.value,
                        spreadRadius: 1,
                      ),
                    ],
                  ),

                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // ── アイコン ─────────────────
                      Container(
                        width: 72,
                        height: 72,

                        decoration: BoxDecoration(
                          shape: BoxShape.circle,

                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFFFFD700),
                              Color(0xFFB8860B),
                            ],
                          ),

                          boxShadow: [
                            BoxShadow(
                              color: const Color(
                                0xFFFFD700,
                              ).withValues(alpha: 0.45),

                              blurRadius: 18,
                            ),
                          ],
                        ),

                        child: const Icon(
                          Icons.auto_awesome,
                          color: Colors.white,
                          size: 34,
                        ),
                      ),

                      const SizedBox(height: 18),

                      // ── タイトル ─────────────────
                      const Text(
                        'MISSION COMPLETE',
                        style: TextStyle(
                          color: Color(0xFFC8A97A),
                          fontSize: 11,
                          letterSpacing: 2,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 8),

                      const Text(
                        '冒険報酬を獲得',
                        style: TextStyle(
                          color: Color(0xFFF5EDD8),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 24),

                      // ── EXP ────────────────────
                      _RewardRow(
                        icon: Icons.bolt,
                        label: '経験値',
                        value: '+${widget.exp} EXP',
                        color: const Color(0xFF57D6C9),
                      ),

                      const SizedBox(height: 12),

                      // ── Fragment ──────────────
                      _RewardRow(
                        icon: Icons.diamond,
                        label: '街の断片',
                        value: '+${widget.fragments}',
                        color: const Color(0xFFB8860B),
                      ),

                      const SizedBox(height: 24),

                      const Text(
                        '光が、次の冒険へ流れ込んでいく...',
                        style: TextStyle(
                          color: Color(0xFF7A5C3A),
                          fontSize: 11,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
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

// ─────────────────────────────────────
// ✨ 報酬行
// ─────────────────────────────────────

class _RewardRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _RewardRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 12,
      ),

      decoration: BoxDecoration(
        color: const Color(0xFF1C1610),
        borderRadius: BorderRadius.circular(14),
      ),

      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,

            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withValues(alpha: 0.18),
            ),

            child: Icon(
              icon,
              color: color,
              size: 20,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: Color(0xFF7A5C3A),
                    fontSize: 11,
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  value,
                  style: TextStyle(
                    color: color,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
// lib/widgets/navigation/navigation_top_bar.dart

import 'package:flutter/material.dart';

class NavigationTopBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  final bool useGoogleMap;

  final VoidCallback onToggleMap;

  final VoidCallback onExit;

  const NavigationTopBar({
    super.key,
    required this.title,
    required this.useGoogleMap,
    required this.onToggleMap,
    required this.onExit,
  });

  @override
  Size get preferredSize => const Size.fromHeight(72);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,

      elevation: 0,

      backgroundColor: Colors.transparent,

      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF1A140F).withValues(alpha: 0.96),
              const Color(0xFF2C2318).withValues(alpha: 0.82),
              Colors.transparent,
            ],
          ),
        ),
      ),

      titleSpacing: 8,

      title: Row(
        children: [
          // ─────────────────────────
          // 🚪 終了ボタン
          // ─────────────────────────
          _CircleIconButton(icon: Icons.close, onTap: onExit),

          const SizedBox(width: 12),

          // ─────────────────────────
          // 🗺️ タイトル
          // ─────────────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              mainAxisAlignment: MainAxisAlignment.center,

              children: [
                const Text(
                  '探索中',
                  style: TextStyle(
                    color: Color(0xFF9E8465),
                    fontSize: 11,
                    letterSpacing: 1.4,
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFFF5EDD8),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          // ─────────────────────────
          // 🧭 マップ切替
          // ─────────────────────────
          _CircleIconButton(
            icon: useGoogleMap ? Icons.map_outlined : Icons.explore_outlined,

            onTap: onToggleMap,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────
// 🌙 Circle Button
// ─────────────────────────────

class _CircleIconButton extends StatefulWidget {
  final IconData icon;

  final VoidCallback onTap;

  const _CircleIconButton({required this.icon, required this.onTap});

  @override
  State<_CircleIconButton> createState() => _CircleIconButtonState();
}

class _CircleIconButtonState extends State<_CircleIconButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          _pressed = true;
        });
      },

      onTapUp: (_) {
        setState(() {
          _pressed = false;
        });
      },

      onTapCancel: () {
        setState(() {
          _pressed = false;
        });
      },

      onTap: widget.onTap,

      child: AnimatedScale(
        scale: _pressed ? 0.92 : 1.0,

        duration: const Duration(milliseconds: 100),

        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),

          width: 44,
          height: 44,

          decoration: BoxDecoration(
            shape: BoxShape.circle,

            color: const Color(0xFF3D2B1F).withValues(alpha: 0.88),

            border: Border.all(
              color: const Color(0xFFC8A97A).withValues(alpha: 0.45),
              width: 1,
            ),

            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.45),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),

              BoxShadow(
                color: const Color(0xFFC8A97A).withValues(alpha: 0.06),
                blurRadius: 12,
                spreadRadius: 1,
              ),
            ],
          ),

          child: Icon(widget.icon, color: const Color(0xFFF5EDD8), size: 20),
        ),
      ),
    );
  }
}

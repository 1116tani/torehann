// lib/widgets/home/home_map_controls.dart

import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_radius.dart';
import '../../constants/app_sizes.dart';

class HomeMapControls extends StatelessWidget {
  final VoidCallback? onLocationPressed;

  final VoidCallback? onLayersPressed;

  final VoidCallback? onCompassPressed;

  const HomeMapControls({
    super.key,
    this.onLocationPressed,
    this.onLayersPressed,
    this.onCompassPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,

      children: [
        // ─────────────────────
        // 🗺 Layer
        // ─────────────────────
        _MapControlButton(icon: Icons.layers_rounded, onTap: onLayersPressed),

        const SizedBox(height: AppSizes.p12),

        // ─────────────────────
        // 📍 Location
        // ─────────────────────
        _MapControlButton(
          icon: Icons.my_location_rounded,

          isPrimary: true,

          onTap: onLocationPressed,
        ),

        const SizedBox(height: AppSizes.p12),

        // ─────────────────────
        // 🧭 Compass
        // ─────────────────────
        _MapControlButton(icon: Icons.explore_rounded, onTap: onCompassPressed),
      ],
    );
  }
}

// ─────────────────────────────────
// BUTTON
// ─────────────────────────────────

class _MapControlButton extends StatelessWidget {
  final IconData icon;

  final VoidCallback? onTap;

  final bool isPrimary;

  const _MapControlButton({
    required this.icon,
    this.onTap,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,

      child: InkWell(
        onTap: onTap,

        borderRadius: BorderRadius.circular(999),

        child: Ink(
          width: 56,
          height: 56,

          decoration: BoxDecoration(
            shape: BoxShape.circle,

            color: isPrimary
                ? AppColors.primary
                : AppColors.surface.withValues(alpha: 0.92),

            border: Border.all(
              color: isPrimary
                  ? AppColors.primaryLight.withValues(alpha: 0.4)
                  : AppColors.border,
            ),

            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),

                blurRadius: 12,

                offset: const Offset(0, 6),
              ),
            ],
          ),

          child: Icon(
            icon,

            color: isPrimary ? AppColors.textDark : AppColors.textPrimary,

            size: 24,
          ),
        ),
      ),
    );
  }
}

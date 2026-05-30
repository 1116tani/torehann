// lib/widgets/navigation/navigation_map_controls.dart

import 'package:flutter/material.dart';

import '../../constants/navigation_ui_constants.dart';

class NavigationMapControls extends StatelessWidget {
  final VoidCallback onCompass;
  final VoidCallback onRecenter;

  const NavigationMapControls({
    super.key,
    required this.onCompass,
    required this.onRecenter,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _NavFab(
          icon: Icons.explore_outlined,
          tooltip: '北向き',
          onPressed: onCompass,
        ),
        const SizedBox(height: 10),
        _NavFab(
          icon: Icons.my_location_rounded,
          tooltip: '現在地に戻る',
          onPressed: onRecenter,
        ),
      ],
    );
  }
}

class _NavFab extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  const _NavFab({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: NavigationUiConstants.cream,
      elevation: 4,
      shadowColor: Colors.black26,
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onPressed,
        child: Tooltip(
          message: tooltip,
          child: SizedBox(
            width: 48,
            height: 48,
            child: Icon(icon, color: NavigationUiConstants.sepia, size: 22),
          ),
        ),
      ),
    );
  }
}

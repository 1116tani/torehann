// lib/widgets/home/home_map_controls.dart
import 'package:flutter/material.dart';
import '../../utils/colors.dart';

class HomeMapControls extends StatelessWidget {
  final VoidCallback? onLocationPressed;
  final VoidCallback? onLayersPressed;

  const HomeMapControls({
    super.key,
    this.onLocationPressed,
    this.onLayersPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        // マップの見た目切り替えボタン
        FloatingActionButton(
          heroTag: "layer_btn",
          mini: true,
          onPressed: onLayersPressed,
          backgroundColor: AppColors.surface,
          child: const Icon(Icons.layers, color: AppColors.textPrimary, size: 20),
        ),
        const SizedBox(height: 12),

        // 既存の現在地ボタン
        FloatingActionButton(
          heroTag: "location_btn",
          onPressed: onLocationPressed,
          backgroundColor: theme.colorScheme.primary,
          child: const Icon(
            Icons.my_location,
            color: AppColors.background,
          ),
        ),
      ],
    );
  }
}

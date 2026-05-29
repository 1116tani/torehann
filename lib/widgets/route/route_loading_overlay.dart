// lib/widgets/route/route_loading_overlay.dart

import 'package:flutter/material.dart';

class RouteLoadingOverlay extends StatelessWidget {
  const RouteLoadingOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            width: 56,
            height: 56,
            child: CircularProgressIndicator(
              color: Color(0xFFC8A97A),
              strokeWidth: 3.5,
            ),
          ),
          const SizedBox(height: 32),
          const Text(
            '冒険の地図を編纂中...',
            style: TextStyle(
              color: Color(0xFFF5EDD8),
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'AIが街の記憶を探しています\n最高の寄り道をご用意するまで、少々お待ちください...',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFFC8A97A),
              fontSize: 13,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

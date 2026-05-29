// lib/widgets/route/route_loading_overlay.dart

import 'package:flutter/material.dart';
import '../common/torenyan.dart';

class RouteLoadingOverlay extends StatelessWidget {
  const RouteLoadingOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Torenyan(
            size: 110,
            state: TorenyanState.loading,
            enableTap: false,
          ),
          SizedBox(height: 32),
          Text(
            '冒険の地図を編纂中...',
            style: TextStyle(
              color: Color(0xFFF5EDD8),
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
            ),
          ),
          SizedBox(height: 16),
          SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              color: Color(0xFFC8A97A),
              strokeWidth: 2.0,
            ),
          ),
        ],
      ),
    );
  }
}

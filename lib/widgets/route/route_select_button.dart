// lib/widgets/route/route_select_button.dart

import 'package:flutter/material.dart';
import '../../constants/app_sizes.dart';

class RouteSelectButton extends StatelessWidget {
  final VoidCallback onStart;

  const RouteSelectButton({super.key, required this.onStart});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.p16),
      decoration: const BoxDecoration(
        color: Color(0xFF1C1610), // 背景ダークブラウン
        border: Border(
          top: BorderSide(color: Color(0xFFC8A97A), width: 1.0),
        ),
      ),
      child: SizedBox(
        width: double.infinity,
        height: 60,
        child: ElevatedButton.icon(
          onPressed: onStart,
          icon: const Icon(Icons.auto_awesome, size: 20),
          label: const Text('この物語を歩きはじめる'),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFB8860B), // 金色
            foregroundColor: Colors.white,
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: const BorderSide(color: Color(0xFFC8A97A), width: 0.5),
            ),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
        ),
      ),
    );
  }
}

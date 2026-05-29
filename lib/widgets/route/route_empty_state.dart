// lib/widgets/route/route_empty_state.dart

import 'package:flutter/material.dart';
import '../../constants/app_sizes.dart';

class RouteEmptyState extends StatelessWidget {
  final VoidCallback onGenerate;

  const RouteEmptyState({super.key, required this.onGenerate});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.p24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.auto_awesome,
              color: Color(0xFFC8A97A),
              size: AppSizes.iconL,
            ),
            const SizedBox(height: AppSizes.p16),
            const Text(
              '街の記憶を見つけられませんでした',
              style: TextStyle(
                color: Color(0xFFF5EDD8),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSizes.p8),
            const Text(
              '気分や目的地などのセッティングを変えて、\nもう一度街の物語を探しにいきましょう。',
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFFC8A97A), fontSize: 13, height: 1.5),
            ),
            const SizedBox(height: AppSizes.p24),
            ElevatedButton.icon(
              onPressed: onGenerate,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('もう一度記憶を探索する'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFB8860B),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.p24,
                  vertical: AppSizes.p12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: const BorderSide(color: Color(0xFFC8A97A), width: 0.5),
                ),
                textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

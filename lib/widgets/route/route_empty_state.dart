// lib/widgets/route/route_empty_state.dart

import 'package:flutter/material.dart';
import '../../constants/app_sizes.dart';
import '../common/torenyan.dart';

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
            const Torenyan(
              size: 110,
              state: TorenyanState.error,
              enableTap: true,
            ),
            const SizedBox(height: AppSizes.p24),
            const Text(
              '街の記憶を見つけられませんでした',
              style: TextStyle(
                color: Color(0xFFF5EDD8),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
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

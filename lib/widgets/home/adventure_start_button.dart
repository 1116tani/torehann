// lib/widgets/home/adventure_start_button.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:tale_trace/router/app_router.dart';
import 'package:tale_trace/widgets/common/custom_button.dart';

class AdventureStartButton extends StatelessWidget {
  const AdventureStartButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: CustomButton(
        text: '冒険を出発する',
        icon: Icons.explore,
        onPressed: () {
          context.push(AppRoutes.adventureSetting);
        },
      ),
    );
  }
}

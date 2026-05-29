// lib/pages/adventure_setting_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../router/route_names.dart';

import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';
import '../constants/app_text_styles.dart';

import '../providers/adventure_provider.dart';

import '../widgets/common/custom_header.dart';

import '../widgets/adventure_setup/location_status_card.dart';
import '../widgets/adventure_setup/weather_chip.dart';
import '../widgets/adventure_setup/mood_selector.dart';
import '../widgets/adventure_setup/mode_selector.dart';
import '../widgets/adventure_setup/destination_input.dart';
import '../widgets/adventure_setup/generate_route_button.dart';

class AdventureSettingPage extends ConsumerWidget {
  const AdventureSettingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(adventureProvider);

    return Scaffold(
      backgroundColor: AppColors.background,

      body: SafeArea(
        child: Stack(
          children: [
            // ─────────────────────────────
            // 🌌 Background
            // ─────────────────────────────
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,

                  colors: [
                    AppColors.background,
                    AppColors.surface,
                    AppColors.background,
                  ],
                ),
              ),
            ),

            // ─────────────────────────────
            // 📄 Main UI
            // ─────────────────────────────
            Column(
              children: [
                // ─────────────────────────
                // 🧭 Header
                // ─────────────────────────
                const CustomHeader(
                  title: '冒険セッティング',
                  subtitle: 'ADVENTURE SETUP',
                ),

                // ─────────────────────────
                // 📜 Scroll Area
                // ─────────────────────────
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(
                      AppSizes.p20,
                      AppSizes.p20,
                      AppSizes.p20,
                      140,
                    ),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        // ───────────────────
                        // 📍 Status Card
                        // ───────────────────
                        Container(
                          padding: const EdgeInsets.all(AppSizes.p16),

                          decoration: BoxDecoration(
                            color: AppColors.surfaceLight,

                            borderRadius: BorderRadius.circular(
                              AppSizes.radiusL,
                            ),

                            border: Border.all(color: AppColors.border),
                          ),

                          child: const Column(
                            children: [
                              LocationStatusCard(),

                              SizedBox(height: AppSizes.p16),

                              Align(
                                alignment: Alignment.centerLeft,
                                child: WeatherChip(),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: AppSizes.p40),

                        // ───────────────────
                        // 📍 Destination
                        // ───────────────────
                        _SectionTitle(title: '目的地', subtitle: 'DESTINATION'),

                        const SizedBox(height: AppSizes.p16),

                        const DestinationInput(),

                        const SizedBox(height: AppSizes.p40),

                        // ───────────────────
                        // 😊 Mood
                        // ───────────────────
                        _SectionTitle(title: '今の気分', subtitle: 'MOOD'),

                        const SizedBox(height: AppSizes.p16),

                        const MoodSelector(),

                        const SizedBox(height: AppSizes.p40),

                        // ───────────────────
                        // 🚶 Mode
                        // ───────────────────
                        _SectionTitle(
                          title: '歩く距離',
                          subtitle: 'ADVENTURE MODE',
                        ),

                        const SizedBox(height: AppSizes.p16),

                        const ModeSelector(),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // ─────────────────────────────
            // ✨ Generate Button
            // ─────────────────────────────
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,

              child: Container(
                padding: const EdgeInsets.fromLTRB(
                  AppSizes.p20,
                  AppSizes.p12,
                  AppSizes.p20,
                  AppSizes.p24,
                ),

                decoration: BoxDecoration(
                  color: AppColors.background.withValues(alpha: 0.96),

                  border: Border(top: BorderSide(color: AppColors.border)),
                ),

                child: GenerateRouteButton(
                  onSuccess: () {
                    context.push(AppRoutes.routeSelect);
                  },
                ),
              ),
            ),

            // ─────────────────────────────
            // 🌙 Loading Overlay
            // ─────────────────────────────
            if (state.isGenerating)
              Container(
                color: Colors.black.withValues(alpha: 0.45),

                child: Center(
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: AppSizes.p32,
                    ),

                    padding: const EdgeInsets.all(AppSizes.p24),

                    decoration: BoxDecoration(
                      color: AppColors.surface,

                      borderRadius: BorderRadius.circular(AppSizes.radiusXL),

                      border: Border.all(color: AppColors.border),
                    ),

                    child: Column(
                      mainAxisSize: MainAxisSize.min,

                      children: [
                        const SizedBox(
                          width: 42,
                          height: 42,

                          child: CircularProgressIndicator(strokeWidth: 3),
                        ),

                        const SizedBox(height: AppSizes.p20),

                        Text(
                          'AIが冒険ルートを生成中...',
                          style: AppTextStyles.titleSmall.copyWith(
                            fontSize: 18,
                          ),
                        ),

                        const SizedBox(height: AppSizes.p8),

                        Text(
                          '街の記憶を探しています',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────
// 📌 Section Title
// ─────────────────────────────

class _SectionTitle extends StatelessWidget {
  final String title;
  final String subtitle;

  const _SectionTitle({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Text(
          title,

          style: AppTextStyles.titleMedium.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),

        const SizedBox(height: AppSizes.p4),

        Text(
          subtitle,

          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
            letterSpacing: 1.5,
          ),
        ),
      ],
    );
  }
}

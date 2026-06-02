// lib/pages/adventure_setting_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../router/route_names.dart';

import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';
import '../constants/app_text_styles.dart';

import '../providers/adventure_provider.dart';
import '../providers/route_provider.dart';

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
    final routeSelectState = ref.watch(routeSelectProvider);
    final isGenerating = state.isGenerating || routeSelectState.isLoading;
    final colors = AppColors.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: colors.background,

      body: SafeArea(
        child: AbsorbPointer(
          absorbing: isGenerating,
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
                    colors.background,
                    colors.surface,
                    colors.background,
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
                            color: colors.surfaceLight,

                            borderRadius: BorderRadius.circular(
                              AppSizes.radiusL,
                            ),

                            border: Border.all(color: colors.border),
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
                  color: colors.background.withValues(alpha: 0.96),

                  border: Border(top: BorderSide(color: colors.border)),
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
            if (isGenerating)
              Container(
                color: colors.background.withValues(alpha: isDark ? 0.78 : 0.72),

                child: Center(
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: AppSizes.p32,
                    ),

                    padding: const EdgeInsets.all(AppSizes.p24),

                    decoration: BoxDecoration(
                      color: colors.surface,

                      borderRadius: BorderRadius.circular(AppSizes.radiusXL),

                      border: Border.all(color: colors.border),
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
                          'トレにゃんが冒険ルートを生成中...',
                          style: AppTextStyles.of(context).titleSmall.copyWith(
                            fontSize: 18,
                            color: colors.textPrimary,
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
    final colors = AppColors.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Text(
          title,

          style: AppTextStyles.of(context).titleMedium.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: colors.textPrimary,
          ),
        ),

        const SizedBox(height: AppSizes.p4),

        Text(
          subtitle,

          style: AppTextStyles.of(context).bodySmall.copyWith(
            color: colors.textSecondary,
            letterSpacing: 1.5,
          ),
        ),
      ],
    );
  }
}


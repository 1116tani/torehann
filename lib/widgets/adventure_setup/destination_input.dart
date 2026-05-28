// lib/widgets/adventure_setup/destination_input.dart

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_sizes.dart';
import '../../constants/app_text_styles.dart';

import '../../providers/adventure_provider.dart';
import '../../providers/places_provider.dart';

class DestinationInput extends ConsumerStatefulWidget {
  const DestinationInput({super.key});

  @override
  ConsumerState<DestinationInput> createState() => _DestinationInputState();
}

class _DestinationInputState extends ConsumerState<DestinationInput> {
  late final TextEditingController _controller;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    final initialText = ref.read(adventureProvider).destination;
    _controller = TextEditingController(text: initialText);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    final notifier = ref.read(adventureProvider.notifier);
    notifier.setDestination(value);

    // 空なら候補消す
    if (value.trim().isEmpty) {
      ref.read(placesProvider.notifier).clear();
      return;
    }

    // デバウンス処理
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (mounted) {
        ref.read(placesProvider.notifier).searchPlaces(value);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // 外部からの更新（おまかせボタンなど）を反映
    ref.listen(adventureProvider.select((s) => s.destination), (previous, next) {
      if (next != _controller.text) {
        _controller.text = next;
      }
    });

    final placeState = ref.watch(placesProvider);
    final isRandomMode = ref.watch(
      adventureProvider.select((state) => state.isRandomMode),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ───────────────────
        // ✏️ Input
        // ───────────────────
        AbsorbPointer(
          absorbing: isRandomMode,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: isRandomMode ? 0.5 : 1.0,
            child: TextField(
              controller: _controller,
              onChanged: _onChanged,
              style: AppTextStyles.bodyLarge,
              decoration: InputDecoration(
                hintText: '駅名・街・スポット名を入力',
                prefixIcon: const Icon(
                  Icons.search_rounded,
                  color: AppColors.textMuted,
                ),
                filled: true,
                fillColor: AppColors.surfaceLight,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.p16,
                  vertical: AppSizes.p16,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusL),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusL),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusL),
                  borderSide: const BorderSide(
                    color: AppColors.primary,
                    width: 1.5,
                  ),
                ),
              ),
            ),
          ),
        ),

        // ───────────────────
        // 🔍 Suggestions
        // ───────────────────
        if (!isRandomMode && _controller.text.trim().isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: AppSizes.p12),
            child: _SuggestionBox(
              state: placeState,
              onSelect: (placeName) {
                _controller.text = placeName;
                ref.read(adventureProvider.notifier).setDestination(placeName);
                ref.read(placesProvider.notifier).clear();
                FocusScope.of(context).unfocus();
              },
            ),
          ),
      ],
    );
  }
}

// ─────────────────────────────
// 🔍 Suggestion Box
// ─────────────────────────────

class _SuggestionBox extends StatelessWidget {
  final PlacesState state;
  final void Function(String) onSelect;

  const _SuggestionBox({required this.state, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    if (state.isLoading) {
      return Container(
        padding: const EdgeInsets.all(AppSizes.p16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSizes.radiusL),
          border: Border.all(color: AppColors.border),
        ),
        child: const Center(
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AppColors.secondary,
            ),
          ),
        ),
      );
    }

    if (state.places.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusL),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: state.places.map((place) {
          return Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => onSelect(place.name),
              borderRadius: BorderRadius.circular(AppSizes.radiusL),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.p16,
                  vertical: AppSizes.p16,
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 20,
                      color: AppColors.secondary,
                    ),
                    const SizedBox(width: AppSizes.p12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            place.name,
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (place.address.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(
                              place.address,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.textMuted,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

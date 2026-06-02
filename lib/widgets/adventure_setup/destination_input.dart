// lib/widgets/adventure_setup/destination_input.dart

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_sizes.dart';
import '../../constants/app_text_styles.dart';
import '../../providers/adventure_provider.dart';
import '../../providers/location_provider.dart';
import '../../providers/places_provider.dart';

class DestinationInput extends ConsumerStatefulWidget {
  const DestinationInput({super.key});

  @override
  ConsumerState<DestinationInput> createState() => _DestinationInputState();
}

class _DestinationInputState extends ConsumerState<DestinationInput> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    final initialText = ref.read(adventureProvider).destination;
    _controller = TextEditingController(text: initialText);
    _focusNode = FocusNode()..addListener(_onFocusChanged);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _focusNode.removeListener(_onFocusChanged);
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  void _onChanged(String value) {
    ref.read(adventureProvider.notifier).setDestination(value);
    setState(() {});

    if (value.trim().isEmpty) {
      ref.read(placesProvider.notifier).clear();
      return;
    }

    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () async {
      if (!mounted) {
        return;
      }

      try {
        final position = await ref.read(currentLocationProvider.future);
        if (mounted) {
          ref
              .read(placesProvider.notifier)
              .searchPlaces(
                value,
                latitude: position.latitude,
                longitude: position.longitude,
              );
        }
      } catch (_) {
        if (mounted) {
          ref.read(placesProvider.notifier).searchPlaces(value);
        }
      }
    });
  }

  Future<void> _selectPlace(PlaceItem placeItem) async {
    final selectedText = placeItem.fullText.isNotEmpty
        ? placeItem.fullText
        : placeItem.name;
    _controller.text = selectedText;
    ref.read(placesProvider.notifier).clear();
    FocusScope.of(context).unfocus();

    try {
      if (placeItem.placeId.isEmpty) {
        throw Exception('query suggestion');
      }

      final detail = await ref
          .read(placesRepositoryProvider)
          .getPlaceDetail(placeItem.placeId);
      ref
          .read(adventureProvider.notifier)
          .setDestinationWithCoordinates(
            name: detail.name,
            lat: detail.lat,
            lng: detail.lng,
          );
    } catch (_) {
      ref.read(adventureProvider.notifier).setDestination(selectedText);
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(adventureProvider.select((s) => s.destination), (
      previous,
      next,
    ) {
      if (next != _controller.text) {
        _controller.text = next;
      }
    });

    final placeState = ref.watch(placesProvider);
    final isRandomMode = ref.watch(
      adventureProvider.select((state) => state.isRandomMode),
    );
    final showSuggestions =
        !isRandomMode &&
        _focusNode.hasFocus &&
        _controller.text.trim().isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _DestinationTextField(
          controller: _controller,
          focusNode: _focusNode,
          isRandomMode: isRandomMode,
          onChanged: _onChanged,
          onEnableInput: () {
            ref.read(adventureProvider.notifier).setRandomMode(false);
            _focusNode.requestFocus();
          },
        ),
        if (showSuggestions)
          Padding(
            padding: const EdgeInsets.only(top: AppSizes.p12),
            child: _SuggestionBox(state: placeState, onSelect: _selectPlace),
          ),
        if (!showSuggestions) ...[
          const SizedBox(height: AppSizes.p12),
          _RandomDestinationButton(
            isRandomMode: isRandomMode,
            onTap: () {
              final nextMode = !isRandomMode;
              ref.read(adventureProvider.notifier).setRandomMode(nextMode);
              if (nextMode) {
                ref.read(placesProvider.notifier).clear();
                FocusScope.of(context).unfocus();
              } else {
                _focusNode.requestFocus();
              }
            },
          ),
        ],
      ],
    );
  }
}

class _DestinationTextField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool isRandomMode;
  final ValueChanged<String> onChanged;
  final VoidCallback onEnableInput;

  const _DestinationTextField({
    required this.controller,
    required this.focusNode,
    required this.isRandomMode,
    required this.onChanged,
    required this.onEnableInput,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final textStyles = AppTextStyles.of(context);
    return GestureDetector(
      onTap: () {
        if (isRandomMode) {
          onEnableInput();
        }
      },
      child: AbsorbPointer(
        absorbing: isRandomMode,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 200),
          opacity: isRandomMode ? 0.45 : 1.0,
          child: TextField(
            controller: controller,
            focusNode: focusNode,
            onChanged: onChanged,
            onTap: () {
              if (isRandomMode) {
                onEnableInput();
              }
            },
            style: textStyles.bodyLarge.copyWith(color: colors.textPrimary),
            decoration: InputDecoration(
              hintText: '駅名・街・スポット名を入力',
              hintStyle: textStyles.bodyLarge.copyWith(color: colors.textMuted),
              prefixIcon: Icon(
                Icons.search_rounded,
                color: colors.textMuted,
              ),
              filled: true,
              fillColor: colors.surfaceLight,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSizes.p16,
                vertical: AppSizes.p16,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSizes.radiusL),
                borderSide: BorderSide(color: colors.border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSizes.radiusL),
                borderSide: BorderSide(color: colors.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSizes.radiusL),
                borderSide: BorderSide(
                  color: colors.primary,
                  width: 1.5,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RandomDestinationButton extends StatelessWidget {
  final bool isRandomMode;
  final VoidCallback onTap;

  const _RandomDestinationButton({
    required this.isRandomMode,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final selectedForeground = AppColors.textDark;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSizes.radiusL),
          color: isRandomMode ? colors.primary : colors.surfaceLight,
          border: Border.all(
            color: isRandomMode ? colors.primaryLight : colors.border,
            width: 1.2,
          ),
          boxShadow: isRandomMode
              ? [
                  BoxShadow(
                    color: colors.primary.withValues(alpha: 0.25),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.casino_rounded,
              color: isRandomMode ? selectedForeground : colors.textSecondary,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              '目的地をおまかせする',
              style: TextStyle(
                color: isRandomMode
                    ? selectedForeground
                    : colors.textSecondary,
                fontSize: 14,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SuggestionBox extends StatelessWidget {
  final PlacesState state;
  final void Function(PlaceItem) onSelect;

  const _SuggestionBox({required this.state, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    if (state.isLoading) {
      return _SuggestionShell(
        child: SizedBox(
          height: 48,
          child: Center(
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: colors.secondary,
              ),
            ),
          ),
        ),
      );
    }

    if (state.places.isEmpty) {
      return const SizedBox.shrink();
    }

    final visiblePlaces = state.places.take(3).toList();

    return _SuggestionShell(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (int index = 0; index < visiblePlaces.length; index++) ...[
            _SuggestionTile(
              place: visiblePlaces[index],
              onTap: () => onSelect(visiblePlaces[index]),
            ),
            if (index != visiblePlaces.length - 1)
              Divider(height: 1, thickness: 1, color: colors.divider),
          ],
        ],
      ),
    );
  }
}

class _SuggestionShell extends StatelessWidget {
  final Widget child;

  const _SuggestionShell({required this.child});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Material(
      color: Colors.transparent,
      elevation: 12,
      shadowColor: colors.textPrimary.withValues(alpha: 0.22),
      borderRadius: BorderRadius.circular(AppSizes.radiusL),
      child: Container(
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(AppSizes.radiusL),
          border: Border.all(color: colors.border),
        ),
        clipBehavior: Clip.antiAlias,
        child: child,
      ),
    );
  }
}

class _SuggestionTile extends StatelessWidget {
  final PlaceItem place;
  final VoidCallback onTap;

  const _SuggestionTile({required this.place, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.p16,
            vertical: 12,
          ),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: colors.background.withValues(alpha: 0.55),
                  shape: BoxShape.circle,
                  border: Border.all(color: colors.glassBorder),
                ),
                child: Icon(
                  Icons.location_on_outlined,
                  size: 21,
                  color: colors.secondary,
                ),
              ),
              const SizedBox(width: AppSizes.p12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      place.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.of(context).bodyMedium.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colors.textPrimary,
                      ),
                    ),
                    if (place.address.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        place.address,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.of(context).bodySmall.copyWith(
                          color: colors.textMuted,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: AppSizes.p12),
              Icon(
                Icons.north_west_rounded,
                size: 22,
                color: colors.textMuted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}


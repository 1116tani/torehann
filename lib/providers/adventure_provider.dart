// lib/providers/adventure_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

class AdventureSettingState {
  final String destination;
  final bool isRandom;
  final String mood;
  final String mode;
  final bool isLoading;

  const AdventureSettingState({
    this.destination = '',
    this.isRandom = false,
    this.mood = 'のんびり',
    this.mode = 'お散歩',
    this.isLoading = false,
  });

  AdventureSettingState copyWith({
    String? destination,
    bool? isRandom,
    String? mood,
    String? mode,
    bool? isLoading,
  }) {
    return AdventureSettingState(
      destination: destination ?? this.destination,
      isRandom: isRandom ?? this.isRandom,
      mood: mood ?? this.mood,
      mode: mode ?? this.mode,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class AdventureSettingNotifier extends Notifier<AdventureSettingState> {
  @override
  AdventureSettingState build() => const AdventureSettingState();

  void setDestination(String destination) {
    state = state.copyWith(destination: destination, isRandom: false);
  }

  void setRandom() {
    state = state.copyWith(destination: '', isRandom: true);
  }

  void setMood(String mood) {
    state = state.copyWith(mood: mood);
  }

  void setMode(String mode) {
    state = state.copyWith(mode: mode);
  }

  void reset() {
    state = const AdventureSettingState();
  }

  Future<bool> generateRoutes() async {
    state = state.copyWith(isLoading: true);

    try {
      await Future.delayed(const Duration(seconds: 2));
      return true;
    } catch (_) {
      return false;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}

final adventureSettingProvider =
    NotifierProvider<AdventureSettingNotifier, AdventureSettingState>(
      AdventureSettingNotifier.new,
    );

final currentAddressProvider = FutureProvider<String>((ref) async {
  try {
    await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.low),
    );

    // TODO: Geocodingで住所に変換する
    return '愛知県豊田市';
  } catch (_) {
    return '現在地を検索中...';
  }
});

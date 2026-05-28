// lib/providers/weather_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/weather_service.dart';
import 'location_provider.dart';

// ─────────────────────────────
// ☀️ WeatherService Provider
// ─────────────────────────────

final weatherServiceProvider = Provider<WeatherService>((ref) {
  return WeatherService();
});

// ─────────────────────────────
// 🌤️ 現在地の天気取得
// ─────────────────────────────

final weatherProvider = FutureProvider<WeatherInfo>((ref) async {
  final location = await ref.watch(currentLocationProvider.future);

  final weatherService = ref.read(weatherServiceProvider);

  return weatherService.getCurrentWeather(
    latitude: location.latitude,
    longitude: location.longitude,
  );
});

// ─────────────────────────────
// 🌧️ 雨かどうか
// ─────────────────────────────

final isRainingProvider = Provider<bool>((ref) {
  final weatherAsync = ref.watch(weatherProvider);

  return weatherAsync.maybeWhen(
    data: (weather) => weather.isRaining,
    orElse: () => false,
  );
});

// ─────────────────────────────
// 🌡️ 気温
// ─────────────────────────────

final temperatureProvider = Provider<double?>((ref) {
  final weatherAsync = ref.watch(weatherProvider);

  return weatherAsync.maybeWhen(
    data: (weather) => weather.temperature,
    orElse: () => null,
  );
});

// ─────────────────────────────
// 🧭 冒険ムード
// ─────────────────────────────

final weatherMoodProvider = Provider<String>((ref) {
  final weatherAsync = ref.watch(weatherProvider);

  return weatherAsync.maybeWhen(
    data: (weather) {
      final service = ref.read(weatherServiceProvider);

      return service.getWeatherMood(weather);
    },
    orElse: () => '霧に包まれた街',
  );
});

// ─────────────────────────────
// ✨ おすすめ探索モード
// ─────────────────────────────

final recommendedAdventureModeProvider = Provider<String>((ref) {
  final weatherAsync = ref.watch(weatherProvider);

  return weatherAsync.maybeWhen(
    data: (weather) {
      final service = ref.read(weatherServiceProvider);

      return service.recommendAdventureMode(weather);
    },
    orElse: () => '街歩き探索',
  );
});

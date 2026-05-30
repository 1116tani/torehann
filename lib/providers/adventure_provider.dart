// lib/providers/adventure_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/enums/adventure_mode.dart';

// ─────────────────────────────
// 🌌 Adventure State
// ─────────────────────────────

enum AdventureMood {
  relaxed('のんびり', '🌸'),
  excited('わくわく', '✨'),
  intense('ガッツリ', '🔥'),
  random('きまぐれ', '🎲');

  const AdventureMood(this.label, this.emoji);

  // Geminiプロンプト・UI表示用ラベル
  final String label;

  // 絵文字
  final String emoji;
}

class AdventureState {
  // 気分
  final AdventureMood mood;

  // 難易度
  final AdventureMode mode;

  // 目的地 (下位互換用)
  final String destination;

  // 目的地の詳細情報
  final String destinationName;
  final double? destinationLat;
  final double? destinationLng;

  // おまかせモード
  final bool isRandomMode;

  // 空き時間（分）
  final int freeTimeMinutes;

  // 趣味タグ
  final List<String> hobbyTags;

  // 生成中
  final bool isGenerating;

  // エラー
  final String? errorMessage;

  const AdventureState({
    this.mood = AdventureMood.relaxed,
    this.mode = AdventureMode.walk,
    this.destination = '',
    this.destinationName = '',
    this.destinationLat,
    this.destinationLng,
    this.isRandomMode = true,
    this.freeTimeMinutes = 60,
    this.hobbyTags = const [],
    this.isGenerating = false,
    this.errorMessage,
  });

  // ─────────────────────────────
  // ✨ copyWith
  // ─────────────────────────────

  AdventureState copyWith({
    AdventureMood? mood,
    AdventureMode? mode,
    String? destination,
    String? destinationName,
    double? destinationLat,
    double? destinationLng,
    bool? isRandomMode,
    int? freeTimeMinutes,
    List<String>? hobbyTags,
    bool? isGenerating,
    String? errorMessage,
    bool clearDestinationCoordinates = false,
  }) {
    return AdventureState(
      mood: mood ?? this.mood,
      mode: mode ?? this.mode,
      destination: destination ?? this.destination,
      destinationName: destinationName ?? this.destinationName,
      destinationLat: clearDestinationCoordinates
          ? null
          : (destinationLat ?? this.destinationLat),
      destinationLng: clearDestinationCoordinates
          ? null
          : (destinationLng ?? this.destinationLng),
      isRandomMode: isRandomMode ?? this.isRandomMode,
      freeTimeMinutes: freeTimeMinutes ?? this.freeTimeMinutes,
      hobbyTags: hobbyTags ?? this.hobbyTags,
      isGenerating: isGenerating ?? this.isGenerating,
      errorMessage: errorMessage,
    );
  }
}

// ─────────────────────────────
// 🧭 Adventure Notifier
// ─────────────────────────────

class AdventureNotifier extends Notifier<AdventureState> {
  @override
  AdventureState build() {
    return const AdventureState();
  }

  // ─────────────────────────────
  // 😊 気分変更
  // ─────────────────────────────

  void setMood(AdventureMood mood) {
    state = state.copyWith(mood: mood);
  }

  // ─────────────────────────────
  // 🗺️ 難易度変更
  // ─────────────────────────────

  void setMode(AdventureMode mode) {
    state = state.copyWith(mode: mode);
  }

  // ─────────────────────────────
  // 📍 目的地入力 (座標なし)
  // ─────────────────────────────

  void setDestination(String destination) {
    state = state.copyWith(
      destination: destination,
      destinationName: destination,
      destinationLat: null,
      destinationLng: null,
      isRandomMode: false,
      clearDestinationCoordinates: true,
    );
  }

  // ─────────────────────────────
  // 📍 目的地入力 (座標あり)
  // ─────────────────────────────

  void setDestinationWithCoordinates({
    required String name,
    required double lat,
    required double lng,
  }) {
    state = state.copyWith(
      destination: name,
      destinationName: name,
      destinationLat: lat,
      destinationLng: lng,
      isRandomMode: false,
    );
  }

  // ─────────────────────────────
  // 🎲 おまかせモード
  // ─────────────────────────────

  void enableRandomMode() {
    state = state.copyWith(
      isRandomMode: true,
      destination: '',
      destinationName: '',
      destinationLat: null,
      destinationLng: null,
      clearDestinationCoordinates: true,
    );
  }

  void setRandomMode(bool enabled) {
    state = state.copyWith(
      isRandomMode: enabled,
      destination: enabled ? '' : state.destination,
      destinationName: enabled ? '' : state.destinationName,
      destinationLat: enabled ? null : state.destinationLat,
      destinationLng: enabled ? null : state.destinationLng,
      clearDestinationCoordinates: enabled,
    );
  }

  // ─────────────────────────────
  // ⏰ 空き時間変更
  // ─────────────────────────────

  void setFreeTime(int minutes) {
    state = state.copyWith(freeTimeMinutes: minutes);
  }

  // ─────────────────────────────
  // 🏷️ 趣味タグ変更
  // ─────────────────────────────

  void setHobbyTags(List<String> tags) {
    state = state.copyWith(hobbyTags: tags);
  }

  // ─────────────────────────────
  // 🔄 生成開始
  // ─────────────────────────────

  void startGenerating() {
    state = state.copyWith(isGenerating: true, errorMessage: null);
  }

  // ─────────────────────────────
  // ✅ 生成完了
  // ─────────────────────────────

  void finishGenerating() {
    state = state.copyWith(isGenerating: false);
  }

  // ─────────────────────────────
  // ❌ エラー設定
  // ─────────────────────────────

  void setError(String message) {
    state = state.copyWith(isGenerating: false, errorMessage: message);
  }

  // ─────────────────────────────
  // 🧹 リセット
  // ─────────────────────────────

  void reset() {
    state = const AdventureState();
  }
}

// ─────────────────────────────
// 🌌 Provider
// ─────────────────────────────

final adventureProvider = NotifierProvider<AdventureNotifier, AdventureState>(
  AdventureNotifier.new,
);

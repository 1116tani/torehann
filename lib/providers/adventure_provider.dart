// lib/providers/adventure_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';

// 冒険セッティングの状態をまとめたクラス
class AdventureSettingState {
  final String destination; // 目的地
  final bool isRandom; // おまかせモードかどうか
  final String mood; // 気分（'のんびり', 'わくわく', 'ガッツリ'）
  final String mode; // モード（'お散歩', '探索', '冒険'）

  const AdventureSettingState({
    this.destination = '',
    this.isRandom = false,
    this.mood = 'のんびり',
    this.mode = 'お散歩',
  });

  // 一部だけ変更した新しいStateを返す
  AdventureSettingState copyWith({
    String? destination,
    bool? isRandom,
    String? mood,
    String? mode,
  }) {
    return AdventureSettingState(
      destination: destination ?? this.destination,
      isRandom: isRandom ?? this.isRandom,
      mood: mood ?? this.mood,
      mode: mode ?? this.mode,
    );
  }
}

// Notifier本体
class AdventureSettingNotifier extends Notifier<AdventureSettingState> {
  @override
  AdventureSettingState build() => const AdventureSettingState();

  void setDestination(String value) {
    state = state.copyWith(destination: value, isRandom: false);
  }

  void setRandom() {
    state = state.copyWith(destination: '', isRandom: true);
  }

  void setMood(String value) {
    state = state.copyWith(mood: value);
  }

  void setMode(String value) {
    state = state.copyWith(mode: value);
  }

  void reset() {
    state = const AdventureSettingState();
  }
}

// 外から使うためのProvider
final adventureSettingProvider =
    NotifierProvider<AdventureSettingNotifier, AdventureSettingState>(
      AdventureSettingNotifier.new,
    );

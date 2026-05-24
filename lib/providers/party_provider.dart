// lib/providers/party_provider.dart

import 'package:flutter_riverpod/legacy.dart';

/// ── パーティ参加メンバー ─────────────────────
class PartyMember {
  final String id;
  final String name;
  final bool isReady;
  final bool isHost;

  const PartyMember({
    required this.id,
    required this.name,
    this.isReady = false,
    this.isHost = false,
  });

  PartyMember copyWith({
    String? id,
    String? name,
    bool? isReady,
    bool? isHost,
  }) {
    return PartyMember(
      id: id ?? this.id,
      name: name ?? this.name,
      isReady: isReady ?? this.isReady,
      isHost: isHost ?? this.isHost,
    );
  }
}

/// ── パーティ状態 ────────────────────────────
class PartyState {
  final String roomId;
  final List<PartyMember> members;
  final bool isLoading;
  final bool isConnected;

  const PartyState({
    this.roomId = '',
    this.members = const [],
    this.isLoading = false,
    this.isConnected = false,
  });

  PartyState copyWith({
    String? roomId,
    List<PartyMember>? members,
    bool? isLoading,
    bool? isConnected,
  }) {
    return PartyState(
      roomId: roomId ?? this.roomId,
      members: members ?? this.members,
      isLoading: isLoading ?? this.isLoading,
      isConnected: isConnected ?? this.isConnected,
    );
  }
}

/// ── Notifier ────────────────────────────────
class PartyNotifier extends StateNotifier<PartyState> {
  PartyNotifier() : super(const PartyState());

  /// ルーム作成
  void createRoom() {
    state = state.copyWith(
      roomId: '48271',
      isConnected: true,
      members: [
        const PartyMember(
          id: 'host_001',
          name: 'みくくん',
          isHost: true,
          isReady: true,
        ),
      ],
    );
  }

  /// ルーム参加（モック）
  void joinRoom(String roomId) {
    state = state.copyWith(
      roomId: roomId,
      isConnected: true,
      members: [
        const PartyMember(
          id: 'member_001',
          name: 'あなた',
          isReady: false,
        ),
      ],
    );
  }

  /// メンバー追加（モック）
  void addMockMember() {
    final count = state.members.length;

    if (count >= 5) return;

    final newMember = PartyMember(
      id: 'member_$count',
      name: '冒険者$count',
      isReady: count % 2 == 0,
    );

    state = state.copyWith(
      members: [...state.members, newMember],
    );
  }

  /// Ready切替
  void toggleReady(String memberId) {
    final updated = state.members.map((m) {
      if (m.id == memberId) {
        return m.copyWith(isReady: !m.isReady);
      }
      return m;
    }).toList();

    state = state.copyWith(members: updated);
  }

  /// ローディング切替
  void setLoading(bool value) {
    state = state.copyWith(isLoading: value);
  }
}

/// ── Provider ───────────────────────────────
final partyProvider =
    StateNotifierProvider<PartyNotifier, PartyState>(
  (ref) => PartyNotifier(),
);
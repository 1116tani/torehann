// lib/models/party_model.dart

/// ── パーティメンバー ─────────────────────────
/// フレンド1人分の情報だよ
class PartyMember {
  final String id;
  final String name;
  final bool isHost;
  final bool isReady;
  final String? avatarUrl;

  const PartyMember({
    required this.id,
    required this.name,
    this.isHost = false,
    this.isReady = false,
    this.avatarUrl,
  });

  PartyMember copyWith({
    String? id,
    String? name,
    bool? isHost,
    bool? isReady,
    String? avatarUrl,
  }) {
    return PartyMember(
      id: id ?? this.id,
      name: name ?? this.name,
      isHost: isHost ?? this.isHost,
      isReady: isReady ?? this.isReady,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }
}

/// ── パーティ状態 ───────────────────────────
/// ルーム全体の状態を管理するモデルだよ
class PartyModel {
  final String roomId;

  /// 現在の参加メンバー
  final List<PartyMember> members;

  /// ホストが冒険開始したか
  final bool isAdventureStarted;

  /// 接続中かどうか
  final bool isConnected;

  /// ローディング状態
  final bool isLoading;

  const PartyModel({
    required this.roomId,
    required this.members,
    this.isAdventureStarted = false,
    this.isConnected = false,
    this.isLoading = false,
  });

  /// ── 初期状態 ──
  factory PartyModel.initial() {
    return const PartyModel(
      roomId: '',
      members: [],
      isAdventureStarted: false,
      isConnected: false,
      isLoading: false,
    );
  }

  /// ── コピー更新 ──
  PartyModel copyWith({
    String? roomId,
    List<PartyMember>? members,
    bool? isAdventureStarted,
    bool? isConnected,
    bool? isLoading,
  }) {
    return PartyModel(
      roomId: roomId ?? this.roomId,
      members: members ?? this.members,
      isAdventureStarted:
          isAdventureStarted ?? this.isAdventureStarted,
      isConnected: isConnected ?? this.isConnected,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  /// ── ホスト取得 ──
  PartyMember? get host {
    try {
      return members.firstWhere((m) => m.isHost);
    } catch (_) {
      return null;
    }
  }

  /// ── Ready人数 ──
  int get readyCount {
    return members.where((m) => m.isReady).length;
  }

  /// ── 全員Readyか ──
  bool get allReady {
    if (members.isEmpty) return false;
    return members.every((m) => m.isReady);
  }

  /// ── 最大人数か ──
  bool get isFull {
    return members.length >= 5;
  }
}
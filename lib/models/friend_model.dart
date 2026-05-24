// lib/models/friend_model.dart

enum FriendStatus {
  offline,
  exploring,
  inParty,
}

class FriendModel {
  final String id;
  final String name;
  final String avatarUrl;

  // 状態
  final FriendStatus status;

  // 最近の歩数
  final int recentSteps;

  // よく歩くエリア
  final List<String> favoriteAreas;

  // 最終ログイン
  final DateTime lastActiveAt;

  // フレンド申請中か
  final bool isRequestPending;

  const FriendModel({
    required this.id,
    required this.name,
    required this.avatarUrl,
    required this.status,
    required this.recentSteps,
    required this.favoriteAreas,
    required this.lastActiveAt,
    this.isRequestPending = false,
  });

  FriendModel copyWith({
    String? id,
    String? name,
    String? avatarUrl,
    FriendStatus? status,
    int? recentSteps,
    List<String>? favoriteAreas,
    DateTime? lastActiveAt,
    bool? isRequestPending,
  }) {
    return FriendModel(
      id: id ?? this.id,
      name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      status: status ?? this.status,
      recentSteps: recentSteps ?? this.recentSteps,
      favoriteAreas: favoriteAreas ?? this.favoriteAreas,
      lastActiveAt: lastActiveAt ?? this.lastActiveAt,
      isRequestPending:
          isRequestPending ?? this.isRequestPending,
    );
  }

  // ── 状態表示用 ──

  String get statusLabel {
    switch (status) {
      case FriendStatus.offline:
        return '休息中';

      case FriendStatus.exploring:
        return '冒険中';

      case FriendStatus.inParty:
        return 'パーティ中';
    }
  }

  bool get isOnline {
    return status != FriendStatus.offline;
  }
}
// lib/providers/friend_provider.dart

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/friend_model.dart';

class FriendState {
  final List<FriendModel> friends;
  final List<FriendModel> requests;

  const FriendState({
    required this.friends,
    required this.requests,
  });

  FriendState copyWith({
    List<FriendModel>? friends,
    List<FriendModel>? requests,
  }) {
    return FriendState(
      friends: friends ?? this.friends,
      requests: requests ?? this.requests,
    );
  }

  int get onlineCount {
    return friends.where((f) => f.isOnline).length;
  }
}

class FriendNotifier extends Notifier<FriendState> {
  @override
  FriendState build() {
    return FriendState(
      friends: _mockFriends,
      requests: _mockRequests,
    );
  }

  // ── フレンド追加 ──
  void addFriend(FriendModel friend) {
    state = state.copyWith(
      friends: [...state.friends, friend],
    );
  }

  // ── 申請承認 ──
  void acceptRequest(String friendId) {
    final request = state.requests.firstWhere(
      (r) => r.id == friendId,
    );

    final updatedRequests = state.requests
        .where((r) => r.id != friendId)
        .toList();

    final updatedFriends = [
      ...state.friends,
      request.copyWith(
        isRequestPending: false,
      ),
    ];

    state = state.copyWith(
      friends: updatedFriends,
      requests: updatedRequests,
    );
  }

  // ── 申請拒否 ──
  void rejectRequest(String friendId) {
    state = state.copyWith(
      requests: state.requests
          .where((r) => r.id != friendId)
          .toList(),
    );
  }

  // ── 招待送信 ──
  void inviteFriend(String friendId) {
    // TODO:
    // Firebase通知とかに置き換える
    debugPrint('invite -> $friendId');
  }

  // ── 検索（仮） ──
  List<FriendModel> searchFriend(String keyword) {
    return state.friends.where((friend) {
      return friend.name
          .toLowerCase()
          .contains(keyword.toLowerCase());
    }).toList();
  }
}

// ── Provider ─────────────────────────────

final friendProvider = NotifierProvider<FriendNotifier, FriendState>(
  FriendNotifier.new,
);

// ── モックデータ ──────────────────────────

final List<FriendModel> _mockFriends = [
  FriendModel(
    id: 'f001',
    name: 'ルナ',
    avatarUrl: '',
    status: FriendStatus.exploring,
    recentSteps: 12421,
    favoriteAreas: ['渋谷', '下北沢'],
    lastActiveAt: DateTime.now(),
  ),

  FriendModel(
    id: 'f002',
    name: 'ノア',
    avatarUrl: '',
    status: FriendStatus.offline,
    recentSteps: 4221,
    favoriteAreas: ['吉祥寺'],
    lastActiveAt: DateTime.now().subtract(
      const Duration(hours: 5),
    ),
  ),

  FriendModel(
    id: 'f003',
    name: 'ミナ',
    avatarUrl: '',
    status: FriendStatus.inParty,
    recentSteps: 18902,
    favoriteAreas: ['浅草', '上野'],
    lastActiveAt: DateTime.now(),
  ),
];

final List<FriendModel> _mockRequests = [
  FriendModel(
    id: 'r001',
    name: 'アルマ',
    avatarUrl: '',
    status: FriendStatus.offline,
    recentSteps: 5320,
    favoriteAreas: ['中野'],
    lastActiveAt: DateTime.now(),
    isRequestPending: true,
  ),

  FriendModel(
    id: 'r002',
    name: 'シエル',
    avatarUrl: '',
    status: FriendStatus.exploring,
    recentSteps: 9100,
    favoriteAreas: ['池袋'],
    lastActiveAt: DateTime.now(),
    isRequestPending: true,
  ),
];
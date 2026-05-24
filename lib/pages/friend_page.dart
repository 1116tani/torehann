// lib/pages/friend/friend_page.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/friend_provider.dart';
import '../../widgets/friend/friend_card.dart';
import '../../widgets/friend/friend_request_tile.dart';

class FriendPage extends ConsumerStatefulWidget {
  const FriendPage({super.key});

  @override
  ConsumerState<FriendPage> createState() => _FriendPageState();
}

class _FriendPageState extends ConsumerState<FriendPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final TextEditingController _searchController =
      TextEditingController();

  @override
  void initState() {
    super.initState();

    _tabController = TabController(
      length: 2,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(friendProvider);
    final notifier = ref.read(friendProvider.notifier);

    return Scaffold(
      backgroundColor: const Color(0xFF1C1610),

      appBar: AppBar(
        backgroundColor: const Color(0xFF1C1610),
        elevation: 0,
        centerTitle: true,

        title: const Column(
          children: [
            Text(
              '冒険者ギルド',
              style: TextStyle(
                color: Color(0xFFF5EDD8),
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),

            SizedBox(height: 2),

            Text(
              'ADVENTURERS GUILD',
              style: TextStyle(
                color: Color(0xFFC8A97A),
                fontSize: 9,
                letterSpacing: 2,
              ),
            ),
          ],
        ),

        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(52),

          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),

            child: Container(
              height: 42,

              decoration: BoxDecoration(
                color: const Color(0xFF2C2318),
                borderRadius: BorderRadius.circular(16),
              ),

              child: TabBar(
                controller: _tabController,

                indicator: BoxDecoration(
                  color: const Color(0xFFB8860B),
                  borderRadius: BorderRadius.circular(14),
                ),

                dividerColor: Colors.transparent,

                labelColor: Colors.white,
                unselectedLabelColor:
                    const Color(0xFFC8A97A),

                tabs: const [
                  Tab(text: '仲間一覧'),
                  Tab(text: '新たな出会い'),
                ],
              ),
            ),
          ),
        ),
      ),

      body: TabBarView(
        controller: _tabController,

        children: [
          // ─────────────────────────
          // 仲間一覧
          // ─────────────────────────
          Padding(
            padding: const EdgeInsets.all(16),

            child: Column(
              children: [
                // サマリー
                Container(
                  padding: const EdgeInsets.all(16),

                  decoration: BoxDecoration(
                    color: const Color(0xFF2C2318),
                    borderRadius: BorderRadius.circular(18),

                    border: Border.all(
                      color: const Color(0xFF4A3728),
                    ),
                  ),

                  child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceAround,

                    children: [
                      _SummaryItem(
                        label: '総フレンド',
                        value: '${state.friends.length}人',
                      ),

                      Container(
                        width: 1,
                        height: 36,
                        color: const Color(0xFF4A3728),
                      ),

                      _SummaryItem(
                        label: '冒険中',
                        value: '${state.onlineCount}人',
                        highlight: true,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                // フレンド一覧
                Expanded(
                  child: ListView.builder(
                    itemCount: state.friends.length,

                    itemBuilder: (context, index) {
                      final friend =
                          state.friends[index];

                      return FriendCard(
                        friend: friend,

                        onInvite: () {
                          notifier.inviteFriend(
                            friend.id,
                          );

                          ScaffoldMessenger.of(context)
                              .showSnackBar(
                            SnackBar(
                              content: Text(
                                '${friend.name} を招待したよ',
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // ─────────────────────────
          // 新たな出会い
          // ─────────────────────────
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),

            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [
                // ── 自分のコード ──
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),

                  decoration: BoxDecoration(
                    color: const Color(0xFF2C2318),

                    borderRadius:
                        BorderRadius.circular(20),

                    border: Border.all(
                      color: const Color(0xFFB8860B),
                      width: 0.8,
                    ),
                  ),

                  child: Column(
                    children: [
                      const Text(
                        'あなたの冒険者コード',
                        style: TextStyle(
                          color: Color(0xFFC8A97A),
                          fontSize: 12,
                        ),
                      ),

                      const SizedBox(height: 14),

                      const Text(
                        '58241',
                        style: TextStyle(
                          color: Color(0xFFF5EDD8),
                          fontSize: 34,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 6,
                        ),
                      ),

                      const SizedBox(height: 18),

                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                Clipboard.setData(
                                  const ClipboardData(
                                    text: '58241',
                                  ),
                                );

                                ScaffoldMessenger.of(
                                  context,
                                ).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'コードをコピーしたよ',
                                    ),
                                  ),
                                );
                              },

                              icon: const Icon(
                                Icons.copy,
                              ),

                              label: const Text(
                                'コピー',
                              ),

                              style:
                                  OutlinedButton.styleFrom(
                                foregroundColor:
                                    const Color(
                                  0xFFC8A97A,
                                ),

                                side: const BorderSide(
                                  color:
                                      Color(0xFFB8860B),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(width: 10),

                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {},

                              icon: const Icon(
                                Icons.qr_code,
                              ),

                              label: const Text(
                                'QR表示',
                              ),

                              style:
                                  ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color(
                                  0xFFB8860B,
                                ),

                                foregroundColor:
                                    Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 22),

                // ── 検索 ──
                const Text(
                  '冒険者検索',
                  style: TextStyle(
                    color: Color(0xFFF5EDD8),
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),

                const SizedBox(height: 10),

                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF2C2318),
                    borderRadius:
                        BorderRadius.circular(16),

                    border: Border.all(
                      color: const Color(0xFF4A3728),
                    ),
                  ),

                  child: TextField(
                    controller: _searchController,

                    style: const TextStyle(
                      color: Color(0xFFF5EDD8),
                    ),

                    decoration: const InputDecoration(
                      border: InputBorder.none,

                      prefixIcon: Icon(
                        Icons.search,
                        color: Color(0xFFC8A97A),
                      ),

                      hintText: '冒険者IDを入力...',
                      hintStyle: TextStyle(
                        color: Color(0xFF7A5C3A),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 28),

                // ── 申請一覧 ──
                const Text(
                  '届いた申請',
                  style: TextStyle(
                    color: Color(0xFFF5EDD8),
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),

                const SizedBox(height: 12),

                ...state.requests.map(
                  (request) {
                    return FriendRequestTile(
                      friend: request,

                      onAccept: () {
                        notifier.acceptRequest(
                          request.id,
                        );
                      },

                      onReject: () {
                        notifier.rejectRequest(
                          request.id,
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── サマリー ──────────────────────────

class _SummaryItem extends StatelessWidget {
  final String label;
  final String value;
  final bool highlight;

  const _SummaryItem({
    required this.label,
    required this.value,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF7A5C3A),
            fontSize: 11,
          ),
        ),

        const SizedBox(height: 4),

        Text(
          value,
          style: TextStyle(
            color: highlight
                ? const Color(0xFF57D6C9)
                : const Color(0xFFF5EDD8),

            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
// lib/pages/collection/collection_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/collection_provider.dart';
import '../../widgets/collection/fragment_grid_item.dart';

class CollectionPage extends ConsumerWidget {
  const CollectionPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(collectionListProvider);

    // 取得済みの種類数を計算
    final unlockedCount = items.where((item) => item.isUnlocked).length;

    // レアリティごとにグループ分けするよ
    final normalItems = items
        .where((i) => i.rarity == ItemRarity.normal)
        .toList();
    final rareItems = items.where((i) => i.rarity == ItemRarity.rare).toList();
    final legendItems = items
        .where((i) => i.rarity == ItemRarity.legend)
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFF1C1610),
      appBar: AppBar(
        title: const Text(
          '✦ 宝箱 ✦',
          style: TextStyle(
            color: Color(0xFFF5EDD8),
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF2C2318),
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFFC8A97A)),
      ),
      body: CustomScrollView(
        slivers: [
          // ── ヘッダー：収集率 ──
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
              decoration: const BoxDecoration(
                color: Color(0xFF2C2318),
                border: Border(
                  bottom: BorderSide(color: Color(0xFF5C4033), width: 1),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '見出した秘宝の数',
                    style: TextStyle(color: Color(0xFFC8A97A), fontSize: 14),
                  ),
                  Text(
                    '$unlockedCount / ${items.length}',
                    style: const TextStyle(
                      color: Color(0xFFB8860B),
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── セクションを作る魔法のお手伝いメソッド ──
          ..._buildCategorySection('ノーマル遺物', normalItems),
          ..._buildCategorySection('レア遺物', rareItems),
          ..._buildCategorySection('レジェンド遺物', legendItems),

          const SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      ),
    );
  }

  // カテゴリごとの見出しとグリッドを作るヘルパーメソッド
  List<Widget> _buildCategorySection(
    String title,
    List<CollectionItemModel> categoryItems,
  ) {
    if (categoryItems.isEmpty) return [];

    return [
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, top: 24, bottom: 12),
          child: Text(
            '─ $title ─',
            style: const TextStyle(
              color: Color(0xFF7A5C3A),
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        sliver: SliverGrid(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, // 1行に3つ並べるよ！
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.0, // 真四角！
          ),
          delegate: SliverChildBuilderDelegate(
            (context, index) => FragmentGridItem(item: categoryItems[index]),
            childCount: categoryItems.length,
          ),
        ),
      ),
    ];
  }
}

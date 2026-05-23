// lib/pages/collection/collection_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/fragment_model.dart'; // 👈 新しいレアリティ型を使うためにインポート
import '../../providers/collection_provider.dart';
import '../../widgets/collection/fragment_grid_item.dart';

class CollectionPage extends ConsumerWidget {
  const CollectionPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 💡 新しいUI用モデルのリストを受け取るよ
    final items = ref.watch(collectionListProvider);

    // 取得済みの種類数を計算
    final unlockedCount = items.where((item) => item.isUnlocked).length;

    // 新しい FragmentRarity で綺麗にグループ分け♡
    final normalItems = items
        .where((i) => i.rarity == FragmentRarity.normal)
        .toList();
    final rareItems = items
        .where((i) => i.rarity == FragmentRarity.rare)
        .toList();
    final legendItems = items
        .where((i) => i.rarity == FragmentRarity.legend)
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFF1C1610),
      appBar: AppBar(
        title: const Text(
          '✦ 街の記憶図鑑 ✦', // アプリ名「Tale Trace」に合わせて少しエモくしてみたよ♡
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
                    '見出した街の断片',
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

          // ── 各セクションのレンダリング ──
          ..._buildCategorySection('🟢 日常の断片（ノーマル）', normalItems),
          ..._buildCategorySection('🔷 街角の記憶（レア）', rareItems),
          ..._buildCategorySection('👑 紡がれた神話（レジェンド）', legendItems),

          const SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      ),
    );
  }

  /// カテゴリごとの見出しとグリッドを作るヘルパーメソッド
  List<Widget> _buildCategorySection(
    String title,
    List<CollectionItemUIModel> categoryItems, // 👈 新しいUI用モデルの型に修正
  ) {
    if (categoryItems.isEmpty) return [];

    return [
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, top: 28, bottom: 12),
          child: Text(
            title,
            style: const TextStyle(
              color: Color(0xFF8B7355), // 視認性の高い、少し明るいゴールドブラウンに
              fontSize: 13,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.1,
            ),
          ),
        ),
      ),
      SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        sliver: SliverGrid(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, // みぃくんこだわりの1行3並び！
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.0, // 綺麗な真四角
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
// lib/pages/collection/collection_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../constants/app_colors.dart';
import '../../models/fragment_model.dart'; // 👈 新しいレアリティ型を使うためにインポート
import '../../providers/collection_provider.dart';
import '../../widgets/collection/fragment_grid_item.dart';
import '../widgets/common/custom_header.dart';

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

    final colors = AppColors.of(context);

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Column(
          children: [
            const CustomHeader(
              title: '街の記憶図鑑',
              subtitle: 'MEMORY DICTIONARY',
            ),
            Expanded(
              child: CustomScrollView(
        slivers: [
          // ── ヘッダー：収集率 ──
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
              decoration: BoxDecoration(
                color: colors.surface,
                border: Border(
                  bottom: BorderSide(color: colors.border, width: 1),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '見出した街の断片',
                    style: TextStyle(color: colors.secondary, fontSize: 14),
                  ),
                  Text(
                    '$unlockedCount / ${items.length}',
                    style: TextStyle(
                      color: colors.primary,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── 各セクションのレンダリング ──
          ..._buildCategorySection(context, '🟢 日常の断片（ノーマル）', normalItems),
          ..._buildCategorySection(context, '🔷 街角の記憶（レア）', rareItems),
          ..._buildCategorySection(context, '👑 紡がれた神話（レジェンド）', legendItems),

          const SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      ),
            ),
          ],
        ),
      ),
    );
  }

  /// カテゴリごとの見出しとグリッドを作るヘルパーメソッド
  List<Widget> _buildCategorySection(
    BuildContext context,
    String title,
    List<CollectionItemUIModel> categoryItems,
  ) {
    if (categoryItems.isEmpty) return [];
    final colors = AppColors.of(context);

    return [
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, top: 28, bottom: 12),
          child: Text(
            title,
            style: TextStyle(
              color: colors.secondary,
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
// lib/widgets/route/route_card.dart
import 'package:flutter/material.dart';
import '../../models/route_model.dart';
import '../../models/spot_model.dart'; // 👈 スポットの型を追加
import 'route_tag.dart';
import 'route_preview_map.dart'; // 👈 マップをインポート！

class RouteCard extends StatelessWidget {
  final RouteModel route;
  final Map<String, SpotModel> spots; // 👈 スポットを貰えるようにするよ
  final bool isSelected;
  final VoidCallback onTap;

  const RouteCard({
    super.key,
    required this.route,
    required this.spots, // 👈 必須にするね
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4), // 余白を微調整
      decoration: BoxDecoration(
        color: const Color(0xFF2C2318),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected ? const Color(0xFFB8860B) : const Color(0xFF7A5C3A),
          width: isSelected ? 2 : 0.5,
        ),
        boxShadow: [
          BoxShadow(
            color: isSelected
                ? const Color(0xFFB8860B).withValues(alpha: 0.24)
                : Colors.black.withValues(alpha: 0.32),
            blurRadius: isSelected ? 16 : 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── プレビューマップ ──
                // カードの中にマップを綺麗に埋め込むよ！ピタッと収まるようにパディングなし
                RoutePreviewMap(
                  route: route,
                  spots: spots,
                  isSelected: isSelected,
                ),
                
                // ── テキストコンテンツ群 ──
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ルート名
                      Text(
                        route.themeName,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: isSelected ? Colors.white : const Color(0xFFF5EDD8),
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // 説明文
                      Text(
                        route.themeDescription,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: isSelected ? Colors.white70 : const Color(0xFFC8A97A),
                          fontSize: 12,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 12),
                      // タグ一覧
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: route.tags
                            .map((tag) => RouteTag(label: tag))
                            .toList(),
                      ),
                    ],
                  ),
                ),
                const Spacer(), // 高さを揃えるための魔法のクッション
              ],
            ),
          ),
        ),
      ),
    );
  }
}
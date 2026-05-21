// lib/widgets/history/history_card.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HistoryCard extends StatelessWidget {
  final Map<String, dynamic> historyData;

  const HistoryCard({super.key, required this.historyData});

  @override
  Widget build(BuildContext context) {
    // データの安全な取り出し（万が一空っぽでもクラッシュしないようにね！）
    final themeName = historyData['themeName'] ?? '名もなき散歩道';
    final themeDescription = historyData['themeDescription'] ?? '';
    final aiReport = historyData['aiReport'] ?? 'ここに冒険の記憶が刻まれます。';
    final totalDistance = (historyData['totalDistance'] ?? 0.0).toDouble();
    final estimatedTime = historyData['estimatedTime'] ?? 0;
    final imageUrls = List<String>.from(historyData['imageUrls'] ?? []);

    // タイムスタンプの日付フォーマット（簡単に「2026/05/21」みたいに変換するよ）
    final createdAt = historyData['createdAt'] as Timestamp?;
    final dateStr = createdAt != null
        ? '${createdAt.toDate().year}/${createdAt.toDate().month.toString().padLeft(2, '0')}/${createdAt.toDate().day.toString().padLeft(2, '0')}'
        : 'はるかな過去の日';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2318), // いつもの渋いブラウン
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF7A5C3A), width: 0.5),
        boxShadow: const [
          BoxShadow(color: Colors.black45, blurRadius: 6, offset: Offset(0, 3)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── ヘッダー（日付 ＆ 距離など） ──
          Padding(
            padding: const EdgeInsets.only(
              left: 16,
              right: 16,
              top: 14,
              bottom: 8,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '📅 $dateStr',
                  style: const TextStyle(
                    color: Color(0xFFC8A97A),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${totalDistance.toStringAsFixed(1)}km / 約$estimatedTime分',
                  style: const TextStyle(
                    color: Color(0xFF7A5C3A),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),

          const Divider(color: Color(0xFF4A3728), height: 1),

          // ── ルートタイトル ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text(
              '📖 $themeName',
              style: const TextStyle(
                color: Color(0xFFF5EDD8),
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // ── 💡 AI冒険日誌（ここが一番魅せたいエモポイント！） ──
          Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF3D2B1F), // 少し明るい背景で本っぽく
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFFB8860B).withValues(alpha: 0.3),
                width: 0.5,
              ),
            ),
            child: Text(
              aiReport,
              style: const TextStyle(
                color: Color(0xFFC8A97A),
                fontSize: 12,
                height: 1.5, // 行間を広げて読みやすく！
                fontStyle: FontStyle.italic, // 詩的な雰囲気を出すイタリック
              ),
            ),
          ),

          // ── 📸 思い出の写真たち（画像があれば横スクロールで並べるよ） ──
          if (imageUrls.isNotEmpty) ...[
            const SizedBox(height: 12),
            SizedBox(
              height: 80,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: imageUrls.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        imageUrls[index],
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                        // 読み込み中のプレースホルダー
                        loadingBuilder: (context, child, progress) {
                          if (progress == null) return child;
                          return Container(
                            width: 80,
                            color: const Color(0xFF3D2B1F),
                            child: const Center(
                              child: SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Color(0xFFC8A97A),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],

          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

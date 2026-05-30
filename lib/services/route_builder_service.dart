// lib/services/route_builder_service.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import '../models/route_model.dart';
import '../models/spot_model.dart';

class RouteBuilderService {
  RouteModel buildRoute({
    required String id,
    required double startLat,
    required double startLng,
    required String themeName,
    required String themeDescription,
    required List<String> tags,
    required List<SpotModel> geminiSpots,
    String? destinationName,
    double? destinationLat,
    double? destinationLng,
  }) {
    final List<SpotModel> finalSpots = [];

    // 1. 出発点（現在地）を追加
    finalSpots.add(
      SpotModel(
        id: '${id}_start',
        lat: startLat,
        lng: startLng,
        name: '出発地',
        aiStoryName: '旅立ちの始まり',
        aiFlavorText: 'ここから新たな物語が紡ぎ出されます。',
        category: 'スタート',
      ),
    );

    // 2. Geminiが生成した中間経由地を追加
    for (int i = 0; i < geminiSpots.length; i++) {
      final spot = geminiSpots[i];
      finalSpots.add(
        SpotModel(
          id: spot.id.isNotEmpty ? '${id}_${spot.id}' : '${id}_spot_$i',
          lat: spot.lat,
          lng: spot.lng,
          name: spot.name,
          aiStoryName: spot.aiStoryName,
          aiFlavorText: spot.aiFlavorText,
          category: spot.category.isNotEmpty ? spot.category : '寄り道',
        ),
      );
    }

    // 3. 目的地（設定されている場合）を最後に追加
    if (destinationLat != null &&
        destinationLng != null &&
        destinationName != null &&
        destinationName.isNotEmpty) {
      finalSpots.add(
        SpotModel(
          id: '${id}_destination',
          lat: destinationLat,
          lng: destinationLng,
          name: destinationName,
          aiStoryName: '約束の終着地',
          aiFlavorText: 'ついに目的地へ到達しました。ここがあなたの旅の終着点です。',
          category: 'ゴール',
        ),
      );
    }

    // 4. 全スポット間の距離をローカルで計算 (m -> km)
    double totalDistanceMeters = 0.0;
    for (int i = 0; i < finalSpots.length - 1; i++) {
      totalDistanceMeters += Geolocator.distanceBetween(
        finalSpots[i].lat,
        finalSpots[i].lng,
        finalSpots[i + 1].lat,
        finalSpots[i + 1].lng,
      );
    }

    // 小数点第1位までに丸める
    final double totalDistanceKm = double.parse(
      (totalDistanceMeters / 1000.0).toStringAsFixed(1),
    );

    // 5. 所要時間をローカルで計算 (徒歩分速75m ＋ スポット滞在各3分)
    final int estimatedTime =
        (totalDistanceMeters / 75.0).round() + (finalSpots.length * 3);

    return RouteModel(
      id: id,
      themeName: themeName,
      themeDescription: themeDescription,
      tags: tags,
      generatedSpots: finalSpots,
      spotIds: finalSpots.map((s) => s.id).toList(),
      totalDistance: totalDistanceKm,
      estimatedTime: estimatedTime,
      createdAt: DateTime.now(),
    );
  }
}

// ─────────────────────────────
// 🛰️ Provider 登録
// ─────────────────────────────
final routeBuilderServiceProvider = Provider<RouteBuilderService>((ref) {
  return RouteBuilderService();
});

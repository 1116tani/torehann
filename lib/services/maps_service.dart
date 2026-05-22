// lib/services/maps_service.dart

import 'package:dio/dio.dart';
import '../models/spot_model.dart';

class MapsService {
  final Dio _dio;

  // もしGoogle Directions APIを使う場合はここにキーを入れるよ
  static const _googleMapsApiKey = 'YOUR_GOOGLE_MAPS_API_KEY';

  MapsService() : _dio = Dio();

  /// ── スポット一覧から、地図に描画するための「ルート座標列（ポリライン）」を生成する ──
  Future<List<Map<String, double>>> getRoutePoints(
    List<SpotModel> spots,
  ) async {
    if (spots.isEmpty) return [];

    try {
      // 💡 ハッカソン爆速モード：APIを叩かずに、スポット間を擬似的に繋ぐ座標列を返すよ！
      // これがあれば、GoogleのDirections APIが間に合わなくても、地図に綺麗な線が引ける
      List<Map<String, double>> polylinePoints = [];

      for (int i = 0; i < spots.length - 1; i++) {
        final start = spots[i];
        final end = spots[i + 1];

        // スタート地点を追加
        polylinePoints.add({'lat': start.lat, 'lng': start.lng});

        // 2点の間を少し曲がりくねらせて「道っぽい」中間点を計算（ちょっといじわるに、真っ直ぐにさせない魔法だよ！）
        final midLat = (start.lat + end.lat) / 2 + 0.0005;
        final midLng = (start.lng + end.lng) / 2 - 0.0005;
        polylinePoints.add({'lat': midLat, 'lng': midLng});
      }

      // 最後のスポットを追加
      polylinePoints.add({'lat': spots.last.lat, 'lng': spots.last.lng});

      // 実際はちょっと待つ演出（AIっぽさ！）
      await Future.delayed(const Duration(milliseconds: 500));

      return polylinePoints;

      /* // 💡 【本番用】Google Directions APIを使う場合は、ここをアンコメントしてね！
      final origin = '${spots.first.lat},${spots.first.lng}';
      final destination = '${spots.last.lat},${spots.last.lng}';
      final waypoints = spots.skip(1).take(spots.length - 2).map((s) => '${s.lat},${s.lng}').join('|');

      final response = await _dio.get(
        'https://maps.googleapis.com/maps/api/directions/json',
        queryParameters: {
          'origin': origin,
          'destination': destination,
          'waypoints': waypoints,
          'key': _googleMapsApiKey,
          'mode': 'walking', // 徒歩モード
        },
      );
      
      // ここでレスポンスの overview_polyline をデコードして座標リストにして返すロジックを書くよ！
      */
    } catch (e) {
      throw Exception('ルート軌跡の取得に失敗しました: $e');
    }
  }
}

// lib/services/location_service.dart

import 'package:geolocator/geolocator.dart';

class LocationService {
  // ─────────────────────────────
  // 📍 位置情報サービス確認
  // ─────────────────────────────

  Future<void> checkPermission() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      throw Exception('位置情報サービスがOFFになっています。\n端末設定から有効化してください。');
    }

    LocationPermission permission = await Geolocator.checkPermission();

    // 初回拒否
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        throw Exception('位置情報の権限が拒否されました。');
      }
    }

    // 永久拒否
    if (permission == LocationPermission.deniedForever) {
      throw Exception('位置情報権限が永久拒否されています。\n設定画面から許可してください。');
    }
  }

  // ─────────────────────────────
  // 📍 現在地取得
  // ─────────────────────────────

  Future<Position> getCurrentLocation() async {
    await checkPermission();

    return Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        // GPS取得失敗時に無限待機しない
        timeLimit: Duration(seconds: 10),
      ),
    );
  }

  // ─────────────────────────────
  // 🚶 リアルタイム位置追従
  // ─────────────────────────────

  Stream<Position> getLocationStream() async* {
    await checkPermission();

    const settings = LocationSettings(
      accuracy: LocationAccuracy.bestForNavigation,

      // 5m移動したら更新
      distanceFilter: 5,
    );

    yield* Geolocator.getPositionStream(locationSettings: settings);
  }

  // ─────────────────────────────
  // 🧭 2地点間距離
  // meter単位
  // ─────────────────────────────

  double calculateDistance({
    required double startLat,
    required double startLng,
    required double endLat,
    required double endLng,
  }) {
    return Geolocator.distanceBetween(startLat, startLng, endLat, endLng);
  }

  // ─────────────────────────────
  // 🧭 方角計算
  // degree
  // ─────────────────────────────

  double calculateBearing({
    required double startLat,
    required double startLng,
    required double endLat,
    required double endLng,
  }) {
    return Geolocator.bearingBetween(startLat, startLng, endLat, endLng);
  }
}

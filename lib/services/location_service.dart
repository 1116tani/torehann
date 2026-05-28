// lib/services/location_service.dart

import 'dart:async';

import 'package:geocoding/geocoding.dart';
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

    try {
      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.bestForNavigation,

          // GPS取得失敗時に無限待機しない
          timeLimit: Duration(seconds: 12),
        ),
      );
    } on TimeoutException {
      throw Exception('GPS取得がタイムアウトしました。');
    } catch (e) {
      throw Exception('現在地の取得に失敗しました: $e');
    }
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

  // ─────────────────────────────
  // 🏙️ 緯度経度 → 地名変換
  // （現在地表示用）
  // ─────────────────────────────

  Future<String> getPlaceName({
    required double latitude,
    required double longitude,
  }) async {
    try {
      final placemarks = await placemarkFromCoordinates(
        latitude,
        longitude,
      );

      if (placemarks.isEmpty) {
        return '現在地取得中...';
      }

      final place = placemarks.first;

      // 市区町村優先
      final locality = place.locality;
      final subLocality = place.subLocality;
      final administrativeArea = place.administrativeArea;

      if (locality != null && locality.isNotEmpty) {
        return locality;
      }

      if (subLocality != null && subLocality.isNotEmpty) {
        return subLocality;
      }

      if (administrativeArea != null && administrativeArea.isNotEmpty) {
        return administrativeArea;
      }

      return '現在地';
    } catch (_) {
      return '現在地';
    }
  }

  // ─────────────────────────────
  // 📍 GPS精度テキスト
  // UI表示用
  // ─────────────────────────────

  String getAccuracyLabel(double accuracy) {
    if (accuracy <= 10) {
      return 'GPS精度: 高';
    }

    if (accuracy <= 30) {
      return 'GPS精度: 中';
    }

    return 'GPS精度: 低';
  }

  // ─────────────────────────────
  // 🛰️ GPS利用可能か
  // ─────────────────────────────

  Future<bool> isGpsAvailable() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        return false;
      }

      final permission = await Geolocator.checkPermission();

      return permission != LocationPermission.denied &&
          permission != LocationPermission.deniedForever;
    } catch (_) {
      return false;
    }
  }
}

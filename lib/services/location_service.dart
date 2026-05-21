// lib/services/location_service.dart

import 'package:geolocator/geolocator.dart';

class LocationService {
  /// ── ユーザーの現在地（緯度・経度）を取得する ────────────────
  Future<Position> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // 位置情報サービスが有効かチェック
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('位置情報サービスが無効になっています。設定から有効にしてくださいね。');
    }

    // 権限のチェック
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('位置情報の権限を拒否されました。冒険には位置情報が必要なので、許可してください。');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('位置情報の権限が永久に拒否されています。アプリの設定画面から許可してね。');
    }

    // 現在地を取得（ハッカソン用には高精度すぎると時間がかかるので、accuracyはhighかmediumがおすすめ）
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  /// ── 位置情報の変更をリアルタイムに監視する（歩いている時の追従用） ──
  Stream<Position> getLocationStream() {
    return Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10, // 10メートル動いたら通知するよ
      ),
    );
  }
}

// 💡 route_provider.dart などから ref.read(locationServiceProvider) で呼び出せるように、
// globalなProviderを作っておくと便利だよ！

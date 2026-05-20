// lib/providers/location_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

// 位置情報の状態を管理するProvider
// シンプルに現在のPositionを返す（取得できていない時はnull）
final locationProvider = StreamProvider<Position?>((ref) async* {
  // 権限の確認
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    yield null;
    return;
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      yield null;
      return;
    }
  }

  if (permission == LocationPermission.deniedForever) {
    yield null;
    return;
  }

  // 位置情報のストリームをリッスンする
  const locationSettings = LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 5, // 5メートル動いたら更新
  );

  yield* Geolocator.getPositionStream(locationSettings: locationSettings);
});

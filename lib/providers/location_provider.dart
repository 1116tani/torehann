// lib/providers/location_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

final locationProvider = StreamProvider<Position?>((ref) async* {
  // ── 位置情報サービスの確認 ──
  final serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    yield null;
    return;
  }

  // ── 権限の確認・リクエスト ──
  var permission = await Geolocator.checkPermission();
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

  // ── 位置情報ストリームを流す ──
  const locationSettings = LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 5, // 5m動いたら更新
  );

  // Position → Position? にキャストして流す
  yield* Geolocator.getPositionStream(
    locationSettings: locationSettings,
  ).map((position) => position as Position?);
});

// lib/providers/location_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import '../services/location_service.dart';

// ─────────────────────────────
// 📍 LocationService Provider
// ─────────────────────────────

final locationServiceProvider = Provider<LocationService>((ref) {
  return LocationService();
});

// ─────────────────────────────
// 📡 リアルタイム現在地
// NavigationPageなどで常時監視用
// ─────────────────────────────

final locationProvider = StreamProvider.autoDispose<Position>((ref) {
  final service = ref.read(locationServiceProvider);

  return service.getLocationStream();
});

// ─────────────────────────────
// 📍 単発現在地取得
// 初回ロード時や手動更新用
// ─────────────────────────────

final currentLocationProvider = FutureProvider<Position>((ref) async {
  final service = ref.read(locationServiceProvider);

  return service.getCurrentLocation();
});

// ─────────────────────────────
// 🛰️ GPS ON/OFF 状態監視
// ─────────────────────────────

final locationServiceStatusProvider = StreamProvider.autoDispose<ServiceStatus>(
  (ref) {
    return Geolocator.getServiceStatusStream();
  },
);

// ─────────────────────────────
// 🔐 権限状態取得
// ─────────────────────────────

final locationPermissionProvider =
    FutureProvider.autoDispose<LocationPermission>((ref) async {
      return Geolocator.checkPermission();
    });

// ─────────────────────────────
// 📍 GPS有効状態
// true = ON
// false = OFF
// ─────────────────────────────

final isLocationServiceEnabledProvider = FutureProvider.autoDispose<bool>((
  ref,
) async {
  return Geolocator.isLocationServiceEnabled();
});

// ─────────────────────────────
// 📌 現在地文字列
// UI表示用
// 「GPS取得中...」とかをここで管理
// ─────────────────────────────

final currentLocationLabelProvider = FutureProvider.autoDispose<String>((
  ref,
) async {
  try {
    final position = await ref.watch(currentLocationProvider.future);
    // TODO: Geocoding APIで地名に変換する
    // 今は「現在地取得済み」を返す
    return '現在地取得済み（${position.latitude.toStringAsFixed(2)}, ${position.longitude.toStringAsFixed(2)})';
  } catch (_) {
    return '現在地を取得できません';
  }
});
// ─────────────────────────────
// 🚨 GPSエラーメッセージ
// UI側でそのまま表示できる
// ─────────────────────────────

final locationErrorProvider = FutureProvider.autoDispose<String?>((ref) async {
  try {
    await ref.watch(currentLocationProvider.future);
    return null;
  } catch (e) {
    return e.toString();
  }
});

// ─────────────────────────────
// 📍 GPS状態をまとめたEnum
// location_status_card.dartで使う
// ─────────────────────────────

enum LocationStatus {
  loading, // 取得中
  success, // 取得済み
  error, // エラー
  disabled, // GPS OFF
}

final locationStatusProvider = FutureProvider.autoDispose<LocationStatus>((
  ref,
) async {
  // GPS自体がOFFの場合
  final isEnabled = await ref.watch(isLocationServiceEnabledProvider.future);
  if (!isEnabled) return LocationStatus.disabled;

  // 権限がない場合
  final permission = await ref.watch(locationPermissionProvider.future);
  if (permission == LocationPermission.denied ||
      permission == LocationPermission.deniedForever) {
    return LocationStatus.error;
  }

  // 取得を試みる
  try {
    await ref.watch(currentLocationProvider.future);
    return LocationStatus.success;
  } catch (_) {
    return LocationStatus.error;
  }
});

// lib/providers/location_provider.dart

import 'dart:async';

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
// 📡 現在地ストリーム Provider
// ─────────────────────────────

final locationProvider = StreamProvider.autoDispose<Position>((ref) {
  final locationService = ref.read(locationServiceProvider);

  return locationService.getLocationStream();
});

// ─────────────────────────────
// 📍 現在地取得 Provider
// 単発取得用
// ─────────────────────────────

final currentLocationProvider = FutureProvider<Position>((ref) async {
  final locationService = ref.read(locationServiceProvider);

  return locationService.getCurrentLocation();
});

// ─────────────────────────────
// 🛰️ GPS状態監視
// ─────────────────────────────

final locationServiceStatusProvider = StreamProvider<ServiceStatus>((ref) {
  return Geolocator.getServiceStatusStream();
});

// ─────────────────────────────
// 📍 権限状態取得
// ─────────────────────────────

final locationPermissionProvider = FutureProvider<LocationPermission>((
  ref,
) async {
  return Geolocator.checkPermission();
});

import 'package:flutter/services.dart';

Future<String> loadGoogleMapStyle(String themeMode) async {
  const darkStyleAsset = 'assets/map_styles/dark_fantasy_map.json';
  const daylightStyleAsset = 'assets/map_styles/daylight_parchment_map.json';

  final assetPath = themeMode == 'daylight' ? daylightStyleAsset : darkStyleAsset;
  return await rootBundle.loadString(assetPath);
}

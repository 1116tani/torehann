// lib/services/weather_service.dart

import 'dart:convert';

import 'package:http/http.dart' as http;

class WeatherInfo {
  final String locationName;

  final double temperature;

  final String description;

  final String iconCode;

  final int humidity;

  final double windSpeed;

  final bool isRaining;

  const WeatherInfo({
    required this.locationName,
    required this.temperature,
    required this.description,
    required this.iconCode,
    required this.humidity,
    required this.windSpeed,
    required this.isRaining,
  });

  factory WeatherInfo.fromJson(Map<String, dynamic> json) {
    final weather = (json['weather'] as List).first;
    final main = json['main'];
    final wind = json['wind'];

    final weatherMain = weather['main'].toString().toLowerCase();

    return WeatherInfo(
      locationName: json['name'] ?? 'Unknown',

      temperature: (main['temp'] as num).toDouble(),

      description: weather['description'] ?? '',

      iconCode: weather['icon'] ?? '01d',

      humidity: main['humidity'] ?? 0,

      windSpeed: (wind['speed'] as num?)?.toDouble() ?? 0,

      isRaining:
          weatherMain.contains('rain') ||
          weatherMain.contains('drizzle') ||
          weatherMain.contains('thunderstorm'),
    );
  }

  // ☀️ UI用アイコンURL
  String get iconUrl {
    return 'https://openweathermap.org/img/wn/$iconCode@2x.png';
  }

  // 🌡️ 温度表示
  String get temperatureLabel {
    return '${temperature.round()}°';
  }

  // 🌤️ 日本語化
  String get localizedDescription {
    switch (description.toLowerCase()) {
      case 'clear sky':
        return '快晴';

      case 'few clouds':
        return '晴れ';

      case 'scattered clouds':
      case 'broken clouds':
      case 'overcast clouds':
        return 'くもり';

      case 'light rain':
        return '小雨';

      case 'moderate rain':
      case 'heavy intensity rain':
        return '雨';

      case 'thunderstorm':
        return '雷雨';

      case 'snow':
        return '雪';

      case 'mist':
      case 'fog':
        return '霧';

      default:
        return description;
    }
  }
}

class WeatherService {
  // ─────────────────────────────
  // 🔑 OpenWeatherMap API Key
  // ─────────────────────────────
  //
  // ↓ 必ず自分のAPIキーに変更してね！
  //
  static const String _apiKey = 'YOUR_OPENWEATHERMAP_API_KEY';

  static const String _baseUrl =
      'https://api.openweathermap.org/data/2.5/weather';

  // ─────────────────────────────
  // ☀️ 現在地の天気取得
  // ─────────────────────────────

  Future<WeatherInfo> getCurrentWeather({
    required double latitude,
    required double longitude,
  }) async {
    try {
      final uri = Uri.parse(
        '$_baseUrl'
        '?lat=$latitude'
        '&lon=$longitude'
        '&appid=$_apiKey'
        '&units=metric'
        '&lang=ja',
      );

      final response = await http.get(uri);

      if (response.statusCode != 200) {
        throw Exception(
          '天気情報の取得に失敗しました。'
          '(${response.statusCode})',
        );
      }

      final json = jsonDecode(response.body) as Map<String, dynamic>;

      return WeatherInfo.fromJson(json);
    } catch (e) {
      throw Exception('天気データを取得できませんでした。\n$e');
    }
  }

  // ─────────────────────────────
  // 🌦️ 天候から探索演出を決定
  // ─────────────────────────────

  String getWeatherMood(WeatherInfo weather) {
    if (weather.isRaining) {
      return '雨に濡れた街角';
    }

    if (weather.temperature <= 5) {
      return '凍てつく静寂';
    }

    if (weather.temperature >= 30) {
      return '陽炎揺れる街路';
    }

    if (weather.localizedDescription.contains('くもり')) {
      return '曇天に沈む街';
    }

    return '穏やかな旅日和';
  }

  // ─────────────────────────────
  // 🧭 天候によるおすすめモード
  // ─────────────────────────────

  String recommendAdventureMode(WeatherInfo weather) {
    if (weather.isRaining) {
      return '室内探索';
    }

    if (weather.temperature >= 32) {
      return '短距離散策';
    }

    if (weather.temperature <= 3) {
      return 'カフェ巡り';
    }

    return '街歩き探索';
  }
}

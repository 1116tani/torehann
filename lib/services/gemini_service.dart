// lib/services/gemini_service.dart

import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../constants/api_constants.dart';
import '../models/route_model.dart';
import '../models/spot_model.dart';

class GeminiService {
  final Dio _dio;

  static String get _apiKey {
    final envKey =
        dotenv.env['GEMINI_API_KEY'] ?? dotenv.env['Gemini_API_Key'] ?? '';
    if (envKey.isNotEmpty) {
      return envKey;
    }
    return ApiConstants.geminiApiKey;
  }

  static const _baseUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-3.5-flash:generateContent';

  GeminiService()
    : _dio = Dio(
        BaseOptions(
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 60),
          sendTimeout: const Duration(seconds: 30),
          headers: {'Content-Type': 'application/json'},
        ),
      );

  Future<List<RouteModel>> generateRoutes({
    required double lat,
    required double lng,
    required String mood,
    required String mode,
    required List<String> hobbyTags,
    String destination = '',
  }) async {
    if (_apiKey.isEmpty) {
      throw Exception('Gemini APIキーが設定されていません。');
    }

    final prompt = _buildPrompt(
      lat: lat,
      lng: lng,
      mood: mood,
      mode: mode,
      hobbyTags: hobbyTags,
      destination: destination,
    );

    try {
      final response = await _dio.post(
        '$_baseUrl?key=$_apiKey',
        data: {
          'contents': [
            {
              'parts': [
                {'text': prompt},
              ],
            },
          ],
          'generationConfig': {
            'temperature': 0.9,
            'topP': 0.95,
            'maxOutputTokens': 8192,
            'responseMimeType': 'application/json',
          },
          'safetySettings': [
            {
              'category': 'HARM_CATEGORY_HATE_SPEECH',
              'threshold': 'BLOCK_ONLY_HIGH',
            },
            {
              'category': 'HARM_CATEGORY_DANGEROUS_CONTENT',
              'threshold': 'BLOCK_ONLY_HIGH',
            },
          ],
        },
      );

      final candidates = response.data['candidates'];
      if (candidates == null || candidates.isEmpty) {
        throw Exception('Geminiからレスポンスが返りませんでした。');
      }

      final rawText = candidates[0]['content']['parts'][0]['text'];
      return _parseRoutes(rawText);
    } on DioException catch (e) {
      final message = e.response?.data.toString() ?? e.message ?? 'unknown';
      throw Exception('Gemini API通信に失敗しました\n$message');
    } on TimeoutException {
      throw Exception('Gemini APIがタイムアウトしました');
    } catch (e) {
      throw Exception('ルート生成に失敗しました\n$e');
    }
  }

  Future<String> generateAdventureReport({
    required String themeName,
    required List<SpotModel> visitedSpots,
    required double distanceKm,
    required int durationMinutes,
  }) async {
    if (_apiKey.isEmpty) {
      throw Exception('Gemini APIキーが設定されていません。');
    }

    final spotsText = visitedSpots
        .map((e) => e.aiStoryName.isNotEmpty ? e.aiStoryName : e.name)
        .join('、');

    final prompt =
        '''
あなたは幻想的な旅の語り部です。

以下の冒険記録を元に、150文字程度の詩的な冒険レポートを書いてください。
JSONではなく、文章だけを返してください。

テーマ:
$themeName

巡った場所:
$spotsText

歩行距離:
${distanceKm.toStringAsFixed(1)}km

所要時間:
$durationMinutes分
''';

    try {
      final response = await _dio.post(
        '$_baseUrl?key=$_apiKey',
        data: {
          'contents': [
            {
              'parts': [
                {'text': prompt},
              ],
            },
          ],
          'generationConfig': {'temperature': 0.9, 'maxOutputTokens': 512},
        },
      );

      return response.data['candidates'][0]['content']['parts'][0]['text']
          .toString()
          .trim();
    } on DioException catch (e) {
      throw Exception('冒険レポート生成に失敗しました\n$e');
    } catch (e) {
      throw Exception('冒険レポート生成に失敗しました\n$e');
    }
  }

  String _buildPrompt({
    required double lat,
    required double lng,
    required String mood,
    required String mode,
    required List<String> hobbyTags,
    required String destination,
  }) {
    final distanceRange = switch (mode) {
      'お散歩' => '1〜3km',
      '探索' => '3〜6km',
      '冒険' => '6km以上',
      _ => '2〜4km',
    };

    final hobbies = hobbyTags.isEmpty ? '指定なし' : hobbyTags.join('、');
    final destinationText = destination.trim().isEmpty
        ? '現在地周辺でおまかせ'
        : destination.trim();

    return '''
あなたは徒歩ナビアプリのルート生成AIです。
現在地から歩ける、実在する場所だけを使った徒歩ルートを、必ず3つ生成してください。
返答はJSONだけにしてください。説明文、挨拶、Markdown、コードブロックは禁止です。

出力形式:
{
  "routes": [
    {
      "id": "route_001",
      "themeName": "白壁の記憶をたどる小径",
      "themeDescription": "古い街角を抜けると、静かな記憶が道の奥で揺れている。",
      "totalDistance": 2.4,
      "estimatedTime": 35,
      "tags": ["#歴史の灯火", "#静かな歩み", "#路地裏の記憶"],
      "spots": [
        {
          "id": "spot_001",
          "name": "実在するスポット名",
          "lat": 35.0,
          "lng": 139.0,
          "category": "公園",
          "aiStoryName": "物語風の名前",
          "aiFlavorText": "30文字以内の短い説明"
        }
      ]
    }
  ]
}

条件:
- routes は必ず3件: route_001, route_002, route_003
- 3つのルートはテーマ、通るスポット、歩く方向をなるべく分ける
- 3つのルートで同じスポット名を使い回さない
- 3つのルートの経由地ができるだけ重ならないようにする
- 可能なら、route_001は北/東寄り、route_002は西/南寄り、route_003は中心地/別方向のように分散する
- 現在地から徒歩で自然に回れる範囲にする
- 各ルートの spots は2〜3件の中間スポットだけにする
- 目的地が指定されている場合、目的地そのものは spots に含めない
- 目的地が指定されている場合、目的地へ向かう途中にある寄り道スポットだけを spots に入れる
- 目的地がおまかせの場合、各ルートの終点方向もできるだけ別にする
- 実在しない場所、座標が不明な場所、海や建物内だけを通る場所は禁止
- lat/lng は実際の座標に近い値にする
- themeName はゲームっぽく、でも短く
- themeDescription は40〜70文字程度で、詩的だけど意味がわかる文章にする
- tags は3個
- aiStoryName は物語風の短いスポット名
- aiFlavorText は30文字以内

現在地:
緯度: $lat
経度: $lng

目的地:
$destinationText

気分:
$mood

歩く距離:
$mode
目安: $distanceRange

趣味:
$hobbies
''';
  }

  List<RouteModel> _parseRoutes(dynamic rawData) {
    try {
      final cleaned = rawData
          .toString()
          .replaceAll('```json', '')
          .replaceAll('```', '')
          .trim();

      final data = jsonDecode(cleaned) as Map<String, dynamic>;
      final routesJson = data['routes'];

      if (routesJson == null || routesJson is! List) {
        throw Exception('routes が存在しません');
      }

      return routesJson.take(3).map<RouteModel>((routeJson) {
        final spotsJson = routeJson['spots'] as List? ?? [];

        final spots = spotsJson.map<SpotModel>((spotJson) {
          return SpotModel(
            id: spotJson['id'] ?? '',
            name: spotJson['name'] ?? '',
            lat: (spotJson['lat'] ?? 0.0).toDouble(),
            lng: (spotJson['lng'] ?? 0.0).toDouble(),
            category: spotJson['category'] ?? 'スポット',
            aiStoryName: spotJson['aiStoryName'] ?? '',
            aiFlavorText: spotJson['aiFlavorText'] ?? '',
          );
        }).toList();

        return RouteModel(
          id: routeJson['id'] ?? '',
          themeName: routeJson['themeName'] ?? '名もなき探索路',
          themeDescription: routeJson['themeDescription'] ?? '',
          totalDistance: (routeJson['totalDistance'] ?? 0.0).toDouble(),
          estimatedTime: routeJson['estimatedTime'] ?? 0,
          tags: List<String>.from(routeJson['tags'] ?? []),
          spotIds: spots.map((e) => e.id).toList(),
          generatedSpots: spots,
        );
      }).toList();
    } catch (e) {
      throw Exception('Geminiレスポンス解析に失敗しました\n$e');
    }
  }
}

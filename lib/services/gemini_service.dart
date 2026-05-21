// lib/services/gemini_service.dart

import 'dart:convert';
import 'package:dio/dio.dart';
import '../models/route_model.dart';
import '../models/spot_model.dart';

class GeminiService {
  final Dio _dio;

  // ── APIの設定 ──────────────────────────────
  static const _apiKey = 'ここにGemini APIキーを貼る';
  static const _baseUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent';

  GeminiService() : _dio = Dio();

  // ── ルートを生成する ───────────────────────
  Future<List<RouteModel>> generateRoutes({
    required double lat,
    required double lng,
    required String mood, // 気分（のんびり／わくわく／ガッツリ／きまぐれ）
    required String mode, // モード（お散歩／探索／冒険）
    required List<String> hobbyTags, // 趣味タグ
    String destination = '', // 目的地（空の場合はおまかせ）
  }) async {
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
        options: Options(headers: {'Content-Type': 'application/json'}),
        data: {
          'contents': [
            {
              'parts': [
                {'text': prompt},
              ],
            },
          ],
          'generationConfig': {
            'temperature': 0.8, // 創造性を高め
            'maxOutputTokens': 2048,
            'responseMimeType': 'application/json', // JSON形式で返す
          },
        },
      );

      final text =
          response.data['candidates'][0]['content']['parts'][0]['text'];
      return _parseRoutes(text);
    } on DioException catch (e) {
      throw Exception('ルート生成に失敗しました: ${e.message}');
    }
  }

  // ── AIレポートを生成する ───────────────────
  Future<String> generateAdventureReport({
    required String themeName,
    required List<SpotModel> visitedSpots,
    required double distanceKm,
    required int durationMinutes,
  }) async {
    final spotNames = visitedSpots
        .map((s) => s.aiStoryName.isNotEmpty ? s.aiStoryName : s.name)
        .join('、');

    final prompt =
        '''
あなたは幻想的な冒険の語り部です。
以下の冒険の記録を元に、詩的で没入感のある冒険日誌を150文字程度で書いてください。

テーマ：$themeName
巡ったスポット：$spotNames
歩いた距離：${distanceKm.toStringAsFixed(1)}km
所要時間：$durationMinutes分

条件：
- 「あなたは〜」という語り口で書く
- 幻想的・詩的な表現を使う
- 街の記憶や断片という概念を入れる
- JSONではなく、そのまま文章で返す
''';

    try {
      final response = await _dio.post(
        '$_baseUrl?key=$_apiKey',
        options: Options(headers: {'Content-Type': 'application/json'}),
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
          as String;
    } on DioException catch (e) {
      throw Exception('レポート生成に失敗しました: ${e.message}');
    }
  }

  // ── プロンプトを組み立てる ─────────────────
  String _buildPrompt({
    required double lat,
    required double lng,
    required String mood,
    required String mode,
    required List<String> hobbyTags,
    required String destination,
  }) {
    // モードごとの距離設定
    final distanceRange = switch (mode) {
      'お散歩' => '1〜3km',
      '探索' => '3〜6km',
      '冒険' => '6km以上',
      _ => '2〜4km',
    };

    final tagText = hobbyTags.isEmpty ? '指定なし' : hobbyTags.join('、');
    final destText = destination.isEmpty ? 'おまかせ（現在地周辺）' : destination;

    return '''
あなたは街の冒険を設計するAIナビゲーターです。
以下の条件で、ユーザーにぴったりの散歩ルートを3つ提案してください。

【条件】
- 現在地：緯度 $lat、経度 $lng
- 目的地：$destText
- 気分：$mood
- 難易度：$mode（距離の目安：$distanceRange）
- 好みのスポット：$tagText

【出力形式】
必ず以下のJSON形式のみで返してください。説明文は不要です。

{
  "routes": [
    {
      "id": "route_001",
      "themeName": "ルートの物語風タイトル（例：古のパン屋を巡る調査員コース）",
      "themeDescription": "このルートのコンセプト説明（50文字以内）",
      "totalDistance": 2.3,
      "estimatedTime": 35,
      "tags": ["#カフェ", "#レトロ"],
      "spots": [
        {
          "id": "spot_001",
          "name": "実際のスポット名",
          "lat": 35.6812,
          "lng": 139.7671,
          "category": "カフェ",
          "aiStoryName": "物語風の場所の名前（例：記憶の香りを持つ小屋）",
          "aiFlavorText": "その場所の雰囲気を表す一言（30文字以内）"
        }
      ]
    }
  ]
}

条件：
- spotsは2〜4個
- 現在地から実際に歩いて行ける範囲のスポットを選ぶ
- タイトルは日本語で詩的・冒険的な表現にする
- 3つのルートはそれぞれ違うテーマにする
''';
  }

  // ── JSONをRouteModelに変換する ──────────────
  List<RouteModel> _parseRoutes(String jsonText) {
    try {
      // JSONの余分な文字を除去
      final cleaned = jsonText
          .replaceAll('```json', '')
          .replaceAll('```', '')
          .trim();

      final data = jsonDecode(cleaned) as Map<String, dynamic>;
      final routesJson = data['routes'] as List<dynamic>;

      return routesJson.map((routeJson) {
        final spotsJson = routeJson['spots'] as List<dynamic>;

        // スポットをSpotModelに変換
        final spots = spotsJson.map((spotJson) {
          return SpotModel(
            id: spotJson['id'] ?? '',
            name: spotJson['name'] ?? '',
            lat: (spotJson['lat'] ?? 0.0).toDouble(),
            lng: (spotJson['lng'] ?? 0.0).toDouble(),
            category: spotJson['category'] ?? '',
            aiStoryName: spotJson['aiStoryName'] ?? '',
            aiFlavorText: spotJson['aiFlavorText'] ?? '',
          );
        }).toList();

        return RouteModel(
          id: routeJson['id'] ?? '',
          themeName: routeJson['themeName'] ?? '名もなき散歩道',
          themeDescription: routeJson['themeDescription'] ?? '',
          spotIds: spots.map((s) => s.id).toList(),
          totalDistance: (routeJson['totalDistance'] ?? 0.0).toDouble(),
          estimatedTime: routeJson['estimatedTime'] ?? 0,
          tags: List<String>.from(routeJson['tags'] ?? []),
          // spotsはProviderに渡すために別途保持
          generatedSpots: spots,
        );
      }).toList();
    } catch (e) {
      throw Exception('ルートデータの解析に失敗しました: $e');
    }
  }
}

// シングルトンとして使えるようにProviderで管理
// route_provider.dart から ref.read(geminiServiceProvider) で使う

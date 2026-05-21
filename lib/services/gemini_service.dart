// lib/services/gemini_service.dart

import 'dart:convert';
import 'package:dio/dio.dart';
import '../models/route_model.dart';
import '../models/spot_model.dart';

class GeminiService {
  final Dio _dio;

  // ── APIの設定 ──────────────────────────────
  // 💡 安全対策：実行コマンド（flutter run --dart-define=GEMINI_API_KEY=xxx）から読み込むようにしたよ！
  static const _apiKey = String.fromEnvironment(
    'GEMINI_API_KEY',
    defaultValue: 'ここにGemini APIキーを貼る',
  );
  static const _baseUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent';

  GeminiService() : _dio = Dio();

  // ── ルートを生成する ───────────────────────
  Future<List<RouteModel>> generateRoutes({
    required double lat,
    required double lng,
    required String mood,
    required String mode,
    required List<String> hobbyTags,
    String destination = '',
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
            'temperature': 0.8,
            'maxOutputTokens': 2048,
            'responseMimeType': 'application/json',
            // 💡 【新機能】Geminiに絶対にこのJSON構造を守らせるスキーマ設定だよ！
            'responseSchema': _buildRouteResponseSchema(),
          },
        },
      );

      // Dioが自動でMapにしているか、Stringのままかで処理を分ける安全設計
      final rawData =
          response.data['candidates'][0]['content']['parts'][0]['text'];
      return _parseRoutes(rawData);
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
    final distanceRange = switch (mode) {
      'お散歩' => '1〜3km',
      '探索' => '3〜6km',
      '冒険' => '6km以上',
      _ => '2〜4km',
    };

    final tagText = hobbyTags.isEmpty ? '指定なし' : hobbyTags.join('、');
    final destText = destination.isEmpty ? 'おまかせ（現在地周辺）' : destination;

    // スキーマを指定しているので、プロンプト内の出力形式の指定をシンプルにできたよ！
    return '''
あなたは街の冒険を設計するAIナビゲーターです。
以下の条件に合致し、実在する場所を含んだ素敵な散歩ルートを3つ提案してください。

【条件】
- 現在地：緯度 $lat、経度 $lng
- 目的地：$destText
- 気分：$mood
- 難易度：$mode（距離の目安：$distanceRange）
- 好みのスポット：$tagText

【冒険の演出ルール】
- spotsは各ルート2〜4個にしてください。
- 現在地周辺に実在し、実際に歩いて行ける範囲のスポット（お店、公園、史跡など）を選んでください。
- themeNameは日本語で、詩的・ゲームのクエスト風・冒険的な表現にしてください。
- 3つのルートはそれぞれ全く違うテーマ（例：歴史、グルメ、自然など）にしてください。
- aiStoryNameやaiFlavorTextには、その場所が持つ隠された物語のようなファンタジーな表現を与えてください。
''';
  }

  // ── 💡 Gemini用のJSONスキーマ定義 ─────────────────
  Map<String, dynamic> _buildRouteResponseSchema() {
    return {
      'type': 'OBJECT',
      'properties': {
        'routes': {
          'type': 'ARRAY',
          'description': '提案する3つのルート一覧',
          'items': {
            'type': 'OBJECT',
            'properties': {
              'id': {'type': 'STRING', 'description': 'route_001 などの一意のID'},
              'themeName': {'type': 'STRING', 'description': 'ルートの物語風タイトル'},
              'themeDescription': {
                'type': 'STRING',
                'description': 'コンセプト説明（50文字以内）',
              },
              'totalDistance': {'type': 'NUMBER', 'description': '総移動距離(km)'},
              'estimatedTime': {'type': 'INTEGER', 'description': '想定所要時間(分)'},
              'tags': {
                'type': 'ARRAY',
                'items': {'type': 'STRING'},
                'description': 'ルート属性タグ（例：["#カフェ", "#レトロ"]）',
              },
              'spots': {
                'type': 'ARRAY',
                'description': '経由するスポットの一覧（2〜4個）',
                'items': {
                  'type': 'OBJECT',
                  'properties': {
                    'id': {
                      'type': 'STRING',
                      'description': 'spot_001 などの一意のID',
                    },
                    'name': {'type': 'STRING', 'description': '実際の実在するスポット名'},
                    'lat': {'type': 'NUMBER', 'description': 'スポットの緯度'},
                    'lng': {'type': 'NUMBER', 'description': 'スポットの経度'},
                    'category': {
                      'type': 'STRING',
                      'description': 'カテゴリ（例：カフェ、公園、史跡）',
                    },
                    'aiStoryName': {
                      'type': 'STRING',
                      'description': '物語風の場所の名前',
                    },
                    'aiFlavorText': {
                      'type': 'STRING',
                      'description': 'その場所の雰囲気を表す一言（30文字以内）',
                    },
                  },
                  'required': [
                    'id',
                    'name',
                    'lat',
                    'lng',
                    'category',
                    'aiStoryName',
                    'aiFlavorText',
                  ],
                },
              },
            },
            'required': [
              'id',
              'themeName',
              'themeDescription',
              'totalDistance',
              'estimatedTime',
              'tags',
              'spots',
            ],
          },
        },
      },
      'required': ['routes'],
    };
  }

  // ── JSONをRouteModelに変換する ──────────────
  List<RouteModel> _parseRoutes(dynamic rawData) {
    try {
      Map<String, dynamic> data;

      // 文字列で返ってきた場合と、すでにMapになっている場合の両方に対応！
      if (rawData is String) {
        final cleaned = rawData
            .replaceAll('```json', '')
            .replaceAll('```', '')
            .trim();
        data = jsonDecode(cleaned) as Map<String, dynamic>;
      } else if (rawData is Map<String, dynamic>) {
        data = rawData;
      } else {
        throw const FormatException('不正なデータ型です');
      }

      final routesJson = data['routes'] as List<dynamic>;

      return routesJson.map((routeJson) {
        final spotsJson = routeJson['spots'] as List<dynamic>;

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
          generatedSpots: spots,
        );
      }).toList();
    } catch (e) {
      throw Exception('ルートデータの解析に失敗しました: $e');
    }
  }
}

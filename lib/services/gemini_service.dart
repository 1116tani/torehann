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

  // ─────────────────────────────
  // 🔑 API設定
  // ─────────────────────────────

  static String get _apiKey {
    final envKey =
        dotenv.env['GEMINI_API_KEY'] ?? dotenv.env['Gemini_API_Key'] ?? '';
    if (envKey.isNotEmpty) {
      return envKey;
    }
    return ApiConstants.geminiApiKey;
  }

  // 🌟 最新の 3.5-flash モデルのエンドポイントだよ
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

  // ─────────────────────────────
  // 🗺️ ルート生成
  // ─────────────────────────────

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
      final url = '$_baseUrl?key=$_apiKey';

      final response = await _dio.post(
        url,
        data: {
          'contents': [
            {
              'parts': [
                {'text': prompt},
              ],
            },
          ],

          // ── generationConfig ──
          'generationConfig': {
            'temperature': 0.85,
            'topP': 0.95,
            'maxOutputTokens': 8192,

            'responseMimeType': 'application/json',
          },

          // ── safety ──
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
        throw Exception('Geminiからレスポンスが返されませんでした');
      }

      final rawText = candidates[0]['content']['parts'][0]['text'];

      return _parseRoutes(rawText);
    } on DioException catch (e) {
      final message =
          e.response?.data.toString() ?? e.message ?? 'unknown error';

      throw Exception('Gemini API通信に失敗しました\n$message');
    } on TimeoutException {
      throw Exception('Gemini APIがタイムアウトしました');
    } catch (e) {
      throw Exception('ルート生成に失敗しました\n$e');
    }
  }

  // ─────────────────────────────
  // 📝 冒険レポート生成
  // ─────────────────────────────

  Future<String> generateAdventureReport({
    required String themeName,
    required List<SpotModel> visitedSpots,
    required double distanceKm,
    required int durationMinutes,
  }) async {
    if (_apiKey.isEmpty) {
      throw Exception('Gemini APIキーが設定されていません');
    }

    final spotsText = visitedSpots
        .map((e) => e.aiStoryName.isNotEmpty ? e.aiStoryName : e.name)
        .join('、');

    final prompt =
        '''
あなたは幻想的な旅の語り部です。

以下の冒険記録を元に、
150文字程度の幻想的な冒険レポートを書いてください。

【テーマ】
$themeName

【巡った場所】
$spotsText

【歩行距離】
${distanceKm.toStringAsFixed(1)}km

【所要時間】
$durationMinutes分

条件:
- 詩的で静かな文体
- 街の記憶・断片・物語感
- 「あなたは〜」の語り口
- JSONではなく文章のみ
''';

    try {
      final url = '$_baseUrl?key=$_apiKey';

      final response = await _dio.post(
        url,
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

      final text =
          response.data['candidates'][0]['content']['parts'][0]['text'];

      return text.toString().trim();
    } on DioException catch (e) {
      throw Exception('冒険レポート生成に失敗しました\n$e');
    } catch (e) {
      throw Exception('冒険レポート生成に失敗しました\n$e');
    }
  }

  // ─────────────────────────────
  // ✨ プロンプト生成
  // ─────────────────────────────

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

    final destinationText = destination.isEmpty ? '現在地周辺でおまかせ' : destination;

    return '''
以下条件に合う、実在する場所を巡る徒歩ルートを【1つだけ】生成して、指定されたJSON形式のデータのみを出力してください。
他の挨拶や説明、バッククォートなどのマークアップは一切含めないでください。

【形式】
{
  "routes": [
    {
      "id": "route_001",
      "themeName": "黄昏の記憶巡礼",
      "themeDescription": "静かな夕暮れを歩く探索路",
      "totalDistance": 2.4,
      "estimatedTime": 35,
      "tags": ["#黄昏", "#静かな冒険"],
      "spots": [
        {
          "id": "spot_001",
          "name": "○○公園",
          "lat": 35.0,
          "lng": 139.0,
          "category": "公園",
          "aiStoryName": "記憶の庭園",
          "aiFlavorText": "風が静かに記憶を運ぶ"
        }
      ]
    }
  ]
}

【現在地】
緯度: $lat
経度: $lng

【目的地】
$destinationText

【気分】
$mood

【難易度】
$mode
距離目安: $distanceRange

【興味】
$hobbies

【ルール】
- 1つの明確なテーマを作る
- 実在する場所を使う
- 徒歩で巡れる範囲
- ルートには2〜4スポットを含める
- カフェ、公園、路地裏、史跡などを混ぜる
- 幻想的・ゲーム的なタイトル
- aiStoryName は物語風
- aiFlavorText は30文字以内
''';
  }

  // ─────────────────────────────
  // 🧩 JSON → RouteModel
  // ─────────────────────────────

  List<RouteModel> _parseRoutes(dynamic rawData) {
    try {
      final cleaned = rawData
          .toString()
          .replaceAll('```json', '')
          .replaceAll('```', '')
          .trim();

      final Map<String, dynamic> data = jsonDecode(cleaned);

      final routesJson = data['routes'];

      if (routesJson == null || routesJson is! List) {
        throw Exception('routes が存在しません');
      }

      final routes = routesJson.map<RouteModel>((routeJson) {
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

      return routes;
    } catch (e) {
      throw Exception('Geminiレスポンス解析に失敗しました\n$e');
    }
  }
}

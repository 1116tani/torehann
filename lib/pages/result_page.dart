// lib/pages/result_page.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../models/result_model.dart';

import '../widgets/result/adventure_title_card.dart';
import '../widgets/result/photo_timeline.dart';
import '../widgets/result/share_button.dart';
import '../widgets/result/stat_panel.dart';
import '../widgets/result/reward_popup.dart';

class ResultPage extends StatefulWidget {
  const ResultPage({super.key});

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  bool _showReward = true;

  // ── ダミーデータ ─────────────────────
  final AdventureResult result = AdventureResult(
    title: '雨路地に眠る古書の記憶',
    date: DateTime.now(),

    friendNames: [
      'ルナ',
      'ノア',
    ],

    story:
        '''
薄暗い裏路地を抜けた先、
君たちは小さな古書店へ辿り着いた。

濡れた石畳を踏む音と、
遠くで鳴る踏切の音。

積み重なった本の隙間には、
誰かの忘れた記憶みたいな匂いが残っていた。

今日の冒険は、
少しだけ世界の奥行きを知る旅だった。
''',

    distanceKm: 4.8,
    steps: 6840,
    calories: 243,
    fragments: 6,
    earnedExp: 180,

    routeImageUrl:
        'https://images.unsplash.com/photo-1524661135-423995f22d0b',

    photos: [
      ResultPhoto(
        imageUrl:
            'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee',
        caption: '静かな裏路地に、小さな灯りが揺れていた。',
      ),

      ResultPhoto(
        imageUrl:
            'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085',
        caption: '雨音を聞きながら、古びた珈琲を飲んだ。',
      ),

      ResultPhoto(
        imageUrl:
            'https://images.unsplash.com/photo-1516979187457-637abb4f9353',
        caption: '本棚の奥に、誰かの記憶が眠っていた気がした。',
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1610),

      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                // ── AppBar ─────────────────
                _buildHeader(context),

                // ── Main Scroll ───────────
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),

                    padding: const EdgeInsets.fromLTRB(
                      18,
                      12,
                      18,
                      120,
                    ),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── タイトル ─────────
                        AdventureTitleCard(
                          title: result.title,
                          date: result.date,
                          friendNames: result.friendNames,
                        ),

                        const SizedBox(height: 22),

                        // ── ルートマップ ─────
                        _RouteMap(
                          imageUrl: result.routeImageUrl,
                        ),

                        const SizedBox(height: 28),

                        // ── AIレポート ──────
                        _StorySection(
                          story: result.story,
                        ),

                        const SizedBox(height: 32),

                        // ── 写真タイムライン ─
                        PhotoTimeline(
                          photos: result.photos,
                        ),

                        const SizedBox(height: 32),

                        // ── 統計 ───────────
                        StatPanel(
                          distanceKm: result.distanceKm,
                          steps: result.steps,
                          calories: result.calories,
                          fragments: result.fragments,
                        ),

                        const SizedBox(height: 28),

                        // ── ボタン群 ───────
                        ShareButton(
                          onTap: () {
                            // TODO: SNS共有
                          },
                        ),

                        const SizedBox(height: 14),

                        SizedBox(
                          width: double.infinity,

                          child: OutlinedButton(
                            onPressed: () {
                              context.pop();
                            },

                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(
                                color: Color(0xFF5C4033),
                              ),

                              padding: const EdgeInsets.symmetric(
                                vertical: 16,
                              ),

                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(18),
                              ),
                            ),

                            child: const Text(
                              'ホームへ戻る',
                              style: TextStyle(
                                color: Color(0xFFC8A97A),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── 報酬Popup ─────────────────
          if (_showReward)
            RewardPopup(
              exp: result.earnedExp,
              fragments: result.fragments,

              onFinished: () {
                setState(() {
                  _showReward = false;
                });
              },
            ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────
  // ヘッダー
  // ─────────────────────────────────────

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 8,
      ),

      child: Row(
        children: [
          IconButton(
            onPressed: () => context.pop(),

            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Color(0xFFC8A97A),
            ),
          ),

          const Spacer(),

          const Text(
            'ADVENTURE RESULT',
            style: TextStyle(
              color: Color(0xFFB8860B),
              letterSpacing: 2,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),

          const Spacer(),

          const SizedBox(width: 48),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────
// 🗺 ルートマップ
// ─────────────────────────────────────

class _RouteMap extends StatelessWidget {
  final String imageUrl;

  const _RouteMap({
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 240,

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),

        border: Border.all(
          color: const Color(0xFF5C4033),
          width: 0.8,
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),

      clipBehavior: Clip.antiAlias,

      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            imageUrl,
            fit: BoxFit.cover,
          ),

          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,

                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.5),
                ],
              ),
            ),
          ),

          const Positioned(
            left: 18,
            bottom: 18,

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '冒険の軌跡',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 11,
                  ),
                ),

                SizedBox(height: 4),

                Text(
                  'ROUTE MAP',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────
// 📜 AIレポート
// ─────────────────────────────────────

class _StorySection extends StatelessWidget {
  final String story;

  const _StorySection({
    required this.story,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(22),

      decoration: BoxDecoration(
        color: const Color(0xFF2C2318),

        borderRadius: BorderRadius.circular(24),

        border: Border.all(
          color: const Color(0xFF5C4033),
          width: 0.6,
        ),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.menu_book_rounded,
                color: Color(0xFFB8860B),
                size: 18,
              ),

              SizedBox(width: 8),

              Text(
                'AI冒険譚',
                style: TextStyle(
                  color: Color(0xFFF5EDD8),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          Text(
            story,
            style: const TextStyle(
              color: Color(0xFFC8A97A),
              fontSize: 14,
              height: 2,
            ),
          ),
        ],
      ),
    );
  }
}
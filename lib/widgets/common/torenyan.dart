// lib/widgets/common/torenyan.dart

import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../../constants/app_sizes.dart';

enum TorenyanState {
  idle,
  loading,
  error,
  success,
}

class TorenyanLines {
  static const idle = [
    '今日はどこへ行くの？',
    '寄り道していこうよ',
    '静かな道、好きなんだよね',
    '面白い場所、見つかるかも',
  ];

  static const loading = [
    '街の記憶を探してるよ…',
    'いい冒険になりそう',
  ];

  static const error = [
    '街の記憶が見つからなかったみたい…',
    '少し休んでからもう一度探そう？',
  ];

  static const success = [
    '面白いルートが見つかったよ！さあ歩こう！',
    '今日の冒険に出発だね！',
  ];

  static List<String> getLines(TorenyanState state) {
    return switch (state) {
      TorenyanState.idle => idle,
      TorenyanState.loading => loading,
      TorenyanState.error => error,
      TorenyanState.success => success,
    };
  }
}

class Torenyan extends StatefulWidget {
  final double size;
  final bool enableTap;
  final TorenyanState state;
  final bool showSpeechBubble;

  const Torenyan({
    super.key,
    this.size = 96.0,
    this.enableTap = true,
    this.state = TorenyanState.idle,
    this.showSpeechBubble = true,
  });

  @override
  State<Torenyan> createState() => _TorenyanState();
}

class _TorenyanState extends State<Torenyan> {
  double _scale = 1.0;
  String _currentLine = '';
  final _random = math.Random();

  @override
  void initState() {
    super.initState();
    _updateLine();
  }

  @override
  void didUpdateWidget(Torenyan oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.state != widget.state) {
      _updateLine();
    }
  }

  void _updateLine() {
    final lines = TorenyanLines.getLines(widget.state);
    if (lines.isNotEmpty) {
      setState(() {
        _currentLine = lines[_random.nextInt(lines.length)];
      });
    }
  }

  void _changeLine() {
    if (!widget.enableTap) return;

    final lines = TorenyanLines.getLines(widget.state);
    if (lines.length <= 1) return;

    // 前と違うセリフを選ぶようにループ
    String newLine;
    do {
      newLine = lines[_random.nextInt(lines.length)];
    } while (newLine == _currentLine);

    setState(() {
      _currentLine = newLine;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 💬 ゲームライクな吹き出し
        if (widget.showSpeechBubble && _currentLine.isNotEmpty)
          _buildSpeechBubble(),
          
        const SizedBox(height: 4),

        // 🐱 トレにゃん本体 (タップ収縮フィードバックのみ)
        GestureDetector(
          onTapDown: (_) {
            if (widget.enableTap) {
              setState(() => _scale = 0.92);
            }
          },
          onTapUp: (_) {
            if (widget.enableTap) {
              setState(() => _scale = 1.0);
            }
          },
          onTapCancel: () {
            if (widget.enableTap) {
              setState(() => _scale = 1.0);
            }
          },
          onTap: _changeLine,
          child: AnimatedScale(
            scale: _scale,
            duration: const Duration(milliseconds: 100),
            curve: Curves.easeOut,
            child: Image.asset(
              'assets/images/mascot/mascot_neko.png',
              width: widget.size,
              height: widget.size,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSpeechBubble() {
    return Stack(
      alignment: Alignment.bottomCenter,
      clipBehavior: Clip.none,
      children: [
        // 吹き出しのメイン枠
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.p16,
            vertical: 10.0,
          ),
          constraints: const BoxConstraints(maxWidth: 240),
          decoration: BoxDecoration(
            color: const Color(0xFF2C2318), // 深いゲームUI調のダークブラウン
            border: Border.all(
              color: const Color(0xFFC8A97A), // 気品あるゴールドのフチ
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(20), // 丸み強め
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.35),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Text(
            _currentLine,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFFF5EDD8), // 温かみのあるクリームゴールド
              fontSize: 13.0,
              fontWeight: FontWeight.bold,
              height: 1.35,
            ),
          ),
        ),

        // 吹き出しのツノ（矢印）
        Positioned(
          bottom: -6.0,
          child: Transform.rotate(
            angle: math.pi / 4,
            child: Container(
              width: 12.0,
              height: 12.0,
              decoration: BoxDecoration(
                color: const Color(0xFF2C2318),
                border: Border(
                  bottom: BorderSide(
                    color: const Color(0xFFC8A97A),
                    width: 2.0,
                  ),
                  right: BorderSide(
                    color: const Color(0xFFC8A97A),
                    width: 2.0,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

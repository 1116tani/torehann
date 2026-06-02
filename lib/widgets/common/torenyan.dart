// lib/widgets/common/torenyan.dart

import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../../constants/app_sizes.dart';
import '../../constants/app_colors.dart';

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
  final List<String>? customLines;

  const Torenyan({
    super.key,
    this.size = 96.0,
    this.enableTap = true,
    this.state = TorenyanState.idle,
    this.showSpeechBubble = true,
    this.customLines,
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
    
    // Compare customLines content or state
    bool linesChanged = oldWidget.state != widget.state ||
        oldWidget.customLines != widget.customLines;

    if (!linesChanged && oldWidget.customLines != null && widget.customLines != null) {
      if (oldWidget.customLines!.length != widget.customLines!.length) {
        linesChanged = true;
      } else {
        for (int i = 0; i < oldWidget.customLines!.length; i++) {
          if (oldWidget.customLines![i] != widget.customLines![i]) {
            linesChanged = true;
            break;
          }
        }
      }
    }

    if (linesChanged) {
      _updateLine();
    }
  }

  void _updateLine() {
    final lines = widget.customLines ?? TorenyanLines.getLines(widget.state);
    if (lines.isNotEmpty) {
      setState(() {
        _currentLine = lines[_random.nextInt(lines.length)];
      });
    } else {
      setState(() {
        _currentLine = '';
      });
    }
  }

  void _changeLine() {
    if (!widget.enableTap) return;

    final lines = widget.customLines ?? TorenyanLines.getLines(widget.state);
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

  void _onTapDown(TapDownDetails details) {
    if (widget.enableTap) {
      setState(() => _scale = 0.92);
    }
  }

  void onTapUp(TapUpDetails details) {
    if (widget.enableTap) {
      setState(() => _scale = 1.0);
    }
  }

  void _onTapCancel() {
    if (widget.enableTap) {
      setState(() => _scale = 1.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomOffset = widget.showSpeechBubble ? 32.0 : 0.0;
    // 吹き出しスペースを確保した全体の高さを定義
    final totalHeight = widget.showSpeechBubble ? (widget.size + 120.0) : widget.size;
    // 吹き出しがねこの横幅を超えて描画できるように横幅は 240.0 と widget.size の大きい方にする
    final totalWidth = widget.showSpeechBubble ? math.max(240.0, widget.size) : widget.size;

    return SizedBox(
      width: totalWidth,
      height: totalHeight,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // 🐱 トレにゃん本体 (画像表示用・AnimatedScale)
          Positioned(
            bottom: bottomOffset,
            left: 0,
            width: widget.size,
            height: widget.size,
            child: IgnorePointer(
              child: AnimatedScale(
                scale: _scale,
                duration: const Duration(milliseconds: 100),
                curve: Curves.easeOut,
                child: Image.asset(
                  'assets/images/mascot/mascot_neko.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),

          // 💬 ゲームライクな吹き出し (ねこの上部に重なるように配置)
          if (widget.showSpeechBubble && _currentLine.isNotEmpty)
            Positioned(
              bottom: bottomOffset + widget.size - 12.0, // ねこの頭頂部から12dp重ねる
              left: 0,
              child: _buildSpeechBubble(context),
            ),

          // 🐱 タッチ判定エリア (ねこ本体の上部65%のみに限定し、下のボタンの邪魔をしない)
          if (widget.enableTap)
            Positioned(
              bottom: bottomOffset + widget.size * (widget.showSpeechBubble ? 0.35 : 0.0),
              left: 0,
              width: widget.size,
              height: widget.showSpeechBubble ? widget.size * 0.65 : widget.size,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTapDown: _onTapDown,
                onTapUp: (details) {
                  if (widget.enableTap) {
                    setState(() => _scale = 1.0);
                  }
                },
                onTapCancel: _onTapCancel,
                onTap: _changeLine,
                child: const SizedBox.expand(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSpeechBubble(BuildContext context) {
    final colors = AppColors.of(context);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: _onTapDown,
      onTapUp: (details) {
        if (widget.enableTap) {
          setState(() => _scale = 1.0);
        }
      },
      onTapCancel: _onTapCancel,
      onTap: _changeLine,
      child: Stack(
        alignment: Alignment.bottomLeft, // 矢印を左寄りに配置するため
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
              color: colors.speechBubble,
              border: Border.all(
                color: colors.speechAccent,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(20), // 丸み強め
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Text(
              _currentLine,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: colors.textPrimary,
                fontSize: 13.0,
                fontWeight: FontWeight.bold,
                height: 1.35,
              ),
            ),
          ),

          // 吹き出しのツノ（矢印）
          // 左端から 55dp の位置に固定し、ねこの頭（左寄りの位置）を指すように調整
          Positioned(
            bottom: -6.0,
            left: 55.0,
            child: Transform.rotate(
              angle: math.pi / 4,
              child: Container(
                width: 12.0,
                height: 12.0,
                decoration: BoxDecoration(
                  color: colors.speechBubble,
                  border: Border(
                    bottom: BorderSide(
                      color: colors.speechAccent,
                      width: 2.0,
                    ),
                    right: BorderSide(
                      color: colors.speechAccent,
                      width: 2.0,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

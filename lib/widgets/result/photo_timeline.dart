// lib/widgets/result/photo_timeline.dart

import 'dart:io';
import 'package:flutter/material.dart';
import '../../models/result_model.dart';

class PhotoTimeline extends StatelessWidget {
  final List<ResultPhoto> photos;

  const PhotoTimeline({
    super.key,
    required this.photos,
  });

  @override
  Widget build(BuildContext context) {
    if (photos.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── タイトル ─────────────────────
        const Row(
          children: [
            Icon(
              Icons.photo_library_outlined,
              color: Color(0xFFB8860B),
              size: 18,
            ),

            SizedBox(width: 8),

            Text(
              '旅の挿絵',
              style: TextStyle(
                color: Color(0xFFF5EDD8),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),

        const SizedBox(height: 18),

        // ── タイムライン ─────────────────
        Column(
          children: List.generate(
            photos.length,
            (index) {
              final photo = photos[index];
              final isLeft = index.isEven;

              return _TimelineItem(
                photo: photo,
                isLeft: isLeft,
              );
            },
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────
// 📸 タイムラインアイテム
// ─────────────────────────────────────

class _TimelineItem extends StatelessWidget {
  final ResultPhoto photo;
  final bool isLeft;

  const _TimelineItem({
    required this.photo,
    required this.isLeft,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 28),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 左側配置
          if (isLeft) ...[
            Expanded(
              child: _PhotoCard(photo: photo),
            ),

            const SizedBox(width: 18),

            _TimelineLine(),
          ]

          // 右側配置
          else ...[
            _TimelineLine(),

            const SizedBox(width: 18),

            Expanded(
              child: _PhotoCard(photo: photo),
            ),
          ],
        ],
      ),
    );
  }
}

// ─────────────────────────────────────
// 📷 写真カード
// ─────────────────────────────────────

class _PhotoCard extends StatelessWidget {
  final ResultPhoto photo;

  const _PhotoCard({
    required this.photo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2C2318),

        borderRadius: BorderRadius.circular(18),

        border: Border.all(
          color: const Color(0xFF5C4033),
          width: 0.5,
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── 写真 ───────────────────────
          ClipRRect(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(18),
            ),

            child: AspectRatio(
              aspectRatio: 4 / 3,

              child: photo.imageUrl.startsWith('http')
                  ? Image.network(
                      photo.imageUrl,
                      fit: BoxFit.cover,
                      loadingBuilder: (
                        context,
                        child,
                        progress,
                      ) {
                        if (progress == null) {
                          return child;
                        }
                        return Container(
                          color: const Color(0xFF3D2B1F),
                          child: const Center(
                            child: CircularProgressIndicator(
                              color: Color(0xFFC8A97A),
                              strokeWidth: 2,
                            ),
                          ),
                        );
                      },
                      errorBuilder: (
                        context,
                        error,
                        stackTrace,
                      ) {
                        return Container(
                          color: const Color(0xFF3D2B1F),
                          child: const Center(
                            child: Icon(
                              Icons.image_not_supported_outlined,
                              color: Color(0xFF7A5C3A),
                            ),
                          ),
                        );
                      },
                    )
                  : Image.file(
                      File(photo.imageUrl),
                      fit: BoxFit.cover,
                      errorBuilder: (
                        context,
                        error,
                        stackTrace,
                      ) {
                        return Container(
                          color: const Color(0xFF3D2B1F),
                          child: const Center(
                            child: Icon(
                              Icons.image_not_supported_outlined,
                              color: Color(0xFF7A5C3A),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ),

          // ── キャプション ───────────────
          Padding(
            padding: const EdgeInsets.all(14),

            child: Text(
              photo.caption,
              style: const TextStyle(
                color: Color(0xFFC8A97A),
                fontSize: 12,
                height: 1.7,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────
// ✨ タイムライン線
// ─────────────────────────────────────

class _TimelineLine extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 12,
          height: 12,

          decoration: BoxDecoration(
            shape: BoxShape.circle,

            color: const Color(0xFFB8860B),

            boxShadow: [
              BoxShadow(
                color: const Color(
                  0xFFB8860B,
                ).withValues(alpha: 0.5),

                blurRadius: 8,
              ),
            ],
          ),
        ),

        Container(
          width: 2,
          height: 160,
          color: const Color(0xFF4A3728),
        ),
      ],
    );
  }
}
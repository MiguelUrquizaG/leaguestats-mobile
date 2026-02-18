import 'dart:ui';

import 'package:flutter/material.dart';

class NewsDetailCard extends StatelessWidget {
  final String imageUrl;
  final String category;
  final String time;
  final String title;
  final String description;
  final bool showReadMore;
  final bool isLive;
  final VoidCallback? onTap;

  const NewsDetailCard({
    super.key,
    required this.imageUrl,
    required this.category,
    required this.time,
    required this.title,
    required this.description,
    this.showReadMore = false,
    this.isLive = false,
    this.onTap,
  });

  Color get _accentColor {
    switch (category.toUpperCase()) {
      case 'LEC':
        return const Color(0xFF00C8FF); // cyan – LEC branding
      case 'LCK':
        return const Color(0xFFE8344E); // red – LCK branding
      case 'LPL':
        return const Color(0xFFFF6B00); // orange – LPL branding
      case 'LCS' || 'LTA':
        return const Color(0xFF00A86B); // green – LCS/LTA branding
      case 'WORLDS':
        return const Color(0xFFC89B3C); // gold – Worlds branding
      case 'FICHAJES' || 'TRANSFER':
        return const Color(0xFFFF9800); // amber
      default:
        return const Color(0xFF7C3AED); // purple default
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AspectRatio(
        aspectRatio: 16 / 11,
        child: Container(
          margin: const EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _accentColor.withValues(alpha: 0.15),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: _accentColor.withValues(alpha: 0.10),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
              BoxShadow(
                color: const Color(0xFF0A0A12).withValues(alpha: 0.6),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Background image
                Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, error, stackTrace) => Container(
                    color: const Color(0xFF12121A),
                    child: const Center(
                      child: Icon(
                        Icons.broken_image_rounded,
                        color: Color(0xFF8E8A93),
                        size: 48,
                      ),
                    ),
                  ),
                ),

                // Dark gradient overlay for text readability
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        const Color(0xFF0A0A12).withValues(alpha: 0.25),
                        const Color(0xFF0A0A12).withValues(alpha: 0.85),
                        const Color(0xFF0A0A12).withValues(alpha: 0.98),
                      ],
                      stops: const [0.0, 0.35, 0.65, 1.0],
                    ),
                  ),
                ),

                // Subtle accent gradient at the bottom edge
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  height: 3,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          _accentColor.withValues(alpha: 0.0),
                          _accentColor.withValues(alpha: 0.7),
                          _accentColor.withValues(alpha: 0.0),
                        ],
                      ),
                    ),
                  ),
                ),

                // Content
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Top row: optional LIVE badge
                      if (isLive)
                        Align(
                          alignment: Alignment.topRight,
                          child: _LiveBadge(color: _accentColor),
                        ),

                      const Spacer(),

                      // Category + time
                      Row(
                        children: [
                          _CategoryBadge(label: category, color: _accentColor),
                          const SizedBox(width: 10),
                          Icon(
                            Icons.access_time_rounded,
                            size: 13,
                            color: Colors.white.withValues(alpha: 0.45),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            time,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.50),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // Title
                      Text(
                        title,
                        maxLines: showReadMore ? 1 : 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          height: 1.2,
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 6),

                      // Description
                      Text(
                        description,
                        maxLines: showReadMore ? 1 : 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.55),
                          fontSize: 13,
                          height: 1.4,
                        ),
                      ),

                      // Read more button
                      if (showReadMore) ...[
                        const SizedBox(height: 12),
                        _ReadMoreButton(onTap: onTap, color: _accentColor),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Category Badge ──────────────────────────────────────────────────────────

class _CategoryBadge extends StatelessWidget {
  final String label;
  final Color color;

  const _CategoryBadge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.20),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: color.withValues(alpha: 0.40), width: 1),
          ),
          child: Text(
            label.toUpperCase(),
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.4,
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Live Badge ──────────────────────────────────────────────────────────────

class _LiveBadge extends StatelessWidget {
  final Color color;

  const _LiveBadge({required this.color});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFFE8344E).withValues(alpha: 0.20),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: const Color(0xFFE8344E).withValues(alpha: 0.50),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: Color(0xFFE8344E),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              const Text(
                'EN VIVO',
                style: TextStyle(
                  color: Color(0xFFE8344E),
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Read More Button ────────────────────────────────────────────────────────

class _ReadMoreButton extends StatelessWidget {
  final VoidCallback? onTap;
  final Color color;

  const _ReadMoreButton({this.onTap, required this.color});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color, color.withValues(alpha: 0.75)],
            ),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.35),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Leer más',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(width: 6),
              Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}

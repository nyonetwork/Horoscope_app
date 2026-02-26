import 'dart:math' as math;

import 'package:flutter/material.dart';

class CosmicBackground extends StatefulWidget {
  final Widget child;
  final bool showBottomGlow;

  const CosmicBackground({
    super.key,
    required this.child,
    this.showBottomGlow = true,
  });

  @override
  State<CosmicBackground> createState() => _CosmicBackgroundState();
}

class _CosmicBackgroundState extends State<CosmicBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final List<_StarNode> _stars;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 28),
    )..repeat();
    _stars = _buildStars();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<_StarNode> _buildStars() {
    final random = math.Random(7);
    return List.generate(90, (_) {
      return _StarNode(
        anchor: Offset(random.nextDouble(), random.nextDouble()),
        radius: 0.5 + random.nextDouble() * 1.8,
        twinkleSpeed: 0.8 + random.nextDouble() * 2.2,
        twinklePhase: random.nextDouble() * math.pi * 2,
        drift: 2 + random.nextDouble() * 10,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return DecoratedBox(
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              center: Alignment(0.65, -0.85),
              radius: 1.35,
              colors: [
                Color(0xFF2A3A72),
                Color(0xFF141D3D),
                Color(0xFF060A1A),
                Color(0xFF04070F),
              ],
            ),
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: CustomPaint(
                  painter: _SpacePainter(
                    progress: _controller.value,
                    stars: _stars,
                    showBottomGlow: widget.showBottomGlow,
                  ),
                ),
              ),
              widget.child,
            ],
          ),
        );
      },
    );
  }
}

class _StarNode {
  final Offset anchor;
  final double radius;
  final double twinkleSpeed;
  final double twinklePhase;
  final double drift;

  const _StarNode({
    required this.anchor,
    required this.radius,
    required this.twinkleSpeed,
    required this.twinklePhase,
    required this.drift,
  });
}

class _SpacePainter extends CustomPainter {
  final double progress;
  final List<_StarNode> stars;
  final bool showBottomGlow;

  const _SpacePainter({
    required this.progress,
    required this.stars,
    required this.showBottomGlow,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final t = progress * math.pi * 2;

    final nebulaA = Paint()
      ..color = const Color(0xFF9BB8FF).withValues(alpha: 0.08)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 90);
    canvas.drawCircle(Offset(size.width * 0.15, size.height * 0.22), 120, nebulaA);

    final nebulaB = Paint()
      ..color = const Color(0xFFFFD2A1).withValues(alpha: 0.07)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 110);
    canvas.drawCircle(Offset(size.width * 0.86, size.height * 0.08), 140, nebulaB);

    if (showBottomGlow) {
      final glowRect = Rect.fromLTWH(0, size.height - 240, size.width, 240);
      final glow = Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0x00000000),
            Color(0x2B5D8CFF),
            Color(0x3652A4D8),
          ],
        ).createShader(glowRect);
      canvas.drawRect(glowRect, glow);
    }

    final points = <Offset>[];
    for (final star in stars) {
      final base = Offset(star.anchor.dx * size.width, star.anchor.dy * size.height);
      final phase = star.twinklePhase;
      final x = base.dx + math.sin(t * 0.6 + phase) * star.drift;
      final y = base.dy + math.cos(t * 0.45 + phase) * (star.drift * 0.7);
      final alpha = 0.25 + 0.75 * ((math.sin(t * star.twinkleSpeed + phase) + 1) / 2);

      final paint = Paint()..color = Colors.white.withValues(alpha: alpha);
      final center = Offset(x, y);
      canvas.drawCircle(center, star.radius, paint);
      points.add(center);
    }

    final linePaint = Paint()
      ..color = const Color(0xFF9FC3FF).withValues(alpha: 0.20)
      ..strokeWidth = 0.75;

    final linkCount = math.min(points.length, 24);
    for (var i = 0; i < linkCount; i++) {
      for (var j = i + 1; j < linkCount; j++) {
        final distance = (points[i] - points[j]).distance;
        if (distance < 95) {
          final opacity = (1 - distance / 95) * 0.45;
          linePaint.color = const Color(0xFF9FC3FF).withValues(alpha: opacity);
          canvas.drawLine(points[i], points[j], linePaint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant _SpacePainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.showBottomGlow != showBottomGlow;
  }
}

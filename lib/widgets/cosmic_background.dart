import 'dart:math' as math;

import 'package:flutter/material.dart';

class CosmicBackground extends StatefulWidget {
  final Widget child;
  final bool showBottomGlow;
  final bool reduceMotion;

  const CosmicBackground({
    super.key,
    required this.child,
    this.showBottomGlow = true,
    this.reduceMotion = false,
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
      duration: const Duration(seconds: 36),
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
        drift: 4 + random.nextDouble() * 18,
        orbitSpeed: 0.45 + random.nextDouble() * 0.75,
        orbitOffset: random.nextDouble() * math.pi * 2,
        orbitStretch: 0.6 + random.nextDouble() * 1.1,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.maybeOf(context);
    final systemReduceMotion =
        mediaQuery?.disableAnimations ?? mediaQuery?.accessibleNavigation ?? false;
    final reduceMotion = widget.reduceMotion || systemReduceMotion;

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
                    reduceMotion: reduceMotion,
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
  final double orbitSpeed;
  final double orbitOffset;
  final double orbitStretch;

  const _StarNode({
    required this.anchor,
    required this.radius,
    required this.twinkleSpeed,
    required this.twinklePhase,
    required this.drift,
    required this.orbitSpeed,
    required this.orbitOffset,
    required this.orbitStretch,
  });
}

class _SpacePainter extends CustomPainter {
  final double progress;
  final List<_StarNode> stars;
  final bool showBottomGlow;
  final bool reduceMotion;

  const _SpacePainter({
    required this.progress,
    required this.stars,
    required this.showBottomGlow,
    required this.reduceMotion,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final t = progress * math.pi * 2;
    final motion = reduceMotion ? 0.2 : 1.0;
    final sceneDx = math.sin(t * 0.3) * 16 * motion;
    final sceneDy = math.cos(t * 0.24) * 11 * motion;

    final nebulaA = Paint()
      ..color = const Color(0xFF9BB8FF).withValues(alpha: 0.08)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 90);
    canvas.drawCircle(
      Offset(size.width * 0.15 + sceneDx, size.height * 0.22 + sceneDy),
      120,
      nebulaA,
    );

    final nebulaB = Paint()
      ..color = const Color(0xFFFFD2A1).withValues(alpha: 0.07)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 110);
    canvas.drawCircle(
      Offset(size.width * 0.86 - sceneDx * 0.7, size.height * 0.08 + sceneDy * 0.5),
      140,
      nebulaB,
    );

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
      final orbit = t * star.orbitSpeed + star.orbitOffset;
      final x = base.dx +
          math.sin(orbit + phase) * star.drift * motion +
          math.sin(orbit * 0.5 + phase * 0.7) * (star.drift * 0.45) * motion +
          sceneDx * 0.65;
      final y = base.dy +
          math.cos(orbit * star.orbitStretch + phase) * (star.drift * 0.7) * motion +
          math.sin(orbit * 0.42 + phase) * (star.drift * 0.35) * motion +
          sceneDy * 0.65;
      final alpha = 0.25 + 0.75 * ((math.sin(t * star.twinkleSpeed + phase) + 1) / 2);

      final paint = Paint()..color = Colors.white.withValues(alpha: alpha);
      final center = Offset(x, y);
      canvas.drawCircle(center, star.radius, paint);
      points.add(center);
    }

    final linePaint = Paint()
      ..color = const Color(0xFF9FC3FF).withValues(alpha: 0.22)
      ..strokeWidth = 0.95;

    final linkCount = math.min(points.length, 42);
    final connectDistance = (88 + math.sin(t * 0.9) * 16) * (reduceMotion ? 0.95 : 1.0);
    for (var i = 0; i < linkCount; i++) {
      for (var j = i + 1; j < linkCount; j++) {
        final distance = (points[i] - points[j]).distance;
        if (distance < connectDistance) {
          final opacity = (1 - distance / connectDistance) * 0.62;
          linePaint.color = const Color(0xFF9FC3FF).withValues(alpha: opacity);
          canvas.drawLine(points[i], points[j], linePaint);
        }
      }
    }

    _drawShootingStar(
      canvas: canvas,
      size: size,
      localProgress: ((progress + 0.12) * (reduceMotion ? 0.8 : 1.35)) % 1.0,
      start: Offset(size.width * 0.08, size.height * 0.18),
      travel: Offset(size.width * 0.52, size.height * 0.26),
      width: 1.8,
      activeWindow: reduceMotion ? 0.14 : 0.24,
    );
    _drawShootingStar(
      canvas: canvas,
      size: size,
      localProgress: ((progress + 0.68) * (reduceMotion ? 0.8 : 1.35)) % 1.0,
      start: Offset(size.width * 0.70, size.height * 0.10),
      travel: Offset(-size.width * 0.34, size.height * 0.24),
      width: 1.4,
      activeWindow: reduceMotion ? 0.12 : 0.20,
    );
  }

  void _drawShootingStar({
    required Canvas canvas,
    required Size size,
    required double localProgress,
    required Offset start,
    required Offset travel,
    required double width,
    required double activeWindow,
  }) {
    if (localProgress > activeWindow) return;

    final p = localProgress / activeWindow;
    final head = Offset(start.dx + travel.dx * p, start.dy + travel.dy * p);
    final tail = Offset(
      head.dx - travel.dx * 0.22,
      head.dy - travel.dy * 0.22,
    );

    final opacity = (1 - p).clamp(0.0, 1.0) * 0.75;
    final trail = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white.withValues(alpha: opacity),
          const Color(0xFFBDD6FF).withValues(alpha: opacity * 0.55),
          Colors.transparent,
        ],
      ).createShader(Rect.fromPoints(head, tail))
      ..strokeWidth = width
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(tail, head, trail);
    canvas.drawCircle(
      head,
      width * 1.1,
      Paint()..color = Colors.white.withValues(alpha: opacity),
    );
  }

  @override
  bool shouldRepaint(covariant _SpacePainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.showBottomGlow != showBottomGlow ||
        oldDelegate.reduceMotion != reduceMotion;
  }
}

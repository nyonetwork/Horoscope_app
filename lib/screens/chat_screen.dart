import 'dart:math' as math;

import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2600),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final t = _controller.value;
          final pulse = 0.9 + (math.sin(t * 2 * math.pi) + 1) * 0.12;
          final dotOpacities = List<double>.generate(
            3,
            (i) =>
                0.25 +
                ((math.sin(t * 2 * math.pi - (i * 0.9)) + 1) * 0.5) * 0.75,
          );

          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 28),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 26),
            decoration: BoxDecoration(
              color: const Color(0xCC0E142A),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFF304172)),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x3D000000),
                  blurRadius: 24,
                  offset: Offset(0, 12),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Transform.scale(
                      scale: pulse,
                      child: Container(
                        width: 92,
                        height: 92,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0x664C7DFF),
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                    const CircleAvatar(
                      radius: 30,
                      backgroundColor: Color(0xFF1A2547),
                      child: Icon(
                        Icons.lock_clock_rounded,
                        color: Color(0xFFEAF0FF),
                        size: 32,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                const Text(
                  'Locked for now',
                  style: TextStyle(
                    color: Color(0xFFEAF0FF),
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text.rich(
                  TextSpan(
                    style: const TextStyle(
                      color: Color(0xFFB9C4E7),
                      fontSize: 15,
                      height: 1.35,
                    ),
                    children: [
                      const TextSpan(
                        text: 'The chat feature is waiting to be revealed',
                      ),
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: SizedBox(
                          width: 18,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.min,
                            children: List.generate(
                              3,
                              (i) => Opacity(
                                opacity: dotOpacities[i],
                                child: const Text(
                                  '.',
                                  style: TextStyle(
                                    color: Color(0xFFB9C4E7),
                                    fontSize: 15,
                                    height: 1.35,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

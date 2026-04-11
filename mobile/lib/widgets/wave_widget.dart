import 'dart:math' as math;
import 'package:flutter/material.dart';

class WaveWidget extends StatefulWidget {
  final double progress; // 0.0 to 1.0
  final Color color;
  final double size;

  const WaveWidget({
    super.key,
    required this.progress,
    required this.color,
    this.size = 200,
  });

  @override
  State<WaveWidget> createState() => _WaveWidgetState();
}

class _WaveWidgetState extends State<WaveWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          size: Size(widget.size, widget.size),
          painter: _WavePainter(
            waveValue: _controller.value,
            progress: widget.progress,
            color: widget.color,
          ),
        );
      },
    );
  }
}

class _WavePainter extends CustomPainter {
  final double waveValue;
  final double progress;
  final Color color;

  _WavePainter({
    required this.waveValue,
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0) return;

    final yOffset = size.height * (1 - progress);
    final amplitude = size.height * 0.04 * (progress > 0 && progress < 1 ? 1 : 0.4);

    // Layer 1: Back Wave (Lighter, faster)
    _drawWave(
      canvas, 
      size, 
      yOffset + 4, 
      amplitude * 0.8, 
      color.withOpacity(0.3), 
      waveValue * 1.5, 
      reverse: true,
    );

    // Layer 2: Middle Wave (Moderate)
    _drawWave(
      canvas, 
      size, 
      yOffset + 2, 
      amplitude * 1.2, 
      color.withOpacity(0.6), 
      waveValue, 
      reverse: false,
    );

    // Layer 3: Front Wave (Main color, slow)
    _drawWave(
      canvas, 
      size, 
      yOffset, 
      amplitude, 
      color, 
      waveValue * 0.7, 
      reverse: false,
    );
    
    // Shine effect on top
    if (progress > 0.1) {
      final shinePaint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white.withOpacity(0.1),
            Colors.transparent,
          ],
        ).createShader(Rect.fromLTWH(0, yOffset - 10, size.width, 20));
      
      canvas.drawRect(Rect.fromLTWH(0, yOffset - 10, size.width, 10), shinePaint);
    }
  }

  void _drawWave(
    Canvas canvas, 
    Size size, 
    double yOffset, 
    double amplitude, 
    Color color, 
    double phase, 
    {required bool reverse}
  ) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, yOffset);

    for (double x = 0; x <= size.width; x++) {
      final phaseShift = reverse ? -phase : phase;
      final y = yOffset +
          math.sin((x / size.width * 2 * math.pi) + (phaseShift * 2 * math.pi)) *
              amplitude;
      path.lineTo(x, y);
    }

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _WavePainter oldDelegate) {
    return oldDelegate.waveValue != waveValue || oldDelegate.progress != progress;
  }
}

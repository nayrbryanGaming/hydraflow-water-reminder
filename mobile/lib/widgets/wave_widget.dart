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
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    final yOffset = size.height * (1 - progress);
    
    // Smooth transition for wave height
    final amplitude = size.height * 0.05 * (progress > 0 && progress < 1 ? 1 : 0.2);
    
    path.moveTo(0, yOffset);
    
    for (double x = 0; x <= size.width; x++) {
      final y = yOffset +
          math.sin((x / size.width * 2 * math.pi) + (waveValue * 2 * math.pi)) *
              amplitude;
      path.lineTo(x, y);
    }

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
    
    // Optional: Draw a second, lighter wave for depth
    final path2 = Path();
    final yOffset2 = yOffset + 5;
    final paint2 = Paint()
      ..color = color.withOpacity(0.5)
      ..style = PaintingStyle.fill;

    path2.moveTo(0, yOffset2);
    for (double x = 0; x <= size.width; x++) {
      final y = yOffset2 +
          math.sin((x / size.width * 2 * math.pi) - (waveValue * 2 * math.pi) + math.pi) *
              amplitude;
      path2.lineTo(x, y);
    }
    path2.lineTo(size.width, size.height);
    path2.lineTo(0, size.height);
    path2.close();
    
    canvas.drawPath(path2, paint2);
  }

  @override
  bool shouldRepaint(covariant _WavePainter oldDelegate) {
    return oldDelegate.waveValue != waveValue || oldDelegate.progress != progress;
  }
}

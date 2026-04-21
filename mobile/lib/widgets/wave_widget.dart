import 'dart:math' as math;
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

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
  final List<_Bubble> _bubbles = [];
  double _rippleAmplitude = 0.0;
  final math.Random _random = math.Random();
  
  // Sensory slosh
  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;
  double _tilt = 0.0; // Current tilt in radians
  Timer? _fallbackTimer;
  bool _usingSensorFallback = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();

    // Initialize random bubbles
    for (int i = 0; i < 15; i++) {
      _bubbles.add(_Bubble(_random));
    }

    _initSensors();
    _startFallbackTimer();
  }

  void _startFallbackTimer() {
    // If no sensor data received within 500ms, start a gentle procedural oscillation
    _fallbackTimer = Timer(const Duration(milliseconds: 500), () {
      if (_usingSensorFallback && mounted) {
        _startProceduralAnimation();
      }
    });
  }

  void _startProceduralAnimation() {
    _fallbackTimer?.cancel();
    _fallbackTimer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        // Gentle automated sloshing
        _tilt = math.sin(DateTime.now().millisecondsSinceEpoch / 1000) * 0.05;
      });
    });
  }

  void _initSensors() {
    _accelerometerSubscription = accelerometerEventStream().listen((AccelerometerEvent event) {
      if (mounted) {
        if (_usingSensorFallback) {
          _usingSensorFallback = false;
          _fallbackTimer?.cancel();
        }
        setState(() {
          // Calculate tilt angle based on X axis (roll) with smoother interpolation
          final targetTilt = (event.x / 12).clamp(-0.5, 0.5); 
          _tilt = _tilt * 0.8 + targetTilt * 0.2; // Smooth damping
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _accelerometerSubscription?.cancel();
    _fallbackTimer?.cancel();
    super.dispose();
  }

  void _handleTap() {
    setState(() {
      _rippleAmplitude = 20.0;
    });
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() {
          _rippleAmplitude = 0.0;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          // Update bubble positions
          for (var bubble in _bubbles) {
            bubble.update(_controller.value, widget.size, widget.progress);
          }

          return CustomPaint(
            size: Size(widget.size, widget.size),
            painter: _WavePainter(
              waveValue: _controller.value,
              progress: widget.progress,
              color: widget.color,
              bubbles: _bubbles,
              rippleAmplitude: _rippleAmplitude,
              tilt: _tilt,
            ),
          );
        },
      ),
    );
  }
}

class _Bubble {
  late double x;
  late double y;
  late double radius;
  late double speed;
  late double opacity;

  _Bubble(math.Random random) {
    x = random.nextDouble();
    y = random.nextDouble();
    radius = random.nextDouble() * 3 + 1;
    speed = random.nextDouble() * 0.5 + 0.2;
    opacity = random.nextDouble() * 0.5 + 0.1;
  }

  void update(double t, double size, double progress) {
    y -= speed * 0.015;
    if (y < (1 - progress - 0.1)) {
      y = 1.2; // Reset below bottom
      x = math.Random().nextDouble(); // Randomize X again
    }
  }
}

class _WavePainter extends CustomPainter {
  final double waveValue;
  final double progress;
  final Color color;
  final List<_Bubble> bubbles;
  final double rippleAmplitude;
  final double tilt;

  _WavePainter({
    required this.waveValue,
    required this.progress,
    required this.color,
    required this.bubbles,
    required this.rippleAmplitude,
    required this.tilt,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0) return;

    final yOffset = size.height * (1 - progress);
    final baseAmplitude = size.height * 0.04;
    final totalAmplitude = baseAmplitude + rippleAmplitude;

    // Apply rotation for tilt/slosh
    canvas.save();
    canvas.translate(size.width / 2, size.height / 2);
    canvas.rotate(tilt);
    canvas.translate(-size.width / 2, -size.height / 2);

    // Draw bubbles first (back layer)
    final bubblePaint = Paint()..style = PaintingStyle.fill;
    for (var bubble in bubbles) {
      if (bubble.y < 1.1) {
        bubblePaint.color = Colors.white.withValues(alpha: bubble.opacity);
        canvas.drawCircle(
          Offset(bubble.x * size.width, bubble.y * size.height),
          bubble.radius,
          bubblePaint,
        );
      }
    }

    // Layer 1: Deep Back Wave
    _drawWave(
      canvas,
      size,
      yOffset + 6,
      totalAmplitude * 0.6,
      color.withValues(alpha: 0.2),
      waveValue * 1.8,
      reverse: true,
    );

    // Layer 2: Refractive Foam Layer (Premium Hardening)
    _drawWave(
      canvas,
      size,
      yOffset + 2,
      totalAmplitude * 0.8,
      Colors.white.withValues(alpha: 0.08),
      waveValue * 1.5,
      reverse: false,
      onlyStroke: true,
      strokeWidthValue: 4,
    );

    // Layer 3: Middle Wave
    _drawWave(
      canvas,
      size,
      yOffset + 3,
      totalAmplitude * 0.9,
      color.withValues(alpha: 0.4),
      waveValue * 1.2,
      reverse: false,
    );

    // Layer 4: Main Front Wave with Gradient
    _drawWaveWithGradient(
      canvas,
      size,
      yOffset,
      totalAmplitude,
      color,
      waveValue * 0.8,
    );

    // SPECULAR HIGHLIGHT (Premium Glassy Effect)
    _drawSpecularHighlight(
      canvas,
      size,
      yOffset,
      totalAmplitude,
      waveValue * 0.8,
    );

    // Shine / Surface Highlight
    final surfacePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    
    _drawWavePath(
      canvas,
      size,
      yOffset,
      totalAmplitude,
      waveValue * 0.8,
      surfacePaint,
      onlyStroke: true,
    );
    
    canvas.restore();
  }

  void _drawSpecularHighlight(
    Canvas canvas,
    Size size,
    double yOffset,
    double amplitude,
    double phase,
  ) {
    final highlightPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.white.withValues(alpha: 0.4),
          Colors.white.withValues(alpha: 0.0),
        ],
      ).createShader(Rect.fromLTWH(0, yOffset - amplitude, size.width, 20));

    final path = Path();
    // Smaller, offset wave path for the highlight
    path.moveTo(size.width * 0.1, yOffset);
    for (double x = size.width * 0.1; x <= size.width * 0.7; x++) {
      final y = yOffset +
          math.sin((x / size.width * 2 * math.pi) + (phase * 2 * math.pi)) *
              amplitude - 4;
      path.lineTo(x, y);
    }
    
    canvas.drawPath(
        path, 
        Paint()
          ..color = Colors.white.withValues(alpha: 0.15)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 8
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4)
    );
  }

  void _drawWaveWithGradient(
    Canvas canvas,
    Size size,
    double yOffset,
    double amplitude,
    Color color,
    double phase,
  ) {
    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          color.withValues(alpha: 0.8),
          color,
          color.withValues(alpha: 0.78), // replacing withAlpha(200) equivalent for consistency
        ],
      ).createShader(Rect.fromLTWH(0, yOffset - amplitude, size.width, size.height - yOffset + amplitude));

    _drawWavePath(canvas, size, yOffset, amplitude, phase, paint);
  }

  void _drawWave(
    Canvas canvas,
    Size size,
    double yOffset,
    double amplitude,
    Color color,
    double phase,
    {bool reverse = false, bool onlyStroke = false, double strokeWidthValue = 1.0}
  ) {
    final paint = Paint()
      ..color = color
      ..style = onlyStroke ? PaintingStyle.stroke : PaintingStyle.fill
      ..strokeWidth = strokeWidthValue;

    _drawWavePath(canvas, size, yOffset, amplitude, phase, paint, reverse: reverse, onlyStroke: onlyStroke);
  }

  void _drawWavePath(
    Canvas canvas,
    Size size,
    double yOffset,
    double amplitude,
    double phase,
    Paint paint,
    {bool reverse = false, bool onlyStroke = false}
  ) {
    final path = Path();
    path.moveTo(0, yOffset);

    for (double x = 0; x <= size.width; x++) {
      final phaseShift = reverse ? -phase : phase;
      final y = yOffset +
          math.sin((x / size.width * 2 * math.pi) + (phaseShift * 2 * math.pi)) *
              amplitude;
      path.lineTo(x, y);
    }

    if (!onlyStroke) {
      path.lineTo(size.width, size.height);
      path.lineTo(0, size.height);
      path.close();
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _WavePainter oldDelegate) {
    return true; // We have bubbles and ripples moving
  }
}



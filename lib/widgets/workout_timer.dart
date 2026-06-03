import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Timer circular animado para descanso entre series.
///
/// Muestra un arco degradado que se va vaciando con el tiempo,
/// vibra al terminar y permite configurar duración.
class WorkoutTimer extends StatefulWidget {
  const WorkoutTimer({
    super.key,
    required this.durationSeconds,
    this.onComplete,
    this.autoStart = true,
    this.size = 220,
  });

  final int durationSeconds;
  final VoidCallback? onComplete;
  final bool autoStart;
  final double size;

  @override
  State<WorkoutTimer> createState() => WorkoutTimerState();
}

class WorkoutTimerState extends State<WorkoutTimer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late int _remaining;
  Timer? _ticker;
  bool _running = false;

  @override
  void initState() {
    super.initState();
    _remaining = widget.durationSeconds;
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: widget.durationSeconds),
    );
    if (widget.autoStart) {
      _start();
    }
  }

  @override
  void dispose() {
    _ticker?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _start() {
    _running = true;
    _remaining = widget.durationSeconds;
    _controller.forward(from: 0);
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_remaining > 0) {
        setState(() => _remaining--);
        if (_remaining == 0) {
          _finish();
        }
      }
    });
  }

  void _finish() {
    _ticker?.cancel();
    _running = false;
    HapticFeedback.heavyImpact();
    widget.onComplete?.call();
  }

  void restart() {
    _ticker?.cancel();
    _controller.reset();
    setState(() {
      _remaining = widget.durationSeconds;
    });
    _start();
  }

  void toggle() {
    if (_running) {
      _ticker?.cancel();
      _controller.stop();
      _running = false;
    } else {
      _start();
    }
    setState(() {});
  }

  String get _timeString {
    final minutes = _remaining ~/ 60;
    final seconds = _remaining % 60;
    if (minutes > 0) {
      return '$minutes:${seconds.toString().padLeft(2, '0')}';
    }
    return '$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: widget.size,
          height: widget.size,
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return CustomPaint(
                painter: _TimerPainter(
                  progress: 1.0 - _controller.value,
                  gradientColors: const [AppColors.orange, AppColors.cyan],
                ),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(_timeString, style: AppTextStyles.timerDisplay),
                      Text(
                        _running ? 'DESCANSA' : 'PAUSADO',
                        style: AppTextStyles.labelMedium.copyWith(
                          color: _running
                              ? AppColors.cyan
                              : AppColors.textMuted,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _TimerButton(
              icon: _running ? Icons.pause_rounded : Icons.play_arrow_rounded,
              label: _running ? 'Pausar' : 'Reanudar',
              onTap: toggle,
              isPrimary: true,
            ),
            const SizedBox(width: 16),
            _TimerButton(
              icon: Icons.refresh_rounded,
              label: 'Reiniciar',
              onTap: restart,
            ),
          ],
        ),
      ],
    );
  }
}

class _TimerButton extends StatelessWidget {
  const _TimerButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isPrimary = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isPrimary;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isPrimary
          ? AppColors.orange.withValues(alpha: 0.2)
          : AppColors.bgElevated,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon,
                  color: isPrimary ? AppColors.orange : AppColors.textSecondary,
                  size: 20),
              const SizedBox(width: 8),
              Text(
                label,
                style: AppTextStyles.labelLarge.copyWith(
                  color:
                      isPrimary ? AppColors.orange : AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TimerPainter extends CustomPainter {
  _TimerPainter({
    required this.progress,
    required this.gradientColors,
  });

  final double progress;
  final List<Color> gradientColors;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 12;
    const strokeWidth = 8.0;

    // Track de fondo
    final trackPaint = Paint()
      ..color = AppColors.bgElevated
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, trackPaint);

    // Arco de progreso con gradiente
    if (progress > 0) {
      final rect = Rect.fromCircle(center: center, radius: radius);
      final gradient = SweepGradient(
        startAngle: -pi / 2,
        endAngle: 3 * pi / 2,
        colors: gradientColors,
      );

      final progressPaint = Paint()
        ..shader = gradient.createShader(rect)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        rect,
        -pi / 2,
        2 * pi * progress,
        false,
        progressPaint,
      );

      // Glow sutil en el extremo
      final glowPaint = Paint()
        ..color = gradientColors.first.withValues(alpha: 0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth + 6
        ..strokeCap = StrokeCap.round
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

      final glowAngle = -pi / 2 + 2 * pi * progress;
      final glowOffset = Offset(
        center.dx + radius * cos(glowAngle),
        center.dy + radius * sin(glowAngle),
      );
      canvas.drawCircle(glowOffset, 4, glowPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _TimerPainter old) =>
      old.progress != progress;
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Metrónomo visual y háptico para ritmo de repeticiones.
///
/// Emite pulsos visuales y vibraciones según el tempo configurado
/// (ej. 3-1-1 = 3s baja, 1s pausa, 1s sube).
class RepMetronome extends StatefulWidget {
  const RepMetronome({
    super.key,
    required this.tempo,
    this.onTick,
  });

  /// Tempo en formato "X-Y-Z" (excéntrica-pausa-concéntrica).
  final String tempo;

  final VoidCallback? onTick;

  @override
  State<RepMetronome> createState() => _RepMetronomeState();
}

class _RepMetronomeState extends State<RepMetronome>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  Timer? _timer;
  bool _active = false;

  // Fases parseadas del tempo
  late List<_TempoPhase> _phases;
  int _currentPhaseIndex = 0;
  int _phaseBeatsRemaining = 0;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
      lowerBound: 0.8,
      upperBound: 1.0,
    )..value = 1.0;

    _parseTempo();
  }

  void _parseTempo() {
    final parts = widget.tempo.split('-');
    _phases = [];
    final labels = ['Baja', 'Pausa', 'Sube'];
    final colors = [AppColors.cyan, AppColors.gold, AppColors.orange];
    for (var i = 0; i < parts.length && i < 3; i++) {
      final secs = int.tryParse(parts[i].trim()) ?? 1;
      _phases.add(_TempoPhase(
        label: labels[i],
        beats: secs,
        color: colors[i],
      ));
    }
    if (_phases.isEmpty) {
      _phases = [_TempoPhase(label: 'Beat', beats: 1, color: AppColors.cyan)];
    }
    _currentPhaseIndex = 0;
    _phaseBeatsRemaining = _phases.first.beats;
  }

  @override
  void didUpdateWidget(covariant RepMetronome oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.tempo != widget.tempo) {
      _stop();
      _parseTempo();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  void _start() {
    _active = true;
    _currentPhaseIndex = 0;
    _phaseBeatsRemaining = _phases.first.beats;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
    setState(() {});
  }

  void _stop() {
    _active = false;
    _timer?.cancel();
    setState(() {});
  }

  void _tick() {
    _phaseBeatsRemaining--;

    // Pulso visual
    _pulseController.forward(from: 0.8);

    // Háptico
    HapticFeedback.lightImpact();
    widget.onTick?.call();

    if (_phaseBeatsRemaining <= 0) {
      _currentPhaseIndex = (_currentPhaseIndex + 1) % _phases.length;
      _phaseBeatsRemaining = _phases[_currentPhaseIndex].beats;
      // Háptico más fuerte en cambio de fase
      HapticFeedback.mediumImpact();
    }

    setState(() {});
  }

  _TempoPhase get _currentPhase => _phases[_currentPhaseIndex];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Indicador de fase actual
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: _active
                ? _currentPhase.color.withValues(alpha: 0.15)
                : AppColors.bgElevated,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _active
                  ? _currentPhase.color.withValues(alpha: 0.4)
                  : AppColors.border,
            ),
          ),
          child: Column(
            children: [
              Text(
                _active ? _currentPhase.label : 'Metrónomo',
                style: AppTextStyles.labelLarge.copyWith(
                  color: _active ? _currentPhase.color : AppColors.textMuted,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Tempo: ${widget.tempo}',
                style: AppTextStyles.bodySmall,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Pulso visual
        ScaleTransition(
          scale: _pulseController,
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _active
                  ? _currentPhase.color.withValues(alpha: 0.3)
                  : AppColors.bgSurface,
              border: Border.all(
                color: _active ? _currentPhase.color : AppColors.border,
                width: 3,
              ),
              boxShadow: _active
                  ? [
                      BoxShadow(
                        color: _currentPhase.color.withValues(alpha: 0.3),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ]
                  : null,
            ),
            child: Icon(
              _active ? Icons.music_note_rounded : Icons.music_off_rounded,
              color: _active ? _currentPhase.color : AppColors.textMuted,
              size: 28,
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Fases visuales
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (var i = 0; i < _phases.length; i++) ...[
              if (i > 0)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Icon(Icons.arrow_forward_rounded,
                      size: 14, color: AppColors.textMuted),
                ),
              _PhaseChip(
                phase: _phases[i],
                isActive: _active && i == _currentPhaseIndex,
              ),
            ],
          ],
        ),
        const SizedBox(height: 16),

        // Botón de inicio/parada
        Material(
          color: _active
              ? AppColors.error.withValues(alpha: 0.15)
              : AppColors.orange.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            onTap: _active ? _stop : _start,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _active ? Icons.stop_rounded : Icons.play_arrow_rounded,
                    color: _active ? AppColors.error : AppColors.orange,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _active ? 'Detener' : 'Iniciar ritmo',
                    style: AppTextStyles.labelLarge.copyWith(
                      color: _active ? AppColors.error : AppColors.orange,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _PhaseChip extends StatelessWidget {
  const _PhaseChip({required this.phase, required this.isActive});

  final _TempoPhase phase;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isActive
            ? phase.color.withValues(alpha: 0.2)
            : AppColors.bgCard,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isActive ? phase.color : AppColors.border,
          width: isActive ? 2 : 1,
        ),
      ),
      child: Text(
        '${phase.label} ${phase.beats}s',
        style: AppTextStyles.labelSmall.copyWith(
          color: isActive ? phase.color : AppColors.textMuted,
          fontWeight: isActive ? FontWeight.w900 : FontWeight.w600,
        ),
      ),
    );
  }
}

class _TempoPhase {
  const _TempoPhase({
    required this.label,
    required this.beats,
    required this.color,
  });

  final String label;
  final int beats;
  final Color color;
}

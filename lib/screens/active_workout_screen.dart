import 'package:flutter/material.dart';

import '../data/motivational_data.dart';
import '../models/exercise.dart';
import '../models/workout_plan.dart';
import '../services/workout_state.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../widgets/glassmorphic_card.dart';
import '../widgets/motivational_card.dart';
import '../widgets/progress_indicator.dart';
import '../widgets/rep_metronome.dart';
import '../widgets/workout_timer.dart';

/// Pantalla de entrenamiento activo con timer, metrónomo y consejos.
class ActiveWorkoutScreen extends StatefulWidget {
  const ActiveWorkoutScreen({
    super.key,
    required this.day,
    required this.dayIndex,
    required this.goal,
    required this.level,
    required this.onComplete,
  });

  final WorkoutDay day;
  final int dayIndex;
  final FitnessGoal goal;
  final FitnessLevel level;
  final VoidCallback onComplete;

  @override
  State<ActiveWorkoutScreen> createState() => _ActiveWorkoutScreenState();
}

class _ActiveWorkoutScreenState extends State<ActiveWorkoutScreen> {
  late WorkoutState _state;
  bool _showTimer = false;
  bool _showMetronome = false;
  bool _showFinishScreen = false;

  @override
  void initState() {
    super.initState();
    _state = WorkoutState(day: widget.day, dayIndex: widget.dayIndex);
  }

  void _completeSet() {
    setState(() {
      _state.completeSet();
      if (_state.currentExerciseDone) {
        // Si terminó todas las series, avanza al siguiente ejercicio
        if (!_state.nextExercise()) {
          // Todos los ejercicios terminados
          _showFinishScreen = true;
          widget.onComplete();
        }
        _showTimer = false;
        _showMetronome = false;
      } else {
        // Mostrar timer de descanso
        _showTimer = true;
        _showMetronome = false;
      }
    });
  }

  void _skipExercise() {
    setState(() {
      if (!_state.nextExercise()) {
        _showFinishScreen = true;
        widget.onComplete();
      }
      _showTimer = false;
      _showMetronome = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_showFinishScreen) {
      return _FinishScreen(
        day: widget.day,
        onClose: () => Navigator.of(context).pop(),
      );
    }

    final exercise = _state.currentExercise;
    final prescription = exercise.prescription;
    final goalKey = widget.goal.name;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.day.name),
        actions: [
          TextButton(
            onPressed: _skipExercise,
            child: Text(
              'Saltar',
              style: AppTextStyles.labelMedium.copyWith(
                color: AppColors.textMuted,
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          // ── Progreso general ──
          GradientProgressBar(
            progress: _state.overallProgress,
            showLabel: true,
          ),
          const SizedBox(height: 6),
          Text(
            'Ejercicio ${_state.currentExerciseIndex + 1} de ${_state.totalExercises}',
            style: AppTextStyles.bodySmall,
          ),
          const SizedBox(height: 16),

          // ── Ejercicio actual ──
          GlassmorphicCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        exercise.exercise.imageAsset,
                        width: 70,
                        height: 70,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            exercise.exercise.name,
                            style: AppTextStyles.titleMedium,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            exercise.exercise.type.label,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.cyan,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Prescripción
                Row(
                  children: [
                    _PrescriptionChip(
                      icon: Icons.repeat_rounded,
                      label: 'Series',
                      value: prescription.sets,
                    ),
                    const SizedBox(width: 10),
                    _PrescriptionChip(
                      icon: Icons.fitness_center_rounded,
                      label: 'Reps',
                      value: prescription.reps,
                    ),
                    const SizedBox(width: 10),
                    _PrescriptionChip(
                      icon: Icons.timer_rounded,
                      label: 'Descanso',
                      value: prescription.rest,
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Contador de series
                Text('Series completadas',
                    style: AppTextStyles.labelSmall),
                const SizedBox(height: 8),
                Row(
                  children: List.generate(_state.targetSets, (i) {
                    final done = i < _state.currentCompletedSets;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: done
                              ? AppColors.orange
                              : AppColors.bgElevated,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: done
                                ? AppColors.orange
                                : AppColors.border,
                          ),
                          boxShadow: done
                              ? [
                                  BoxShadow(
                                    color: AppColors.orange
                                        .withValues(alpha: 0.3),
                                    blurRadius: 8,
                                  ),
                                ]
                              : null,
                        ),
                        child: Center(
                          child: done
                              ? const Icon(Icons.check_rounded,
                                  color: Colors.white, size: 18)
                              : Text(
                                  '${i + 1}',
                                  style: AppTextStyles.labelMedium,
                                ),
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 12),

                // Nota técnica
                if (prescription.note.isNotEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.bgElevated,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      prescription.note,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // ── Botón completar serie ──
          if (!_showTimer)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _completeSet,
                icon: const Icon(Icons.check_rounded),
                label: Text(
                  'Serie ${_state.currentCompletedSets + 1} lista',
                  style: AppTextStyles.titleMedium.copyWith(
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.orange,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),

          // ── Timer de descanso ──
          if (_showTimer) ...[
            const SizedBox(height: 8),
            WorkoutTimer(
              durationSeconds: _state.restSeconds,
              onComplete: () {
                setState(() => _showTimer = false);
              },
            ),
            const SizedBox(height: 16),
            RestTipCard(goalKey: goalKey),
            const SizedBox(height: 12),
            const MentalPushBanner(),
          ],

          // ── Toggle metrónomo ──
          if (!_showTimer) ...[
            const SizedBox(height: 16),
            GlassmorphicCard(
              padding: const EdgeInsets.all(14),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(Icons.music_note_rounded,
                          color: AppColors.cyan, size: 20),
                      const SizedBox(width: 8),
                      Text('Ritmo de repeticiones',
                          style: AppTextStyles.titleSmall),
                      const Spacer(),
                      Switch(
                        value: _showMetronome,
                        onChanged: (v) =>
                            setState(() => _showMetronome = v),
                        activeTrackColor: AppColors.cyan,
                      ),
                    ],
                  ),
                  if (_showMetronome) ...[
                    const SizedBox(height: 12),
                    RepMetronome(tempo: prescription.tempo),
                  ],
                ],
              ),
            ),
          ],

          const SizedBox(height: 16),
          MotivationalCard(compact: true),
        ],
      ),
    );
  }
}

// ── Prescripción chip ─────────────────────────────────────────

class _PrescriptionChip extends StatelessWidget {
  const _PrescriptionChip({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.bgElevated,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.cyan, size: 18),
            const SizedBox(height: 4),
            Text(value,
                style: AppTextStyles.titleSmall,
                textAlign: TextAlign.center),
            Text(label, style: AppTextStyles.labelSmall),
          ],
        ),
      ),
    );
  }
}

// ── Pantalla de fin de rutina ─────────────────────────────────

class _FinishScreen extends StatelessWidget {
  const _FinishScreen({required this.day, required this.onClose});

  final WorkoutDay day;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fondo
          Positioned.fill(
            child: Image.asset(
              'assets/images/decorative/workout_complete.png',
              fit: BoxFit.cover,
              color: Colors.black.withValues(alpha: 0.7),
              colorBlendMode: BlendMode.darken,
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: AppColors.gradientDarkFull,
              ),
            ),
          ),
          // Contenido
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: AppColors.gradientOrangeCyan,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.orange.withValues(alpha: 0.4),
                          blurRadius: 30,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: const Icon(Icons.emoji_events_rounded,
                        color: Colors.white, size: 44),
                  ),
                  const SizedBox(height: 28),
                  Text(
                    '¡Rutina completada!',
                    style: AppTextStyles.heroTitle,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${day.name} · ${day.focus}',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.cyan,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  const RecoveryTipCard(),
                  const SizedBox(height: 16),
                  MotivationalCard(
                    quote: MotivationalData.randomQuote,
                    compact: true,
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: onClose,
                      icon: const Icon(Icons.home_rounded),
                      label: const Text('Volver al inicio'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

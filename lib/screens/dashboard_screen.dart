import 'package:flutter/material.dart';

import '../data/motivational_data.dart';
import '../data/plan_generator.dart';
import '../data/exercise_catalog.dart';
import '../models/exercise.dart';
import '../models/user_profile.dart';
import '../models/workout_plan.dart';
import '../services/profile_service.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../widgets/glassmorphic_card.dart';
import '../widgets/motivational_card.dart';
import '../widgets/progress_indicator.dart';
import 'active_workout_screen.dart';

/// Dashboard principal con saludo, plan del día y progreso.
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({
    super.key,
    required this.profile,
    required this.onProfileUpdated,
    this.onTabChanged,
  });

  final UserProfile profile;
  final VoidCallback onProfileUpdated;
  final ValueChanged<int>? onTabChanged;

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late UserProfile _profile;
  final _planGenerator = const PlanGenerator();

  @override
  void initState() {
    super.initState();
    _profile = widget.profile;
  }

  void _editGoal() {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      backgroundColor: AppColors.bgCard,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Editar Objetivo', style: AppTextStyles.titleLarge),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: FitnessGoal.values.map((g) {
                  return ChoiceChip(
                    label: Text(g.label),
                    selected: g == _profile.goal,
                    onSelected: (selected) async {
                      if (selected) {
                        Navigator.pop(context);
                        final updated = _profile.copyWith(
                          goal: g,
                          weekProgress: List.filled(_profile.daysPerWeek, false),
                          currentDayIndex: 0,
                        );
                        await ProfileService.instance.save(updated);
                        setState(() => _profile = updated);
                        widget.onProfileUpdated();
                      }
                    },
                  );
                }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }

  void _editLevel() {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      backgroundColor: AppColors.bgCard,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Editar Nivel', style: AppTextStyles.titleLarge),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: FitnessLevel.values.map((l) {
                  return ChoiceChip(
                    label: Text(l.label),
                    selected: l == _profile.level,
                    onSelected: (selected) async {
                      if (selected) {
                        Navigator.pop(context);
                        final updated = _profile.copyWith(level: l);
                        await ProfileService.instance.save(updated);
                        setState(() => _profile = updated);
                        widget.onProfileUpdated();
                      }
                    },
                  );
                }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }

  void _editDays() {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      backgroundColor: AppColors.bgCard,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Días por semana', style: AppTextStyles.titleLarge),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                children: [2, 3, 4, 5].map((d) {
                  return ChoiceChip(
                    label: Text('$d días'),
                    selected: d == _profile.daysPerWeek,
                    onSelected: (selected) async {
                      if (selected) {
                        Navigator.pop(context);
                        final updated = _profile.copyWith(
                          daysPerWeek: d,
                          weekProgress: List.filled(d, false),
                          currentDayIndex: 0,
                        );
                        await ProfileService.instance.save(updated);
                        setState(() => _profile = updated);
                        widget.onProfileUpdated();
                      }
                    },
                  );
                }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void didUpdateWidget(covariant DashboardScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.profile != widget.profile) {
      _profile = widget.profile;
    }
  }

  WorkoutPlan get _plan {
    final eligible = exerciseCatalog
        .where((e) => e.isAvailableForLevel(_profile.level))
        .toList();
    return _planGenerator.create(
      visibleExercises: eligible,
      goal: _profile.goal,
      level: _profile.level,
      daysPerWeek: _profile.daysPerWeek,
      selectedZones: <BodyZone>{},
      selectedTypes: <MovementType>{},
      selectedEquipment: _profile.availableEquipment.toSet(),
    );
  }

  void _startWorkout() {
    final plan = _plan;
    final dayIndex = _profile.currentDayIndex;
    if (dayIndex >= plan.days.length) return;

    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ActiveWorkoutScreen(
          day: plan.days[dayIndex],
          dayIndex: dayIndex,
          goal: _profile.goal,
          level: _profile.level,
          onComplete: () async {
            await ProfileService.instance.completeDay(dayIndex);
            setState(() {
              _profile = ProfileService.instance.profile!;
            });
            widget.onProfileUpdated();
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final plan = _plan;
    final dayIndex = _profile.currentDayIndex;
    final currentDay =
        dayIndex < plan.days.length ? plan.days[dayIndex] : null;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      children: [
        // ── Hero Header ──
        _HeroHeader(profile: _profile),
        const SizedBox(height: 20),

        // ── Frase motivacional ──
        const MotivationalCard(),
        const SizedBox(height: 20),

        // ── Progreso semanal ──
        GlassmorphicCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Tu semana', style: AppTextStyles.titleMedium),
              const SizedBox(height: 4),
              Text(
                '${_profile.completedDays} de ${_profile.daysPerWeek} días completados',
                style: AppTextStyles.bodySmall,
              ),
              const SizedBox(height: 14),
              WeekProgressIndicator(
                totalDays: _profile.daysPerWeek,
                completedDays: _profile.weekProgress,
                currentDay: _profile.currentDayIndex,
              ),
              if (_profile.weekComplete) ...[
                const SizedBox(height: 14),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.emoji_events_rounded,
                          color: AppColors.gold, size: 24),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          '¡Semana completada! Descansa y vuelve más fuerte.',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.success,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      await ProfileService.instance.resetWeek();
                      setState(() {
                        _profile = ProfileService.instance.profile!;
                      });
                      widget.onProfileUpdated();
                    },
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text('Nueva semana'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.cyan,
                      side: const BorderSide(color: AppColors.cyan),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 20),

        // ── Entrenamiento de hoy ──
        if (currentDay != null && !_profile.weekComplete) ...[
          GlassmorphicCard(
            onTap: _startWorkout,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        gradient: AppColors.gradientOrange,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          '${dayIndex + 1}',
                          style: AppTextStyles.titleLarge.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hoy: ${currentDay.name}',
                            style: AppTextStyles.titleMedium,
                          ),
                          Text(currentDay.focus,
                              style: AppTextStyles.bodySmall),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.orange,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.play_arrow_rounded,
                              color: Colors.white, size: 18),
                          const SizedBox(width: 4),
                          Text(
                            'IR',
                            style: AppTextStyles.labelLarge.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                ...currentDay.exercises.take(3).map((pe) => Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        children: [
                          Icon(Icons.circle,
                              size: 6, color: AppColors.textMuted),
                          const SizedBox(width: 8),
                          Text(pe.exercise.name,
                              style: AppTextStyles.bodyMedium),
                        ],
                      ),
                    )),
                if (currentDay.exercises.length > 3)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      '+${currentDay.exercises.length - 3} más',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.cyan,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],

        // ── Info rápida ──
        Row(
          children: [
            Expanded(
              child: _StatCard(
                icon: Icons.flag_rounded,
                label: 'Objetivo',
                value: _profile.goal.label,
                color: AppColors.orange,
                onTap: _editGoal,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                icon: Icons.speed_rounded,
                label: 'Nivel',
                value: _profile.level.label,
                color: AppColors.cyan,
                onTap: _editLevel,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _StatCard(
                icon: Icons.calendar_today_rounded,
                label: 'Días/semana',
                value: '${_profile.daysPerWeek}',
                color: AppColors.gold,
                onTap: _editDays,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                icon: Icons.fitness_center_rounded,
                label: 'Ejercicios',
                value: '${exerciseCatalog.length}',
                color: AppColors.success,
                onTap: () {
                  widget.onTabChanged?.call(1);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ── Hero Header ───────────────────────────────────────────────

class _HeroHeader extends StatelessWidget {
  const _HeroHeader({required this.profile});

  final UserProfile profile;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(24),
        ),
        image: const DecorationImage(
          image: AssetImage('assets/images/decorative/dashboard_hero.png'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Color(0x88000000),
            BlendMode.darken,
          ),
        ),
      ),
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(24),
          ),
          gradient: AppColors.gradientDarkOverlay,
        ),
        padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.asset(
                  'assets/images/trinity_logo.png',
                  width: 36,
                  height: 36,
                ),
                const SizedBox(width: 10),
                Text('Trinity Gym', style: AppTextStyles.titleMedium),
              ],
            ),
            const Spacer(),
            Text(
              MotivationalData.greeting(profile.name),
              style: AppTextStyles.headline1,
            ),
            const SizedBox(height: 4),
            Text(
              'Listo para entrenar. ${profile.goal.label} · ${profile.level.label}',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.cyan,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Stat Cards ────────────────────────────────────────────────

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: color.withValues(alpha: 0.15)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(icon, color: color, size: 20),
                    if (onTap != null && label != 'Ejercicios')
                      Icon(Icons.edit_rounded, color: color.withValues(alpha: 0.5), size: 14)
                    else if (onTap != null && label == 'Ejercicios')
                      Icon(Icons.arrow_forward_rounded, color: color.withValues(alpha: 0.5), size: 14),
                  ],
                ),
                const SizedBox(height: 8),
                Text(label, style: AppTextStyles.labelSmall),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: AppTextStyles.titleSmall.copyWith(color: color),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

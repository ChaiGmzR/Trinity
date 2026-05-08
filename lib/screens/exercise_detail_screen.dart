import 'package:flutter/material.dart';

import '../data/plan_generator.dart';
import '../models/exercise.dart';
import '../widgets/exercise_video_player.dart';

class ExerciseDetailScreen extends StatelessWidget {
  const ExerciseDetailScreen({
    super.key,
    required this.exercise,
    required this.goal,
    required this.level,
  });

  final Exercise exercise;
  final FitnessGoal goal;
  final FitnessLevel level;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final prescription = PlanGenerator.prescriptionFor(
      exercise,
      goal: goal,
      level: level,
    );

    return Scaffold(
      appBar: AppBar(title: Text(exercise.name)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
        children: [
          ExerciseVideoPlayer(
            assetVideo: exercise.localVideoAsset,
            networkVideoUrl: exercise.onlineVideoUrl,
            posterAsset: exercise.imageAsset,
          ),
          const SizedBox(height: 18),
          Text(exercise.name, style: theme.textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text(exercise.description, style: theme.textTheme.bodyLarge),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _InfoChip(label: exercise.type.label, icon: Icons.route_rounded),
              _InfoChip(
                label: exercise.minLevel.label,
                icon: Icons.trending_up_rounded,
              ),
              _InfoChip(
                label: exercise.isTimed ? 'Por tiempo' : 'Por repeticiones',
                icon: exercise.isTimed
                    ? Icons.timer_rounded
                    : Icons.repeat_rounded,
              ),
            ],
          ),
          const SizedBox(height: 18),
          _PrescriptionCard(
            goal: goal,
            sets: prescription.sets,
            reps: prescription.reps,
            rest: prescription.rest,
            tempo: prescription.tempo,
            note: prescription.note,
          ),
          const SizedBox(height: 18),
          _Section(
            title: 'Músculos',
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: exercise.muscles
                  .map((muscle) => Chip(label: Text(muscle)))
                  .toList(),
            ),
          ),
          _Section(
            title: 'Equipo compatible',
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: exercise.equipment
                  .map((item) => Chip(label: Text(item.label)))
                  .toList(),
            ),
          ),
          _Section(
            title: 'Técnica',
            child: Column(
              children: [
                for (var i = 0; i < exercise.steps.length; i++)
                  _NumberedText(index: i + 1, text: exercise.steps[i]),
              ],
            ),
          ),
          _Section(
            title: 'Claves',
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: exercise.cues
                  .map(
                    (cue) => Chip(
                      avatar: const Icon(Icons.check_rounded, size: 18),
                      label: Text(cue),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _PrescriptionCard extends StatelessWidget {
  const _PrescriptionCard({
    required this.goal,
    required this.sets,
    required this.reps,
    required this.rest,
    required this.tempo,
    required this.note,
  });

  final FitnessGoal goal;
  final String sets;
  final String reps;
  final String rest;
  final String tempo;
  final String note;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Prescripción para ${goal.label.toLowerCase()}',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _Metric(label: 'Series', value: sets),
                ),
                Expanded(
                  child: _Metric(label: 'Reps/tiempo', value: reps),
                ),
                Expanded(
                  child: _Metric(label: 'Descanso', value: rest),
                ),
              ],
            ),
            const SizedBox(height: 10),
            _Metric(label: 'Tempo', value: tempo),
            const SizedBox(height: 10),
            Text(note, style: theme.textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.secondary,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 2),
        Text(value, style: theme.textTheme.titleMedium),
      ],
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.label, required this.icon});

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Chip(avatar: Icon(icon, size: 18), label: Text(label));
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}

class _NumberedText extends StatelessWidget {
  const _NumberedText({required this.index, required this.text});

  final int index;
  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '$index',
              style: TextStyle(
                color: theme.colorScheme.onPrimary,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}

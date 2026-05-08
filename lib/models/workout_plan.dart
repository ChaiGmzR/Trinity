import 'exercise.dart';

class TrainingPrescription {
  const TrainingPrescription({
    required this.sets,
    required this.reps,
    required this.rest,
    required this.tempo,
    required this.note,
  });

  final String sets;
  final String reps;
  final String rest;
  final String tempo;
  final String note;
}

class PlanExercise {
  const PlanExercise({required this.exercise, required this.prescription});

  final Exercise exercise;
  final TrainingPrescription prescription;
}

class WorkoutDay {
  const WorkoutDay({
    required this.name,
    required this.focus,
    required this.warmup,
    required this.exercises,
    required this.finisher,
  });

  final String name;
  final String focus;
  final String warmup;
  final List<PlanExercise> exercises;
  final String finisher;
}

class WorkoutPlan {
  const WorkoutPlan({
    required this.goal,
    required this.level,
    required this.daysPerWeek,
    required this.days,
    required this.guidance,
  });

  final FitnessGoal goal;
  final FitnessLevel level;
  final int daysPerWeek;
  final List<WorkoutDay> days;
  final String guidance;
}

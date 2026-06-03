import '../models/workout_plan.dart';

/// Estado mutable de un entrenamiento activo.
///
/// Registra qué ejercicio y serie está haciendo el usuario.
class WorkoutState {
  WorkoutState({
    required this.day,
    required this.dayIndex,
  }) : completedSets = List.generate(
          day.exercises.length,
          (_) => 0,
        );

  final WorkoutDay day;
  final int dayIndex;

  /// Series completadas por cada ejercicio.
  final List<int> completedSets;

  /// Índice del ejercicio actual.
  int currentExerciseIndex = 0;

  /// Si la rutina fue finalizada.
  bool isFinished = false;

  /// Ejercicio actual.
  PlanExercise get currentExercise => day.exercises[currentExerciseIndex];

  /// Series objetivo del ejercicio actual (parsea el primer número del string).
  int get targetSets {
    final raw = currentExercise.prescription.sets;
    final match = RegExp(r'(\d+)').firstMatch(raw);
    return match != null ? int.parse(match.group(1)!) : 3;
  }

  /// Series completadas del ejercicio actual.
  int get currentCompletedSets =>
      currentExerciseIndex < completedSets.length
          ? completedSets[currentExerciseIndex]
          : 0;

  /// Si el ejercicio actual está completado.
  bool get currentExerciseDone => currentCompletedSets >= targetSets;

  /// Total de ejercicios.
  int get totalExercises => day.exercises.length;

  /// Progreso total (0.0 a 1.0).
  double get overallProgress {
    if (day.exercises.isEmpty) return 0;
    var totalDone = 0;
    var totalTarget = 0;
    for (var i = 0; i < day.exercises.length; i++) {
      final raw = day.exercises[i].prescription.sets;
      final match = RegExp(r'(\d+)').firstMatch(raw);
      final target = match != null ? int.parse(match.group(1)!) : 3;
      totalTarget += target;
      totalDone += completedSets[i];
    }
    if (totalTarget == 0) return 0;
    return totalDone / totalTarget;
  }

  /// Registra una serie completada.
  void completeSet() {
    if (currentExerciseIndex < completedSets.length) {
      completedSets[currentExerciseIndex]++;
    }
  }

  /// Avanza al siguiente ejercicio. Devuelve true si hay más ejercicios.
  bool nextExercise() {
    if (currentExerciseIndex < day.exercises.length - 1) {
      currentExerciseIndex++;
      return true;
    }
    isFinished = true;
    return false;
  }

  /// Parsea los segundos de descanso del ejercicio actual.
  int get restSeconds {
    final raw = currentExercise.prescription.rest;
    final match = RegExp(r'(\d+)').firstMatch(raw);
    return match != null ? int.parse(match.group(1)!) : 60;
  }
}

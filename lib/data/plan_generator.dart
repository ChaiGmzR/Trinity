import '../models/exercise.dart';
import '../models/workout_plan.dart';
import 'exercise_catalog.dart';

class PlanGenerator {
  const PlanGenerator();

  WorkoutPlan create({
    required List<Exercise> visibleExercises,
    required FitnessGoal goal,
    required FitnessLevel level,
    required int daysPerWeek,
    required Set<BodyZone> selectedZones,
    required Set<MovementType> selectedTypes,
    required Set<Equipment> selectedEquipment,
  }) {
    final eligible = _eligiblePool(
      visibleExercises: visibleExercises,
      level: level,
      selectedZones: selectedZones,
      selectedTypes: selectedTypes,
      selectedEquipment: selectedEquipment,
    );
    final templates = _templates(daysPerWeek, goal, selectedTypes);
    final used = <String>{};
    final days = <WorkoutDay>[];

    for (var dayIndex = 0; dayIndex < daysPerWeek; dayIndex++) {
      final template = templates[dayIndex % templates.length];
      final exercises = <PlanExercise>[];

      for (final type in template.types) {
        final picked = _pickExercise(
          pool: eligible,
          used: used,
          type: type,
          selectedZones: selectedZones,
          goal: goal,
        );
        if (picked == null) {
          continue;
        }
        used.add(picked.id);
        exercises.add(
          PlanExercise(
            exercise: picked,
            prescription: prescriptionFor(picked, goal: goal, level: level),
          ),
        );
      }

      if (exercises.length < 4) {
        final fillers = eligible
            .where((exercise) => !used.contains(exercise.id))
            .take(4 - exercises.length)
            .toList();
        for (final exercise in fillers) {
          used.add(exercise.id);
          exercises.add(
            PlanExercise(
              exercise: exercise,
              prescription: prescriptionFor(exercise, goal: goal, level: level),
            ),
          );
        }
      }

      if (used.length > eligible.length - 6) {
        used.clear();
      }

      days.add(
        WorkoutDay(
          name: 'Día ${dayIndex + 1}',
          focus: template.focus,
          warmup: _warmupFor(goal),
          exercises: exercises,
          finisher: _finisherFor(goal, level),
        ),
      );
    }

    return WorkoutPlan(
      goal: goal,
      level: level,
      daysPerWeek: daysPerWeek,
      days: days,
      guidance: _guidance(goal, daysPerWeek),
    );
  }

  static TrainingPrescription prescriptionFor(
    Exercise exercise, {
    required FitnessGoal goal,
    required FitnessLevel level,
  }) {
    final advanced = level == FitnessLevel.avanzado;
    final intermediate = level == FitnessLevel.intermedio;
    final timed =
        exercise.isTimed ||
        exercise.type == MovementType.cardio ||
        exercise.type == MovementType.movilidad ||
        exercise.type == MovementType.carga;

    switch (goal) {
      case FitnessGoal.fuerza:
        if (timed) {
          return const TrainingPrescription(
            sets: '3-4',
            reps: '20-40 s',
            rest: '90-150 s',
            tempo: 'Firme',
            note:
                'Usa una variante difícil pero perfecta; detén antes de perder postura.',
          );
        }
        return TrainingPrescription(
          sets: advanced ? '4-5' : '2-4',
          reps: intermediate || advanced ? '3-6' : '5-8',
          rest: '120-180 s',
          tempo: '2-1-1',
          note: 'Elige carga o variante que deje 1-3 repeticiones en reserva.',
        );
      case FitnessGoal.hipertrofia:
        if (timed) {
          return const TrainingPrescription(
            sets: '3-4',
            reps: '30-50 s',
            rest: '45-75 s',
            tempo: 'Controlado',
            note: 'Suma volumen semanal y trabaja cerca del fallo técnico.',
          );
        }
        return TrainingPrescription(
          sets: intermediate || advanced ? '3-4' : '2-3',
          reps: '8-15',
          rest: '60-90 s',
          tempo: '3-1-1',
          note:
              'Prioriza rango completo; busca unas 8-12 series por músculo/semana.',
        );
      case FitnessGoal.resistencia:
        if (timed) {
          return const TrainingPrescription(
            sets: '2-4',
            reps: '40-70 s',
            rest: '20-45 s',
            tempo: 'Continuo',
            note:
                'Mantén respiración y ritmo que puedas repetir en todas las series.',
          );
        }
        return const TrainingPrescription(
          sets: '2-4',
          reps: '15-25',
          rest: '30-60 s',
          tempo: '2-0-2',
          note:
              'No sacrifiques técnica por velocidad; usa cargas ligeras o moderadas.',
        );
      case FitnessGoal.perdidaGrasa:
        if (timed) {
          return const TrainingPrescription(
            sets: '3-5 rondas',
            reps: '30-45 s',
            rest: '15-40 s',
            tempo: 'Ágil',
            note:
                'Trabaja en circuito; el objetivo es densidad sin perder forma.',
          );
        }
        return const TrainingPrescription(
          sets: '3-5 rondas',
          reps: '10-15',
          rest: '20-45 s',
          tempo: 'Control + ritmo',
          note: 'Alterna zonas del cuerpo para sostener intensidad.',
        );
      case FitnessGoal.movilidad:
        if (timed || exercise.type == MovementType.movilidad) {
          return const TrainingPrescription(
            sets: '2-3',
            reps: '45-75 s',
            rest: '20-40 s',
            tempo: 'Lento',
            note: 'Respira nasal y gana rango sin dolor.',
          );
        }
        return const TrainingPrescription(
          sets: '2-3',
          reps: '6-10',
          rest: '30-60 s',
          tempo: '4-2-2',
          note: 'Convierte el ejercicio en práctica técnica y rango activo.',
        );
    }
  }

  List<Exercise> _eligiblePool({
    required List<Exercise> visibleExercises,
    required FitnessLevel level,
    required Set<BodyZone> selectedZones,
    required Set<MovementType> selectedTypes,
    required Set<Equipment> selectedEquipment,
  }) {
    final primary = visibleExercises.where((exercise) {
      return exercise.isAvailableForLevel(level);
    }).toList();

    if (primary.length >= 4) {
      return primary;
    }

    return exerciseCatalog.where((exercise) {
      final levelOk = exercise.isAvailableForLevel(level);
      final zonesOk =
          selectedZones.isEmpty ||
          exercise.bodyZones.any(selectedZones.contains) ||
          exercise.bodyZones.contains(BodyZone.cuerpoCompleto);
      final typesOk =
          selectedTypes.isEmpty || selectedTypes.contains(exercise.type);
      final equipmentOk =
          selectedEquipment.isEmpty ||
          exercise.equipment.any(selectedEquipment.contains);
      return levelOk && zonesOk && typesOk && equipmentOk;
    }).toList();
  }

  Exercise? _pickExercise({
    required List<Exercise> pool,
    required Set<String> used,
    required MovementType type,
    required Set<BodyZone> selectedZones,
    required FitnessGoal goal,
  }) {
    final matchingType = pool.where((exercise) {
      if (exercise.type != type || used.contains(exercise.id)) {
        return false;
      }
      if (selectedZones.isEmpty) {
        return true;
      }
      return exercise.bodyZones.any(selectedZones.contains) ||
          exercise.bodyZones.contains(BodyZone.cuerpoCompleto);
    }).toList();

    if (matchingType.isNotEmpty) {
      matchingType.sort(
        (a, b) => _score(
          b,
          selectedZones,
          goal,
        ).compareTo(_score(a, selectedZones, goal)),
      );
      return matchingType.first;
    }

    final fallback = pool
        .where((exercise) => !used.contains(exercise.id))
        .toList();
    if (fallback.isEmpty) {
      return null;
    }
    fallback.sort(
      (a, b) => _score(
        b,
        selectedZones,
        goal,
      ).compareTo(_score(a, selectedZones, goal)),
    );
    return fallback.first;
  }

  int _score(Exercise exercise, Set<BodyZone> zones, FitnessGoal goal) {
    var score = exercise.intensity;
    if (zones.isNotEmpty) {
      score += exercise.bodyZones.where(zones.contains).length * 4;
    }
    if (goal == FitnessGoal.perdidaGrasa &&
        exercise.type == MovementType.cardio) {
      score += 3;
    }
    if (goal == FitnessGoal.movilidad &&
        exercise.type == MovementType.movilidad) {
      score += 4;
    }
    if (goal == FitnessGoal.fuerza && exercise.intensity >= 4) {
      score += 2;
    }
    return score;
  }

  List<_Template> _templates(
    int daysPerWeek,
    FitnessGoal goal,
    Set<MovementType> selectedTypes,
  ) {
    if (selectedTypes.isNotEmpty) {
      final selected = selectedTypes.toList();
      return List.generate(
        daysPerWeek,
        (index) => _Template('Enfoque seleccionado', [
          ...selected,
          MovementType.core,
          if (goal == FitnessGoal.perdidaGrasa) MovementType.cardio,
        ]),
      );
    }

    if (goal == FitnessGoal.movilidad) {
      return const [
        _Template('Movilidad de cadera y columna', [
          MovementType.movilidad,
          MovementType.sentadilla,
          MovementType.core,
          MovementType.bisagra,
        ]),
        _Template('Hombro, escápula y postura', [
          MovementType.movilidad,
          MovementType.traccion,
          MovementType.empuje,
          MovementType.core,
        ]),
        _Template('Rango activo total', [
          MovementType.movilidad,
          MovementType.zancada,
          MovementType.carga,
          MovementType.core,
        ]),
      ];
    }

    if (daysPerWeek == 2) {
      return const [
        _Template('Full body A', [
          MovementType.sentadilla,
          MovementType.empuje,
          MovementType.traccion,
          MovementType.core,
          MovementType.carga,
        ]),
        _Template('Full body B', [
          MovementType.bisagra,
          MovementType.zancada,
          MovementType.empuje,
          MovementType.traccion,
          MovementType.core,
        ]),
      ];
    }

    if (daysPerWeek == 4) {
      return const [
        _Template('Pierna y core', [
          MovementType.sentadilla,
          MovementType.bisagra,
          MovementType.zancada,
          MovementType.core,
        ]),
        _Template('Torso empuje/tracción', [
          MovementType.empuje,
          MovementType.traccion,
          MovementType.aislamiento,
          MovementType.core,
        ]),
        _Template('Pierna unilateral', [
          MovementType.zancada,
          MovementType.sentadilla,
          MovementType.bisagra,
          MovementType.carga,
        ]),
        _Template('Torso y acondicionamiento', [
          MovementType.traccion,
          MovementType.empuje,
          MovementType.cardio,
          MovementType.core,
        ]),
      ];
    }

    if (daysPerWeek >= 5) {
      return const [
        _Template('Pierna fuerte', [
          MovementType.sentadilla,
          MovementType.bisagra,
          MovementType.zancada,
          MovementType.core,
        ]),
        _Template('Empuje', [
          MovementType.empuje,
          MovementType.empuje,
          MovementType.aislamiento,
          MovementType.core,
        ]),
        _Template('Tracción', [
          MovementType.traccion,
          MovementType.traccion,
          MovementType.aislamiento,
          MovementType.carga,
        ]),
        _Template('Condición', [
          MovementType.cardio,
          MovementType.cardio,
          MovementType.core,
          MovementType.movilidad,
        ]),
        _Template('Full body técnico', [
          MovementType.bisagra,
          MovementType.sentadilla,
          MovementType.empuje,
          MovementType.traccion,
          MovementType.core,
        ]),
      ];
    }

    return const [
      _Template('Full body fuerza', [
        MovementType.sentadilla,
        MovementType.empuje,
        MovementType.traccion,
        MovementType.core,
        MovementType.carga,
      ]),
      _Template('Cadena posterior y torso', [
        MovementType.bisagra,
        MovementType.zancada,
        MovementType.traccion,
        MovementType.empuje,
        MovementType.core,
      ]),
      _Template('Condición y estabilidad', [
        MovementType.cardio,
        MovementType.sentadilla,
        MovementType.traccion,
        MovementType.core,
        MovementType.movilidad,
      ]),
    ];
  }

  String _warmupFor(FitnessGoal goal) {
    switch (goal) {
      case FitnessGoal.fuerza:
        return '6-8 min: movilidad de cadera/hombro + 2 series fáciles del primer ejercicio.';
      case FitnessGoal.hipertrofia:
        return '5-7 min: movilidad dinámica + una serie de aproximación por patrón.';
      case FitnessGoal.resistencia:
        return '5 min: jumping jacks suaves, bisagras sin carga y plancha corta.';
      case FitnessGoal.perdidaGrasa:
        return '6 min: movilidad rápida + 2 rondas suaves de cardio y core.';
      case FitnessGoal.movilidad:
        return '3-5 min: respiración, cat-cow y rango articular sin carga.';
    }
  }

  String _finisherFor(FitnessGoal goal, FitnessLevel level) {
    switch (goal) {
      case FitnessGoal.fuerza:
        return 'Opcional: caminata con carga 3 x 30 s si la técnica sigue limpia.';
      case FitnessGoal.hipertrofia:
        return 'Última serie: mantén 1-2 repeticiones en reserva, sin fallo forzado.';
      case FitnessGoal.resistencia:
        return 'Final: 4 min alternando 30 s trabajo / 30 s descanso.';
      case FitnessGoal.perdidaGrasa:
        return level == FitnessLevel.principiante
            ? 'Final: 6 min EMOM suave alternando cardio y core.'
            : 'Final: 8-10 min AMRAP técnico con ejercicios del día.';
      case FitnessGoal.movilidad:
        return 'Final: 2 min de respiración lenta en el rango más cómodo.';
    }
  }

  String _guidance(FitnessGoal goal, int days) {
    final frequency = days < 2
        ? 'Sube a 2 días semanales cuando puedas.'
        : 'Deja al menos 48 h entre estímulos duros del mismo grupo muscular.';

    switch (goal) {
      case FitnessGoal.fuerza:
        return '$frequency Prioriza variantes pesadas o difíciles y descansos completos.';
      case FitnessGoal.hipertrofia:
        return '$frequency Busca acumular cerca de 10 series por grupo muscular a la semana.';
      case FitnessGoal.resistencia:
        return '$frequency Mantén técnica mientras subes repeticiones o tiempo bajo tensión.';
      case FitnessGoal.perdidaGrasa:
        return '$frequency Combina fuerza con circuitos; la intensidad no debe romper la forma.';
      case FitnessGoal.movilidad:
        return 'Puedes practicar movilidad casi diario si no hay dolor; conserva respiración y control.';
    }
  }
}

class _Template {
  const _Template(this.focus, this.types);

  final String focus;
  final List<MovementType> types;
}

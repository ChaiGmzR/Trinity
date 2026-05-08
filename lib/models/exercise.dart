enum FitnessGoal { fuerza, hipertrofia, resistencia, perdidaGrasa, movilidad }

enum FitnessLevel { principiante, intermedio, avanzado }

enum MovementType {
  empuje,
  traccion,
  sentadilla,
  bisagra,
  zancada,
  core,
  cardio,
  movilidad,
  carga,
  aislamiento,
}

enum BodyZone {
  cuerpoCompleto,
  pecho,
  espalda,
  hombros,
  brazos,
  abdomen,
  piernas,
  gluteos,
  cadera,
  pantorrillas,
}

enum Equipment {
  pesoCorporal,
  mancuernas,
  kettlebell,
  bandas,
  barraDominadas,
  sillaBanco,
  mochila,
  colchoneta,
  cuerda,
  toalla,
  sliders,
}

extension FitnessGoalLabels on FitnessGoal {
  String get label {
    switch (this) {
      case FitnessGoal.fuerza:
        return 'Fuerza';
      case FitnessGoal.hipertrofia:
        return 'Hipertrofia';
      case FitnessGoal.resistencia:
        return 'Resistencia';
      case FitnessGoal.perdidaGrasa:
        return 'Pérdida de grasa';
      case FitnessGoal.movilidad:
        return 'Movilidad';
    }
  }

  String get description {
    switch (this) {
      case FitnessGoal.fuerza:
        return 'Variantes difíciles, descansos largos y pocas repeticiones.';
      case FitnessGoal.hipertrofia:
        return 'Volumen semanal alto y series cerca del fallo técnico.';
      case FitnessGoal.resistencia:
        return 'Repeticiones altas, descansos cortos y control postural.';
      case FitnessGoal.perdidaGrasa:
        return 'Circuitos densos que elevan pulso sin perder técnica.';
      case FitnessGoal.movilidad:
        return 'Rango articular, control, estabilidad y respiración.';
    }
  }
}

extension FitnessLevelLabels on FitnessLevel {
  String get label {
    switch (this) {
      case FitnessLevel.principiante:
        return 'Principiante';
      case FitnessLevel.intermedio:
        return 'Intermedio';
      case FitnessLevel.avanzado:
        return 'Avanzado';
    }
  }

  int get rank => FitnessLevel.values.indexOf(this);
}

extension MovementTypeLabels on MovementType {
  String get label {
    switch (this) {
      case MovementType.empuje:
        return 'Empuje';
      case MovementType.traccion:
        return 'Tracción';
      case MovementType.sentadilla:
        return 'Sentadilla';
      case MovementType.bisagra:
        return 'Bisagra';
      case MovementType.zancada:
        return 'Zancada';
      case MovementType.core:
        return 'Core';
      case MovementType.cardio:
        return 'Cardio';
      case MovementType.movilidad:
        return 'Movilidad';
      case MovementType.carga:
        return 'Carga';
      case MovementType.aislamiento:
        return 'Aislamiento';
    }
  }
}

extension BodyZoneLabels on BodyZone {
  String get label {
    switch (this) {
      case BodyZone.cuerpoCompleto:
        return 'Cuerpo completo';
      case BodyZone.pecho:
        return 'Pecho';
      case BodyZone.espalda:
        return 'Espalda';
      case BodyZone.hombros:
        return 'Hombros';
      case BodyZone.brazos:
        return 'Brazos';
      case BodyZone.abdomen:
        return 'Abdomen';
      case BodyZone.piernas:
        return 'Piernas';
      case BodyZone.gluteos:
        return 'Glúteos';
      case BodyZone.cadera:
        return 'Cadera';
      case BodyZone.pantorrillas:
        return 'Pantorrillas';
    }
  }
}

extension EquipmentLabels on Equipment {
  String get label {
    switch (this) {
      case Equipment.pesoCorporal:
        return 'Peso corporal';
      case Equipment.mancuernas:
        return 'Mancuernas';
      case Equipment.kettlebell:
        return 'Kettlebell';
      case Equipment.bandas:
        return 'Bandas';
      case Equipment.barraDominadas:
        return 'Barra';
      case Equipment.sillaBanco:
        return 'Silla/banco';
      case Equipment.mochila:
        return 'Mochila';
      case Equipment.colchoneta:
        return 'Colchoneta';
      case Equipment.cuerda:
        return 'Cuerda';
      case Equipment.toalla:
        return 'Toalla';
      case Equipment.sliders:
        return 'Sliders';
    }
  }
}

class Exercise {
  const Exercise({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.bodyZones,
    required this.muscles,
    required this.equipment,
    required this.minLevel,
    required this.pattern,
    required this.imageAsset,
    required this.localVideoAsset,
    required this.onlineVideoUrl,
    required this.steps,
    required this.cues,
    this.isTimed = false,
    this.intensity = 3,
  });

  final String id;
  final String name;
  final String description;
  final MovementType type;
  final List<BodyZone> bodyZones;
  final List<String> muscles;
  final List<Equipment> equipment;
  final FitnessLevel minLevel;
  final String pattern;
  final String imageAsset;
  final String localVideoAsset;
  final String onlineVideoUrl;
  final List<String> steps;
  final List<String> cues;
  final bool isTimed;
  final int intensity;

  bool isAvailableForLevel(FitnessLevel level) {
    return minLevel.rank <= level.rank;
  }

  bool matchesSearch(String query) {
    final text = [
      name,
      description,
      type.label,
      ...bodyZones.map((zone) => zone.label),
      ...muscles,
      ...equipment.map((item) => item.label),
    ].join(' ').toLowerCase();
    return text.contains(query.toLowerCase().trim());
  }
}

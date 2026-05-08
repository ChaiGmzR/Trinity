import '../models/exercise.dart';

const _cdcPushups = 'assets/videos/cdc_pushups.mp4';
const _cdcSquat = 'assets/videos/cdc_half_squat.mp4';
const _cdcOverhead = 'assets/videos/cdc_overhead_press.mp4';
const _cdcCurl = 'assets/videos/cdc_bicep_curls.mp4';
const _cdcSuperman = 'assets/videos/cdc_superman.mp4';
const _cdcSitups = 'assets/videos/cdc_situps.mp4';
const _cdcCalf = 'assets/videos/cdc_toe_lift.mp4';

const _onlineVideos = <String, String>{
  'pushup': 'https://www.cdc.gov/physicalactivity/videos/Push-ups_Ipod-Lg.mp4',
  'squat': 'https://www.cdc.gov/physicalactivity/videos/Half_squat_IPod_Lg.mp4',
  'overhead_press':
      'https://www.cdc.gov/physicalactivity/videos/Overhead_Press-Home_Ipod-Lg.mp4',
  'curl':
      'https://www.cdc.gov/physicalactivity/videos/Biscep_Curls_Ipod-Lg.mp4',
  'superman':
      'https://www.cdc.gov/physicalactivity/videos/Superman_Ipod-Lg.mp4',
  'core': 'https://www.cdc.gov/physicalactivity/videos/Sit-ups_Ipod-Lg.mp4',
  'calf_raise':
      'https://www.cdc.gov/physicalactivity/videos/Toe_Lift_Ipod-Lg.mp4',
  'cardio':
      'https://commons.wikimedia.org/wiki/Special:Redirect/file/Burpee_How_To.webm',
  'lunge':
      'https://commons.wikimedia.org/wiki/Special:Redirect/file/Basic_single_leg_squat.webm',
  'row':
      'https://commons.wikimedia.org/wiki/Special:Redirect/file/Muscle_Strengthening_at_the_Gym_-_Row_Machine.webm',
};

String _image(String pattern) => 'assets/images/$pattern.png';

String _video(String pattern) {
  switch (pattern) {
    case 'pushup':
      return _cdcPushups;
    case 'squat':
      return _cdcSquat;
    case 'overhead_press':
      return _cdcOverhead;
    case 'curl':
      return _cdcCurl;
    case 'superman':
      return _cdcSuperman;
    case 'core':
      return _cdcSitups;
    case 'calf_raise':
      return _cdcCalf;
    default:
      return 'assets/videos/generated_$pattern.mp4';
  }
}

List<String> _steps(String pattern) {
  switch (pattern) {
    case 'pushup':
      return [
        'Coloca manos bajo hombros y crea una línea recta de cabeza a talones.',
        'Baja con codos a unos 30-45 grados del torso.',
        'Empuja el suelo hasta extender brazos sin perder tensión abdominal.',
      ];
    case 'squat':
      return [
        'Pies al ancho cómodo, costillas abajo y abdomen firme.',
        'Lleva cadera atrás y rodillas en dirección de los dedos.',
        'Sube empujando el suelo y mantén el pecho alto.',
      ];
    case 'lunge':
      return [
        'Da un paso estable y reparte el peso entre ambos pies.',
        'Baja hasta que la rodilla trasera se acerque al suelo.',
        'Regresa empujando con el talón delantero sin colapsar la rodilla.',
      ];
    case 'hinge':
      return [
        'Desbloquea rodillas y empuja la cadera hacia atrás.',
        'Mantén espalda larga y carga cerca del cuerpo si usas peso.',
        'Vuelve apretando glúteos, no hiperextiendas la zona lumbar.',
      ];
    case 'row':
      return [
        'Inclina el torso o fija la banda con espalda neutra.',
        'Tira llevando codos hacia la cadera.',
        'Pausa un instante juntando escápulas y vuelve controlado.',
      ];
    case 'pullup':
      return [
        'Cuelga con hombros activos y abdomen firme.',
        'Tira el pecho hacia la barra llevando codos abajo.',
        'Baja controlado hasta extensión completa sin perder control escapular.',
      ];
    case 'overhead_press':
      return [
        'Peso a la altura de hombros, glúteos y abdomen firmes.',
        'Empuja arriba sin arquear la espalda.',
        'Baja al punto inicial con control.',
      ];
    case 'curl':
      return [
        'Codos cerca del torso y muñecas neutras.',
        'Flexiona sin balancear el cuerpo.',
        'Baja lento hasta extender el codo.',
      ];
    case 'core':
      return [
        'Inicia con pelvis neutra y respiración controlada.',
        'Mueve tronco o piernas sin jalar el cuello.',
        'Detén la serie si pierdes control lumbar.',
      ];
    case 'plank':
      return [
        'Apoya antebrazos o manos bajo hombros.',
        'Aprieta glúteos y abdomen para formar una línea estable.',
        'Respira corto y evita que la cadera caiga.',
      ];
    case 'bridge':
      return [
        'Apoya pies cerca de glúteos y costillas abajo.',
        'Eleva la cadera apretando glúteos.',
        'Baja lento sin perder alineación de rodillas.',
      ];
    case 'superman':
      return [
        'Acuéstate boca abajo con cuello largo.',
        'Eleva brazos y piernas desde glúteos y espalda alta.',
        'Pausa breve y vuelve sin golpear el suelo.',
      ];
    case 'calf_raise':
      return [
        'Apoya la punta de los pies y mantén rodillas extendidas.',
        'Sube los talones hasta contraer pantorrillas.',
        'Baja con control hasta sentir estiramiento.',
      ];
    case 'cardio':
      return [
        'Empieza suave para dominar el ritmo.',
        'Mantén aterrizajes silenciosos y tronco estable.',
        'Reduce velocidad antes de perder técnica.',
      ];
    case 'carry':
      return [
        'Toma la carga con hombros abajo y abdomen firme.',
        'Camina con pasos cortos y postura alta.',
        'Evita inclinarte hacia un lado si la carga es unilateral.',
      ];
    case 'mobility':
      return [
        'Muévete lento hacia un rango cómodo.',
        'Respira y mantén control activo, no rebotes.',
        'Aumenta el rango solo si la articulación se siente estable.',
      ];
    case 'band_pull':
      return [
        'Sujeta la banda con brazos al frente.',
        'Separa las manos llevando escápulas atrás y abajo.',
        'Regresa lento sin encoger hombros.',
      ];
  }
  return const ['Ejecuta el movimiento con control y rango cómodo.'];
}

List<String> _cues(String pattern) {
  switch (pattern) {
    case 'pushup':
      return const ['Línea larga', 'Codos controlados', 'Empuja el suelo'];
    case 'squat':
      return const ['Rodillas siguen dedos', 'Pecho alto', 'Talones firmes'];
    case 'lunge':
      return const ['Paso estable', 'Cadera cuadrada', 'Rodilla controlada'];
    case 'hinge':
      return const ['Cadera atrás', 'Espalda neutra', 'Peso cercano'];
    case 'row':
      return const ['Codos a la cadera', 'Cuello largo', 'Pausa atrás'];
    case 'pullup':
      return const ['Hombros activos', 'Pecho a la barra', 'Bajada lenta'];
    case 'overhead_press':
      return const ['Costillas abajo', 'Glúteos firmes', 'Bloqueo estable'];
    case 'curl':
      return const ['No balancees', 'Codos fijos', 'Bajada lenta'];
    case 'core':
      return const ['Respira', 'Pelvis neutra', 'Cuello relajado'];
    case 'plank':
      return const ['Glúteos activos', 'Costillas abajo', 'No hundas cadera'];
    case 'bridge':
      return const ['Empuja talones', 'Aprieta glúteos', 'Rodillas alineadas'];
    case 'superman':
      return const ['Cuello largo', 'Pausa arriba', 'Sin dolor lumbar'];
    case 'calf_raise':
      return const ['Sube completo', 'Baja lento', 'No rebotes'];
    case 'cardio':
      return const ['Aterriza suave', 'Respira', 'Ritmo sostenible'];
    case 'carry':
      return const ['Postura alta', 'Pasos cortos', 'Agarre firme'];
    case 'mobility':
      return const ['Rango cómodo', 'Respira', 'Control activo'];
    case 'band_pull':
      return const ['Hombros abajo', 'Escápulas atrás', 'Sin arquear'];
  }
  return const ['Técnica primero'];
}

Exercise _exercise({
  required String id,
  required String name,
  required String description,
  required MovementType type,
  required List<BodyZone> zones,
  required List<String> muscles,
  required List<Equipment> equipment,
  required String pattern,
  FitnessLevel level = FitnessLevel.principiante,
  bool timed = false,
  int intensity = 3,
  List<String>? steps,
  List<String>? cues,
}) {
  return Exercise(
    id: id,
    name: name,
    description: description,
    type: type,
    bodyZones: zones,
    muscles: muscles,
    equipment: equipment,
    minLevel: level,
    pattern: pattern,
    imageAsset: _image(pattern),
    localVideoAsset: _video(pattern),
    onlineVideoUrl: _onlineVideos[pattern] ?? '',
    steps: steps ?? _steps(pattern),
    cues: cues ?? _cues(pattern),
    isTimed: timed,
    intensity: intensity,
  );
}

final exerciseCatalog = <Exercise>[
  _exercise(
    id: 'pushup_standard',
    name: 'Flexión tradicional',
    description: 'Empuje horizontal base para pecho, hombros y tríceps.',
    type: MovementType.empuje,
    zones: [
      BodyZone.pecho,
      BodyZone.hombros,
      BodyZone.brazos,
      BodyZone.abdomen,
    ],
    muscles: ['Pectoral', 'deltoide anterior', 'tríceps', 'serrato', 'core'],
    equipment: [Equipment.pesoCorporal, Equipment.colchoneta],
    pattern: 'pushup',
  ),
  _exercise(
    id: 'pushup_incline',
    name: 'Flexión inclinada',
    description: 'Variante accesible usando mesa, barra baja o banco.',
    type: MovementType.empuje,
    zones: [BodyZone.pecho, BodyZone.hombros, BodyZone.brazos],
    muscles: ['Pectoral', 'tríceps', 'deltoide anterior'],
    equipment: [Equipment.pesoCorporal, Equipment.sillaBanco],
    pattern: 'pushup',
  ),
  _exercise(
    id: 'pushup_decline',
    name: 'Flexión declinada',
    description:
        'Eleva los pies para aumentar carga en pecho superior y hombro.',
    type: MovementType.empuje,
    zones: [
      BodyZone.pecho,
      BodyZone.hombros,
      BodyZone.brazos,
      BodyZone.abdomen,
    ],
    muscles: ['Pectoral superior', 'deltoide anterior', 'tríceps', 'core'],
    equipment: [Equipment.pesoCorporal, Equipment.sillaBanco],
    pattern: 'pushup',
    level: FitnessLevel.intermedio,
    intensity: 4,
  ),
  _exercise(
    id: 'diamond_pushup',
    name: 'Flexión diamante',
    description: 'Énfasis en tríceps con manos más cerradas.',
    type: MovementType.empuje,
    zones: [BodyZone.pecho, BodyZone.brazos, BodyZone.abdomen],
    muscles: ['Tríceps', 'pectoral interno', 'core'],
    equipment: [Equipment.pesoCorporal, Equipment.colchoneta],
    pattern: 'pushup',
    level: FitnessLevel.intermedio,
    intensity: 4,
  ),
  _exercise(
    id: 'pike_pushup',
    name: 'Flexión pike',
    description: 'Empuje vertical con peso corporal para hombros.',
    type: MovementType.empuje,
    zones: [BodyZone.hombros, BodyZone.brazos, BodyZone.abdomen],
    muscles: ['Deltoide', 'tríceps', 'trapecio superior', 'core'],
    equipment: [Equipment.pesoCorporal, Equipment.colchoneta],
    pattern: 'overhead_press',
    level: FitnessLevel.intermedio,
    intensity: 4,
  ),
  _exercise(
    id: 'archer_pushup',
    name: 'Flexión arquero',
    description: 'Variante unilateral progresiva para empuje avanzado.',
    type: MovementType.empuje,
    zones: [
      BodyZone.pecho,
      BodyZone.hombros,
      BodyZone.brazos,
      BodyZone.abdomen,
    ],
    muscles: ['Pectoral', 'tríceps', 'deltoide', 'core anti-rotación'],
    equipment: [Equipment.pesoCorporal],
    pattern: 'pushup',
    level: FitnessLevel.avanzado,
    intensity: 5,
  ),
  _exercise(
    id: 'chair_dip',
    name: 'Fondos en silla',
    description: 'Trabajo de tríceps y pecho usando una silla estable.',
    type: MovementType.empuje,
    zones: [BodyZone.brazos, BodyZone.pecho, BodyZone.hombros],
    muscles: ['Tríceps', 'pectoral inferior', 'deltoide anterior'],
    equipment: [Equipment.sillaBanco, Equipment.pesoCorporal],
    pattern: 'pushup',
    intensity: 3,
  ),
  _exercise(
    id: 'floor_press',
    name: 'Press de pecho en suelo',
    description:
        'Press seguro para casa con mancuernas, kettlebells o mochila.',
    type: MovementType.empuje,
    zones: [BodyZone.pecho, BodyZone.brazos, BodyZone.hombros],
    muscles: ['Pectoral', 'tríceps', 'deltoide anterior'],
    equipment: [Equipment.mancuernas, Equipment.kettlebell, Equipment.mochila],
    pattern: 'pushup',
  ),
  _exercise(
    id: 'band_chest_press',
    name: 'Press de pecho con banda',
    description: 'Empuje horizontal con banda anclada detrás del cuerpo.',
    type: MovementType.empuje,
    zones: [BodyZone.pecho, BodyZone.hombros, BodyZone.brazos],
    muscles: ['Pectoral', 'tríceps', 'serrato'],
    equipment: [Equipment.bandas],
    pattern: 'pushup',
  ),
  _exercise(
    id: 'db_pullover',
    name: 'Pullover con mancuerna',
    description:
        'Cruce entre pecho y dorsal con énfasis en expansión torácica.',
    type: MovementType.empuje,
    zones: [BodyZone.pecho, BodyZone.espalda, BodyZone.hombros],
    muscles: ['Dorsal ancho', 'pectoral', 'serrato', 'tríceps largo'],
    equipment: [Equipment.mancuernas, Equipment.kettlebell],
    pattern: 'pushup',
    level: FitnessLevel.intermedio,
  ),
  _exercise(
    id: 'air_squat',
    name: 'Sentadilla al aire',
    description: 'Patrón base de pierna para fuerza general y movilidad.',
    type: MovementType.sentadilla,
    zones: [BodyZone.piernas, BodyZone.gluteos, BodyZone.cadera],
    muscles: ['Cuádriceps', 'glúteo mayor', 'aductores', 'core'],
    equipment: [Equipment.pesoCorporal],
    pattern: 'squat',
  ),
  _exercise(
    id: 'pause_squat',
    name: 'Sentadilla con pausa',
    description: 'Pausa abajo para control y fuerza en rango profundo.',
    type: MovementType.sentadilla,
    zones: [BodyZone.piernas, BodyZone.gluteos, BodyZone.cadera],
    muscles: ['Cuádriceps', 'glúteo', 'aductores'],
    equipment: [Equipment.pesoCorporal, Equipment.mochila],
    pattern: 'squat',
    level: FitnessLevel.intermedio,
  ),
  _exercise(
    id: 'sumo_squat',
    name: 'Sentadilla sumo',
    description: 'Postura amplia para aductores y glúteo.',
    type: MovementType.sentadilla,
    zones: [BodyZone.piernas, BodyZone.gluteos, BodyZone.cadera],
    muscles: ['Aductores', 'glúteo', 'cuádriceps'],
    equipment: [
      Equipment.pesoCorporal,
      Equipment.mancuernas,
      Equipment.kettlebell,
    ],
    pattern: 'squat',
  ),
  _exercise(
    id: 'goblet_squat',
    name: 'Sentadilla goblet',
    description:
        'Sentadilla cargada al frente con mancuerna, kettlebell o mochila.',
    type: MovementType.sentadilla,
    zones: [BodyZone.piernas, BodyZone.gluteos, BodyZone.abdomen],
    muscles: ['Cuádriceps', 'glúteo', 'core anterior', 'espalda alta'],
    equipment: [Equipment.mancuernas, Equipment.kettlebell, Equipment.mochila],
    pattern: 'squat',
  ),
  _exercise(
    id: 'pistol_assisted',
    name: 'Pistol squat asistida',
    description: 'Sentadilla unilateral usando soporte para equilibrio.',
    type: MovementType.sentadilla,
    zones: [BodyZone.piernas, BodyZone.gluteos, BodyZone.cadera],
    muscles: ['Cuádriceps', 'glúteo medio', 'core'],
    equipment: [Equipment.pesoCorporal, Equipment.sillaBanco],
    pattern: 'squat',
    level: FitnessLevel.avanzado,
    intensity: 5,
  ),
  _exercise(
    id: 'wall_sit',
    name: 'Sentadilla isométrica en pared',
    description: 'Trabajo sostenido de piernas con baja complejidad técnica.',
    type: MovementType.sentadilla,
    zones: [BodyZone.piernas, BodyZone.gluteos],
    muscles: ['Cuádriceps', 'glúteo', 'gemelos'],
    equipment: [Equipment.pesoCorporal],
    pattern: 'squat',
    timed: true,
  ),
  _exercise(
    id: 'cossack_squat',
    name: 'Sentadilla cossack',
    description:
        'Sentadilla lateral profunda para aductores y movilidad de cadera.',
    type: MovementType.sentadilla,
    zones: [BodyZone.piernas, BodyZone.cadera, BodyZone.gluteos],
    muscles: ['Aductores', 'glúteo medio', 'cuádriceps'],
    equipment: [Equipment.pesoCorporal],
    pattern: 'squat',
    level: FitnessLevel.intermedio,
  ),
  _exercise(
    id: 'step_up',
    name: 'Step-up en silla o banco',
    description: 'Subida unilateral con foco en glúteo y cuádriceps.',
    type: MovementType.zancada,
    zones: [BodyZone.piernas, BodyZone.gluteos, BodyZone.cadera],
    muscles: ['Glúteo mayor', 'cuádriceps', 'isquios', 'core'],
    equipment: [Equipment.sillaBanco, Equipment.mancuernas, Equipment.mochila],
    pattern: 'lunge',
  ),
  _exercise(
    id: 'reverse_lunge',
    name: 'Zancada atrás',
    description: 'Variante amable con rodilla y muy útil para casa.',
    type: MovementType.zancada,
    zones: [BodyZone.piernas, BodyZone.gluteos, BodyZone.cadera],
    muscles: ['Glúteo', 'cuádriceps', 'isquios'],
    equipment: [
      Equipment.pesoCorporal,
      Equipment.mancuernas,
      Equipment.mochila,
    ],
    pattern: 'lunge',
  ),
  _exercise(
    id: 'walking_lunge',
    name: 'Zancada caminando',
    description: 'Secuencia dinámica para pierna unilateral y condición.',
    type: MovementType.zancada,
    zones: [BodyZone.piernas, BodyZone.gluteos, BodyZone.cadera],
    muscles: ['Cuádriceps', 'glúteo', 'aductores'],
    equipment: [
      Equipment.pesoCorporal,
      Equipment.mancuernas,
      Equipment.kettlebell,
    ],
    pattern: 'lunge',
    level: FitnessLevel.intermedio,
  ),
  _exercise(
    id: 'lateral_lunge',
    name: 'Zancada lateral',
    description: 'Fortalece aductores y glúteo medio en plano lateral.',
    type: MovementType.zancada,
    zones: [BodyZone.piernas, BodyZone.gluteos, BodyZone.cadera],
    muscles: ['Aductores', 'glúteo medio', 'cuádriceps'],
    equipment: [Equipment.pesoCorporal, Equipment.mancuernas],
    pattern: 'lunge',
  ),
  _exercise(
    id: 'bulgarian_split_squat',
    name: 'Split squat búlgaro',
    description: 'Pierna unilateral intensa con pie trasero elevado.',
    type: MovementType.zancada,
    zones: [BodyZone.piernas, BodyZone.gluteos, BodyZone.cadera],
    muscles: ['Cuádriceps', 'glúteo mayor', 'glúteo medio'],
    equipment: [Equipment.sillaBanco, Equipment.mancuernas, Equipment.mochila],
    pattern: 'lunge',
    level: FitnessLevel.intermedio,
    intensity: 4,
  ),
  _exercise(
    id: 'curtsy_lunge',
    name: 'Zancada curtsy',
    description: 'Cruce posterior para glúteo medio y estabilidad lateral.',
    type: MovementType.zancada,
    zones: [BodyZone.gluteos, BodyZone.piernas, BodyZone.cadera],
    muscles: ['Glúteo medio', 'cuádriceps', 'aductores'],
    equipment: [Equipment.pesoCorporal, Equipment.mancuernas],
    pattern: 'lunge',
  ),
  _exercise(
    id: 'glute_bridge',
    name: 'Puente de glúteo',
    description: 'Activación y fuerza de glúteos desde el suelo.',
    type: MovementType.bisagra,
    zones: [BodyZone.gluteos, BodyZone.cadera, BodyZone.piernas],
    muscles: ['Glúteo mayor', 'isquios', 'core'],
    equipment: [Equipment.pesoCorporal, Equipment.colchoneta],
    pattern: 'bridge',
  ),
  _exercise(
    id: 'single_leg_bridge',
    name: 'Puente de glúteo a una pierna',
    description: 'Progresión unilateral para glúteo y estabilidad pélvica.',
    type: MovementType.bisagra,
    zones: [BodyZone.gluteos, BodyZone.cadera, BodyZone.piernas],
    muscles: ['Glúteo mayor', 'isquios', 'glúteo medio'],
    equipment: [Equipment.pesoCorporal, Equipment.colchoneta],
    pattern: 'bridge',
    level: FitnessLevel.intermedio,
  ),
  _exercise(
    id: 'hip_thrust_chair',
    name: 'Hip thrust en silla',
    description: 'Extensión de cadera con espalda apoyada en silla o banco.',
    type: MovementType.bisagra,
    zones: [BodyZone.gluteos, BodyZone.cadera, BodyZone.piernas],
    muscles: ['Glúteo mayor', 'isquios', 'aductores'],
    equipment: [Equipment.sillaBanco, Equipment.mochila, Equipment.mancuernas],
    pattern: 'bridge',
  ),
  _exercise(
    id: 'romanian_deadlift',
    name: 'Peso muerto rumano',
    description: 'Bisagra cargada para cadena posterior.',
    type: MovementType.bisagra,
    zones: [BodyZone.gluteos, BodyZone.piernas, BodyZone.espalda],
    muscles: ['Isquios', 'glúteo', 'erectores espinales', 'dorsal'],
    equipment: [Equipment.mancuernas, Equipment.kettlebell, Equipment.mochila],
    pattern: 'hinge',
  ),
  _exercise(
    id: 'single_leg_deadlift',
    name: 'Peso muerto a una pierna',
    description: 'Bisagra unilateral para equilibrio y glúteo medio.',
    type: MovementType.bisagra,
    zones: [BodyZone.gluteos, BodyZone.piernas, BodyZone.cadera],
    muscles: ['Isquios', 'glúteo mayor', 'glúteo medio', 'core'],
    equipment: [
      Equipment.pesoCorporal,
      Equipment.mancuernas,
      Equipment.kettlebell,
    ],
    pattern: 'hinge',
    level: FitnessLevel.intermedio,
  ),
  _exercise(
    id: 'good_morning_backpack',
    name: 'Buenos días con mochila',
    description: 'Bisagra ligera usando mochila cargada.',
    type: MovementType.bisagra,
    zones: [BodyZone.gluteos, BodyZone.piernas, BodyZone.espalda],
    muscles: ['Isquios', 'glúteo', 'erectores'],
    equipment: [Equipment.mochila, Equipment.pesoCorporal],
    pattern: 'hinge',
  ),
  _exercise(
    id: 'band_good_morning',
    name: 'Buenos días con banda',
    description: 'Bisagra con resistencia elástica desde pies a hombros.',
    type: MovementType.bisagra,
    zones: [BodyZone.gluteos, BodyZone.piernas, BodyZone.espalda],
    muscles: ['Isquios', 'glúteo', 'espalda baja'],
    equipment: [Equipment.bandas],
    pattern: 'hinge',
  ),
  _exercise(
    id: 'kb_swing',
    name: 'Swing con kettlebell',
    description: 'Bisagra explosiva para potencia de cadera y condición.',
    type: MovementType.bisagra,
    zones: [BodyZone.cuerpoCompleto, BodyZone.gluteos, BodyZone.piernas],
    muscles: ['Glúteo', 'isquios', 'dorsal', 'core', 'antebrazo'],
    equipment: [Equipment.kettlebell],
    pattern: 'hinge',
    level: FitnessLevel.intermedio,
    intensity: 4,
  ),
  _exercise(
    id: 'towel_hamstring_curl',
    name: 'Curl femoral con toalla',
    description: 'Deslizamiento de talones para isquios en piso liso.',
    type: MovementType.bisagra,
    zones: [BodyZone.piernas, BodyZone.gluteos],
    muscles: ['Isquios', 'glúteo', 'pantorrilla'],
    equipment: [Equipment.toalla, Equipment.sliders],
    pattern: 'bridge',
    level: FitnessLevel.intermedio,
  ),
  _exercise(
    id: 'one_arm_row',
    name: 'Remo a una mano',
    description: 'Tracción horizontal con soporte en silla o rodilla.',
    type: MovementType.traccion,
    zones: [BodyZone.espalda, BodyZone.brazos, BodyZone.hombros],
    muscles: ['Dorsal ancho', 'romboides', 'bíceps', 'deltoide posterior'],
    equipment: [Equipment.mancuernas, Equipment.kettlebell, Equipment.mochila],
    pattern: 'row',
  ),
  _exercise(
    id: 'band_row',
    name: 'Remo con banda',
    description: 'Remo sentado o de pie con banda elástica.',
    type: MovementType.traccion,
    zones: [BodyZone.espalda, BodyZone.brazos],
    muscles: ['Dorsal', 'romboides', 'bíceps'],
    equipment: [Equipment.bandas],
    pattern: 'row',
  ),
  _exercise(
    id: 'towel_door_row',
    name: 'Remo con toalla en puerta',
    description: 'Tracción corporal con toalla bien asegurada.',
    type: MovementType.traccion,
    zones: [BodyZone.espalda, BodyZone.brazos, BodyZone.abdomen],
    muscles: ['Dorsal', 'bíceps', 'romboides', 'core'],
    equipment: [Equipment.toalla, Equipment.pesoCorporal],
    pattern: 'row',
    level: FitnessLevel.intermedio,
  ),
  _exercise(
    id: 'renegade_row',
    name: 'Remo renegado',
    description: 'Remo en posición de plancha con alta demanda de core.',
    type: MovementType.traccion,
    zones: [BodyZone.espalda, BodyZone.abdomen, BodyZone.brazos],
    muscles: ['Dorsal', 'oblicuos', 'bíceps', 'serrato'],
    equipment: [Equipment.mancuernas, Equipment.kettlebell],
    pattern: 'row',
    level: FitnessLevel.avanzado,
    intensity: 5,
  ),
  _exercise(
    id: 'band_lat_pulldown',
    name: 'Jalón con banda',
    description: 'Imita un jalón vertical anclando la banda alto.',
    type: MovementType.traccion,
    zones: [BodyZone.espalda, BodyZone.brazos],
    muscles: ['Dorsal ancho', 'bíceps', 'redondo mayor'],
    equipment: [Equipment.bandas],
    pattern: 'row',
  ),
  _exercise(
    id: 'face_pull',
    name: 'Face pull con banda',
    description: 'Tracción alta para hombro posterior y salud escapular.',
    type: MovementType.traccion,
    zones: [BodyZone.hombros, BodyZone.espalda],
    muscles: ['Deltoide posterior', 'trapecio medio', 'rotadores externos'],
    equipment: [Equipment.bandas],
    pattern: 'band_pull',
  ),
  _exercise(
    id: 'band_pull_apart',
    name: 'Pull-apart con banda',
    description: 'Separación horizontal para postura y hombro posterior.',
    type: MovementType.traccion,
    zones: [BodyZone.hombros, BodyZone.espalda],
    muscles: ['Deltoide posterior', 'romboides', 'trapecio medio'],
    equipment: [Equipment.bandas],
    pattern: 'band_pull',
  ),
  _exercise(
    id: 'pullup_pronated',
    name: 'Dominada pronada',
    description: 'Tracción vertical intensa con agarre por encima.',
    type: MovementType.traccion,
    zones: [BodyZone.espalda, BodyZone.brazos, BodyZone.abdomen],
    muscles: ['Dorsal', 'bíceps', 'braquial', 'core'],
    equipment: [Equipment.barraDominadas],
    pattern: 'pullup',
    level: FitnessLevel.intermedio,
    intensity: 5,
  ),
  _exercise(
    id: 'chinup',
    name: 'Dominada supina',
    description: 'Tracción vertical con más participación del bíceps.',
    type: MovementType.traccion,
    zones: [BodyZone.espalda, BodyZone.brazos],
    muscles: ['Dorsal', 'bíceps', 'braquial'],
    equipment: [Equipment.barraDominadas],
    pattern: 'pullup',
    level: FitnessLevel.intermedio,
    intensity: 5,
  ),
  _exercise(
    id: 'negative_chinup',
    name: 'Dominada negativa',
    description: 'Bajada controlada para construir fuerza de dominada.',
    type: MovementType.traccion,
    zones: [BodyZone.espalda, BodyZone.brazos, BodyZone.abdomen],
    muscles: ['Dorsal', 'bíceps', 'antebrazo', 'core'],
    equipment: [Equipment.barraDominadas, Equipment.sillaBanco],
    pattern: 'pullup',
    level: FitnessLevel.intermedio,
  ),
  _exercise(
    id: 'scapular_pullup',
    name: 'Retracción escapular colgado',
    description: 'Control de escápulas para preparar dominadas.',
    type: MovementType.traccion,
    zones: [BodyZone.espalda, BodyZone.hombros],
    muscles: ['Trapecio inferior', 'dorsal', 'serrato'],
    equipment: [Equipment.barraDominadas],
    pattern: 'pullup',
  ),
  _exercise(
    id: 'db_overhead_press',
    name: 'Press militar con mancuernas',
    description: 'Empuje vertical de hombro con cargas independientes.',
    type: MovementType.empuje,
    zones: [BodyZone.hombros, BodyZone.brazos, BodyZone.abdomen],
    muscles: ['Deltoide', 'tríceps', 'trapecio', 'core'],
    equipment: [Equipment.mancuernas, Equipment.kettlebell, Equipment.mochila],
    pattern: 'overhead_press',
  ),
  _exercise(
    id: 'lateral_raise',
    name: 'Elevaciones laterales',
    description: 'Aislamiento del deltoide medio para hombros.',
    type: MovementType.aislamiento,
    zones: [BodyZone.hombros],
    muscles: ['Deltoide medio', 'trapecio superior'],
    equipment: [Equipment.mancuernas, Equipment.bandas],
    pattern: 'overhead_press',
  ),
  _exercise(
    id: 'front_raise',
    name: 'Elevaciones frontales',
    description: 'Aislamiento del hombro anterior con carga ligera.',
    type: MovementType.aislamiento,
    zones: [BodyZone.hombros],
    muscles: ['Deltoide anterior', 'serrato'],
    equipment: [Equipment.mancuernas, Equipment.bandas, Equipment.mochila],
    pattern: 'overhead_press',
  ),
  _exercise(
    id: 'arnold_press',
    name: 'Press Arnold',
    description: 'Press con rotación para deltoides y control escapular.',
    type: MovementType.empuje,
    zones: [BodyZone.hombros, BodyZone.brazos],
    muscles: ['Deltoide anterior', 'deltoide medio', 'tríceps'],
    equipment: [Equipment.mancuernas],
    pattern: 'overhead_press',
    level: FitnessLevel.intermedio,
  ),
  _exercise(
    id: 'thruster',
    name: 'Thruster',
    description: 'Sentadilla más press para fuerza global y condición.',
    type: MovementType.cardio,
    zones: [BodyZone.cuerpoCompleto, BodyZone.piernas, BodyZone.hombros],
    muscles: ['Cuádriceps', 'glúteo', 'deltoide', 'tríceps', 'core'],
    equipment: [Equipment.mancuernas, Equipment.kettlebell, Equipment.mochila],
    pattern: 'cardio',
    level: FitnessLevel.intermedio,
    intensity: 5,
  ),
  _exercise(
    id: 'biceps_curl',
    name: 'Curl de bíceps',
    description: 'Aislamiento básico para flexores del codo.',
    type: MovementType.aislamiento,
    zones: [BodyZone.brazos],
    muscles: ['Bíceps braquial', 'braquial', 'braquiorradial'],
    equipment: [Equipment.mancuernas, Equipment.bandas, Equipment.mochila],
    pattern: 'curl',
  ),
  _exercise(
    id: 'hammer_curl',
    name: 'Curl martillo',
    description: 'Agarre neutro para braquial y antebrazo.',
    type: MovementType.aislamiento,
    zones: [BodyZone.brazos],
    muscles: ['Braquial', 'braquiorradial', 'bíceps'],
    equipment: [Equipment.mancuernas, Equipment.bandas],
    pattern: 'curl',
  ),
  _exercise(
    id: 'band_curl',
    name: 'Curl con banda',
    description: 'Curl con tensión creciente usando banda bajo los pies.',
    type: MovementType.aislamiento,
    zones: [BodyZone.brazos],
    muscles: ['Bíceps', 'braquial', 'antebrazo'],
    equipment: [Equipment.bandas],
    pattern: 'curl',
  ),
  _exercise(
    id: 'overhead_triceps_extension',
    name: 'Extensión de tríceps sobre cabeza',
    description: 'Aislamiento del tríceps largo con carga arriba.',
    type: MovementType.aislamiento,
    zones: [BodyZone.brazos, BodyZone.hombros],
    muscles: ['Tríceps largo', 'tríceps lateral'],
    equipment: [Equipment.mancuernas, Equipment.kettlebell, Equipment.bandas],
    pattern: 'overhead_press',
  ),
  _exercise(
    id: 'triceps_kickback',
    name: 'Patada de tríceps',
    description: 'Extensión de codo con torso inclinado.',
    type: MovementType.aislamiento,
    zones: [BodyZone.brazos],
    muscles: ['Tríceps', 'deltoide posterior'],
    equipment: [Equipment.mancuernas, Equipment.bandas],
    pattern: 'hinge',
  ),
  _exercise(
    id: 'band_triceps_pressdown',
    name: 'Pressdown de tríceps con banda',
    description: 'Extensión de codo con banda anclada alto.',
    type: MovementType.aislamiento,
    zones: [BodyZone.brazos],
    muscles: ['Tríceps lateral', 'tríceps medial'],
    equipment: [Equipment.bandas],
    pattern: 'band_pull',
  ),
  _exercise(
    id: 'plank_front',
    name: 'Plancha frontal',
    description: 'Ejercicio anti-extensión para core y postura.',
    type: MovementType.core,
    zones: [BodyZone.abdomen, BodyZone.hombros],
    muscles: ['Recto abdominal', 'transverso', 'serrato', 'glúteos'],
    equipment: [Equipment.pesoCorporal, Equipment.colchoneta],
    pattern: 'plank',
    timed: true,
  ),
  _exercise(
    id: 'side_plank',
    name: 'Plancha lateral',
    description: 'Trabajo anti-flexión lateral para oblicuos.',
    type: MovementType.core,
    zones: [BodyZone.abdomen, BodyZone.hombros, BodyZone.cadera],
    muscles: ['Oblicuos', 'cuadrado lumbar', 'glúteo medio'],
    equipment: [Equipment.pesoCorporal, Equipment.colchoneta],
    pattern: 'plank',
    timed: true,
  ),
  _exercise(
    id: 'shoulder_tap_plank',
    name: 'Plancha con toque de hombros',
    description: 'Anti-rotación dinámica desde posición alta.',
    type: MovementType.core,
    zones: [BodyZone.abdomen, BodyZone.hombros],
    muscles: ['Oblicuos', 'serrato', 'deltoide', 'glúteos'],
    equipment: [Equipment.pesoCorporal],
    pattern: 'plank',
    level: FitnessLevel.intermedio,
  ),
  _exercise(
    id: 'dead_bug',
    name: 'Dead bug',
    description: 'Control lumbar con movimiento alterno de brazos y piernas.',
    type: MovementType.core,
    zones: [BodyZone.abdomen, BodyZone.cadera],
    muscles: ['Transverso abdominal', 'recto abdominal', 'flexores de cadera'],
    equipment: [Equipment.pesoCorporal, Equipment.colchoneta],
    pattern: 'core',
  ),
  _exercise(
    id: 'hollow_hold',
    name: 'Hollow hold',
    description: 'Isométrico avanzado para línea corporal y abdomen.',
    type: MovementType.core,
    zones: [BodyZone.abdomen],
    muscles: ['Recto abdominal', 'transverso', 'flexores de cadera'],
    equipment: [Equipment.pesoCorporal, Equipment.colchoneta],
    pattern: 'core',
    timed: true,
    level: FitnessLevel.intermedio,
  ),
  _exercise(
    id: 'situp',
    name: 'Sit-up',
    description: 'Flexión de tronco clásica con control de cuello.',
    type: MovementType.core,
    zones: [BodyZone.abdomen, BodyZone.cadera],
    muscles: ['Recto abdominal', 'flexores de cadera'],
    equipment: [Equipment.pesoCorporal, Equipment.colchoneta],
    pattern: 'core',
  ),
  _exercise(
    id: 'bicycle_crunch',
    name: 'Crunch bicicleta',
    description: 'Rotación alterna para oblicuos y abdomen.',
    type: MovementType.core,
    zones: [BodyZone.abdomen],
    muscles: ['Oblicuos', 'recto abdominal', 'flexores de cadera'],
    equipment: [Equipment.pesoCorporal, Equipment.colchoneta],
    pattern: 'core',
  ),
  _exercise(
    id: 'leg_raise',
    name: 'Elevación de piernas',
    description: 'Control de pelvis con palanca larga.',
    type: MovementType.core,
    zones: [BodyZone.abdomen, BodyZone.cadera],
    muscles: ['Recto abdominal inferior', 'flexores de cadera'],
    equipment: [
      Equipment.pesoCorporal,
      Equipment.colchoneta,
      Equipment.barraDominadas,
    ],
    pattern: 'core',
    level: FitnessLevel.intermedio,
  ),
  _exercise(
    id: 'hanging_knee_raise',
    name: 'Elevación de rodillas colgado',
    description: 'Core colgado con énfasis en abdomen y agarre.',
    type: MovementType.core,
    zones: [BodyZone.abdomen, BodyZone.brazos, BodyZone.espalda],
    muscles: ['Recto abdominal', 'flexores de cadera', 'antebrazo'],
    equipment: [Equipment.barraDominadas],
    pattern: 'pullup',
    level: FitnessLevel.intermedio,
  ),
  _exercise(
    id: 'russian_twist',
    name: 'Russian twist',
    description: 'Rotación de tronco con o sin carga.',
    type: MovementType.core,
    zones: [BodyZone.abdomen],
    muscles: ['Oblicuos', 'recto abdominal', 'flexores de cadera'],
    equipment: [
      Equipment.pesoCorporal,
      Equipment.mancuernas,
      Equipment.mochila,
    ],
    pattern: 'core',
  ),
  _exercise(
    id: 'pallof_press',
    name: 'Pallof press con banda',
    description: 'Anti-rotación de pie con banda lateral.',
    type: MovementType.core,
    zones: [BodyZone.abdomen, BodyZone.cadera],
    muscles: ['Oblicuos', 'transverso', 'glúteo medio'],
    equipment: [Equipment.bandas],
    pattern: 'band_pull',
  ),
  _exercise(
    id: 'towel_rollout',
    name: 'Rollout con toalla',
    description: 'Extensión controlada en piso liso para abdomen.',
    type: MovementType.core,
    zones: [BodyZone.abdomen, BodyZone.hombros],
    muscles: ['Recto abdominal', 'dorsal', 'serrato'],
    equipment: [Equipment.toalla, Equipment.sliders],
    pattern: 'plank',
    level: FitnessLevel.avanzado,
    intensity: 5,
  ),
  _exercise(
    id: 'superman',
    name: 'Superman',
    description: 'Extensión posterior suave para espalda y glúteos.',
    type: MovementType.core,
    zones: [BodyZone.espalda, BodyZone.gluteos],
    muscles: ['Erectores espinales', 'glúteo', 'deltoide posterior'],
    equipment: [Equipment.pesoCorporal, Equipment.colchoneta],
    pattern: 'superman',
  ),
  _exercise(
    id: 'bird_dog',
    name: 'Bird dog',
    description: 'Estabilidad cruzada para espalda, glúteo y abdomen.',
    type: MovementType.core,
    zones: [BodyZone.abdomen, BodyZone.espalda, BodyZone.gluteos],
    muscles: ['Multífidos', 'glúteo', 'transverso abdominal'],
    equipment: [Equipment.pesoCorporal, Equipment.colchoneta],
    pattern: 'superman',
  ),
  _exercise(
    id: 'mountain_climber',
    name: 'Mountain climber',
    description: 'Core dinámico y cardio desde posición de plancha.',
    type: MovementType.cardio,
    zones: [BodyZone.cuerpoCompleto, BodyZone.abdomen, BodyZone.hombros],
    muscles: ['Core', 'flexores de cadera', 'hombros', 'cuádriceps'],
    equipment: [Equipment.pesoCorporal],
    pattern: 'cardio',
    timed: true,
  ),
  _exercise(
    id: 'burpee',
    name: 'Burpee',
    description: 'Movimiento total para condición y potencia.',
    type: MovementType.cardio,
    zones: [BodyZone.cuerpoCompleto],
    muscles: ['Pecho', 'piernas', 'core', 'hombros'],
    equipment: [Equipment.pesoCorporal],
    pattern: 'cardio',
    level: FitnessLevel.intermedio,
    intensity: 5,
  ),
  _exercise(
    id: 'jumping_jack',
    name: 'Jumping jacks',
    description:
        'Cardio básico de bajo material para calentamiento o circuito.',
    type: MovementType.cardio,
    zones: [BodyZone.cuerpoCompleto, BodyZone.piernas, BodyZone.hombros],
    muscles: ['Pantorrillas', 'deltoides', 'aductores'],
    equipment: [Equipment.pesoCorporal],
    pattern: 'cardio',
    timed: true,
  ),
  _exercise(
    id: 'high_knees',
    name: 'Rodillas altas',
    description: 'Cardio en sitio con énfasis en flexores de cadera.',
    type: MovementType.cardio,
    zones: [BodyZone.cuerpoCompleto, BodyZone.piernas, BodyZone.abdomen],
    muscles: ['Flexores de cadera', 'pantorrillas', 'core'],
    equipment: [Equipment.pesoCorporal],
    pattern: 'cardio',
    timed: true,
  ),
  _exercise(
    id: 'skaters',
    name: 'Saltos skater',
    description: 'Desplazamiento lateral para condición y glúteo medio.',
    type: MovementType.cardio,
    zones: [BodyZone.piernas, BodyZone.gluteos, BodyZone.cadera],
    muscles: ['Glúteo medio', 'cuádriceps', 'pantorrillas'],
    equipment: [Equipment.pesoCorporal],
    pattern: 'cardio',
    level: FitnessLevel.intermedio,
  ),
  _exercise(
    id: 'jump_rope',
    name: 'Saltar cuerda',
    description: 'Cardio coordinativo con mínima ocupación de espacio.',
    type: MovementType.cardio,
    zones: [BodyZone.cuerpoCompleto, BodyZone.pantorrillas],
    muscles: ['Pantorrillas', 'hombros', 'antebrazo', 'core'],
    equipment: [Equipment.cuerda],
    pattern: 'cardio',
    timed: true,
  ),
  _exercise(
    id: 'bear_crawl',
    name: 'Bear crawl',
    description: 'Desplazamiento cuadrúpedo para core, hombros y condición.',
    type: MovementType.cardio,
    zones: [BodyZone.cuerpoCompleto, BodyZone.abdomen, BodyZone.hombros],
    muscles: ['Core', 'serrato', 'cuádriceps', 'glúteo'],
    equipment: [Equipment.pesoCorporal],
    pattern: 'cardio',
    level: FitnessLevel.intermedio,
  ),
  _exercise(
    id: 'farmer_carry',
    name: 'Farmer carry',
    description: 'Caminar con dos cargas para agarre y estabilidad.',
    type: MovementType.carga,
    zones: [BodyZone.cuerpoCompleto, BodyZone.abdomen, BodyZone.brazos],
    muscles: ['Antebrazo', 'trapecio', 'core', 'glúteos'],
    equipment: [Equipment.mancuernas, Equipment.kettlebell, Equipment.mochila],
    pattern: 'carry',
    timed: true,
  ),
  _exercise(
    id: 'suitcase_carry',
    name: 'Suitcase carry',
    description: 'Caminar con carga unilateral para anti-flexión lateral.',
    type: MovementType.carga,
    zones: [BodyZone.abdomen, BodyZone.brazos, BodyZone.cuerpoCompleto],
    muscles: ['Oblicuos', 'antebrazo', 'trapecio', 'glúteo medio'],
    equipment: [Equipment.mancuernas, Equipment.kettlebell, Equipment.mochila],
    pattern: 'carry',
    timed: true,
  ),
  _exercise(
    id: 'front_rack_carry',
    name: 'Carga frontal',
    description: 'Caminar con carga al pecho para core anterior y postura.',
    type: MovementType.carga,
    zones: [BodyZone.cuerpoCompleto, BodyZone.abdomen, BodyZone.espalda],
    muscles: ['Core', 'espalda alta', 'bíceps', 'glúteos'],
    equipment: [Equipment.kettlebell, Equipment.mancuernas, Equipment.mochila],
    pattern: 'carry',
    timed: true,
    level: FitnessLevel.intermedio,
  ),
  _exercise(
    id: 'calf_raise',
    name: 'Elevación de talones',
    description: 'Trabajo directo de pantorrilla en escalón o piso.',
    type: MovementType.aislamiento,
    zones: [BodyZone.pantorrillas, BodyZone.piernas],
    muscles: ['Gastrocnemio', 'sóleo'],
    equipment: [
      Equipment.pesoCorporal,
      Equipment.mancuernas,
      Equipment.sillaBanco,
    ],
    pattern: 'calf_raise',
  ),
  _exercise(
    id: 'single_leg_calf_raise',
    name: 'Elevación de talón a una pierna',
    description: 'Pantorrilla unilateral con mayor carga relativa.',
    type: MovementType.aislamiento,
    zones: [BodyZone.pantorrillas, BodyZone.piernas],
    muscles: ['Gastrocnemio', 'sóleo', 'tibial posterior'],
    equipment: [Equipment.pesoCorporal, Equipment.mancuernas],
    pattern: 'calf_raise',
    level: FitnessLevel.intermedio,
  ),
  _exercise(
    id: 'tibialis_raise',
    name: 'Elevación tibial en pared',
    description: 'Fortalece el frente de la pierna para rodilla y tobillo.',
    type: MovementType.aislamiento,
    zones: [BodyZone.pantorrillas, BodyZone.piernas],
    muscles: ['Tibial anterior'],
    equipment: [Equipment.pesoCorporal],
    pattern: 'calf_raise',
  ),
  _exercise(
    id: 'band_monster_walk',
    name: 'Monster walk con banda',
    description: 'Caminata lateral para glúteo medio y control de rodilla.',
    type: MovementType.aislamiento,
    zones: [BodyZone.gluteos, BodyZone.cadera, BodyZone.piernas],
    muscles: ['Glúteo medio', 'glúteo menor', 'rotadores externos'],
    equipment: [Equipment.bandas],
    pattern: 'lunge',
  ),
  _exercise(
    id: 'band_kickback',
    name: 'Patada de glúteo con banda',
    description: 'Extensión de cadera con resistencia elástica.',
    type: MovementType.aislamiento,
    zones: [BodyZone.gluteos, BodyZone.cadera],
    muscles: ['Glúteo mayor', 'isquios'],
    equipment: [Equipment.bandas],
    pattern: 'bridge',
  ),
  _exercise(
    id: 'clamshell',
    name: 'Clamshell con banda',
    description: 'Rotación externa de cadera para glúteo medio.',
    type: MovementType.aislamiento,
    zones: [BodyZone.gluteos, BodyZone.cadera],
    muscles: ['Glúteo medio', 'rotadores externos'],
    equipment: [Equipment.bandas, Equipment.colchoneta],
    pattern: 'mobility',
  ),
  _exercise(
    id: 'cat_cow',
    name: 'Cat-cow',
    description: 'Movilidad de columna para calentamiento o descarga.',
    type: MovementType.movilidad,
    zones: [BodyZone.espalda, BodyZone.abdomen],
    muscles: ['Erectores', 'abdominales', 'control respiratorio'],
    equipment: [Equipment.pesoCorporal, Equipment.colchoneta],
    pattern: 'mobility',
    timed: true,
  ),
  _exercise(
    id: 'hip_flexor_stretch',
    name: 'Estiramiento de flexor de cadera',
    description: 'Movilidad de cadera útil tras estar sentado.',
    type: MovementType.movilidad,
    zones: [BodyZone.cadera, BodyZone.piernas],
    muscles: ['Psoas', 'recto femoral', 'glúteo'],
    equipment: [Equipment.pesoCorporal, Equipment.colchoneta],
    pattern: 'mobility',
    timed: true,
  ),
  _exercise(
    id: 'squat_to_stand',
    name: 'Squat to stand',
    description: 'Movilidad dinámica para tobillo, cadera y espalda alta.',
    type: MovementType.movilidad,
    zones: [BodyZone.cadera, BodyZone.piernas, BodyZone.espalda],
    muscles: ['Aductores', 'isquios', 'espalda alta'],
    equipment: [Equipment.pesoCorporal],
    pattern: 'mobility',
  ),
  _exercise(
    id: 'inchworm',
    name: 'Inchworm',
    description: 'Movilidad activa de isquios con plancha caminada.',
    type: MovementType.movilidad,
    zones: [BodyZone.cuerpoCompleto, BodyZone.abdomen, BodyZone.piernas],
    muscles: ['Isquios', 'core', 'hombros'],
    equipment: [Equipment.pesoCorporal],
    pattern: 'mobility',
  ),
  _exercise(
    id: 'thoracic_rotation',
    name: 'Rotación torácica en cuadrupedia',
    description: 'Movilidad de espalda alta para press, remo y postura.',
    type: MovementType.movilidad,
    zones: [BodyZone.espalda, BodyZone.hombros],
    muscles: ['Columna torácica', 'romboides', 'oblicuos'],
    equipment: [Equipment.pesoCorporal, Equipment.colchoneta],
    pattern: 'mobility',
    timed: true,
  ),
  _exercise(
    id: 'wall_slide',
    name: 'Wall slide escapular',
    description: 'Control de hombro y escápula contra pared.',
    type: MovementType.movilidad,
    zones: [BodyZone.hombros, BodyZone.espalda],
    muscles: ['Serrato anterior', 'trapecio inferior', 'rotadores externos'],
    equipment: [Equipment.pesoCorporal],
    pattern: 'band_pull',
  ),
  _exercise(
    id: 'band_dislocation',
    name: 'Dislocaciones con banda',
    description: 'Movilidad controlada de hombro con banda ligera.',
    type: MovementType.movilidad,
    zones: [BodyZone.hombros, BodyZone.espalda, BodyZone.pecho],
    muscles: ['Pectoral', 'dorsal', 'rotadores externos'],
    equipment: [Equipment.bandas],
    pattern: 'band_pull',
    level: FitnessLevel.intermedio,
  ),
  _exercise(
    id: 'cobra',
    name: 'Cobra',
    description: 'Extensión suave de columna y apertura anterior.',
    type: MovementType.movilidad,
    zones: [BodyZone.espalda, BodyZone.abdomen, BodyZone.cadera],
    muscles: ['Abdominales', 'flexores de cadera', 'erectores'],
    equipment: [Equipment.pesoCorporal, Equipment.colchoneta],
    pattern: 'mobility',
    timed: true,
  ),
];

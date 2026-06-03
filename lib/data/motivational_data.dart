import 'dart:math';

/// Contenido motivacional y psicológico para Trinity Gym.
///
/// Frases, tips de descanso, consejos de recuperación y
/// mensajes psicológicos para superar barreras mentales.
class MotivationalData {
  const MotivationalData._();

  static final _random = Random();

  // ── Frases motivacionales del día ──────────────────────────
  static const List<String> dailyQuotes = [
    'Tu cuerpo puede soportar casi todo. Es tu mente la que debes convencer.',
    'No entrenas porque sea fácil. Entrenas porque vale la pena.',
    'Cada repetición te acerca a la persona que quieres ser.',
    'La disciplina es el puente entre tus metas y tus logros.',
    'El dolor que sientes hoy será la fuerza que sentirás mañana.',
    'No necesitas motivación. Necesitas hábito.',
    'Tu único rival es la versión de ayer.',
    'Entrena como si nadie te viera. Los resultados hablarán.',
    'La consistencia supera al talento cuando el talento no es consistente.',
    'Hoy es el día que tu yo del futuro te agradecerá.',
    'No cuentes los días. Haz que los días cuenten.',
    'El gimnasio no te cambia el cuerpo. Te cambia la mentalidad.',
    'Empieza donde estás. Usa lo que tienes. Haz lo que puedas.',
    'Los límites existen solo en tu mente.',
    'Cada gota de sudor es un paso más hacia tu mejor versión.',
    'La fuerza no viene de lo que puedes hacer. Viene de superar lo que creías que no podías.',
    'Tu cuerpo es tu templo. Cuídalo con cada repetición.',
    'El progreso, no la perfección.',
    'Entrena duro. Recupera bien. Repite.',
    'No esperes a estar motivado. Actúa y la motivación llegará.',
    'Sé más fuerte que tu excusa más fuerte.',
    'El éxito es la suma de pequeños esfuerzos repetidos día tras día.',
    'Puedes sentir el cansancio y seguir. Eso se llama fortaleza.',
    'El hierro no miente. Solo te da lo que le pones.',
    'Hoy es un buen día para romper tu récord.',
    'Un paso. Una repetición. Una serie. Así se construyen campeones.',
    'No se trata de ser el mejor. Se trata de ser mejor que ayer.',
    'Tu futuro se forja en cada sesión de hoy.',
    'La excelencia no es un acto, es un hábito.',
    'Mientras otros duermen, tú construyes.',
  ];

  // ── Tips entre series ──────────────────────────────────────
  static const List<String> restTips = [
    '💨 Respira profundo: 4 seg inhala, 4 seg exhala. Recupera el ritmo cardíaco.',
    '🧠 Visualiza la siguiente serie perfecta antes de empezar.',
    '💧 Toma un sorbo de agua. La hidratación es rendimiento.',
    '🎯 Concéntrate en el músculo objetivo. Conexión mente-músculo.',
    '🔄 Sacude suavemente los brazos y piernas para eliminar tensión.',
    '👀 Revisa mentalmente tu técnica: ¿postura correcta? ¿rango completo?',
    '🌬️ Exhala completamente para activar el core en la próxima serie.',
    '💪 Recuerda: la última serie es donde ocurre el verdadero cambio.',
    '🧘 Relaja los hombros. La tensión innecesaria roba energía.',
    '📐 Piensa en el tempo: controla la bajada, pausa abajo, empuja con intención.',
    '🔥 Estás aquí por decisión propia. Cada segundo cuenta.',
    '⚡ Activa tus glúteos y abdomen antes de la siguiente serie.',
    '🎯 Menos peso con mejor técnica siempre supera a más peso con mala forma.',
    '💭 Si sientes que no puedes, haz una repetición más. Solo una.',
    '🌊 El músculo crece cuando lo desafías más allá de su zona cómoda.',
  ];

  // ── Tips de descanso por objetivo ──────────────────────────
  static const Map<String, String> restByGoal = {
    'fuerza':
        '⏱️ Descanso largo (2-3 min) para fuerza. Tu sistema nervioso necesita recuperarse completamente.',
    'hipertrofia':
        '⏱️ Descanso moderado (60-90 s). Suficiente para mantener volumen sin perder la congestión muscular.',
    'resistencia':
        '⏱️ Descanso corto (30-60 s). Mantén el corazón arriba para mejorar capacidad aeróbica.',
    'perdidaGrasa':
        '⏱️ Descanso mínimo (20-45 s). La densidad del entrenamiento es tu aliada.',
    'movilidad':
        '⏱️ Descanso libre (20-40 s). Respira y prepara el rango para la siguiente serie.',
  };

  // ── Consejos post-entrenamiento ────────────────────────────
  static const List<String> recoveryTips = [
    '🛁 Una ducha fría de 2-3 minutos puede reducir inflamación y mejorar recuperación.',
    '🥗 Come proteína en las siguientes 2 horas para alimentar la reparación muscular.',
    '💤 Dormir 7-9 horas es cuando tu cuerpo realmente crece y se repara.',
    '🧊 Si sientes dolor muscular, es normal (DOMS). Desaparecerá en 24-72 horas.',
    '🚶 Una caminata suave de 10-15 min post-entreno acelera la recuperación.',
    '💧 Rehidrátate: tu cuerpo pierde agua y electrolitos durante el ejercicio.',
    '📵 Desconecta del estrés. El cortisol elevado frena tu progreso.',
    '🧘 Estira suavemente los músculos que trabajaste durante 5-10 minutos.',
    '📝 Anota cómo te sentiste. El progreso mental es tan importante como el físico.',
    '🏖️ Tus músculos crecen en el descanso, no en el gimnasio. Respétalos.',
  ];

  // ── Frases psicológicas para romper barreras ───────────────
  static const List<String> mentalPush = [
    '🧠 Tu cerebro envía señales de "para" mucho antes de tu límite real.',
    '🔥 El dolor de las últimas repeticiones es temporal. Los resultados son permanentes.',
    '💎 La incomodidad es donde vive el crecimiento.',
    '⚡ Cuando sientas que no puedes más: respira, reenfoca, y dale una más.',
    '🏔️ Cada montaña se sube paso a paso. No mires la cima, mira el siguiente paso.',
    '🌪️ La mente te dirá que pares. El cuerpo todavía puede.',
    '💪 No eres frágil. Eres antifrágil: te haces más fuerte con cada desafío.',
    '🎯 Enfócate en la repetición actual. No en las que faltan.',
  ];

  // ── Saludos personalizados ─────────────────────────────────
  static String greeting(String name) {
    final hour = DateTime.now().hour;
    if (hour < 12) return '¡Buenos días, $name!';
    if (hour < 18) return '¡Buenas tardes, $name!';
    return '¡Buenas noches, $name!';
  }

  static String get randomQuote =>
      dailyQuotes[_random.nextInt(dailyQuotes.length)];

  static String get randomRestTip =>
      restTips[_random.nextInt(restTips.length)];

  static String get randomRecoveryTip =>
      recoveryTips[_random.nextInt(recoveryTips.length)];

  static String get randomMentalPush =>
      mentalPush[_random.nextInt(mentalPush.length)];

  static String restTipForGoal(String goalKey) =>
      restByGoal[goalKey] ?? restByGoal['hipertrofia']!;
}

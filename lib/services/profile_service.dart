import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_profile.dart';

/// Servicio de persistencia del perfil de usuario.
///
/// Usa [SharedPreferences] para almacenar el perfil como JSON.
/// El perfil se carga una sola vez y se cachea en memoria.
class ProfileService {
  ProfileService._();

  static final ProfileService instance = ProfileService._();

  static const _key = 'trinity_user_profile';

  SharedPreferences? _prefs;
  UserProfile? _cached;

  /// Inicializa el servicio cargando SharedPreferences.
  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
    _loadCached();
  }

  void _loadCached() {
    final raw = _prefs?.getString(_key);
    if (raw != null && raw.isNotEmpty) {
      try {
        _cached = UserProfile.decode(raw);
      } catch (_) {
        _cached = null;
      }
    }
  }

  /// Devuelve el perfil guardado o null si no existe.
  UserProfile? get profile => _cached;

  /// Devuelve true si existe un perfil guardado (onboarding completado).
  bool get hasProfile => _cached != null;

  /// Guarda un perfil nuevo o actualizado.
  Future<void> save(UserProfile profile) async {
    _cached = profile;
    await _prefs?.setString(_key, profile.encode());
  }

  /// Marca un día como completado.
  Future<void> completeDay(int dayIndex) async {
    if (_cached == null) return;
    final progress = List<bool>.from(_cached!.weekProgress);
    if (dayIndex < progress.length) {
      progress[dayIndex] = true;
    }
    final next = (_cached!.currentDayIndex + 1) % _cached!.daysPerWeek;
    _cached = _cached!.copyWith(
      weekProgress: progress,
      currentDayIndex: next,
    );
    await save(_cached!);
  }

  /// Resetea el progreso semanal (para nueva semana).
  Future<void> resetWeek() async {
    if (_cached == null) return;
    _cached = _cached!.copyWith(
      weekProgress: List.filled(_cached!.daysPerWeek, false),
      currentDayIndex: 0,
    );
    await save(_cached!);
  }

  /// Elimina el perfil (para testing o reset completo).
  Future<void> clear() async {
    _cached = null;
    await _prefs?.remove(_key);
  }
}

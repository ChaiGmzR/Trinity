import 'dart:convert';

import 'exercise.dart';

/// Perfil del usuario que persiste entre sesiones.
class UserProfile {
  UserProfile({
    required this.name,
    required this.level,
    required this.goal,
    required this.daysPerWeek,
    required this.availableEquipment,
    required this.gymType,
    DateTime? createdAt,
    this.currentDayIndex = 0,
    List<bool>? weekProgress,
  })  : createdAt = createdAt ?? DateTime.now(),
        weekProgress = weekProgress ?? List.filled(daysPerWeek, false);

  final String name;
  final FitnessLevel level;
  final FitnessGoal goal;
  final int daysPerWeek;
  final List<Equipment> availableEquipment;
  final String gymType; // 'casero' | 'comercial'
  final DateTime createdAt;
  int currentDayIndex;
  List<bool> weekProgress;

  /// Cuántos días ha completado esta semana.
  int get completedDays => weekProgress.where((d) => d).length;

  /// Si ya completó todos los días de esta semana.
  bool get weekComplete => completedDays >= daysPerWeek;

  UserProfile copyWith({
    String? name,
    FitnessLevel? level,
    FitnessGoal? goal,
    int? daysPerWeek,
    List<Equipment>? availableEquipment,
    String? gymType,
    int? currentDayIndex,
    List<bool>? weekProgress,
  }) {
    return UserProfile(
      name: name ?? this.name,
      level: level ?? this.level,
      goal: goal ?? this.goal,
      daysPerWeek: daysPerWeek ?? this.daysPerWeek,
      availableEquipment: availableEquipment ?? this.availableEquipment,
      gymType: gymType ?? this.gymType,
      createdAt: createdAt,
      currentDayIndex: currentDayIndex ?? this.currentDayIndex,
      weekProgress: weekProgress ?? this.weekProgress,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'level': level.index,
      'goal': goal.index,
      'daysPerWeek': daysPerWeek,
      'availableEquipment': availableEquipment.map((e) => e.index).toList(),
      'gymType': gymType,
      'createdAt': createdAt.toIso8601String(),
      'currentDayIndex': currentDayIndex,
      'weekProgress': weekProgress,
    };
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    final daysPerWeek = json['daysPerWeek'] as int;
    final rawProgress = json['weekProgress'] as List<dynamic>?;
    final weekProgress = rawProgress != null
        ? rawProgress.map((e) => e as bool).toList()
        : List.filled(daysPerWeek, false);

    return UserProfile(
      name: json['name'] as String,
      level: FitnessLevel.values[json['level'] as int],
      goal: FitnessGoal.values[json['goal'] as int],
      daysPerWeek: daysPerWeek,
      availableEquipment: (json['availableEquipment'] as List<dynamic>)
          .map((e) => Equipment.values[e as int])
          .toList(),
      gymType: json['gymType'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      currentDayIndex: json['currentDayIndex'] as int? ?? 0,
      weekProgress: weekProgress,
    );
  }

  String encode() => jsonEncode(toJson());

  factory UserProfile.decode(String source) {
    return UserProfile.fromJson(
      jsonDecode(source) as Map<String, dynamic>,
    );
  }
}

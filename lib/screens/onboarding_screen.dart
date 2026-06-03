import 'package:flutter/material.dart';

import '../data/motivational_data.dart';
import '../models/exercise.dart';
import '../models/user_profile.dart';
import '../services/profile_service.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../widgets/motivational_card.dart';

/// Onboarding rápido de 4 pasos para configurar el perfil.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key, required this.onComplete});

  final VoidCallback onComplete;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _pageController = PageController();
  int _currentPage = 0;

  // Datos del formulario
  final _nameController = TextEditingController();
  FitnessGoal _goal = FitnessGoal.hipertrofia;
  FitnessLevel _level = FitnessLevel.principiante;
  int _daysPerWeek = 3;
  String _gymType = 'casero';
  final Set<Equipment> _equipment = {Equipment.pesoCorporal};

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage == 0 && _nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Escribe tu nombre para continuar'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }

    if (_currentPage < 3) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutCubic,
      );
    } else {
      _saveProfile();
    }
  }

  void _prevPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutCubic,
      );
    }
  }

  Future<void> _saveProfile() async {
    final profile = UserProfile(
      name: _nameController.text.trim(),
      level: _level,
      goal: _goal,
      daysPerWeek: _daysPerWeek,
      availableEquipment: _equipment.toList(),
      gymType: _gymType,
    );
    await ProfileService.instance.save(profile);
    widget.onComplete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fondo decorativo
          Positioned.fill(
            child: Image.asset(
              'assets/images/decorative/onboarding_hero.png',
              fit: BoxFit.cover,
              color: Colors.black.withValues(alpha: 0.65),
              colorBlendMode: BlendMode.darken,
            ),
          ),
          // Gradiente overlay
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: AppColors.gradientDarkFull,
              ),
            ),
          ),
          // Contenido
          SafeArea(
            child: Column(
              children: [
                // Progress dots
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(4, (i) {
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: i == _currentPage ? 32 : 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: i == _currentPage
                              ? AppColors.orange
                              : i < _currentPage
                                  ? AppColors.orange.withValues(alpha: 0.5)
                                  : AppColors.bgElevated,
                          borderRadius: BorderRadius.circular(5),
                        ),
                      );
                    }),
                  ),
                ),
                // Pages
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    onPageChanged: (i) => setState(() => _currentPage = i),
                    children: [
                      _NamePage(controller: _nameController),
                      _GoalPage(
                        goal: _goal,
                        onChanged: (g) => setState(() => _goal = g),
                      ),
                      _LevelPage(
                        level: _level,
                        daysPerWeek: _daysPerWeek,
                        gymType: _gymType,
                        onLevelChanged: (l) => setState(() => _level = l),
                        onDaysChanged: (d) =>
                            setState(() => _daysPerWeek = d),
                        onGymTypeChanged: (g) =>
                            setState(() => _gymType = g),
                      ),
                      _EquipmentPage(
                        equipment: _equipment,
                        gymType: _gymType,
                        onToggle: (e) {
                          setState(() {
                            _equipment.contains(e)
                                ? _equipment.remove(e)
                                : _equipment.add(e);
                          });
                        },
                      ),
                    ],
                  ),
                ),
                // Navigation buttons
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      if (_currentPage > 0)
                        IconButton(
                          onPressed: _prevPage,
                          icon: const Icon(Icons.arrow_back_rounded),
                          style: IconButton.styleFrom(
                            backgroundColor: AppColors.bgElevated,
                            padding: const EdgeInsets.all(14),
                          ),
                        ),
                      const Spacer(),
                      FilledButton.icon(
                        onPressed: _nextPage,
                        icon: Icon(_currentPage < 3
                            ? Icons.arrow_forward_rounded
                            : Icons.check_rounded),
                        label:
                            Text(_currentPage < 3 ? 'Siguiente' : '¡Empezar!'),
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.orange,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 28, vertical: 14),
                          textStyle: AppTextStyles.titleMedium,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Page 1: Nombre ────────────────────────────────────────────

class _NamePage extends StatelessWidget {
  const _NamePage({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Logo
          Image.asset(
            'assets/images/trinity_logo.png',
            width: 100,
            height: 100,
          ),
          const SizedBox(height: 24),
          Text('Trinity Gym', style: AppTextStyles.heroTitle),
          const SizedBox(height: 8),
          Text(
            'Tu entrenamiento. Tu momento. Tu fuerza.',
            style: AppTextStyles.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          Text(
            '¿Cómo te llaman?',
            style: AppTextStyles.headline3,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: controller,
            textCapitalization: TextCapitalization.words,
            textAlign: TextAlign.center,
            style: AppTextStyles.titleLarge,
            decoration: InputDecoration(
              hintText: 'Tu nombre',
              hintStyle: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textMuted,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Page 2: Objetivo ──────────────────────────────────────────

class _GoalPage extends StatelessWidget {
  const _GoalPage({required this.goal, required this.onChanged});

  final FitnessGoal goal;
  final ValueChanged<FitnessGoal> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Text('¿Cuál es tu objetivo?', style: AppTextStyles.headline2),
          const SizedBox(height: 8),
          Text(
            'Esto define tu plan de entrenamiento.',
            style: AppTextStyles.bodyMedium,
          ),
          const SizedBox(height: 24),
          Expanded(
            child: ListView(
              children: FitnessGoal.values.map((g) {
                final selected = g == goal;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _GoalCard(
                    goal: g,
                    selected: selected,
                    onTap: () => onChanged(g),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _GoalCard extends StatelessWidget {
  const _GoalCard({
    required this.goal,
    required this.selected,
    required this.onTap,
  });

  final FitnessGoal goal;
  final bool selected;
  final VoidCallback onTap;

  IconData get _icon {
    switch (goal) {
      case FitnessGoal.fuerza:
        return Icons.fitness_center_rounded;
      case FitnessGoal.hipertrofia:
        return Icons.sports_gymnastics_rounded;
      case FitnessGoal.resistencia:
        return Icons.timer_rounded;
      case FitnessGoal.perdidaGrasa:
        return Icons.local_fire_department_rounded;
      case FitnessGoal.movilidad:
        return Icons.self_improvement_rounded;
    }
  }

  Color get _color {
    switch (goal) {
      case FitnessGoal.fuerza:
        return AppColors.orange;
      case FitnessGoal.hipertrofia:
        return AppColors.cyan;
      case FitnessGoal.resistencia:
        return AppColors.gold;
      case FitnessGoal.perdidaGrasa:
        return AppColors.error;
      case FitnessGoal.movilidad:
        return AppColors.success;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      decoration: BoxDecoration(
        color: selected
            ? _color.withValues(alpha: 0.12)
            : AppColors.bgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: selected ? _color : AppColors.border,
          width: selected ? 2 : 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: _color.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(_icon, color: _color, size: 26),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        goal.label,
                        style: AppTextStyles.titleMedium.copyWith(
                          color: selected ? _color : AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        goal.description,
                        style: AppTextStyles.bodySmall,
                        maxLines: 2,
                      ),
                    ],
                  ),
                ),
                if (selected)
                  Icon(Icons.check_circle_rounded, color: _color, size: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Page 3: Nivel, días y tipo de gym ─────────────────────────

class _LevelPage extends StatelessWidget {
  const _LevelPage({
    required this.level,
    required this.daysPerWeek,
    required this.gymType,
    required this.onLevelChanged,
    required this.onDaysChanged,
    required this.onGymTypeChanged,
  });

  final FitnessLevel level;
  final int daysPerWeek;
  final String gymType;
  final ValueChanged<FitnessLevel> onLevelChanged;
  final ValueChanged<int> onDaysChanged;
  final ValueChanged<String> onGymTypeChanged;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      children: [
        const SizedBox(height: 20),
        Text('Personaliza tu plan', style: AppTextStyles.headline2),
        const SizedBox(height: 24),

        // Nivel
        Text('Tu nivel actual', style: AppTextStyles.titleSmall),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          children: FitnessLevel.values.map((l) {
            return ChoiceChip(
              label: Text(l.label),
              selected: l == level,
              onSelected: (_) => onLevelChanged(l),
            );
          }).toList(),
        ),
        const SizedBox(height: 28),

        // Días
        Text('¿Cuántos días entrenas?', style: AppTextStyles.titleSmall),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          children: [2, 3, 4, 5].map((d) {
            return ChoiceChip(
              label: Text('$d días'),
              selected: d == daysPerWeek,
              onSelected: (_) => onDaysChanged(d),
            );
          }).toList(),
        ),
        const SizedBox(height: 28),

        // Tipo de gimnasio
        Text('¿Dónde entrenas?', style: AppTextStyles.titleSmall),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _GymTypeCard(
                type: 'casero',
                label: 'En casa',
                icon: Icons.home_rounded,
                selected: gymType == 'casero',
                onTap: () => onGymTypeChanged('casero'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _GymTypeCard(
                type: 'comercial',
                label: 'Gimnasio',
                icon: Icons.fitness_center_rounded,
                selected: gymType == 'comercial',
                onTap: () => onGymTypeChanged('comercial'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _GymTypeCard extends StatelessWidget {
  const _GymTypeCard({
    required this.type,
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String type;
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      decoration: BoxDecoration(
        color: selected
            ? AppColors.cyan.withValues(alpha: 0.12)
            : AppColors.bgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: selected ? AppColors.cyan : AppColors.border,
          width: selected ? 2 : 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Icon(
                  icon,
                  color: selected ? AppColors.cyan : AppColors.textMuted,
                  size: 36,
                ),
                const SizedBox(height: 10),
                Text(
                  label,
                  style: AppTextStyles.titleSmall.copyWith(
                    color: selected ? AppColors.cyan : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Page 4: Equipo ────────────────────────────────────────────

class _EquipmentPage extends StatelessWidget {
  const _EquipmentPage({
    required this.equipment,
    required this.gymType,
    required this.onToggle,
  });

  final Set<Equipment> equipment;
  final String gymType;
  final ValueChanged<Equipment> onToggle;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      children: [
        const SizedBox(height: 20),
        Text('¿Qué equipo tienes?', style: AppTextStyles.headline2),
        const SizedBox(height: 8),
        Text(
          'Selecciona todo lo disponible.',
          style: AppTextStyles.bodyMedium,
        ),
        const SizedBox(height: 20),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: Equipment.values.map((e) {
            final selected = equipment.contains(e);
            return FilterChip(
              label: Text(e.label),
              selected: selected,
              onSelected: (_) => onToggle(e),
            );
          }).toList(),
        ),
        const SizedBox(height: 28),
        MotivationalCard(
          quote: MotivationalData.dailyQuotes[0],
          compact: true,
        ),
      ],
    );
  }
}

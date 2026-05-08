import 'package:flutter/material.dart';

import '../core/config/update_config.dart';
import '../core/constants/app_constants.dart';
import '../data/exercise_catalog.dart';
import '../data/plan_generator.dart';
import '../models/exercise.dart';
import '../models/workout_plan.dart';
import 'exercise_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _planGenerator = const PlanGenerator();

  int _tab = 0;
  FitnessGoal _goal = FitnessGoal.hipertrofia;
  FitnessLevel _level = FitnessLevel.principiante;
  int _daysPerWeek = 3;
  String _query = '';
  final Set<MovementType> _types = {};
  final Set<BodyZone> _zones = {};
  final Set<Equipment> _equipment = {};

  List<Exercise> get _filteredExercises {
    return exerciseCatalog.where((exercise) {
      final queryOk = _query.trim().isEmpty || exercise.matchesSearch(_query);
      final levelOk = exercise.isAvailableForLevel(_level);
      final typeOk = _types.isEmpty || _types.contains(exercise.type);
      final zoneOk =
          _zones.isEmpty ||
          exercise.bodyZones.any(_zones.contains) ||
          exercise.bodyZones.contains(BodyZone.cuerpoCompleto);
      final equipmentOk =
          _equipment.isEmpty || exercise.equipment.any(_equipment.contains);
      return queryOk && levelOk && typeOk && zoneOk && equipmentOk;
    }).toList();
  }

  WorkoutPlan get _plan => _planGenerator.create(
    visibleExercises: _filteredExercises,
    goal: _goal,
    level: _level,
    daysPerWeek: _daysPerWeek,
    selectedZones: _zones,
    selectedTypes: _types,
    selectedEquipment: _equipment,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.appName),
        actions: [
          IconButton(
            tooltip: 'Fuentes',
            onPressed: _showSources,
            icon: const Icon(Icons.library_books_rounded),
          ),
        ],
      ),
      body: IndexedStack(
        index: _tab,
        children: [
          _CatalogTab(
            exercises: _filteredExercises,
            totalExercises: exerciseCatalog.length,
            goal: _goal,
            level: _level,
            daysPerWeek: _daysPerWeek,
            query: _query,
            selectedTypes: _types,
            selectedZones: _zones,
            selectedEquipment: _equipment,
            onGoalChanged: (goal) => setState(() => _goal = goal),
            onLevelChanged: (level) => setState(() => _level = level),
            onDaysChanged: (days) => setState(() => _daysPerWeek = days),
            onQueryChanged: (query) => setState(() => _query = query),
            onToggleType: _toggleType,
            onToggleZone: _toggleZone,
            onToggleEquipment: _toggleEquipment,
            onClearFilters: _clearFilters,
            onOpenExercise: _openExercise,
          ),
          _PlanTab(
            plan: _plan,
            visibleCount: _filteredExercises.length,
            totalCount: exerciseCatalog.length,
            goal: _goal,
            level: _level,
            daysPerWeek: _daysPerWeek,
            onGoalChanged: (goal) => setState(() => _goal = goal),
            onLevelChanged: (level) => setState(() => _level = level),
            onDaysChanged: (days) => setState(() => _daysPerWeek = days),
            onOpenExercise: _openExercise,
            onShowSources: _showSources,
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tab,
        onDestinationSelected: (index) => setState(() => _tab = index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.fitness_center_rounded),
            label: 'Catálogo',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_month_rounded),
            label: 'Plan',
          ),
        ],
      ),
    );
  }

  void _toggleType(MovementType type) {
    setState(() {
      _types.contains(type) ? _types.remove(type) : _types.add(type);
    });
  }

  void _toggleZone(BodyZone zone) {
    setState(() {
      _zones.contains(zone) ? _zones.remove(zone) : _zones.add(zone);
    });
  }

  void _toggleEquipment(Equipment equipment) {
    setState(() {
      _equipment.contains(equipment)
          ? _equipment.remove(equipment)
          : _equipment.add(equipment);
    });
  }

  void _clearFilters() {
    setState(() {
      _query = '';
      _types.clear();
      _zones.clear();
      _equipment.clear();
    });
  }

  void _openExercise(Exercise exercise) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ExerciseDetailScreen(
          exercise: exercise,
          goal: _goal,
          level: _level,
        ),
      ),
    );
  }

  void _showSources() {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) => const _SourcesSheet(),
    );
  }
}

class _CatalogTab extends StatelessWidget {
  const _CatalogTab({
    required this.exercises,
    required this.totalExercises,
    required this.goal,
    required this.level,
    required this.daysPerWeek,
    required this.query,
    required this.selectedTypes,
    required this.selectedZones,
    required this.selectedEquipment,
    required this.onGoalChanged,
    required this.onLevelChanged,
    required this.onDaysChanged,
    required this.onQueryChanged,
    required this.onToggleType,
    required this.onToggleZone,
    required this.onToggleEquipment,
    required this.onClearFilters,
    required this.onOpenExercise,
  });

  final List<Exercise> exercises;
  final int totalExercises;
  final FitnessGoal goal;
  final FitnessLevel level;
  final int daysPerWeek;
  final String query;
  final Set<MovementType> selectedTypes;
  final Set<BodyZone> selectedZones;
  final Set<Equipment> selectedEquipment;
  final ValueChanged<FitnessGoal> onGoalChanged;
  final ValueChanged<FitnessLevel> onLevelChanged;
  final ValueChanged<int> onDaysChanged;
  final ValueChanged<String> onQueryChanged;
  final ValueChanged<MovementType> onToggleType;
  final ValueChanged<BodyZone> onToggleZone;
  final ValueChanged<Equipment> onToggleEquipment;
  final VoidCallback onClearFilters;
  final ValueChanged<Exercise> onOpenExercise;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        _SummaryCard(
          visible: exercises.length,
          total: totalExercises,
          goal: goal,
          level: level,
        ),
        const SizedBox(height: 14),
        _TrainingControls(
          goal: goal,
          level: level,
          daysPerWeek: daysPerWeek,
          onGoalChanged: onGoalChanged,
          onLevelChanged: onLevelChanged,
          onDaysChanged: onDaysChanged,
        ),
        const SizedBox(height: 14),
        TextField(
          onChanged: onQueryChanged,
          controller: TextEditingController(text: query)
            ..selection = TextSelection.collapsed(offset: query.length),
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.search_rounded),
            hintText: 'Buscar ejercicio, músculo o equipo',
          ),
        ),
        const SizedBox(height: 14),
        _FilterPanel(
          selectedTypes: selectedTypes,
          selectedZones: selectedZones,
          selectedEquipment: selectedEquipment,
          onToggleType: onToggleType,
          onToggleZone: onToggleZone,
          onToggleEquipment: onToggleEquipment,
          onClearFilters: onClearFilters,
        ),
        const SizedBox(height: 16),
        if (exercises.isEmpty)
          const _EmptyState()
        else
          for (final exercise in exercises) ...[
            _ExerciseCard(
              exercise: exercise,
              onTap: () => onOpenExercise(exercise),
            ),
            const SizedBox(height: 10),
          ],
      ],
    );
  }
}

class _PlanTab extends StatelessWidget {
  const _PlanTab({
    required this.plan,
    required this.visibleCount,
    required this.totalCount,
    required this.goal,
    required this.level,
    required this.daysPerWeek,
    required this.onGoalChanged,
    required this.onLevelChanged,
    required this.onDaysChanged,
    required this.onOpenExercise,
    required this.onShowSources,
  });

  final WorkoutPlan plan;
  final int visibleCount;
  final int totalCount;
  final FitnessGoal goal;
  final FitnessLevel level;
  final int daysPerWeek;
  final ValueChanged<FitnessGoal> onGoalChanged;
  final ValueChanged<FitnessLevel> onLevelChanged;
  final ValueChanged<int> onDaysChanged;
  final ValueChanged<Exercise> onOpenExercise;
  final VoidCallback onShowSources;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        _TrainingControls(
          goal: goal,
          level: level,
          daysPerWeek: daysPerWeek,
          onGoalChanged: onGoalChanged,
          onLevelChanged: onLevelChanged,
          onDaysChanged: onDaysChanged,
        ),
        const SizedBox(height: 14),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.auto_awesome_rounded,
                      color: theme.colorScheme.tertiary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Plan ${plan.daysPerWeek} días · ${plan.goal.label}',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    IconButton(
                      tooltip: 'Fuentes',
                      onPressed: onShowSources,
                      icon: const Icon(Icons.info_outline_rounded),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(plan.guidance),
                const SizedBox(height: 10),
                Text(
                  '$visibleCount ejercicios coinciden con tus filtros de $totalCount totales.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.secondary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 14),
        for (final day in plan.days) ...[
          _PlanDayCard(day: day, onOpenExercise: onOpenExercise),
          const SizedBox(height: 12),
        ],
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.visible,
    required this.total,
    required this.goal,
    required this.level,
  });

  final int visible;
  final int total;
  final FitnessGoal goal;
  final FitnessLevel level;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.fitness_center_rounded,
                color: theme.colorScheme.onPrimary,
                size: 30,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$visible ejercicios disponibles',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Catálogo total: $total · ${goal.label} · ${level.label}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.secondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TrainingControls extends StatelessWidget {
  const _TrainingControls({
    required this.goal,
    required this.level,
    required this.daysPerWeek,
    required this.onGoalChanged,
    required this.onLevelChanged,
    required this.onDaysChanged,
  });

  final FitnessGoal goal;
  final FitnessLevel level;
  final int daysPerWeek;
  final ValueChanged<FitnessGoal> onGoalChanged;
  final ValueChanged<FitnessLevel> onLevelChanged;
  final ValueChanged<int> onDaysChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _MiniTitle(
              icon: Icons.flag_rounded,
              title: 'Objetivo',
              trailing: goal.description,
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: FitnessGoal.values
                  .map(
                    (item) => ChoiceChip(
                      label: Text(item.label),
                      selected: item == goal,
                      onSelected: (_) => onGoalChanged(item),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 16),
            _MiniTitle(
              icon: Icons.speed_rounded,
              title: 'Nivel',
              trailing: 'Filtra progresiones adecuadas',
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: FitnessLevel.values
                  .map(
                    (item) => ChoiceChip(
                      label: Text(item.label),
                      selected: item == level,
                      onSelected: (_) => onLevelChanged(item),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 16),
            _MiniTitle(
              icon: Icons.today_rounded,
              title: 'Días por semana',
              trailing: '2 a 5 sesiones',
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              children: [2, 3, 4, 5]
                  .map(
                    (days) => ChoiceChip(
                      label: Text('$days días'),
                      selected: days == daysPerWeek,
                      onSelected: (_) => onDaysChanged(days),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 4),
            Text(
              'Trabaja los grupos principales al menos 2 días por semana.',
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterPanel extends StatelessWidget {
  const _FilterPanel({
    required this.selectedTypes,
    required this.selectedZones,
    required this.selectedEquipment,
    required this.onToggleType,
    required this.onToggleZone,
    required this.onToggleEquipment,
    required this.onClearFilters,
  });

  final Set<MovementType> selectedTypes;
  final Set<BodyZone> selectedZones;
  final Set<Equipment> selectedEquipment;
  final ValueChanged<MovementType> onToggleType;
  final ValueChanged<BodyZone> onToggleZone;
  final ValueChanged<Equipment> onToggleEquipment;
  final VoidCallback onClearFilters;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Expanded(
                  child: _MiniTitle(
                    icon: Icons.tune_rounded,
                    title: 'Filtros',
                    trailing: 'Tipo, zona y equipo',
                  ),
                ),
                TextButton.icon(
                  onPressed: onClearFilters,
                  icon: const Icon(Icons.clear_all_rounded),
                  label: const Text('Limpiar'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _ChipGroup<MovementType>(
              title: 'Tipo de ejercicio',
              values: MovementType.values,
              selected: selectedTypes,
              labelOf: (item) => item.label,
              onToggle: onToggleType,
            ),
            _ChipGroup<BodyZone>(
              title: 'Músculo o parte del cuerpo',
              values: BodyZone.values,
              selected: selectedZones,
              labelOf: (item) => item.label,
              onToggle: onToggleZone,
            ),
            _ChipGroup<Equipment>(
              title: 'Equipo disponible',
              values: Equipment.values,
              selected: selectedEquipment,
              labelOf: (item) => item.label,
              onToggle: onToggleEquipment,
            ),
          ],
        ),
      ),
    );
  }
}

class _ChipGroup<T> extends StatelessWidget {
  const _ChipGroup({
    required this.title,
    required this.values,
    required this.selected,
    required this.labelOf,
    required this.onToggle,
  });

  final String title;
  final List<T> values;
  final Set<T> selected;
  final String Function(T value) labelOf;
  final ValueChanged<T> onToggle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.labelLarge?.copyWith(
              color: theme.colorScheme.tertiary,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: values
                .map(
                  (value) => FilterChip(
                    label: Text(labelOf(value)),
                    selected: selected.contains(value),
                    onSelected: (_) => onToggle(value),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _ExerciseCard extends StatelessWidget {
  const _ExerciseCard({required this.exercise, required this.onTap});

  final Exercise exercise;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  exercise.imageAsset,
                  width: 96,
                  height: 96,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      exercise.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      exercise.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall,
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        _TinyBadge(text: exercise.type.label),
                        _TinyBadge(text: exercise.minLevel.label),
                        _TinyBadge(text: exercise.bodyZones.first.label),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: 'Ver técnica',
                onPressed: onTap,
                icon: const Icon(Icons.play_circle_rounded),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PlanDayCard extends StatelessWidget {
  const _PlanDayCard({required this.day, required this.onOpenExercise});

  final WorkoutDay day;
  final ValueChanged<Exercise> onOpenExercise;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    day.name.replaceAll('Día ', ''),
                    style: TextStyle(
                      color: theme.colorScheme.onPrimary,
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        day.name,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Text(day.focus, style: theme.textTheme.bodySmall),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _PlanNote(
              icon: Icons.local_fire_department_rounded,
              text: day.warmup,
            ),
            const SizedBox(height: 10),
            for (var i = 0; i < day.exercises.length; i++) ...[
              if (i > 0) const Divider(height: 18),
              _PlanExerciseRow(
                item: day.exercises[i],
                onTap: () => onOpenExercise(day.exercises[i].exercise),
              ),
            ],
            const SizedBox(height: 12),
            _PlanNote(icon: Icons.flag_circle_rounded, text: day.finisher),
          ],
        ),
      ),
    );
  }
}

class _PlanExerciseRow extends StatelessWidget {
  const _PlanExerciseRow({required this.item, required this.onTap});

  final PlanExercise item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final exercise = item.exercise;
    final prescription = item.prescription;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                exercise.imageAsset,
                width: 58,
                height: 58,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    exercise.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${prescription.sets} x ${prescription.reps} · descanso ${prescription.rest}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.secondary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    prescription.note,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 6),
            const Icon(Icons.chevron_right_rounded),
          ],
        ),
      ),
    );
  }
}

class _PlanNote extends StatelessWidget {
  const _PlanNote({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: theme.colorScheme.tertiary),
        const SizedBox(width: 8),
        Expanded(child: Text(text, style: theme.textTheme.bodySmall)),
      ],
    );
  }
}

class _MiniTitle extends StatelessWidget {
  const _MiniTitle({
    required this.icon,
    required this.title,
    required this.trailing,
  });

  final IconData icon;
  final String title;
  final String trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: theme.colorScheme.secondary),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                trailing,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TinyBadge extends StatelessWidget {
  const _TinyBadge({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: theme.colorScheme.outline),
      ),
      child: Text(
        text,
        style: theme.textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 42,
              color: theme.colorScheme.tertiary,
            ),
            const SizedBox(height: 10),
            Text(
              'No hay ejercicios con esos filtros',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Limpia algún filtro o baja el nivel para ampliar el catálogo.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _SourcesSheet extends StatelessWidget {
  const _SourcesSheet();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
        shrinkWrap: true,
        children: [
          Text(
            '${AppConstants.appName} ${AppConstants.appVersion}',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Repositorio: ${UpdateConfig.githubUser}/${UpdateConfig.repoName}',
            style: theme.textTheme.bodySmall,
          ),
          const SizedBox(height: 10),
          const Text(
            'ACSM 2026: consistencia, grupos musculares principales al menos dos veces por semana; fuerza con cargas altas y 2-3 series; hipertrofia con volumen semanal cercano a 10 series por grupo muscular.',
          ),
          const SizedBox(height: 8),
          const SelectableText(
            'https://acsm.org/resistance-training-guidelines-update-2026/',
          ),
          const SizedBox(height: 12),
          const Text(
            'CDC: adultos necesitan 2 o más días semanales de fortalecimiento que trabajen piernas, cadera, espalda, abdomen, pecho, hombros y brazos; una serie de 8-12 repeticiones cuenta y 2-3 series aportan más beneficios.',
          ),
          const SizedBox(height: 8),
          const SelectableText(
            'https://www.cdc.gov/physical-activity-basics/guidelines/adults.html\nhttps://www.cdc.gov/physical-activity-basics/adding-adults/what-counts.html',
          ),
          const SizedBox(height: 12),
          const Text(
            'Videos reales offline: CDC, dominio público de EE. UU. Clips generados: assets propios del proyecto para cubrir patrones sin video público específico.',
          ),
        ],
      ),
    );
  }
}

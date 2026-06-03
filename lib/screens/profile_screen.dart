import 'package:flutter/material.dart';

import '../models/exercise.dart';
import '../models/user_profile.dart';
import '../services/profile_service.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../widgets/glassmorphic_card.dart';

/// Pantalla de perfil del usuario.
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
    required this.profile,
    required this.onProfileUpdated,
    required this.onLogout,
  });

  final UserProfile profile;
  final VoidCallback onProfileUpdated;
  final VoidCallback onLogout;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late UserProfile _profile;

  @override
  void initState() {
    super.initState();
    _profile = widget.profile;
  }

  @override
  void didUpdateWidget(covariant ProfileScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.profile != widget.profile) {
      _profile = widget.profile;
    }
  }

  Future<void> _updateProfile(UserProfile updated) async {
    await ProfileService.instance.save(updated);
    setState(() => _profile = updated);
    widget.onProfileUpdated();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      children: [
        // ── Avatar y nombre ──
        Center(
          child: Column(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: AppColors.gradientOrangeCyan,
                ),
                child: Center(
                  child: Text(
                    _profile.name.isNotEmpty
                        ? _profile.name[0].toUpperCase()
                        : '?',
                    style: AppTextStyles.heroTitle.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(_profile.name, style: AppTextStyles.headline2),
              const SizedBox(height: 4),
              Text(
                'Miembro desde ${_formatDate(_profile.createdAt)}',
                style: AppTextStyles.bodySmall,
              ),
            ],
          ),
        ),
        const SizedBox(height: 28),

        // ── Objetivo ──
        _SettingSection(
          title: 'Objetivo',
          icon: Icons.flag_rounded,
          iconColor: AppColors.orange,
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: FitnessGoal.values.map((g) {
              return ChoiceChip(
                label: Text(g.label),
                selected: g == _profile.goal,
                onSelected: (_) => _updateProfile(
                  _profile.copyWith(goal: g),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 16),

        // ── Nivel ──
        _SettingSection(
          title: 'Nivel',
          icon: Icons.speed_rounded,
          iconColor: AppColors.cyan,
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: FitnessLevel.values.map((l) {
              return ChoiceChip(
                label: Text(l.label),
                selected: l == _profile.level,
                onSelected: (_) => _updateProfile(
                  _profile.copyWith(level: l),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 16),

        // ── Días ──
        _SettingSection(
          title: 'Días por semana',
          icon: Icons.calendar_today_rounded,
          iconColor: AppColors.gold,
          child: Wrap(
            spacing: 8,
            children: [2, 3, 4, 5].map((d) {
              return ChoiceChip(
                label: Text('$d días'),
                selected: d == _profile.daysPerWeek,
                onSelected: (_) => _updateProfile(
                  _profile.copyWith(daysPerWeek: d),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 16),

        // ── Tipo de gimnasio ──
        _SettingSection(
          title: 'Tipo de entrenamiento',
          icon: Icons.home_rounded,
          iconColor: AppColors.success,
          child: Row(
            children: [
              Expanded(
                child: _OptionChip(
                  label: 'En casa',
                  icon: Icons.home_rounded,
                  selected: _profile.gymType == 'casero',
                  onTap: () => _updateProfile(
                    _profile.copyWith(gymType: 'casero'),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _OptionChip(
                  label: 'Gimnasio',
                  icon: Icons.fitness_center_rounded,
                  selected: _profile.gymType == 'comercial',
                  onTap: () => _updateProfile(
                    _profile.copyWith(gymType: 'comercial'),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // ── Equipo ──
        _SettingSection(
          title: 'Equipo disponible',
          icon: Icons.inventory_2_rounded,
          iconColor: AppColors.orange,
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: Equipment.values.map((e) {
              final selected = _profile.availableEquipment.contains(e);
              return FilterChip(
                label: Text(e.label),
                selected: selected,
                onSelected: (_) {
                  final list =
                      List<Equipment>.from(_profile.availableEquipment);
                  selected ? list.remove(e) : list.add(e);
                  _updateProfile(
                    _profile.copyWith(availableEquipment: list),
                  );
                },
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 28),

        // ── Acciones ──
        GlassmorphicCard(
          child: Column(
            children: [
              _ActionTile(
                icon: Icons.refresh_rounded,
                label: 'Reiniciar semana',
                subtitle: 'Borra el progreso de esta semana',
                color: AppColors.cyan,
                onTap: () async {
                  await ProfileService.instance.resetWeek();
                  setState(() {
                    _profile = ProfileService.instance.profile!;
                  });
                  widget.onProfileUpdated();
                },
              ),
              const Divider(),
              _ActionTile(
                icon: Icons.logout_rounded,
                label: 'Reiniciar app',
                subtitle: 'Borra perfil y vuelve al onboarding',
                color: AppColors.error,
                onTap: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('¿Estás seguro?'),
                      content: const Text(
                          'Se borrará tu perfil y progreso.'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx, false),
                          child: const Text('Cancelar'),
                        ),
                        FilledButton(
                          onPressed: () => Navigator.pop(ctx, true),
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.error,
                          ),
                          child: const Text('Borrar'),
                        ),
                      ],
                    ),
                  );
                  if (confirm == true) {
                    await ProfileService.instance.clear();
                    widget.onLogout();
                  }
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // ── Versión ──
        Center(
          child: Text(
            'Trinity Gym v1.0.0',
            style: AppTextStyles.bodySmall,
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'ene', 'feb', 'mar', 'abr', 'may', 'jun',
      'jul', 'ago', 'sep', 'oct', 'nov', 'dic',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}

// ── Setting Section ───────────────────────────────────────────

class _SettingSection extends StatelessWidget {
  const _SettingSection({
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.child,
  });

  final String title;
  final IconData icon;
  final Color iconColor;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GlassmorphicCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 20),
              const SizedBox(width: 8),
              Text(title, style: AppTextStyles.titleSmall),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

// ── Option Chip ───────────────────────────────────────────────

class _OptionChip extends StatelessWidget {
  const _OptionChip({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: selected
            ? AppColors.cyan.withValues(alpha: 0.1)
            : AppColors.bgElevated,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: selected ? AppColors.cyan : AppColors.border,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Column(
              children: [
                Icon(
                  icon,
                  color: selected ? AppColors.cyan : AppColors.textMuted,
                ),
                const SizedBox(height: 6),
                Text(
                  label,
                  style: AppTextStyles.labelMedium.copyWith(
                    color:
                        selected ? AppColors.cyan : AppColors.textSecondary,
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

// ── Action Tile ───────────────────────────────────────────────

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label,
                        style: AppTextStyles.titleSmall
                            .copyWith(color: color)),
                    Text(subtitle, style: AppTextStyles.bodySmall),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded,
                  color: AppColors.textMuted),
            ],
          ),
        ),
      ),
    );
  }
}

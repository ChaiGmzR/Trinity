import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Indicador visual de progreso semanal con dots animados.
class WeekProgressIndicator extends StatelessWidget {
  const WeekProgressIndicator({
    super.key,
    required this.totalDays,
    required this.completedDays,
    this.currentDay = 0,
  });

  final int totalDays;
  final List<bool> completedDays;
  final int currentDay;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalDays, (index) {
        final completed = index < completedDays.length && completedDays[index];
        final isCurrent = index == currentDay && !completed;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: _DayDot(
            dayNumber: index + 1,
            completed: completed,
            isCurrent: isCurrent,
          ),
        );
      }),
    );
  }
}

class _DayDot extends StatelessWidget {
  const _DayDot({
    required this.dayNumber,
    required this.completed,
    required this.isCurrent,
  });

  final int dayNumber;
  final bool completed;
  final bool isCurrent;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutCubic,
      width: isCurrent ? 48 : 38,
      height: isCurrent ? 48 : 38,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: completed
            ? AppColors.orange
            : isCurrent
                ? AppColors.orange.withValues(alpha: 0.15)
                : AppColors.bgElevated,
        border: Border.all(
          color: completed
              ? AppColors.orange
              : isCurrent
                  ? AppColors.orange
                  : AppColors.border,
          width: isCurrent ? 2.5 : 1.5,
        ),
        boxShadow: completed
            ? [
                BoxShadow(
                  color: AppColors.orange.withValues(alpha: 0.3),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ]
            : null,
      ),
      child: Center(
        child: completed
            ? const Icon(Icons.check_rounded, color: Colors.white, size: 18)
            : Text(
                '$dayNumber',
                style: AppTextStyles.labelLarge.copyWith(
                  color: isCurrent ? AppColors.orange : AppColors.textMuted,
                  fontWeight: isCurrent ? FontWeight.w900 : FontWeight.w600,
                ),
              ),
      ),
    );
  }
}

/// Barra de progreso con gradiente premium.
class GradientProgressBar extends StatelessWidget {
  const GradientProgressBar({
    super.key,
    required this.progress,
    this.height = 8,
    this.showLabel = false,
  });

  final double progress;
  final double height;
  final bool showLabel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showLabel) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Progreso', style: AppTextStyles.labelSmall),
              Text(
                '${(progress * 100).round()}%',
                style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.orange,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
        ],
        Container(
          height: height,
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.bgElevated,
            borderRadius: BorderRadius.circular(height),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: progress.clamp(0.0, 1.0),
            child: Container(
              decoration: BoxDecoration(
                gradient: AppColors.gradientOrangeCyan,
                borderRadius: BorderRadius.circular(height),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.orange.withValues(alpha: 0.4),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

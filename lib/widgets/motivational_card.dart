import 'package:flutter/material.dart';

import '../data/motivational_data.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Card motivacional con frase impactante y fondo decorativo.
class MotivationalCard extends StatelessWidget {
  const MotivationalCard({
    super.key,
    this.quote,
    this.showRefresh = true,
    this.compact = false,
  });

  final String? quote;
  final bool showRefresh;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final text = quote ?? MotivationalData.randomQuote;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(compact ? 14 : 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.orange.withValues(alpha: 0.12),
            AppColors.cyan.withValues(alpha: 0.06),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.orange.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.format_quote_rounded,
            color: AppColors.orange.withValues(alpha: 0.6),
            size: compact ? 20 : 28,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: compact
                  ? AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textPrimary,
                      fontStyle: FontStyle.italic,
                    )
                  : AppTextStyles.motivationalQuote,
            ),
          ),
        ],
      ),
    );
  }
}

/// Widget de tips de descanso entre series.
class RestTipCard extends StatelessWidget {
  const RestTipCard({super.key, this.goalKey});

  final String? goalKey;

  @override
  Widget build(BuildContext context) {
    final tip = goalKey != null
        ? MotivationalData.restTipForGoal(goalKey!)
        : MotivationalData.randomRestTip;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cyan.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.cyan.withValues(alpha: 0.15),
        ),
      ),
      child: Text(
        tip,
        style: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}

/// Widget de consejo post-entrenamiento.
class RecoveryTipCard extends StatelessWidget {
  const RecoveryTipCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.success.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.success.withValues(alpha: 0.15),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.self_improvement_rounded,
                  color: AppColors.success, size: 20),
              const SizedBox(width: 8),
              Text(
                'Recuperación',
                style: AppTextStyles.titleSmall.copyWith(
                  color: AppColors.success,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            MotivationalData.randomRecoveryTip,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

/// Badge de empuje mental.
class MentalPushBanner extends StatelessWidget {
  const MentalPushBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.orange.withValues(alpha: 0.15),
            AppColors.gold.withValues(alpha: 0.10),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        MotivationalData.randomMentalPush,
        style: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w600,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

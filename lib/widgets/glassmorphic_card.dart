import 'dart:ui';

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Card con efecto glassmorphism premium.
///
/// Combina blur de fondo, bordes semi-transparentes y
/// gradientes sutiles para un look moderno y elegante.
class GlassmorphicCard extends StatelessWidget {
  const GlassmorphicCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.margin = EdgeInsets.zero,
    this.borderRadius = 16,
    this.blur = 12,
    this.opacity = 0.06,
    this.borderOpacity = 0.10,
    this.gradient,
    this.onTap,
  });

  final Widget child;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final double borderRadius;
  final double blur;
  final double opacity;
  final double borderOpacity;
  final Gradient? gradient;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final card = ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          margin: margin,
          decoration: BoxDecoration(
            gradient: gradient ??
                LinearGradient(
                  colors: [
                    Colors.white.withValues(alpha: opacity),
                    Colors.white.withValues(alpha: opacity * 0.4),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: Colors.white.withValues(alpha: borderOpacity),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.glassShadow,
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(borderRadius),
              splashColor: AppColors.orange.withValues(alpha: 0.1),
              highlightColor: AppColors.cyan.withValues(alpha: 0.05),
              child: Padding(padding: padding, child: child),
            ),
          ),
        ),
      ),
    );

    return card;
  }
}

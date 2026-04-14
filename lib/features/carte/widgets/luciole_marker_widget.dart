import 'package:flutter/material.dart';

import '../../../core/theme.dart';

/// Marqueur animé qui représente une entrée sur la carte.
///
/// L'animation imite la pulsation d'une vraie luciole : le halo dorée
/// s'élargit et se rétrécit lentement, de façon apaisante.
class LucioleMarkerWidget extends StatefulWidget {
  const LucioleMarkerWidget({
    super.key,
    required this.onTap,
    this.isHighlighted = false,
  });

  final VoidCallback onTap;

  /// Indique si ce marqueur est actuellement sélectionné / mis en avant
  final bool isHighlighted;

  @override
  State<LucioleMarkerWidget> createState() => _LucioleMarkerWidgetState();
}

class _LucioleMarkerWidgetState extends State<LucioleMarkerWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  // Animation de pulsation : opacity du halo entre 0.2 et 0.9
  late final Animation<double> _haloOpacity;

  // Animation d'échelle : le halo grandit légèrement à chaque pulsation
  late final Animation<double> _haloScale;

  @override
  void initState() {
    super.initState();

    // Chaque luciole a une phase légèrement aléatoire pour éviter
    // que toutes les lucioles clignotent en même temps
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2200),
      vsync: this,
    );

    _haloOpacity = Tween<double>(begin: 0.15, end: 0.7).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _haloScale = Tween<double>(begin: 0.7, end: 1.3).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // Démarre l'animation avec une phase initiale aléatoire
    _controller.repeat(reverse: true);

    // Décalage aléatoire pour désynchroniser les lucioles
    Future.delayed(
      Duration(milliseconds: DateTime.now().millisecond % 2000),
      () {
        if (mounted) {
          _controller.forward(from: DateTime.now().millisecond / 2000.0);
        }
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 32,
        height: 32,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            return Stack(
              alignment: Alignment.center,
              children: [
                // Halo extérieur — pulsation lente
                Transform.scale(
                  scale: _haloScale.value,
                  child: Container(
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppTheme.lucioleOr
                          .withValues(alpha: _haloOpacity.value * 0.4),
                    ),
                  ),
                ),

                // Cercle intermédiaire
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.lucioleOr
                        .withValues(alpha: 0.4 + _haloOpacity.value * 0.3),
                  ),
                ),

                // Cœur lumineux — toujours visible
                Container(
                  width: widget.isHighlighted ? 11 : 9,
                  height: widget.isHighlighted ? 11 : 9,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.isHighlighted
                        ? Colors.white
                        : AppTheme.lucioleOr,
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.lucioleOr
                            .withValues(alpha: 0.6 + _haloOpacity.value * 0.4),
                        blurRadius: 8,
                        spreadRadius: widget.isHighlighted ? 3 : 1,
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

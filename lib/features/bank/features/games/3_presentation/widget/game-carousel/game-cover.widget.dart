import 'dart:math';

import 'package:flutter/material.dart';
import 'package:le_spawn_fr/features/bank/features/games/2_domain/entity/game.entity.dart';

class GameCoverWidget extends StatelessWidget {
  final GameEntity game;
  final double intensity;
  final double height;
  final double? _width;
  final double borderRadius;
  final VoidCallback? onTap;

  double get width => _width ?? height * 2 / 3;

  const GameCoverWidget({
    super.key,
    required this.game,
    this.intensity = 0,
    required this.height,
    double? width,
    this.borderRadius = 8,
    this.onTap,
  }) : _width = width;

  @override
  Widget build(BuildContext context) {
    final rotationAngle = (intensity * pi / 2);
    final scale = 1 - (0.1 * intensity.abs());
    final double elevation = max(0, 8 * (1 - intensity.abs() / 2));
    final int shadowAlpha = ((1 - intensity.abs() / 2) * 255).round();

    final String? coverUrl = game.gameLocalizations.isNotEmpty && game.gameLocalizations.first.coverUrl != null ? game.gameLocalizations.firstWhere((loc) => loc.region.abbreviation == 'EU', orElse: () => game.gameLocalizations.first).coverUrl : game.coverUrl;

    return GestureDetector(
      onTap: onTap,
      child: Transform(
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.001)
          ..rotateY(rotationAngle)
          ..scale(scale),
        alignment: Alignment.center,
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(shadowAlpha),
                blurRadius: elevation,
                offset: Offset(elevation / 2, elevation / 2),
              ),
            ],
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(
                color: Colors.black,
                width: 1.5,
              ),
            ),
            clipBehavior: Clip.antiAlias,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(borderRadius),
              child: Image.network(
                coverUrl ?? '',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.error,
                  size: 48,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

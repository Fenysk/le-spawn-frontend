import 'package:flutter/material.dart';
import 'package:le_spawn_frontend/features/bank/games/2_domain/entity/game.entity.dart';
import 'dart:math';
import 'package:le_spawn_frontend/features/bank/games/3_presentation/game-carousel/game-cover.widget.dart';
import 'package:le_spawn_frontend/features/bank/games/3_presentation/game-carousel/game-carousel-debug.widget.dart';

class GameCarouselWidget extends StatefulWidget {
  const GameCarouselWidget({
    super.key,
    required this.games,
    required this.isLastItemOnTop,
    required this.isCenterItemOnTop,
    required this.alignLeft,
    required this.scrollPosition,
    required this.perspectiveIntensity,
    required this.spacingFactor,
    required this.circleRadius,
    required this.circleOffset,
    required this.perspectiveOffset,
    required this.hoverSpacingIncrease,
    required this.coverRatio,
    this.debugMode = false,
    this.height = 300,
    this.coverHeight,
  });

  final double height;
  final List<GameEntity> games;
  final bool debugMode;
  final bool isLastItemOnTop;
  final bool isCenterItemOnTop;
  final bool alignLeft;
  final double scrollPosition;
  final double perspectiveIntensity;
  final double spacingFactor;
  final double circleRadius;
  final Offset circleOffset;
  final double perspectiveOffset;
  final double hoverSpacingIncrease;
  final double coverRatio;
  final double? coverHeight;

  @override
  State<GameCarouselWidget> createState() => _GameCarouselWidgetState();
}

class _GameCarouselWidgetState extends State<GameCarouselWidget> with SingleTickerProviderStateMixin {
  late double scrollOffset;
  late double depthEffect;
  late double depthOffset;
  late double itemSpacing;
  late double circularPathRadius;
  late double horizontalOffset;
  late double verticalOffset;
  late bool displayLastItemOnTop;
  late bool displayCenterItemOnTop;
  late bool useLeftAlignment;
  late int visibleItemCount;
  late Map<String, Map<String, double>> sliderSettings;
  late AnimationController hoverAnimationController;
  late Animation<double> spacingAnimation;

  @override
  void initState() {
    super.initState();
    _initializeSliderSettings();
    _initializeCarouselState();
    _setupHoverAnimation();
  }

  void _initializeSliderSettings() {
    sliderSettings = {
      'Scroll Position': {
        'min': -2.0,
        'max': 2.0
      },
      'Perspective Intensity': {
        'min': -10.0,
        'max': 10.0
      },
      'Perspective Offset': {
        'min': -2.0,
        'max': 2.0
      },
      'Spacing Factor': {
        'min': 0.0,
        'max': 2.0
      },
      'Radius': {
        'min': -1000.0,
        'max': 1000.0
      },
      'Offset X': {
        'min': -10000.0,
        'max': 10000.0
      },
      'Offset Y': {
        'min': -1000.0,
        'max': 1000.0
      },
      'Max Items': {
        'min': 1.0,
        'max': 20.0
      },
      'Hover Spacing Increase': {
        'min': 0.0,
        'max': 0.1
      },
      'Cover Ratio': {
        'min': 0.1,
        'max': 1.0
      },
    };
  }

  void _initializeCarouselState() {
    scrollOffset = widget.scrollPosition;
    depthEffect = widget.perspectiveIntensity;
    depthOffset = widget.perspectiveOffset;
    itemSpacing = widget.spacingFactor;
    circularPathRadius = widget.circleRadius;
    horizontalOffset = widget.circleOffset.dx;
    verticalOffset = widget.circleOffset.dy;
    displayLastItemOnTop = widget.isLastItemOnTop;
    displayCenterItemOnTop = widget.isCenterItemOnTop;
    useLeftAlignment = widget.alignLeft;
    visibleItemCount = widget.games.length;
  }

  void _setupHoverAnimation() {
    hoverAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    spacingAnimation = Tween<double>(
      begin: 0.0,
      end: widget.hoverSpacingIncrease,
    ).animate(CurvedAnimation(
      parent: hoverAnimationController,
      curve: Curves.easeInOut,
    ));

    hoverAnimationController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    hoverAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildCarousel(),
        if (widget.debugMode)
          GameCarouselDebugWidget(
            height: widget.height,
            isLastItemOnTop: displayLastItemOnTop,
            isCenterItemOnTop: displayCenterItemOnTop,
            alignLeft: useLeftAlignment,
            scrollPosition: scrollOffset,
            perspectiveIntensity: depthEffect,
            spacingFactor: itemSpacing,
            radius: circularPathRadius,
            offsetX: horizontalOffset,
            offsetY: verticalOffset,
            perspectiveOffset: depthOffset,
            maxItems: visibleItemCount,
            sliderConfig: sliderSettings,
            onLastItemOnTopChanged: (value) => setState(() => displayLastItemOnTop = value),
            onCenterItemOnTopChanged: (value) => setState(() => displayCenterItemOnTop = value),
            onAlignLeftChanged: (value) => setState(() => useLeftAlignment = value),
            onScrollPositionChanged: (value) => setState(() => scrollOffset = value),
            onPerspectiveIntensityChanged: (value) => setState(() => depthEffect = value),
            onPerspectiveOffsetChanged: (value) => setState(() => depthOffset = value),
            onSpacingFactorChanged: (value) => setState(() => itemSpacing = value),
            onRadiusChanged: (value) => setState(() => circularPathRadius = value),
            onOffsetXChanged: (value) => setState(() => horizontalOffset = value),
            onOffsetYChanged: (value) => setState(() => verticalOffset = value),
            onMaxItemsChanged: (value) => setState(() => visibleItemCount = value.toInt()),
            onReset: _resetCarouselState,
            hoverSpacingIncrease: widget.hoverSpacingIncrease,
            coverRatio: widget.coverRatio,
            onHoverSpacingIncreaseChanged: (value) => setState(() {}), // Ces valeurs sont en lecture seule
            onCoverRatioChanged: (value) => setState(() {}), // Ces valeurs sont en lecture seule
          ),
      ],
    );
  }

  Widget _buildCarousel() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final containerWidth = constraints.maxWidth;
        final itemHeight = widget.coverHeight ?? widget.height;
        final itemWidth = itemHeight * widget.coverRatio;

        return ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: _buildInteractiveArea(containerWidth, itemWidth, itemHeight),
        );
      },
    );
  }

  Widget _buildInteractiveArea(double containerWidth, double itemWidth, double itemHeight) {
    return GestureDetector(
      onTapDown: (_) => hoverAnimationController.forward(),
      onTapUp: (_) => hoverAnimationController.reverse(),
      onTapCancel: () => hoverAnimationController.reverse(),
      child: MouseRegion(
        onEnter: (_) => hoverAnimationController.forward(),
        onExit: (_) => hoverAnimationController.reverse(),
        child: SizedBox(
          height: widget.height,
          child: Stack(
            alignment: useLeftAlignment ? Alignment.centerLeft : Alignment.center,
            children: [
              _buildGameItems(containerWidth, itemWidth, itemHeight),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGameItems(double containerWidth, double itemWidth, double itemHeight) {
    final visibleGames = widget.games.take(visibleItemCount).toList();
    final gameEntries = displayLastItemOnTop ? visibleGames.asMap().entries.toList() : visibleGames.asMap().entries.toList().reversed;
    final List<MapEntry<double, Widget>> sortedItems = [];

    for (final entry in gameEntries) {
      final itemIndex = entry.key;
      final game = entry.value;

      final currentSpacing = itemSpacing + spacingAnimation.value;
      final itemGap = itemWidth * currentSpacing;
      final centerPosition = (containerWidth - itemWidth) / 2;

      final itemPosition = _calculateItemPosition(itemIndex, containerWidth, itemWidth, itemGap, centerPosition, visibleGames.length);

      final depthValue = itemPosition.depthValue;
      final finalPosition = itemPosition.position;

      Widget gameItem;
      if (circularPathRadius == 0) {
        gameItem = _buildLinearGameItem(
          finalPosition,
          game,
          itemWidth,
          itemHeight,
          depthValue,
        );
      } else {
        gameItem = _buildCircularGameItem(
          itemPosition.normalizedPosition,
          game,
          containerWidth,
          itemWidth,
          itemHeight,
          depthValue,
        );
      }

      sortedItems.add(MapEntry(depthValue.abs(), gameItem));
    }

    if (displayCenterItemOnTop) {
      sortedItems.sort((a, b) => b.key.compareTo(a.key));
    }

    return Stack(
      alignment: Alignment.center,
      children: sortedItems.map((e) => e.value).toList(),
    );
  }

  ItemPosition _calculateItemPosition(
    int index,
    double containerWidth,
    double itemWidth,
    double spacing,
    double centerX,
    int totalItems,
  ) {
    double basePosition;
    double normalizedPosition;
    double scrolledOffset;

    final maxLeftOffset = -((totalItems - 1) / 2) * spacing;
    final maxRightOffset = ((totalItems - 1) / 2) * spacing;
    final minScrollBound = maxLeftOffset - centerX + 7.6;
    final maxScrollBound = maxRightOffset + (containerWidth - centerX - itemWidth) - 7.6;
    final scrollRange = maxScrollBound - minScrollBound;
    final normalizedScroll = (scrollOffset + 2) * 25;
    scrolledOffset = minScrollBound + (scrollRange * normalizedScroll / 100);

    if (useLeftAlignment && circularPathRadius != 0) {
      final firstItemPosition = centerX - ((totalItems - 1) / 2) * spacing;
      basePosition = firstItemPosition + (index * spacing);
      final scrolledPosition = basePosition + scrolledOffset;
      normalizedPosition = (scrolledPosition - firstItemPosition) / (containerWidth / 2);
    } else {
      final offsetFromCenter = (index - (totalItems - 1) / 2) * spacing;
      basePosition = centerX + offsetFromCenter;
      final scrolledPosition = basePosition + scrolledOffset;
      normalizedPosition = (scrolledPosition - centerX) / (containerWidth / 2);
    }

    final finalPosition = basePosition + scrolledOffset;
    final depthValue = normalizedPosition - depthOffset;

    return ItemPosition(
      position: finalPosition,
      normalizedPosition: normalizedPosition,
      depthValue: depthValue,
    );
  }

  Widget _buildLinearGameItem(
    double position,
    GameEntity game,
    double width,
    double height,
    double perspective,
  ) {
    return Positioned(
      left: position + horizontalOffset,
      top: verticalOffset,
      child: GameCoverWidget(
        game: game,
        width: width,
        height: height,
        intensity: perspective * depthEffect,
      ),
    );
  }

  Widget _buildCircularGameItem(
    double normalizedPosition,
    GameEntity game,
    double containerWidth,
    double itemWidth,
    double itemHeight,
    double perspective,
  ) {
    final radius = circularPathRadius.abs();
    final centerX = containerWidth / 2;
    final centerY = widget.height / 2;

    final angleRange = pi / 2;
    final angle = (normalizedPosition * angleRange) - (angleRange / 2);
    final defaultRotation = pi / 4;

    final x = centerX + (radius * sin(angle + defaultRotation)) - (itemWidth / 2) + horizontalOffset;
    final y = centerY - (radius * cos(angle + defaultRotation)) - (itemHeight / 2) + verticalOffset;

    final rotation = (angle * (180 / pi) + 45) * circularPathRadius.sign;

    return Positioned(
      left: x,
      top: y,
      child: Transform(
        transform: Matrix4.rotationZ(rotation * (pi / 180.0)),
        alignment: Alignment.center,
        child: GameCoverWidget(
          game: game,
          width: itemWidth,
          height: itemHeight,
          intensity: perspective * depthEffect,
        ),
      ),
    );
  }

  void _resetCarouselState() {
    setState(() {
      scrollOffset = widget.scrollPosition;
      depthEffect = widget.perspectiveIntensity;
      depthOffset = widget.perspectiveOffset;
      itemSpacing = widget.spacingFactor;
      circularPathRadius = widget.circleRadius;
      horizontalOffset = widget.circleOffset.dx;
      verticalOffset = widget.circleOffset.dy;
      displayLastItemOnTop = widget.isLastItemOnTop;
      displayCenterItemOnTop = widget.isCenterItemOnTop;
      useLeftAlignment = widget.alignLeft;
    });
  }
}

class ItemPosition {
  final double position;
  final double normalizedPosition;
  final double depthValue;

  ItemPosition({
    required this.position,
    required this.normalizedPosition,
    required this.depthValue,
  });
}

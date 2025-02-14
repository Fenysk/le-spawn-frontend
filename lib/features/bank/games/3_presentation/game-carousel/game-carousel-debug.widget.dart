import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GameCarouselDebugWidget extends StatelessWidget {
  const GameCarouselDebugWidget({
    super.key,
    required this.height,
    required this.isLastItemOnTop,
    required this.isCenterItemOnTop,
    required this.alignLeft,
    required this.scrollPosition,
    required this.perspectiveIntensity,
    required this.spacingFactor,
    required this.radius,
    required this.offsetX,
    required this.offsetY,
    required this.perspectiveOffset,
    required this.maxItems,
    required this.sliderConfig,
    required this.onLastItemOnTopChanged,
    required this.onCenterItemOnTopChanged,
    required this.onAlignLeftChanged,
    required this.onScrollPositionChanged,
    required this.onPerspectiveIntensityChanged,
    required this.onPerspectiveOffsetChanged,
    required this.onSpacingFactorChanged,
    required this.onRadiusChanged,
    required this.onOffsetXChanged,
    required this.onOffsetYChanged,
    required this.onMaxItemsChanged,
    required this.onReset,
    required this.hoverSpacingIncrease,
    required this.coverRatio,
    required this.onHoverSpacingIncreaseChanged,
    required this.onCoverRatioChanged,
  });

  final double height;
  final bool isLastItemOnTop;
  final bool isCenterItemOnTop;
  final bool alignLeft;
  final double scrollPosition;
  final double perspectiveIntensity;
  final double spacingFactor;
  final double radius;
  final double offsetX;
  final double offsetY;
  final double perspectiveOffset;
  final int maxItems;
  final double hoverSpacingIncrease;
  final double coverRatio;
  final Map<String, Map<String, double>> sliderConfig;
  final ValueChanged<bool> onLastItemOnTopChanged;
  final ValueChanged<bool> onCenterItemOnTopChanged;
  final ValueChanged<bool> onAlignLeftChanged;
  final ValueChanged<double> onScrollPositionChanged;
  final ValueChanged<double> onPerspectiveIntensityChanged;
  final ValueChanged<double> onPerspectiveOffsetChanged;
  final ValueChanged<double> onSpacingFactorChanged;
  final ValueChanged<double> onRadiusChanged;
  final ValueChanged<double> onOffsetXChanged;
  final ValueChanged<double> onOffsetYChanged;
  final ValueChanged<double> onMaxItemsChanged;
  final ValueChanged<double> onHoverSpacingIncreaseChanged;
  final ValueChanged<double> onCoverRatioChanged;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.orange, width: 2),
        color: Colors.yellow.withAlpha(50),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Debug Controls', style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.copy, color: Colors.orange),
                    onPressed: () {
                      final values = '''
height: $height,
coverHeight: ${height * 0.85},
isLastItemOnTop: $isLastItemOnTop,
isCenterItemOnTop: $isCenterItemOnTop,
alignLeft: $alignLeft,
scrollPosition: $scrollPosition,
perspectiveIntensity: $perspectiveIntensity,
spacingFactor: $spacingFactor,
circleRadius: $radius,
circleOffset: Offset($offsetX, $offsetY),
perspectiveOffset: $perspectiveOffset,
hoverSpacingIncrease: $hoverSpacingIncrease,
coverRatio: $coverRatio,
''';
                      Clipboard.setData(ClipboardData(text: values));
                    },
                    tooltip: 'Copy current values',
                  ),
                  IconButton(
                    icon: const Icon(Icons.refresh, color: Colors.orange),
                    onPressed: onReset,
                    tooltip: 'Reset to initial values',
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Last Item on Top', style: TextStyle(color: Colors.orange)),
                  const SizedBox(width: 8),
                  Switch(
                    value: isLastItemOnTop,
                    onChanged: onLastItemOnTopChanged,
                    activeColor: Colors.orange,
                  ),
                ],
              ),
              const SizedBox(width: 16),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Center Item on Top', style: TextStyle(color: Colors.orange)),
                  const SizedBox(width: 8),
                  Switch(
                    value: isCenterItemOnTop,
                    onChanged: onCenterItemOnTopChanged,
                    activeColor: Colors.orange,
                  ),
                ],
              ),
              const SizedBox(width: 16),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Align Left', style: TextStyle(color: Colors.orange)),
                  const SizedBox(width: 8),
                  Switch(
                    value: alignLeft,
                    onChanged: onAlignLeftChanged,
                    activeColor: Colors.orange,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          _buildLabeledSlider(
            label: 'Scroll Position',
            value: scrollPosition,
            onChanged: onScrollPositionChanged,
          ),
          _buildLabeledSlider(
            label: 'Perspective Intensity',
            value: perspectiveIntensity,
            onChanged: onPerspectiveIntensityChanged,
          ),
          _buildLabeledSlider(
            label: 'Perspective Offset',
            value: perspectiveOffset,
            onChanged: onPerspectiveOffsetChanged,
          ),
          _buildLabeledSlider(
            label: 'Spacing Factor',
            value: spacingFactor,
            onChanged: onSpacingFactorChanged,
          ),
          _buildLabeledSlider(
            label: 'Radius',
            value: radius,
            onChanged: onRadiusChanged,
          ),
          _buildLabeledSlider(
            label: 'Offset X',
            value: offsetX,
            onChanged: onOffsetXChanged,
          ),
          _buildLabeledSlider(
            label: 'Offset Y',
            value: offsetY,
            onChanged: onOffsetYChanged,
          ),
          _buildLabeledSlider(
            label: 'Max Items',
            value: maxItems.toDouble(),
            onChanged: onMaxItemsChanged,
          ),
          _buildLabeledSlider(
            label: 'Hover Spacing Increase',
            value: hoverSpacingIncrease,
            onChanged: onHoverSpacingIncreaseChanged,
          ),
          _buildLabeledSlider(
            label: 'Cover Ratio',
            value: coverRatio,
            onChanged: onCoverRatioChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildLabeledSlider({
    required String label,
    required double value,
    required ValueChanged<double> onChanged,
  }) {
    final config = sliderConfig[label]!;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label),
            Text(value.toStringAsFixed(1)),
          ],
        ),
        SizedBox(
          height: 20,
          child: Slider(
            value: value,
            min: config['min']!,
            max: config['max']!,
            label: value.toStringAsFixed(1),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}

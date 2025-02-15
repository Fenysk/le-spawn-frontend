import 'package:flutter/material.dart';
import 'package:le_spawn_fr/core/constant/image.constant.dart';
import 'package:soft_edge_blur/soft_edge_blur.dart';

class ImageOverlay extends StatelessWidget {
  final String image;
  final double distance;
  final List<EdgeType> sides;
  final Color color;
  final double height;
  final bool disableGradient;

  const ImageOverlay({
    super.key,
    required this.image,
    required this.distance,
    required this.sides,
    required this.color,
    required this.height,
    required this.disableGradient,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomLeft,
      children: [
        if (distance != null)
          SoftEdgeBlur(
            edges: [
              if (sides.contains(EdgeType.topEdge))
                EdgeBlur(
                  type: EdgeType.topEdge,
                  size: height,
                  controlPoints: [
                    ControlPoint(position: 1, type: ControlPointType.transparent),
                    ControlPoint(position: distance!, type: ControlPointType.transparent),
                    ControlPoint(position: 0, type: ControlPointType.visible),
                  ],
                  sigma: 7,
                ),
              if (sides.contains(EdgeType.bottomEdge))
                EdgeBlur(
                  type: EdgeType.bottomEdge,
                  size: height,
                  controlPoints: [
                    ControlPoint(position: 1, type: ControlPointType.transparent),
                    ControlPoint(position: distance!, type: ControlPointType.transparent),
                    ControlPoint(position: 0, type: ControlPointType.visible),
                  ],
                  sigma: 7,
                ),
              if (sides.contains(EdgeType.leftEdge))
                EdgeBlur(
                  type: EdgeType.leftEdge,
                  size: height,
                  controlPoints: [
                    ControlPoint(position: 1, type: ControlPointType.transparent),
                    ControlPoint(position: distance!, type: ControlPointType.transparent),
                    ControlPoint(position: 0, type: ControlPointType.visible),
                  ],
                  sigma: 7,
                ),
              if (sides.contains(EdgeType.rightEdge))
                EdgeBlur(
                  type: EdgeType.rightEdge,
                  size: height,
                  controlPoints: [
                    ControlPoint(position: 1, type: ControlPointType.transparent),
                    ControlPoint(position: distance!, type: ControlPointType.transparent),
                    ControlPoint(position: 0, type: ControlPointType.visible),
                  ],
                  sigma: 7,
                ),
            ],
            child: Image.network(
              image,
              errorBuilder: (context, error, stackTrace) => Image.asset(ImageConstant.placeholderPath),
              height: height,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
        if (!disableGradient) ...[
          if (sides.contains(EdgeType.bottomEdge))
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [
                      0,
                      (1 - distance) * 1.2,
                      1
                    ],
                    colors: [
                      Colors.transparent,
                      color.withAlpha(100),
                      color.withAlpha(250),
                    ],
                  ),
                ),
              ),
            ),
          if (sides.contains(EdgeType.topEdge))
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    stops: [
                      0,
                      (1 - distance) * 1.2,
                      1
                    ],
                    colors: [
                      Colors.transparent,
                      color.withAlpha(100),
                      color.withAlpha(250),
                    ],
                  ),
                ),
              ),
            ),
          if (sides.contains(EdgeType.leftEdge))
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerRight,
                    end: Alignment.centerLeft,
                    stops: [
                      0,
                      (1 - distance) * 1.2,
                      1
                    ],
                    colors: [
                      Colors.transparent,
                      color.withAlpha(100),
                      color.withAlpha(250),
                    ],
                  ),
                ),
              ),
            ),
          if (sides.contains(EdgeType.rightEdge))
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    stops: [
                      0,
                      (1 - distance) * 1.2,
                      1
                    ],
                    colors: [
                      Colors.transparent,
                      color.withAlpha(100),
                      color.withAlpha(250),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ],
    );
  }
}

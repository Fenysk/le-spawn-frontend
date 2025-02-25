import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';
import 'package:le_spawn_fr/core/constant/rive.constant.dart';

class AnimatedYellowBarsBackgroundWidget extends StatefulWidget {
  final BoxFit fit;

  const AnimatedYellowBarsBackgroundWidget({
    super.key,
    this.fit = BoxFit.fill,
  });

  @override
  State<AnimatedYellowBarsBackgroundWidget> createState() => _AnimatedYellowBarsBackgroundWidgetState();
}

class _AnimatedYellowBarsBackgroundWidgetState extends State<AnimatedYellowBarsBackgroundWidget> {
  Artboard? _riveArtBoard;
  StateMachineController? _riveController;

  @override
  void initState() {
    super.initState();
    _initRive();
  }

  void _initRive() async {
    final riveData = await rootBundle.load(RiveConstant.collectionCardOverviewBackgroundPath);
    final riveFile = RiveFile.import(riveData);

    final artboard = riveFile.mainArtboard;
    _riveArtBoard = artboard;

    var controller = StateMachineController.fromArtboard(
      artboard,
      RiveConstant.collectionCardOverviewBackgroundStateMachineName,
    );

    if (controller != null) {
      artboard.addController(controller);
      _riveController = controller;
      _riveController?.isActive = true;
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (_riveArtBoard == null) return const SizedBox.shrink();

    return Positioned.fill(
      child: Rive(
        artboard: _riveArtBoard!,
        fit: widget.fit,
      ),
    );
  }

  @override
  void dispose() {
    _riveController?.dispose();
    super.dispose();
  }
}

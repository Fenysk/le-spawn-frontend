import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';
import 'package:le_spawn_fr/core/constant/rive.constant.dart';

class AnimatedMainButtonBackgroundWidget extends StatefulWidget {
  final bool? inputValue;
  final BoxFit fit;

  const AnimatedMainButtonBackgroundWidget({
    super.key,
    this.inputValue,
    this.fit = BoxFit.cover,
  });

  @override
  State<AnimatedMainButtonBackgroundWidget> createState() => _AnimatedMainButtonBackgroundWidgetState();
}

class _AnimatedMainButtonBackgroundWidgetState extends State<AnimatedMainButtonBackgroundWidget> {
  Artboard? _riveArtBoard;
  StateMachineController? _riveController;
  SMIInput<bool>? _riveAnimationController;

  @override
  void initState() {
    super.initState();
    _initRive();
  }

  void _initRive() async {
    final riveData = await rootBundle.load(RiveConstant.mainButtonAnimatedBackgroundPath);
    final riveFile = RiveFile.import(riveData);

    final artboard = riveFile.mainArtboard;
    _riveArtBoard = artboard;

    var controller = StateMachineController.fromArtboard(
      artboard,
      RiveConstant.mainButtonAnimatedBackgroundStateMachineName,
    );

    if (controller != null) {
      artboard.addController(controller);
      _riveController = controller;

      _riveAnimationController = controller.findInput<bool>(RiveConstant.mainButtonAnimatedBackgroundInputOnHoverName);
      _riveAnimationController?.value = widget.inputValue ?? false;
    }

    setState(() {});
  }

  @override
  void didUpdateWidget(AnimatedMainButtonBackgroundWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.inputValue != widget.inputValue) {
      _riveAnimationController?.value = widget.inputValue ?? false;
    }
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

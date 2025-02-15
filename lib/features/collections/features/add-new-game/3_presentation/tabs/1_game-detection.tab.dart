import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:le_spawn_fr/features/bank/features/games/2_domain/entity/game.entity.dart';
import 'package:le_spawn_fr/features/collections/features/add-new-game/3_presentation/bloc/add-new-game.cubit.dart';
import 'package:le_spawn_fr/features/collections/features/add-new-game/3_presentation/bloc/add-new-game.state.dart';
import 'package:le_spawn_fr/features/collections/features/add-new-game/widget/barcode-scanner.widget.dart';

class GameDetectionTab extends StatefulWidget {
  final Function(GameEntity) onGameFetched;
  final Function() skipStep;

  const GameDetectionTab({
    super.key,
    required this.onGameFetched,
    required this.skipStep,
  });

  @override
  State<GameDetectionTab> createState() => _GameDetectionTabState();
}

class _GameDetectionTabState extends State<GameDetectionTab> {
  bool barcodeShouldEnable = false;
  bool photoShouldEnable = false;
  bool fileShouldEnable = true;

  @override
  void initState() {
    checkPlatform();
    super.initState();
  }

  void checkPlatform() {
    if (Platform.isAndroid || Platform.isIOS)
      setState(() {
        barcodeShouldEnable = true;
        photoShouldEnable = true;
      });
  }

  void _showBarcodeDrawer() {
    showModalBottomSheet<void>(
      context: context,
      builder: (context) => BarcodeScannerWidget(
        onCodeDetected: _onCodeDetected,
      ),
    );
  }

  void _showPhotoCaptureDrawer() {
    showModalBottomSheet<void>(
      context: context,
      builder: (context) => Center(child: Text('Photo capture')),
    );
  }

  void _showFileUploadDrawer() {
    showModalBottomSheet<void>(
      context: context,
      builder: (context) => Center(child: Text('File upload')),
    );
  }

  void _onCodeDetected(String code) {
    BlocProvider.of<AddNewGameCubit>(context).fetchGameData(barcode: code);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddNewGameCubit, AddNewGameState>(
        builder: (context, state) => switch (state) {
              AddNewGameInitialState() => _buildMethodSelectionDetection(),
              AddNewGameLoadingState() => _buildLoadingContent(),
              AddNewGameSuccessState() => _buildSuccessContent(state.game),
              AddNewGameFailureState() => _buildFailureContent(),
              _ => const SizedBox.shrink(),
            });
  }

  Center _buildMethodSelectionDetection() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.yellow,
            ),
            onPressed: _showBarcodeDrawer,
            icon: const Icon(Icons.qr_code_scanner),
            label: const Text('Debug Scan Barcode'),
          ),
          const SizedBox(height: 20),
          Tooltip(
            message: photoShouldEnable ? null : '⚠️ Mobile only',
            child: ElevatedButton.icon(
              onPressed: barcodeShouldEnable ? _showBarcodeDrawer : null,
              icon: const Icon(Icons.qr_code_scanner),
              label: const Text('Scan Barcode'),
            ),
          ),
          const SizedBox(height: 20),
          Tooltip(
            message: photoShouldEnable ? null : '⚠️ Mobile only',
            child: ElevatedButton.icon(
              onPressed: photoShouldEnable ? _showPhotoCaptureDrawer : null,
              icon: const Icon(Icons.camera_alt),
              label: const Text('Take Photo'),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: fileShouldEnable ? _showFileUploadDrawer : null,
            icon: const Icon(Icons.upload_file),
            label: const Text('Upload File'),
          ),
          const SizedBox(height: 40),
          SizedBox(width: 200, child: const Divider()),
          const SizedBox(height: 40),
          ElevatedButton.icon(
            onPressed: widget.skipStep,
            icon: const Icon(Icons.skip_next),
            label: const Text('Skip step'),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingContent() => const Center(child: CircularProgressIndicator());

  Widget _buildFailureContent() => const Center(child: Text('Failure!'));

  Widget _buildSuccessContent(GameEntity gameData) {
    widget.onGameFetched(gameData);
    return Center(
      child: Text('Success! ${gameData.name}'),
    );
  }
}

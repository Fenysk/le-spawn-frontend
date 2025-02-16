import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:le_spawn_fr/features/collections/features/add-new-item/3_presentation/bloc/add-new-game.cubit.dart';
import 'package:le_spawn_fr/features/collections/features/add-new-item/widget/barcode-scanner.widget.dart';

class GameDetectionTab extends StatefulWidget {
  const GameDetectionTab({
    super.key,
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
      isScrollControlled: true,
      builder: (modalContext) => BlocProvider.value(
        value: BlocProvider.of<AddNewGameCubit>(context),
        child: BarcodeScannerWidget(
          onCodeDetected: _onCodeDetected,
        ),
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
            message: photoShouldEnable ? '' : '⚠️ Mobile only',
            child: ElevatedButton.icon(
              onPressed: barcodeShouldEnable ? _showBarcodeDrawer : null,
              icon: const Icon(Icons.qr_code_scanner),
              label: const Text('Scan Barcode'),
            ),
          ),
          const SizedBox(height: 20),
          Tooltip(
            message: photoShouldEnable ? '' : '⚠️ Mobile only',
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
        ],
      ),
    );
  }
}

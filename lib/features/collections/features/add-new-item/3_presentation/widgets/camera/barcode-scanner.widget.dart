import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:le_spawn_fr/features/collections/features/add-new-item/3_presentation/bloc/add-new-game.cubit.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class BarcodeScannerWidget extends StatefulWidget {
  final VoidCallback onClose;

  const BarcodeScannerWidget({
    super.key,
    required this.onClose,
  });

  @override
  State<BarcodeScannerWidget> createState() => _BarcodeScannerWidgetState();
}

class _BarcodeScannerWidgetState extends State<BarcodeScannerWidget> {
  MobileScannerController? cameraController;
  bool isTorchOn = false;

  @override
  void initState() {
    super.initState();
    cameraController = MobileScannerController();
  }

  void onDetect(BarcodeCapture capture) async {
    try {
      if (!mounted || cameraController == null) return;

      final List<Barcode> barcodes = capture.barcodes;
      if (barcodes.isEmpty) return;

      final barcode = barcodes.first;
      if (barcode.rawValue == null) return;

      await cameraController?.stop();
      context.read<AddNewGameCubit>().fetchGamesFromBarcode(barcode: barcode.rawValue!);
    } catch (e) {
      debugPrint('Error in barcode detection: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        MobileScanner(
          controller: cameraController,
          onDetect: onDetect,
        ),
        Positioned(
          top: 16,
          right: 16,
          child: Row(
            children: [
              IconButton(
                color: Colors.white,
                icon: Icon(isTorchOn ? Icons.flash_off : Icons.flash_on),
                onPressed: () => setState(() {
                  isTorchOn = !isTorchOn;
                  cameraController?.toggleTorch();
                }),
              ),
              IconButton(
                color: Colors.white,
                icon: const Icon(Icons.close),
                onPressed: widget.onClose,
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    cameraController?.dispose();
    super.dispose();
  }
}

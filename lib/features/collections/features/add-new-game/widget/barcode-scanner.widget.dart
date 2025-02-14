import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class BarcodeScannerWidget extends StatefulWidget {
  final void Function(String code) onCodeDetected;

  const BarcodeScannerWidget({
    super.key,
    required this.onCodeDetected,
  });

  @override
  State<BarcodeScannerWidget> createState() => _BarcodeScannerWidgetState();
}

class _BarcodeScannerWidgetState extends State<BarcodeScannerWidget> {
  late MobileScannerController cameraController;
  bool isTorchOn = false;

  // TODO: Remove this after development
  @override
  void initState() {
    debugReturn();
    super.initState();
  }

  void debugReturn() {
    Future.delayed(Duration(seconds: 2), () {
      widget.onCodeDetected('711719567653');
      if (mounted) Navigator.pop(context);
    });
  }
  /////

  void onDetect(BarcodeCapture capture) {
    final List<Barcode> barcodes = capture.barcodes;
    for (final barcode in barcodes) {
      debugPrint('Barcode found! ${barcode.rawValue}');
      widget.onCodeDetected(barcode.rawValue!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: Icon(
                isTorchOn ? Icons.flash_on : Icons.flash_off,
                color: isTorchOn ? Colors.yellow : Colors.grey,
              ),
              onPressed: () async {
                await cameraController.toggleTorch();
                setState(() {
                  isTorchOn = !isTorchOn;
                });
              },
            ),
            IconButton(
              icon: const Icon(Icons.cameraswitch),
              onPressed: () => cameraController.switchCamera(),
            ),
          ],
        ),
        Expanded(
          child: MobileScanner(
            controller: cameraController,
            onDetect: onDetect,
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }
}

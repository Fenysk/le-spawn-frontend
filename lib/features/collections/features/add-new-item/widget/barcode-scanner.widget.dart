import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:le_spawn_fr/features/collections/features/add-new-item/3_presentation/bloc/add-new-game.cubit.dart';
import 'package:le_spawn_fr/features/collections/features/add-new-item/3_presentation/bloc/add-new-game.state.dart';
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
  bool hasError = false;
  bool isLoading = false;

  void onDetect(BarcodeCapture capture) {
    if (hasError || isLoading) return;

    final List<Barcode> barcodes = capture.barcodes;
    for (final barcode in barcodes) {
      debugPrint('Barcode found! ${barcode.rawValue}');
      setState(() => isLoading = true);
      widget.onCodeDetected(barcode.rawValue!);
    }
  }

  @override
  void initState() {
    super.initState();
    cameraController = MobileScannerController();
  }

  void showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
        onVisible: () {
          if (mounted) {
            setState(() => hasError = true);
          }
        },
        action: SnackBarAction(
          label: 'Dismiss',
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            if (mounted) {
              setState(() => hasError = false);
            }
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddNewGameCubit, AddNewGameState>(
      listener: (context, state) {
        if (state is AddNewGameFailureState) {
          showErrorSnackBar(context, state.errorMessage);
          setState(() => isLoading = false);
        }

        if (state is AddNewGameSuccessState) {
          if (mounted) {
            setState(() {
              hasError = false;
              isLoading = false;
            });
          }
          Navigator.of(context).pop();
        }
      },
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Row(
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
          ),
          Expanded(
            child: MobileScanner(
              controller: cameraController,
              onDetect: onDetect,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:le_spawn_fr/features/collections/features/add-new-item/3_presentation/bloc/add-new-game.cubit.dart';
import 'package:le_spawn_fr/features/collections/features/add-new-item/3_presentation/bloc/add-new-game.state.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class BarcodeScannerWidget extends StatefulWidget {
  final AddNewGameCubit addNewGameCubit;

  const BarcodeScannerWidget({
    super.key,
    required this.addNewGameCubit,
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
    widget.addNewGameCubit.resetGame();
  }

  void onDetect(BarcodeCapture capture) async {
    try {
      if (!mounted || cameraController == null) return;

      final List<Barcode> barcodes = capture.barcodes;
      if (barcodes.isEmpty) return;

      final barcode = barcodes.first;
      if (barcode.rawValue == null) return;

      widget.addNewGameCubit.fetchGameData(barcode: barcode.rawValue!);
    } catch (e) {
      debugPrint('Error in barcode detection: $e');
    }
  }

  Widget _buildLoadingOverlay() {
    return Container(
      color: Colors.black.withOpacity(0.7),
      child: const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text(
              "Loading...",
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorOverlay(String errorMessage) {
    return Container(
      color: Colors.black.withAlpha(179),
      padding: const EdgeInsets.all(16),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              errorMessage,
              style: const TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (cameraController == null) {
      return const Center(child: Text('Camera initialization failed'));
    }

    return BlocProvider.value(
      value: widget.addNewGameCubit,
      child: BlocBuilder<AddNewGameCubit, AddNewGameState>(
        builder: (context, state) {
          return Stack(
            children: [
              Column(
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
                            if (cameraController != null) {
                              await cameraController!.toggleTorch();
                              setState(() {
                                isTorchOn = !isTorchOn;
                              });
                            }
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.cameraswitch),
                          onPressed: () => cameraController?.switchCamera(),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: MobileScanner(
                      controller: cameraController!,
                      onDetect: onDetect,
                    ),
                  ),
                ],
              ),
              if (state is AddNewGameLoadingState) _buildLoadingOverlay(),
              if (state is AddNewGameFailureState) _buildErrorOverlay(state.errorMessage),
            ],
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    cameraController?.stop();
    cameraController?.dispose();
    cameraController = null;
    super.dispose();
  }
}

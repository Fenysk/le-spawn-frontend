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
  bool _barcodeShouldEnable = false;
  bool _photoShouldEnable = false;
  final bool _fileShouldEnable = true;

  static const double _buttonSpacing = 20.0;
  static const String _mobileOnlyTooltip = '⚠️ Mobile only';

  @override
  void initState() {
    _initializePlatformFeatures();
    super.initState();
  }

  void _initializePlatformFeatures() {
    if (Platform.isAndroid || Platform.isIOS) {
      setState(() {
        _barcodeShouldEnable = true;
        _photoShouldEnable = true;
      });
    }
  }

  void _showBarcodeDrawer({bool isDebug = false}) {
    if (!mounted) return;

    final cubit = BlocProvider.of<AddNewGameCubit>(context);
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext modalContext) => BarcodeScannerWidget(
        addNewGameCubit: cubit,
        isDebug: isDebug,
      ),
    );
  }

  void _showPhotoCaptureDrawer() {
    if (!mounted) return;

    showModalBottomSheet<void>(
      context: context,
      builder: (_) => const Center(child: Text('Photo capture')),
    );
  }

  void _showFileUploadDrawer() {
    if (!mounted) return;

    showModalBottomSheet<void>(
      context: context,
      builder: (_) => const Center(child: Text('File upload')),
    );
  }

  Widget _buildActionButton({
    required VoidCallback? onPressed,
    required IconData icon,
    required String label,
    String? tooltip,
    Color? backgroundColor,
  }) {
    final button = ElevatedButton.icon(
      style: backgroundColor != null ? ElevatedButton.styleFrom(backgroundColor: backgroundColor) : null,
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
    );

    return tooltip != null ? Tooltip(message: tooltip, child: button) : button;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildActionButton(
            onPressed: () => _showBarcodeDrawer(isDebug: true),
            icon: Icons.qr_code_scanner,
            label: 'Debug Scan Barcode',
            backgroundColor: Colors.yellow,
          ),
          const SizedBox(height: _buttonSpacing),
          _buildActionButton(
            onPressed: _barcodeShouldEnable ? _showBarcodeDrawer : null,
            icon: Icons.qr_code_scanner,
            label: 'Scan Barcode',
            tooltip: _barcodeShouldEnable ? '' : _mobileOnlyTooltip,
          ),
          const SizedBox(height: _buttonSpacing),
          _buildActionButton(
            onPressed: _photoShouldEnable ? _showPhotoCaptureDrawer : null,
            icon: Icons.camera_alt,
            label: 'Take Photo',
            tooltip: _photoShouldEnable ? '' : _mobileOnlyTooltip,
          ),
          const SizedBox(height: _buttonSpacing),
          _buildActionButton(
            onPressed: _fileShouldEnable ? _showFileUploadDrawer : null,
            icon: Icons.upload_file,
            label: 'Upload File',
          ),
        ],
      ),
    );
  }
}

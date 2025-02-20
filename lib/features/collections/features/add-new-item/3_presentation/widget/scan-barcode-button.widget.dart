import 'package:flutter/material.dart';
import 'package:le_spawn_fr/core/theme/app.theme.dart';

class ScanBarcodeButtonWidget extends StatelessWidget {
  final VoidCallback onScanFirstGamePressed;
  final String text;
  final EdgeInsets? padding;
  final double? fontSize;
  final double? iconSize;

  const ScanBarcodeButtonWidget({
    super.key,
    required this.onScanFirstGamePressed,
    required this.text,
    this.padding,
    this.fontSize,
    this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onScanFirstGamePressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppTheme.primaryBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        padding: padding ?? const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.qr_code_scanner,
            color: AppTheme.primaryText,
            size: iconSize ?? 24,
          ),
          const SizedBox(width: 16),
          Text(
            text,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontSize: fontSize ?? 20,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }
}

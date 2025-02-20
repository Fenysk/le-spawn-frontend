import 'package:flutter/material.dart';
import 'package:le_spawn_fr/core/theme/app.theme.dart';
import 'package:le_spawn_fr/features/collections/features/add-new-item/3_presentation/widget/scan-barcode-button.widget.dart';
import 'package:outlined_text/outlined_text.dart';

class WelcomeTab extends StatefulWidget {
  final VoidCallback onScanFirstGamePressed;

  const WelcomeTab({super.key, required this.onScanFirstGamePressed});

  @override
  State<WelcomeTab> createState() => _WelcomeTabState();
}

class _WelcomeTabState extends State<WelcomeTab> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        spacing: 24,
        children: [
          OutlinedText(
            strokes: [
              OutlinedTextStroke(width: 1, color: AppTheme.primaryText),
            ],
            text: Text(
              'Toute ta collection\ndans un seul endroit !',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppTheme.primaryBackground,
                    fontSize: 24,
                  ),
            ),
          ),
          Spacer(),
          ScanBarcodeButtonWidget(
            text: 'Scan ton premier jeu',
            onScanFirstGamePressed: widget.onScanFirstGamePressed,
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 32),
            fontSize: 20,
            iconSize: 32,
          ),
          Spacer(),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:le_spawn_fr/core/theme/app.theme.dart';
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
          ElevatedButton(
            onPressed: widget.onScanFirstGamePressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryBackground,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 32),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.qr_code_scanner,
                  color: AppTheme.primaryText,
                  size: 32,
                ),
                const SizedBox(width: 16),
                Text(
                  'Scan ton premier jeu',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ),
          Spacer(),
        ],
      ),
    );
  }
}

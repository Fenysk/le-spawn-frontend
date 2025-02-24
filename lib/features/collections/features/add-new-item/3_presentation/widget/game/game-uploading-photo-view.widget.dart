import 'package:flutter/material.dart';

class GameUploadingPhotoView extends StatelessWidget {
  const GameUploadingPhotoView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text(
            'Analyzing photo...',
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}

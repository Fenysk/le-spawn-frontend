import 'package:flutter/material.dart';
import 'package:le_spawn_fr/core/constant/image.constant.dart';

class AppLoadingWidget extends StatelessWidget {
  const AppLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 50,
          children: const [
            Image(
              image: AssetImage(ImageConstant.logoTextTransparentPath),
              height: 80,
            ),
            SizedBox(
              height: 50,
              width: 50,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

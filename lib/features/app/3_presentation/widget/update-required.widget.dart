import 'package:flutter/material.dart';
import 'package:le_spawn_fr/core/constant/image.constant.dart';

class UpdateRequiredWidget extends StatelessWidget {
  const UpdateRequiredWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(30),
      color: Colors.red,
      child: const Center(
        child: Column(
          spacing: 16,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: AssetImage(ImageConstant.logoTextTransparentPath),
              height: 80,
            ),
            SizedBox(height: 20),
            Icon(
              Icons.system_update,
              size: 64,
              color: Colors.white,
            ),
            Text(
              'Y\'a du nouveau !',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              'Nous vous invitons à mettre à jour l\'application pour profiter des dernières fonctionnalités et améliorations.',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

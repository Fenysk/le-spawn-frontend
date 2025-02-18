import 'package:flutter/material.dart';

class SeparationWidget extends StatelessWidget {
  final EdgeInsets? padding;

  const SeparationWidget({
    super.key,
    this.padding = const EdgeInsets.all(8),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding!,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(child: Divider()),
          const SizedBox(width: 24),
          Text('OU'),
          const SizedBox(width: 24),
          Expanded(child: Divider()),
        ],
      ),
    );
  }
}

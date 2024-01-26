import 'package:flutter/material.dart';

import 'colors.dart';

class StarlinkSectionTitle extends StatelessWidget {
  final String title;
  final Alignment alignment;
  final double size;
  const StarlinkSectionTitle({
    super.key,
    required this.title,
    this.alignment = Alignment.topLeft,
    this.size = 14.0,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 1.0,
      ),
      child: Container(
        alignment: alignment,
        child:
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: StarlinkColors.white,
              fontSize: size,
              // bold
              fontFamily: 'DDIN-Bold',
            ),
          ),
      ),
    );
  }
}

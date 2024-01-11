import 'package:StarTickera/Core/Values/Colors.dart';
import 'package:flutter/material.dart';

class StarlinkSectionTitle extends StatelessWidget {
  final String title;
  final Alignment alignment;
  const StarlinkSectionTitle({
    super.key,
    required this.title,
    this.alignment = Alignment.topLeft,
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
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: StarlinkColors.white,
              fontSize: 14.0,
              // bold
              fontFamily: 'DDIN-Bold',
            ),
          ),
      ),
    );
  }
}

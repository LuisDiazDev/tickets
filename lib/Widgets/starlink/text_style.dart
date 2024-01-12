


import 'dart:ui';

import 'package:StarTickera/Core/Values/Colors.dart';
import 'package:flutter/material.dart';

class StarlinkTextStyle  extends TextStyle{
  StarlinkTextStyle({double size=16, Color color=StarlinkColors.white, bool isBold=true}) : super(
    fontFamily: isBold ? 'DDIN-Bold' : 'DDIN',
    fontSize: size,
    color: color,
    fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
  );
}

class StarlinkText extends Text{
  StarlinkText(super.text, {super.key, double size=16, Color color=StarlinkColors.white, bool isBold=true}) : super(
    style: StarlinkTextStyle(size: size, color: color, isBold: isBold),
  );
}
import 'package:flutter/material.dart';

class StarlinkColors {
  static const Color blue = Color(0xFF3e80e0);
  static const Color lightBlue = Color(0xff6ca9f6);
  static const Color red = Color(0xFFed524a);
  static const Color green = Color(0xFF6cce76);
  static const Color yellow = Color(0xFFffd554);
  static const Color bronze = Color(0xFFf2a055);
  static const Color white = Color(0xFFFFFFFF);
  static const Color midWhite = Color(0xFFdcdcdc);
  static const Color lightGray = Color(0xFFbababa);
  static const Color midLightGray = Color(0xFF828282);
  static const Color gray = Color(0xFF3a3a3a);
  static const Color midDarkGray = Color(0xFF272727);
  static const Color lowMidDarkGray = Color.fromARGB(255, 32, 32, 32);
  static const Color darkGray = Color(0xFF171717);
  static const Color lightBlack = Color.fromARGB(255, 6, 6, 6);
  static const Color black = Color(0xFF000000);
  static const Color transparent = Color(0x00000000);
}

// Define un enum con los tipos de tarjetas
enum InfoContextType { error, warning, info, success }

// Define un mapa para los colores asociados a cada tipo de tarjeta
const Map<InfoContextType, Color> cardColor = {
  InfoContextType.error: Color.fromARGB(100, 120, 30, 35),
  InfoContextType.warning: Color.fromARGB(100, 120, 90, 36),
  InfoContextType.info: StarlinkColors.gray,
  InfoContextType.success: Color.fromARGB(100, 0, 120, 0),
};

const Map<InfoContextType, Color> boxDecorationColor = {
  InfoContextType.error: Color.fromARGB(255, 191, 52, 61),
  InfoContextType.warning: Color.fromARGB(200, 210, 166, 51),
  InfoContextType.info: StarlinkColors.lightGray,
  InfoContextType.success: Color.fromARGB(150, 0, 255, 0),
};



const Map<InfoContextType, Color> textColor = {
  InfoContextType.error: Color.fromARGB(255, 255, 240, 240),
  InfoContextType.warning: Color.fromARGB(255, 255, 255, 240),
  InfoContextType.info: Color.fromARGB(255, 245, 245, 255),
  InfoContextType.success: Color.fromARGB(255, 240, 255, 240),
};

// Define un mapa para los iconos asociados a cada tipo de tarjeta
const Map<InfoContextType, IconData> cardIcon = {
  InfoContextType.error: Icons.warning_amber_outlined,
  InfoContextType.warning: Icons.error_outline,
  InfoContextType.info: Icons.info_outline,
  InfoContextType.success: Icons.check_circle_outline,
};

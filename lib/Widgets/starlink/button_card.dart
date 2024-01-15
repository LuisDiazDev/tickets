import 'package:flutter/material.dart';

import '../../Core/Values/Colors.dart';

// Define un enum con los tipos de tarjetas
enum CardType { error, warning, info, success }

// Define un mapa para los colores asociados a cada tipo de tarjeta
const Map<CardType, Color> _cardColor = {
  CardType.error: Colors.red,
  CardType.warning: Colors.orange,
  CardType.info: Colors.blue,
  CardType.success: Colors.green,
};

// Define un mapa para los iconos asociados a cada tipo de tarjeta
const Map<CardType, IconData> _cardIcon = {
  CardType.error: Icons.error_outline,
  CardType.warning: Icons.warning_amber_outlined,
  CardType.info: Icons.info_outline,
  CardType.success: Icons.check_circle_outline,
};


class StarlinkButtonCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Function() onPressed;
  final Icon? prefixIcon;
  final Icon? suffixIcon;

  const StarlinkButtonCard({
    super.key,
    required this.title,
    required this.onPressed,
    this.subtitle,
    this.prefixIcon,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.0), // Valor más pequeño para menos redondeo
        ),
        color: StarlinkColors.lowMidDarkGray,
        child: ListTile(
            leading: prefixIcon,
            title: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: 'DDIN-Bold',
              ),
            ),
            subtitle:subtitle != null ?  Text(
              subtitle!,
              style: const TextStyle(
                color: StarlinkColors.midLightGray,
                fontFamily: 'DDIN',
              ),
            ) : null,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                suffixIcon ?? Container(),
                const SizedBox(width: 8),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white.withAlpha(200),
                  size: 18,
                ),
              ],
            )
        ),
      ),
    );
  }
}

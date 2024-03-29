import 'package:flutter/material.dart';
import 'colors.dart';

// Define un enum con los tipos de tarjetas
enum ButtonCardType { error, warning, info, success }

class StarlinkButtonCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Function() onPressed;
  final Icon? prefixIcon;
  final Widget? suffixWidget;

  const StarlinkButtonCard({
    super.key,
    required this.title,
    required this.onPressed,
    this.subtitle,
    this.prefixIcon,
    this.suffixWidget,
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
                suffixWidget ?? Container(),
                Visibility(visible: suffixWidget == null, child: const SizedBox(width: 8)),
                Visibility(visible: suffixWidget == null, child: Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white.withAlpha(200),
                  size: 18,
                )),
                Visibility(visible: suffixWidget != null, child: Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white.withAlpha(200),
                  size: 10,
                )),

              ],
            )
        ),
      ),
    );
  }
}

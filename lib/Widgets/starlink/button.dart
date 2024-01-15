import 'package:flutter/material.dart';

import '../../Core/Values/Colors.dart';

enum ButtonType {
  primary,
  secondary,
  outlined,
  transparent,
  destructive,
}

class StarlinkButton extends StatelessWidget {
  final ButtonType type;
  final bool isEnabled;
  final String text;
  final VoidCallback? onPressed;
  final Icon? icon;

  const StarlinkButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type=ButtonType.primary,
    this.isEnabled = true,
    this.icon,
  });

  Color _getBackgroundColor(ButtonType style, bool isEnabled) {
    if (!isEnabled) return StarlinkColors.midDarkGray; // Disabled color
    switch (style) {
      case ButtonType.primary:
        return StarlinkColors.white; // Replace with actual color
      case ButtonType.secondary:
        return StarlinkColors.gray; // Replace with actual color
      case ButtonType.outlined:
        return StarlinkColors.transparent; // Replace with actual color
      case ButtonType.transparent:
        return StarlinkColors.transparent; // Replace with actual color
      case ButtonType.destructive:
        return StarlinkColors.red; // Replace with actual color
      default:
        return StarlinkColors.transparent;
    }
  }

  ButtonStyle _buttonStyle(ButtonType style, bool isEnabled) {
    var backgroundColor = _getBackgroundColor(style, isEnabled);
    var foregroundColor = isEnabled ? Colors.white : Colors.grey[500];

    return ElevatedButton.styleFrom(
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(6.0)),
        side: BorderSide(
          color: Colors.white,
          width: 2.0,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    late Color textColor;
    if (type == ButtonType.primary) {
      textColor = StarlinkColors.black;
    } else if (type == ButtonType.transparent) {
      textColor = StarlinkColors.white;
    } else {
      textColor = StarlinkColors.white;
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 1),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              style: _buttonStyle(type, isEnabled),
              onPressed: isEnabled ? onPressed : null,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  text,
                  style: TextStyle(
                    // bold
                    fontFamily: 'DDin-Bold',
                    fontSize: 14,
                    color: isEnabled

                        ? textColor
                        : StarlinkColors.midLightGray, // Example colors
                  ),
                ),
              ),
            ),
          ),
          Visibility(
            visible: icon != null,
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: icon ?? Container()
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:StarTickera/Widgets/starlink/button.dart';
import 'package:StarTickera/Widgets/starlink/card.dart';
import 'package:StarTickera/Widgets/starlink/text_style.dart';
import 'package:flutter/material.dart';

import '../Core/Values/Colors.dart';

class SnackBarCustom {
  static snackBarCustom(
      {required String title,
        required Function onTap,
        required String titleAction,
        required CardType type,
      }) {
    return SnackBar(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          StarlinkCard(
            title: title.toUpperCase(),
            type: type,
            message: titleAction,
          ),
          Text(title),
          const Spacer(),
          StarlinkButton(
            text: titleAction.toUpperCase(),
            onPressed: () => onTap(),
          )
        ],
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(9),
      ),
    );
  }

  static snackBarStatusCustom({
    required String title,
    required Function onTap,
    required String subtitle,
    required Function hideSnackBar,
    required CardType type,
  }) {
    return SnackBar(
      padding: EdgeInsets.zero,
      content: ClipRRect(
        borderRadius: BorderRadius.circular(9),
        child: GestureDetector(
          onTap: () {
            hideSnackBar();
            onTap();
          },
          child: StarlinkCard(
            title: title,
            message: subtitle,
            type: type,
          ),
        )
      ),
    );
  }
}

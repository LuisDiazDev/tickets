import 'package:StarTickera/Widgets/starlink/button.dart';
import 'package:StarTickera/Widgets/starlink/card.dart';
import 'package:StarTickera/Widgets/starlink/colors.dart';
import 'package:StarTickera/Widgets/starlink/text_style.dart';
import 'package:flutter/material.dart';


class SnackBarCustom {
  static snackBarCustom(
      {required String title,
        required Function onTap,
        required String titleAction,
        required InfoContextType type,
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
          StarlinkText(title),
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
    required InfoContextType type,
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

import 'package:StarTickera/Widgets/starlink/button.dart';
import 'package:StarTickera/Widgets/starlink/text_style.dart';
import 'package:flutter/material.dart';

import '../Core/Values/Colors.dart';

class DialogWidget {
  static dialogInfo({
    required String title,
    required String content,
    required BuildContext context,
    Function? onTap,
    String titleAction = "OK",
  }) {
    return AlertDialog(
      title: StarlinkText(
        title,
        size: 22,
        isBold: true,
      ),
      content: StarlinkText(content),
      titlePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      contentPadding:
          const EdgeInsets.only(top: 0, bottom: 10, left: 20, right: 20),
      backgroundColor: StarlinkColors.darkGray,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      actionsPadding: const EdgeInsets.only(top: 30,bottom: 10, right: 20, left: 20),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        StarlinkButton(
            onPressed: () {
              if (onTap != null) {
                onTap();
              }else{
                Navigator.pop(context);
              }
            },
            text: titleAction.toUpperCase(),
        ),
      ],
    );
  }
}

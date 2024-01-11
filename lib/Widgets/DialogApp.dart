import 'package:flutter/material.dart';

import '../Core/Values/Colors.dart';

class DialogWidget {
  static dialogInfo({
    required String title,
    required String content,
    required BuildContext context,
    String titleAction = "Ok",
  }) {
    return AlertDialog(

      title: Text(
        title,
        style: const TextStyle(
            fontFamily: 'poppins_semi_bold',
            fontSize: 22,
            color: ColorsApp.secondary,
            fontWeight: FontWeight.w400),
      ),
      content: Text(content,
          style: const TextStyle(
              fontFamily: 'poppins_regular',
              fontSize: 18,
              color: ColorsApp.secondary,
              fontWeight: FontWeight.w400)),
      titlePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      contentPadding:
          const EdgeInsets.only(top: 0, bottom: 10, left: 20, right: 20),
      backgroundColor: ColorsApp.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      actionsPadding: const EdgeInsets.only(
        right: 20,
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(titleAction))
      ],
    );
  }
}

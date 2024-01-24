import 'package:StarTickera/Widgets/starlink/button.dart';
import 'package:StarTickera/Widgets/starlink/text_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../Modules/Alerts/AlertCubit.dart';

class StarlinkDialog {
  static show(
      {required BuildContext context,
        required final String title,
        required final String message,
        required final AlertType type,
        required final Map<String, dynamic>? metadata,
        required final List<Widget>? actions,
        required final Exception? error,
        required final Function? onTap}) async {


    return AlertDialog(
      title: StarlinkText(
        title,
        size: 22,
        isBold: true,
      ),
      content: StarlinkText(message),
      titlePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      contentPadding:
          const EdgeInsets.only(top: 0, bottom: 10, left: 20, right: 20),
      backgroundColor: Colors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      actionsPadding: const EdgeInsets.only(top: 30,bottom: 10, right: 20, left: 20),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        Visibility(
          visible: actions != null,
          child: StarlinkButton(
            text: "OK",
            onPressed: () {
              if (onTap != null) {
                onTap();
              }else{
                Navigator.pop(context);
              }
            },
          ),
        ),
        Visibility(
          visible: actions != null,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: actions ?? [],
          )
        ),
      ],
    );
  }
}

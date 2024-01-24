import 'package:StarTickera/Widgets/starlink/button.dart';
import 'package:StarTickera/Widgets/starlink/text_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../Modules/Alerts/AlertCubit.dart';
import 'colors.dart';

class StarlinkDialog {
  static Future<T?> show<T>(
      {required BuildContext context,
      required final String title,
      required final String message,
      required final AlertType type,
      required final Map<String, dynamic>? metadata, // TODO usar metadata
      required final List<Widget>? actions,
      required final Exception? error,
      required final Function? onTap}) async {
    var d = _buildDialog(title, message, actions, onTap, context);
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return d;
      },
    );
  }

  static AlertDialog _buildDialog(String title, String message,
      List<Widget>? actions, Function? onTap, BuildContext context) {
    return AlertDialog(
      title: StarlinkText(
        title,
        size: 20,
        isBold: true,
      ),
      content: StarlinkText(message, size: 16, isBold: false),
      titlePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      contentPadding:
          const EdgeInsets.only(top: 0, bottom: 10, left: 20, right: 20),
      backgroundColor: StarlinkColors.gray,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(2),
      ),
      // actionsPadding: const EdgeInsets.only(top: 30,bottom: 10, right: 20, left: 20),
      actionsAlignment: MainAxisAlignment.end,
      actionsPadding: const EdgeInsets.only(bottom: 10, left: 100, right: 20),
      actions: [
        if (actions == null)
          StarlinkDialogAction(
            text: "OK",
            onPressed: () {
              Navigator.pop(context);
            },
            type: ActionType.info,
          ),
        if (actions != null) ...actions,
      ],
    );
  }
}

enum ActionType { info, destructive }

class StarlinkDialogAction extends StatelessWidget {
  final String text;
  final ActionType type;
  final VoidCallback? onPressed;

  const StarlinkDialogAction(
      {super.key, required this.text, required this.type, this.onPressed});

  @override
  Widget build(BuildContext context) {
    late Color textColor;
    if (type == ActionType.destructive) {
      textColor = StarlinkColors.red;
    } else {
      textColor = StarlinkColors.blue;
    }
    return GestureDetector(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.only(
          left: 40.0,
          top: 20,
          bottom: 10,
        ),
        child: StarlinkText(
          text.toUpperCase(),
          color: textColor,
          size: 16,
          isBold: false,
        ),
      ),
    );
  }
}

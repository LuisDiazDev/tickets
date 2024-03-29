
import 'dart:developer';

import 'package:flutter/cupertino.dart';

import '../../Widgets/starlink/button.dart';
import '../../Widgets/starlink/dialog.dart';
import '../../Widgets/starlink/percentage_progress_circle.dart';
import '../Alerts/alert_cubit.dart';

SingleChildScrollView buildDialogs(BuildContext context) {
  return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(
            child: Padding(
              padding: EdgeInsets.only(top: 20, bottom: 20),
              child: StarlinkProgressCircle(percent: 50),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: StarlinkButton(
              text: "Show Success Dialog",
              onPressed: () {
                StarlinkDialog.show(
                    context: context,
                    title: "SUCCESS",
                    message: "This is a success message",
                    type: AlertType.success,
                    actions: [
                      StarlinkDialogAction(
                        text: "CANCEL",
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        type: ActionType.destructive,
                      ),
                      StarlinkDialogAction(
                        text: "OK",
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        type: ActionType.info,
                      ),
                    ],
                    error: Exception("Error"),
                    onTap: () {
                      log("Tapped");
                    });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: StarlinkButton(
              text: "Show Info Dialog",
              onPressed: () {
                StarlinkDialog.show(
                    context: context,
                    title: "INFO",
                    message: "This is a info message",
                    type: AlertType.info,
                    actions: [],
                    onTap: () {
                      log("Tapped");
                    });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: StarlinkButton(
              text: "Show Warning Dialog",
              onPressed: () {
                StarlinkDialog.show(
                    context: context,
                    title: "SOME WARNING",
                    message: "This is a warning message",
                    type: AlertType.warning,
                    actions: [],
                    onTap: () {
                      log("Tapped");
                    });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: StarlinkButton(
              text: "Show Error Dialog",
              onPressed: () {
                StarlinkDialog.show(
                    context: context,
                    title: "SOME ERROR",
                    message: "This is a error message",
                    type: AlertType.error,
                    actions: [],
                    onTap: () {
                      log("Tapped");
                    });
              },
            ),
          ),
        ],
      ));
}

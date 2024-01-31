import 'package:startickera/Widgets/starlink/colors.dart';
import 'package:flutter/material.dart';
import '../../Data/Services/navigator_service.dart';

class ProgressDialogUtils {
  static bool isProgressVisible = false;

  ///common method for showing progress dialog
  static void showProgressDialog(
      {BuildContext? context, isCancellable = false}) async {
      showDialog(
          barrierDismissible: isCancellable,
          context: NavigatorService.navigatorKey.currentState!.overlay!.context,
          builder: (BuildContext context) {
            return const Center(
              child: CircularProgressIndicator.adaptive(
                strokeWidth: 8,
                valueColor: AlwaysStoppedAnimation<Color>(
                  StarlinkColors.white,
                ),
              ),
            );
          });
      isProgressVisible = true;

  }

  ///common method for hiding progress dialog
  static void hideProgressDialog() {
    if (isProgressVisible) {
      Navigator.pop(
          NavigatorService.navigatorKey.currentState!.overlay!.context);
    }
    isProgressVisible = false;
  }
}

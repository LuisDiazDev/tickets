import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import '../../../Data/Provider/MkProvider.dart';
import '../../../Data/Services/navigator_service.dart';
import '../../../Widgets/starlink/progress_circle.dart';

class IpSearch {
  static Future showDialogSearch(
      {BuildContext? context, isCancellable = true, String ip = ""}) async {
    if (NavigatorService.navigatorKey.currentState?.overlay?.context != null) {
      final StreamController<String> progressController = StreamController<String>();
      MkProvider provider = MkProvider();
      provider.findMikrotikInLocalNetwork(progressController.stream).then((value) =>{
        log("IpSearch: $value"),
      });
      return showDialog(
        barrierDismissible: false,
        context: NavigatorService.navigatorKey.currentState!.overlay!.context,
        builder: (context) {
          return StarlinkProgressCircle(
            percent: 50,
          );
        },
      );
    }
  }
}


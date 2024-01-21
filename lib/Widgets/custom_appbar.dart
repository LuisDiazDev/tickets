import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

import '../Core/Values/Colors.dart';

AppBar customAppBar({String title="",Widget? action,Function()? saved}){
  return AppBar(
    title: Text(title),
    actions: [
      action ?? Container(),
    ],
    backgroundColor: StarlinkColors.black,
    leading: Builder(
      builder: (BuildContext context) {
        return IconButton(
          icon: const Icon(
            EvaIcons.menu2Outline,
            color: StarlinkColors.white,
            size: 30,
          ),
          onPressed: ()async {
            if(saved!=null){
              await saved();
            }
            Scaffold.of(context).openDrawer();
          },
          tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
        );
      },
    ),
  );
}


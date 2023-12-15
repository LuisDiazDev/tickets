import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

import '../Core/Values/Colors.dart';

AppBar customAppBar({String title=""}){
  return AppBar(
    title: Text(title),
    leading: Builder(
      builder: (BuildContext context) {
        return IconButton(
          icon: const Icon(
            EvaIcons.menu2Outline,
            color: ColorsApp.primary,
            size: 30,
          ),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
          tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
        );
      },
    ),
  );
}


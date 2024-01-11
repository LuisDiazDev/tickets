import 'package:flutter/material.dart';

import '../../../Core/Values/Colors.dart';

class TileDrawer extends StatelessWidget {
  final IconData icon;
  final String title;
  final Function()? onTap;

  const TileDrawer(
      {super.key,
      required this.icon,
      required this.title,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: StarlinkColors.white),
          onTap: onTap,
          title: Text(
            title,
            style: const TextStyle(
              color: StarlinkColors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              fontFamily: "DDIN-Bold",
            ),
          ),
        ),
        const Divider(
          indent: 20,
          endIndent: 20,
          height: 2,
          color: Colors.black,
        ),
      ],
    );
  }
}

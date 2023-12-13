
import 'package:flutter/material.dart';
import 'package:tickets/Core/Values/Colors.dart';

class TileDrawer extends StatelessWidget {

  final IconData icon;
  final Color colorIcon;
  final String title;
  final Function()? onTap;

  const TileDrawer({super.key, required this.icon, this.colorIcon = ColorsApp.secondary, required this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon,color: colorIcon),
          onTap: onTap,
          title: Text(title,style: const TextStyle(fontSize: 22,fontWeight: FontWeight.w200),),
        ),
        const Divider(indent: 20,endIndent: 20,height: 2,color: Colors.black,),
      ],
    );
  }
}

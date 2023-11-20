
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:tickets/Core/Routes/Route.dart';
import 'package:tickets/Core/Values/Colors.dart';
import 'package:tickets/Core/utils/navigator_service.dart';

class DrawerCustom extends StatelessWidget {
  const DrawerCustom({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          Container(
            color: ColorsApp.secondary.withOpacity(.8),
            width: double.infinity,
            child: const Column(
              children: [
                SizedBox(height: 100,),
                Text("Sistema Ticket",style: TextStyle(
                    color: ColorsApp.primary,
                    fontFamily: 'poppins_bold',
                    fontWeight: FontWeight.w600,
                    fontSize: 26
                ),),
                SizedBox(height: 40,),
              ],
            ),
          ),
          SizedBox(height: 12,),
          ListTile(
            leading: const Icon(EvaIcons.home,color: ColorsApp.secondary,),
            onTap: (){
              NavigatorService.pushNamedAndRemoveUntil(Routes.home);
            },
            title: const Text("Mis Tickets",style: TextStyle(fontSize: 22,fontWeight: FontWeight.w200),),
          ),
          Divider(indent: 20,endIndent: 20,height: 2,color: Colors.black,),
          ListTile(
            leading: const Icon(EvaIcons.pricetags,color: ColorsApp.secondary,),
            onTap: (){
              NavigatorService.pushNamedAndRemoveUntil(Routes.profiles);
            },
            title: const Text("Mis Planes",style: TextStyle(fontSize: 22,fontWeight: FontWeight.w200),),
          ),
          Divider(indent: 20,endIndent: 20,height: 2,color: Colors.black,),
          ListTile(
            leading: const Icon(EvaIcons.settings,color: ColorsApp.secondary,),
            onTap: (){
              NavigatorService.pushNamedAndRemoveUntil(Routes.settings);
            },
            title: const Text("Configuracion",style: TextStyle(fontSize: 22,fontWeight: FontWeight.w200),),
          ),
          Divider(indent: 20,endIndent: 20,height: 2,color: Colors.black,),
        ],
      ),
    );
  }
}

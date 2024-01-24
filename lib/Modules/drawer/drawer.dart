import 'package:StarTickera/Core/localization/app_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../Data/Services/navigator_service.dart';
import '../../Routes/Route.dart';
import '../../Widgets/starlink/colors.dart';
import '../../Widgets/starlink/text_style.dart';
import '../Session/SessionCubit.dart';
import 'widget/header_drawer.dart';
import 'widget/tiled_drawer.dart';

class DrawerCustom extends StatelessWidget {
  const DrawerCustom({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: StarlinkColors.lightBlack,
      child: ListView(
        children: [
          Container(
            width: double.infinity,
            child: const Column(
              children: [
                SizedBox(height: 100),
                Gap(45),
              ],
            ),
          ),
          TileDrawer(
            icon: Icons.money,
            title: "VENDER TICKETS",
            onTap: (){
              NavigatorService.pushNamedAndRemoveUntil(Routes.home);
            },
          ),
          ExpansionTile(
              leading: const Icon(EvaIcons.peopleOutline, color: StarlinkColors.white),
              backgroundColor: StarlinkColors.darkGray,
              title: StarlinkText(
                "CLIENTES",
                size: 22,
                isBold: true,
              ),
              collapsedIconColor: StarlinkColors.white,
              iconColor:  StarlinkColors.white,
            children: [
              TileDrawer(
                icon: EvaIcons.personAddOutline,
                title: "LISTA DE CLIENTES",
                onTap: (){
                  NavigatorService.pushNamedAndRemoveUntil(Routes.clientList);
                },
              ),
              TileDrawer(
                icon: EvaIcons.pricetagsOutline,
                title: "PLANES CLIENTES",
                onTap: (){
                  NavigatorService.pushNamedAndRemoveUntil(Routes.clientProfile);
                },
              ),
              TileDrawer(
                icon: EvaIcons.list,
                title: "MIS TICKETS",
                onTap: (){
                  NavigatorService.pushNamedAndRemoveUntil(Routes.tickets);
                },
              ),
            ],
          ),
          // TileDrawer(
          //   icon: EvaIcons.bookOpen,
          //   title: "REPORTES",
          //   onTap: (){
          //     NavigatorService.pushNamedAndRemoveUntil(Routes.report);
          //   },
          // ),
          TileDrawer(
            icon: EvaIcons.pricetags,
            title: "services_drawer".tr,
            onTap: (){
              NavigatorService.pushNamedAndRemoveUntil(Routes.profiles);
            },
          ),
          TileDrawer(
            icon: Icons.settings,
            title: "configuration".tr,
            onTap: (){
              NavigatorService.pushNamedAndRemoveUntil(Routes.settings);
            },
          ),
          TileDrawer(
            icon: EvaIcons.logOutOutline,
            title: "CERRAR SESIÓN",
            onTap: () async {
              final sessionCubit = BlocProvider.of<SessionCubit>(context);
              sessionCubit.exitSession();
            },
          ),
        ],
      ),
    );
  }
}

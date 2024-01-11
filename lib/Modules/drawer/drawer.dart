import 'package:StarTickera/Core/Values/Colors.dart';
import 'package:StarTickera/Core/localization/app_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import '../../Core/Values/Enums.dart';
import '../../Data/Services/navigator_service.dart';
import '../../Routes/Route.dart';
import '../Session/SessionCubit.dart';
import 'widget/header_drawer.dart';
import 'widget/tiled_drawer.dart';

class DrawerCustom extends StatelessWidget {
  const DrawerCustom({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: StarlinkColors.black,
      child: Column(
        children: [
          const HeaderDrawer(),
          TileDrawer(
            icon: Icons.money,
            title: "VENDER TICKETS",
            onTap: (){
              NavigatorService.pushNamedAndRemoveUntil(Routes.home);
            },
          ),
          TileDrawer(
            icon: EvaIcons.list,
            title: "list_tickets_drawer".tr,
            onTap: (){
              NavigatorService.pushNamedAndRemoveUntil(Routes.tickets);
            },
          ),
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
              sessionCubit.changeState(
                sessionCubit.state.copyWith(
                  sessionStatus: SessionStatus.finish
                )
              );
            },
          ),
        ],
      ),
    );
  }
}

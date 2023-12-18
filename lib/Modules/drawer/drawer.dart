import 'package:TicketOs/Core/localization/app_localization.dart';
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
      backgroundColor: Colors.white,
      child: Column(
        children: [
          const HeaderDrawer(),
          TileDrawer(
            icon: EvaIcons.home,
            title: "home_drawer".tr,
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
            icon: EvaIcons.settings,
            title: "configuration".tr,
            onTap: (){
              NavigatorService.pushNamedAndRemoveUntil(Routes.settings);
            },
          ),
          TileDrawer(
            icon: EvaIcons.navigation2Outline,
            title: "Activar Internet",
            onTap: () async {
              final sessionCubit = BlocProvider.of<SessionCubit>(context);
              var url = Uri.parse('http://${sessionCubit.state.cfg?.dnsNamed}/login?user=admin&password=a');
              if (!await launchUrl(url,webViewConfiguration: const WebViewConfiguration(
                enableJavaScript: true,
                enableDomStorage: true
              ))) {
                throw Exception('Could not launch $url');
              }
            },
          ),
          TileDrawer(
            icon: EvaIcons.logOutOutline,
            title: "Cerrar Session",
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

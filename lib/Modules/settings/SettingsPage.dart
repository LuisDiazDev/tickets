import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:tickets/Core/Routes/Route.dart';
import 'package:tickets/Core/utils/navigator_service.dart';
import 'package:tickets/models/config_model.dart';
import '../../Core/Values/Colors.dart';
import '../../Core/Widgets/custom_text_field.dart';
import '../Session/SessionCubit.dart';
import '../drawer/drawer.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final sessionBloc = BlocProvider.of<SessionCubit>(context);
    return Scaffold(
      backgroundColor: ColorsApp.grey.withOpacity(.9),
      drawer: const DrawerCustom(),
      appBar: AppBar(
        title: const Text("Configuracion"),
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
      ),
      body: Container(
        color: Colors.transparent,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
            child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            CustomTextField(
              initialValue: sessionBloc.state.cfg?.host ?? "",
              onChanged: (str) {
                sessionBloc.changeState(sessionBloc.state.copyWith(
                    configModel: ConfigModel(
                        password: sessionBloc.state.cfg?.password ?? "",
                        host: str ?? "",
                        user: sessionBloc.state.cfg?.user ?? "")));
              },
              title: "Host",
            ),
            CustomTextField(
              initialValue: sessionBloc.state.cfg?.user ?? "",
              onChanged: (str) {
                sessionBloc.changeState(sessionBloc.state.copyWith(
                    configModel: ConfigModel(
                        password: sessionBloc.state.cfg?.password ?? "",
                        host: sessionBloc.state.cfg?.password ?? "",
                        user: str ?? "")));
              },
              title: "User",
            ),
            CustomTextField(
              initialValue: sessionBloc.state.cfg?.password ?? "",
              onChanged: (str) {
                sessionBloc.changeState(sessionBloc.state.copyWith(
                    configModel: ConfigModel(
                        password: str ?? "",
                        host: sessionBloc.state.cfg?.password ?? "",
                        user: sessionBloc.state.cfg?.user ?? "")));
              },
              title: "Password",
            ),
            const Gap(8),
            Row(
              children: [
                const Spacer(),
                MaterialButton(
                  color: ColorsApp.secondary,
                  onPressed: () {
                    sessionBloc.changeState(sessionBloc.state
                        .copyWith(configModel: ConfigModel.defaultConfig));
                    NavigatorService.pushNamedAndRemoveUntil(Routes.settings);
                  },
                  child: const Text("Reset",
                      style: TextStyle(
                          color: ColorsApp.primary,
                          fontFamily: 'poppins_normal',
                          fontSize: 18)),
                ),
                const Gap(8),
              ],
            )
          ],
        )),
      ),
    );
  }
}

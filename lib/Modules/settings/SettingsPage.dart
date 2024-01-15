import 'dart:io';

import 'package:StarTickera/Core/localization/app_localization.dart';
import 'package:StarTickera/Widgets/starlink/button.dart';
import 'package:StarTickera/Widgets/starlink/section_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import '../../Core/Values/Colors.dart';
import '../../Core/utils/progress_dialog_utils.dart';
import '../../Data/Provider/virtualTicketRepository.dart';
import '../../Widgets/custom_appbar.dart';
import '../../Widgets/starlink/card.dart';
import '../../Widgets/starlink/text_field.dart';
import '../Alerts/AlertCubit.dart';
import '../Session/SessionCubit.dart';
import '../drawer/drawer.dart';
import 'print_setting.dart';

import 'dart:convert';
import 'dart:typed_data';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final sessionBloc = BlocProvider.of<SessionCubit>(context);
    final alertBloc = BlocProvider.of<AlertCubit>(context);

    return BlocBuilder<SessionCubit, SessionState>(builder: (context, state) {
      return Scaffold(
        backgroundColor: StarlinkColors.black.withOpacity(.9),
        drawer: const DrawerCustom(),
        appBar: customAppBar(title: "title_configuration".tr),
        body: Container(
          color: Colors.transparent,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const StarlinkSectionTitle(
                title: "TICKETS VIRTUALES",
              ),
              const StarlinkCard(
                type: CardType.info,
                title: "Tickets Virtuales",
                message:
                    "Son tickets de puedes imprimir masivamente en una impresora común de tinta.\n"
                    "Son mas rápidos de imprimir y no necesitan una impresora térmica (tickera)",
              ),
              StarlinkButton(
                text: "GENERAR TICKETS VIRTUALES",
                onPressed: () async {
                  ProgressDialogUtils.showProgressDialog();
                  generateTickets(10);
                  sessionBloc.backUp(alertBloc);
                },
              ),
              /////////////////////////////
              const Gap(40),
              PrintSettings(
                sessionBloc: sessionBloc,
                alertCubit: alertBloc,
              ),

              //////////////////
              const Gap(16),
              const StarlinkSectionTitle(
                title: "INFORMACIÓN DEL MIKROTIK",
              ),
              StarlinkTextField(
                initialValue: state.cfg?.identity ?? "",
                onChanged: (str) {
                  sessionBloc.changeState(state.copyWith(
                      configModel: state.cfg!.copyWith(identity: str)));
                },
                title: "Identidad",
                textHint: "Nombre del Mikrotik",
              ),
              StarlinkTextField(
                initialValue: state.cfg?.host ?? "",
                onChanged: (str) {
                  sessionBloc.changeState(state.copyWith(
                      configModel: state.cfg!.copyWith(host: str)));
                },
                title: "Mikrotik",
                textHint: "Dirección IP de tu Mikrotik",
              ),
              StarlinkTextField(
                initialValue: state.cfg?.user ?? "",
                onChanged: (str) {
                  sessionBloc.changeState(state.copyWith(
                      configModel: state.cfg!.copyWith(user: str)));
                },
                title: "Usuario",
                textHint: "Usuario de tu Mikrotik",
              ),
              StarlinkTextField(
                initialValue: state.cfg?.password ?? "",
                onChanged: (str) {
                  sessionBloc.changeState(state.copyWith(
                      configModel: state.cfg!.copyWith(password: str)));
                },
                title: "Contraseña",
                textHint: "Contraseña de tu Mikrotik",
              ),
              StarlinkTextField(
                initialValue: state.cfg?.dnsNamed ?? "",
                onChanged: (str) {
                  sessionBloc.changeState(state.copyWith(
                      configModel: state.cfg!
                          .copyWith(dnsNamed: str ?? "")));
                },
                title: "Página Hotspot",
                textHint: "Ejemplo: wifi.com",
              ),
              const Gap(8),
              StarlinkButton(
                text: "COMPROBAR CONEXIÓN",
                onPressed: () async {
                  await sessionBloc.checkConnection(alertBloc);
                },
              ),
              const Gap(16),
              StarlinkButton(
                text: "RESTABLECER MIKROTIK",
                type: ButtonType.destructive,
                onPressed: () async {
                  ProgressDialogUtils.showProgressDialog();
                  sessionBloc.backUp(alertBloc);
                },
              ),
              const Gap(16),
            ],
          )),
        ),
      );
    });
  }

  Image imageFromBase64String(String base64String) {
    return Image.memory(base64Decode(base64String));
  }

  Uint8List dataFromBase64String(String base64String) {
    return base64Decode(base64String);
  }

  String base64String(Uint8List data) {
    return base64Encode(data);
  }
}

Future<File> writeToFile(ByteData data, String path) {
  final buffer = data.buffer;
  return File(path).writeAsBytes(buffer.asUint8ClampedList());
}

/*
*
* */

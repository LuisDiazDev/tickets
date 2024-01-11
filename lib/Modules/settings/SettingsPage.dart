import 'dart:io';

import 'package:StarTickera/Core/localization/app_localization.dart';
import 'package:StarTickera/Widgets/starlink/button.dart';
import 'package:StarTickera/Widgets/starlink/section_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:path_provider/path_provider.dart';
import '../../Core/Values/Colors.dart';
import '../../Core/utils/progress_dialog_utils.dart';
import '../../Data/Provider/virtualTicketRepository.dart';
import '../../Data/Services/ftp_service.dart';
import '../../Widgets/custom_appbar.dart';
import '../../Widgets/custom_text_field.dart';
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
              const Gap(20),
              PrintSettings(
                sessionBloc: sessionBloc,
                alertCubit: alertBloc,
              ),
              const StarlinkSectionTitle(
                title: "INFORMACIÓN",
              ),
              StarlinkTextField(
                initialValue: sessionBloc.state.cfg?.dnsNamed ?? "",
                onChanged: (str) {
                  sessionBloc.changeState(sessionBloc.state.copyWith(
                      configModel: sessionBloc.state.cfg!
                          .copyWith(dnsNamed: str ?? "")));
                },
                title: "Página Hotspot",
                textHint: "Ejemplo: wifi.com",
              ),
              const Gap(16),
              const StarlinkSectionTitle(
                title: "CONEXIÓN",
              ),
              StarlinkTextField(
                initialValue: sessionBloc.state.cfg?.host ?? "",
                onChanged: (str) {
                  sessionBloc.changeState(sessionBloc.state.copyWith(
                      configModel: sessionBloc.state.cfg!.copyWith(host: str)));
                },
                title: "Mikrotik",
                textHint: "Dirección IP de tu Mikrotik",
              ),
              StarlinkTextField(
                initialValue: sessionBloc.state.cfg?.user ?? "",
                onChanged: (str) {
                  sessionBloc.changeState(sessionBloc.state.copyWith(
                      configModel: sessionBloc.state.cfg!.copyWith(user: str)));
                },
                title: "Usuario",
                textHint: "Usuario de tu Mikrotik",
              ),
              StarlinkTextField(
                initialValue: sessionBloc.state.cfg?.password ?? "",
                onChanged: (str) {
                  sessionBloc.changeState(sessionBloc.state.copyWith(
                      configModel:
                          sessionBloc.state.cfg!.copyWith(password: str)));
                },
                title: "Contraseña",
                textHint: "Contraseña de tu Mikrotik",
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
              const StarlinkSectionTitle(
                title: "TICKETS VIRTUALES",
              ),
              const CustomCard(
                type: CardType.info,
                title: "Tickets Virtuales",
                message:
                    "Son tickets de puedes imprimir masivamente en una impresora común de tinta.\n"
                        "Son mas rapidos de imprimir y no necesitan una impresora térmica (tickera)",
              ),
              StarlinkButton(
                text: "GENERAR TICKETS VIRTUALES",
                onPressed: () async {
                  ProgressDialogUtils.showProgressDialog();
                  generateTickets(10);
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

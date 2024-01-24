import 'dart:developer';
import 'dart:io';
import 'package:StarTickera/Core/localization/app_localization.dart';
import 'package:StarTickera/Data/database/databse_firebase.dart';
import 'package:StarTickera/Modules/settings/widgets/form_new_password.dart';
import 'package:StarTickera/Widgets/starlink/button.dart';
import 'package:StarTickera/Widgets/starlink/section_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import '../../Core/utils/progress_dialog_utils.dart';
import '../../Data/Provider/virtualTicketRepository.dart';
import '../../Widgets/custom_appbar.dart';
import '../../Widgets/starlink/button_group.dart';
import '../../Widgets/starlink/card.dart';
import '../../Widgets/starlink/colors.dart';
import '../../Widgets/starlink/text_field.dart';
import '../Alerts/AlertCubit.dart';
import '../Session/SessionCubit.dart';
import '../drawer/drawer.dart';
import 'widgets/print_setting.dart';

import 'dart:convert';
import 'dart:typed_data';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String _contact = "", _name = "";

  @override
  void initState() {
    final sessionBloc = BlocProvider.of<SessionCubit>(context);
    // TODO: implement initState
    _name = sessionBloc.state.cfg?.nameLocal ?? "";
    _contact = sessionBloc.state.cfg?.contact ?? "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final sessionBloc = BlocProvider.of<SessionCubit>(context);
    final alertBloc = BlocProvider.of<AlertCubit>(context);

    return BlocBuilder<SessionCubit, SessionState>(builder: (context, state) {
      DatabaseFirebase databaseFirebase = DatabaseFirebase();
      return Scaffold(
        backgroundColor: StarlinkColors.black.withOpacity(.9),
        drawer: const DrawerCustom(),
        appBar:
            customAppBar(title: "title_configuration".tr, saved: () async {}),
        body: Container(
          color: Colors.transparent,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child:
               StarlinkButtonGroup(
            labels: const ["Impresora", "Mikrotik", "Otros"],
            // crossAxisAlignment: CrossAxisAlignment.start,
            widgets: [
              buildPrinterSettings(sessionBloc, alertBloc),
              buildMikrotikSettings(state, sessionBloc, context, alertBloc),
              buildCustomerSettings(
                  state, sessionBloc, alertBloc, databaseFirebase),
            ],
            onChanged: (int) {
              log("Index: $int");
            },
          )),
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

Widget buildPrinterSettings(sessionBloc, alertBloc) {
  return SingleChildScrollView(
    child: Column(
      children: [
        /////////////////////////////
        PrintSettings(
          sessionBloc: sessionBloc,
          alertCubit: alertBloc,
        ),
        const Gap(40),
        const StarlinkSectionTitle(
          title: "TICKETS VIRTUALES",
        ),
        const StarlinkCard(
          type: InfoContextType.info,
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
            // sessionBloc.backUp(alertBloc);
          },
        ),
      ],
    ),
  );
}

Widget buildMikrotikSettings(state, sessionBloc, context, alertBloc) {
  return SingleChildScrollView(
    child: Column(
      children: [
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
          readOnly: true,
        ),
        StarlinkTextField(
          initialValue: state.cfg?.host ?? "",
          onChanged: (str) {
            sessionBloc.changeState(
                state.copyWith(configModel: state.cfg!.copyWith(host: str)));
          },
          title: "Mikrotik",
          textHint: "Dirección IP de tu Mikrotik",
          readOnly: true,
        ),
        StarlinkTextField(
          initialValue: state.cfg?.user ?? "",
          onChanged: (str) {
            sessionBloc.changeState(
                state.copyWith(configModel: state.cfg!.copyWith(user: str)));
          },
          title: "Usuario",
          textHint: "Usuario de tu Mikrotik",
          readOnly: true,
        ),
        StarlinkTextField(
          initialValue: state.cfg?.password ?? "",
          onChanged: (str) {
            sessionBloc.changeState(state.copyWith(
                configModel: state.cfg!.copyWith(password: str)));
          },
          title: "Contraseña",
          readOnly: true,
          obscureText: true,
          textHint: "Contraseña de tu Mikrotik",
        ),
        StarlinkButton(
          text: "CAMBIAR CONTRASEÑA",
          onPressed: () async {
            return showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    backgroundColor: StarlinkColors.black,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16.0))),
                    contentPadding: const EdgeInsets.only(top: 10.0),
                    content: FormNewPassWord(session: sessionBloc),
                  );
                });
          },
        ),
        StarlinkTextField(
          initialValue: state.cfg?.dnsNamed ?? "",
          onChanged: (str) {
            sessionBloc.changeState(state.copyWith(
                configModel: state.cfg!.copyWith(dnsNamed: str)));
          },
          readOnly: true,
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
          text: "SUBIR LOGIN.HTML",
          type: ButtonType.destructive,
          onPressed: () async {
            ProgressDialogUtils.showProgressDialog();
            await sessionBloc.loginHotspot();
            ProgressDialogUtils.hideProgressDialog();
          },
        ),
      ],
    ),
  );
}

Widget buildCustomerSettings(state, sessionBloc, alertBloc, databaseFirebase) {
  return Column(
    children: [
      StarlinkTextField(
        initialValue: state.cfg?.nameLocal ?? "",
        onChanged: (str) {
          databaseFirebase.updateName(str);
          sessionBloc.changeState(
              state.copyWith(configModel: state.cfg!.copyWith(nameLocal: str)));
        },
        title: "Nombre del local",
        textHint: "Ejemplo: mi tienda",
      ),
      const Gap(8),
      StarlinkTextField(
        initialValue: state.cfg?.contact ?? "",
        onChanged: (str) {
          databaseFirebase.updateContact(str);
          sessionBloc.changeState(
              state.copyWith(configModel: state.cfg!.copyWith(contact: str)));
        },
        title: "Numero de contacto",
        textHint: "Tlf: 04.........",
      ),
    ],
  );
}

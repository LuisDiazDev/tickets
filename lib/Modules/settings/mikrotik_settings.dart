import 'package:StarTickera/Modules/settings/widgets/form_new_password.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../Core/utils/progress_dialog_utils.dart';
import '../../Widgets/starlink/button.dart';
import '../../Widgets/starlink/colors.dart';
import '../../Widgets/starlink/section_title.dart';
import '../../Widgets/starlink/text_field.dart';

Widget buildMikrotikSettings( sessionBloc, context, alertBloc) {
  return SingleChildScrollView(
    child: Column(
      children: [
        const StarlinkSectionTitle(
          title: "INFORMACIÓN DEL MIKROTIK",
        ),
        StarlinkTextField(
          initialValue: sessionBloc.state.cfg?.identity ?? "",
          onChanged: (str) {
            sessionBloc.changeState(sessionBloc.state.copyWith(
                configModel: sessionBloc.state.cfg!.copyWith(identity: str)));
          },
          title: "Identidad",
          textHint: "Nombre del Mikrotik",
          readOnly: true,
        ),
        StarlinkTextField(
          initialValue: sessionBloc.state.cfg?.host ?? "",
          onChanged: (str) {
            sessionBloc.changeState(
                sessionBloc.state.copyWith(configModel: sessionBloc.state.cfg!.copyWith(host: str)));
          },
          title: "Mikrotik",
          textHint: "Dirección IP de tu Mikrotik",
          readOnly: true,
        ),
        StarlinkTextField(
          initialValue: sessionBloc.state.cfg?.user ?? "",
          onChanged: (str) {
            sessionBloc.changeState(
                sessionBloc.state.copyWith(configModel:sessionBloc.state.cfg!.copyWith(user: str)));
          },
          title: "Usuario",
          textHint: "Usuario de tu Mikrotik",
          readOnly: true,
        ),
        StarlinkTextField(
          initialValue: sessionBloc.state.cfg?.password ?? "",
          onChanged: (str) {
            sessionBloc.changeState(sessionBloc.state.copyWith(
                configModel: sessionBloc.state.cfg!.copyWith(password: str)));
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
          initialValue: sessionBloc.state.cfg?.dnsNamed ?? "",
          onChanged: (str) {
            sessionBloc.changeState(sessionBloc.state.copyWith(
                configModel: sessionBloc.state.cfg!.copyWith(dnsNamed: str)));
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

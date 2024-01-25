import 'package:flutter/cupertino.dart';
import 'package:gap/gap.dart';

import '../../Widgets/starlink/text_field.dart';

Widget buildCustomerSettings(sessionBloc, alertBloc, databaseFirebase) {
  return Column(
    children: [
      StarlinkTextField(
        initialValue: sessionBloc.state.cfg?.nameLocal ?? "",
        onChanged: (str) {
          databaseFirebase.updateName(str);
          sessionBloc.changeState(
              sessionBloc.state.copyWith(configModel: sessionBloc.state.cfg!.copyWith(nameLocal: str)));
        },
        title: "Nombre del local",
        textHint: "Ejemplo: mi tienda",
      ),
      const Gap(8),
      StarlinkTextField(
        initialValue: sessionBloc.state.cfg?.contact ?? "",
        onChanged: (str) {
          databaseFirebase.updateContact(str);
          sessionBloc.changeState(
              sessionBloc.state.copyWith(configModel: sessionBloc.state.cfg!.copyWith(contact: str)));
        },
        title: "Numero de contacto",
        textHint: "Tlf: 04.........",
      ),
    ],
  );
}

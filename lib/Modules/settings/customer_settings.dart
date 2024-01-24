import 'package:flutter/cupertino.dart';
import 'package:gap/gap.dart';

import '../../Widgets/starlink/text_field.dart';

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

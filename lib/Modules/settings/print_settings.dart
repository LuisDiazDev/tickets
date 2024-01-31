

import 'package:startickera/Modules/settings/widgets/print_setting.dart';
import 'package:flutter/cupertino.dart';
import 'package:gap/gap.dart';

import '../../Core/utils/progress_dialog_utils.dart';
import '../../Data/Provider/virtual_ticket_repository.dart';
import '../../Widgets/starlink/button.dart';
import '../../Widgets/starlink/card.dart';
import '../../Widgets/starlink/colors.dart';
import '../../Widgets/starlink/section_title.dart';

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
            ProgressDialogUtils.hideProgressDialog();
            // sessionBloc.backUp(alertBloc);
          },
        ),
      ],
    ),
  );
}

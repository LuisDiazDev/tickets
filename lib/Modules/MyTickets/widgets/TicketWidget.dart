import 'package:StarTickera/Modules/Alerts/AlertCubit.dart';
import 'package:StarTickera/Modules/Session/SessionCubit.dart';
import 'package:StarTickera/models/profile_model.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:badges/badges.dart' as badges;
import 'package:gap/gap.dart';
import '../../../Core/Values/Colors.dart';
import '../../../Data/Services/navigator_service.dart';
import '../../../Data/Services/printer_service.dart';
import '../../../Routes/Route.dart';
import '../../../Widgets/qr_dialog.dart';
import '../../../Widgets/starlink/text_style.dart';
import '../../../models/ticket_model.dart';
import '../bloc/TicketsBloc.dart';
import '../bloc/TicketsEvents.dart';

class CustomTicketWidget extends StatelessWidget {
  final TicketModel ticket;
  final ProfileModel? profile;

  const CustomTicketWidget({super.key, required this.ticket, this.profile});

  bool valid() =>
      ticket.limitUptime == null || ticket.limitUptime != ticket.uptime;

  Widget buildDataUsageBadgedWidget(TicketsBloc ticketsBloc) {
    return Visibility(
      visible: profile?.metadata?.usageTime != null,
      child: Padding(
        padding: const EdgeInsets.only(left: 40),
        child: badges.Badge(
          badgeContent: StarlinkText(
            profile?.metadata?.usageTime ?? "",
            size: 14,
          ),
          badgeStyle: const badges.BadgeStyle(
            badgeColor: ColorsApp.secondary,
          ),
          child: Icon(
            getIcon(profile?.metadata?.usageTime ?? ""),
            color: StarlinkColors.lightBlue,
            size: 32,
          ),
        ),
      ),
    );
  }

  IconData getIcon(String type) {
    if (type.contains("m") || type.contains("h")) {
      return EvaIcons.clockOutline;
    }
    if (type.contains("d")) {
      return EvaIcons.calendarOutline;
    }

    return EvaIcons.activity;
  }

  @override
  Widget build(BuildContext context) {
    final homeBloc = BlocProvider.of<TicketsBloc>(context);
    final session = BlocProvider.of<SessionCubit>(context);
    final alertCubit = BlocProvider.of<AlertCubit>(context);
    var sp = profile?.onLogin?.split(",") ?? [];
    var duration = sp.length > 3 ? sp[3] : "";
    var price = sp.length > 4 ? sp[4] : "";
    var dateSP = ticket.comment?.split("|");
    var hour = "";
    var date = "";
    if (dateSP?.length == 2) {
      try{
        var dateSP2 = dateSP![1].split(" ");
        date = dateSP2[1];
        hour = dateSP2[2];
      }catch (e){
        date = "";
        hour = "";
      }
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          TicketDialogUtils.showNewTicketDetailDialog(
              configModel: session.state.cfg!,
              user: ticket.name!,
              duration: duration,
              price: price,
              shareF: () {
                homeBloc.add(
                    ShareQRImage(ticket.name ?? "", ticket.password ?? "",session.state.cfg?.host?? ""));
              },
              printF: () {
                if (session.state.cfg?.bluetoothDevice?.isConnected ?? false) {
                  if (!PrinterService.isProgress) {
                    PrinterService().printTicket(
                        user: ticket.name ?? "",
                        configModel: session.state.cfg,
                        duration: duration,
                        price: price);
                  }

                  alertCubit.showAlertInfo(
                    title: "Imprimiendo",
                    subtitle: "Espere un momento",
                  );
                } else {
                  NavigatorService.pushNamedAndRemoveUntil(Routes.settings);
                  alertCubit.showAlertInfo(
                    title: "Error",
                    subtitle: "No hay impresora conectada",
                  );
                }
              });
        },
        child: ClipPath(
          clipper: CustomTicketClipper(), // <-- CustomClipper
          child: Container(
              color: valid()
                  ? StarlinkColors.blue.withOpacity(.7)
                  : Colors.grey, // <-- background color
              height: 115, // <-- height
              width: 215, // <-- width
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  buildFirstRow(date, hour, homeBloc),
                  buildSecondRow(session, duration, price, alertCubit, homeBloc)
                ],
              )),
        ),
      ),
    );
  }

  Row buildSecondRow(SessionCubit session, String duration, String price,
      AlertCubit alertCubit, TicketsBloc homeBloc) {
    return Row(
      children: [
        Visibility(
          visible: valid(),
          child: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: TextButton(
              onPressed: () async {
                if (!(session.state.cfg?.bluetoothDevice?.isConnected ??
                    false)) {
                  if (session.state.cfg?.bluetoothDevice != null) {
                    await session.state.cfg?.bluetoothDevice!.connect(
                        timeout: const Duration(seconds: 10));
                    if (session.state.cfg?.bluetoothDevice?.isConnected ??
                        false) {
                      session.changeState(session.state.copyWith(
                          configModel: session.state.cfg!.copyWith(
                              bluetoothDevice:
                                  session.state.cfg?.bluetoothDevice)));
                    }
                  }
                }
                if (session.state.cfg?.bluetoothDevice?.isConnected ?? false) {
                  if (!PrinterService.isProgress) {
                    PrinterService().printTicket(
                        user: ticket.name ?? "",
                        configModel: session.state.cfg,
                        duration: duration,
                        price: price);
                  }

                  alertCubit.showAlertInfo(
                    title: "Imprimiendo",
                    subtitle: "Espere un momento",
                  );
                } else {
                  NavigatorService.pushNamedAndRemoveUntil(Routes.settings);
                  alertCubit.showAlertInfo(
                    title: "Error",
                    subtitle: "No hay impresora conectada",
                  );
                }
              },
              child: StarlinkText(
                "IMPRIMIR",
                size: 16,
                isBold: true,
              ),
            ),
          ),
        ),
        const Spacer(),
        Visibility(
          visible: valid(),
          child: IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              onPressed: () {
                homeBloc.add(
                    ShareQRImage(ticket.name ?? "", ticket.password ?? "",session.state.cfg?.host ?? ""));
              },
              icon: const Icon(
                EvaIcons.shareOutline,
                color: StarlinkColors.lightBlue,
              )),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 5,  right: 5),
          child: IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              onPressed: () {
                homeBloc.add(DeletedTicket(ticket.id!));
              },
              icon: const Icon(
                EvaIcons.trashOutline,
                color: Colors.red,
              )),
        )
      ],
    );
  }

  Row buildFirstRow(String date, String hour, TicketsBloc homeBloc) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  StarlinkText(
                    ticket.name ?? "",
                    size: 16,
                    isBold: true,
                  ),
                  const Gap(60),
                  Column(
                    children: [
                      StarlinkText(
                        date,
                        size: 10,
                      ),
                      StarlinkText(
                        hour,
                        size: 10,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            buildDataUsageWidget(),
          ],
        ),
        buildDataUsageBadgedWidget(homeBloc),
      ],
    );
  }

  Padding buildDataUsageWidget() {
    return Padding(
      padding: const EdgeInsets.only(top: 1.0, left: 10),
      child: Builder(
        builder: (context) {
          late String text;
          if (ticket.bytesIn != "0") {
            text =
                "D: ${ticket.getDownloadedInMB()} S: ${ticket.getUploadedInMB()}";
          } else {
            text = "Sin consumo";
          }
          return StarlinkText(
            text,
            size: 14,
          );
        },
      ),
    );
  }
}

class CustomTicketClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    //Radius
    path.addRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height - 1),
        const Radius.circular(8),
      ),
    );

    // Left Round In
    path.addOval(
      Rect.fromCircle(
        center: Offset(0, (size.height / 3) * 1.8), // Position Roun In Left
        radius: 10, // Size
      ),
    );

    // Right Round In
    path.addOval(
      Rect.fromCircle(
        center: Offset(size.width, (size.height / 3) * 1.8),
        // Position Roun In Right
        radius: 10, // Size
      ),
    );

    // Horizontal Line Dash
    const dashWidth = 10;
    const dashSpace = 5;
    final dashCount = (size.width ~/ (dashWidth + dashSpace)) - 1;

    for (var i = 0; i < dashCount; i++) {
      path.addRect(
        Rect.fromLTWH(
          i * (dashWidth + dashSpace).toDouble() + 10,
          (size.height / 3) * 1.8,
          dashWidth.toDouble(),
          1,
        ),
      );
    }

    path.fillType = PathFillType.evenOdd;
    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return true;
  }
}

import 'package:flutter/cupertino.dart';
import 'package:startickera/Modules/Alerts/alert_cubit.dart';
import 'package:startickera/Modules/Home/bloc/home_bloc.dart';
import 'package:startickera/Modules/Session/session_cubit.dart';
import 'package:startickera/models/profile_model.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:badges/badges.dart' as badges;
import 'package:gap/gap.dart';
import '../../../Core/Values/colors.dart';
import '../../../Data/Provider/mikrotik/mk_provider.dart';
import '../../../Data/Services/navigator_service.dart';
import '../../../Data/Services/printer_service.dart';
import '../../../Routes/route.dart';
import '../../../Widgets/qr_dialog.dart';
import '../../../Widgets/starlink/colors.dart';
import '../../../Widgets/starlink/text_style.dart';
import '../../../models/scheduler_model.dart';
import '../../../models/ticket_model.dart';
import '../bloc/tickets_bloc.dart';
import '../bloc/tickets_events.dart';

class CustomTicketWidget extends StatelessWidget {
  final TicketModel ticket;
  final ProfileModel? profile;

  const CustomTicketWidget({super.key, required this.ticket, this.profile});

  bool valid() =>
      ticket.limitUptime == null || ticket.limitUptime != ticket.uptime;

  Future<SchedulerModel?> getTaskData() async {
    SchedulerModel? current;
    var context = NavigatorService.navigatorKey.currentState?.overlay?.context;
    final sessionCubit = BlocProvider.of<SessionCubit>(context!);
    var task = await MkProvider(sessionCubit).allScheduler();
    for (var t in task) {
      if (t.name == ticket.name) {
        return t;
      }
    }
    return current;
  }

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
    var duration = profile?.metadata?.usageTime??"";
    var price = profile?.metadata?.price.toString()??"";
    var dateSP = ticket.comment?.split("|");
    var hour = "";
    var date = "";
    if (dateSP?.length == 2) {
      try {
        var dateSP2 = dateSP![1].split(" ");
        date = dateSP2[1];
        hour = dateSP2[2];
      } catch (e) {
        date = "";
        hour = "";
      }
    }

    return FutureBuilder(
        future: getTaskData(),
        builder: (BuildContext context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              {
                return const CircularProgressIndicator();
              }
            case ConnectionState.waiting:
              {
                return const CircularProgressIndicator();
              }
            case ConnectionState.active:
              {
                return const CircularProgressIndicator();
              }
            case ConnectionState.done:
              {
                if (snapshot.hasData) {

                  return Banner(
                    message: "en uso",
                    location: BannerLocation.bottomStart,
                    child: _build(
              session, duration, price, StarlinkColors.white.withOpacity(.7), homeBloc, alertCubit, date, hour,snapshot.data)
                  );
                }
                return _build(
                    session, duration, price,StarlinkColors.blue.withOpacity(.7), homeBloc, alertCubit, date, hour,null);
              }
          }
        });
  }

  Widget _build(SessionCubit session, String duration, String price,Color color,
      TicketsBloc homeBloc, AlertCubit alertCubit, String date, String hour,SchedulerModel? used) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          TicketDialogUtils.showNewTicketDetailDialog(
              configModel: session.state.cfg!,
              user: ticket.name!.toUpperCase(),
              duration: duration,
              used: used,
              price: price,
              shareF: () {
                homeBloc.add(ShareQRImage(ticket.name ?? "",
                    ticket.password ?? "", session.state.cfg?.host ?? ""));
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

                  alertCubit.showDialog(
                    ShowDialogEvent(
                      title: "IMPRIMIENDO",
                      message: "Espere un momento",
                      type: AlertType.info,
                    ),
                  );
                } else {
                  NavigatorService.pushNamedAndRemoveUntil(Routes.settings);
                  alertCubit.showDialog(
                    ShowDialogEvent(
                      title: "ERROR",
                      message: "No hay impresora conectada",
                      type: AlertType.error,
                    ),
                  );
                }
              });
        },
        child: ClipPath(
          clipper: CustomTicketClipper(), // <-- CustomClipper
          child: Container(
              color: valid()
                  ? color
                  : Colors.grey, // <-- background color
              height: 115, // <-- height
              width: 270, // <-- width
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
                    await session.state.cfg?.bluetoothDevice!
                        .connect(timeout: const Duration(seconds: 10));
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

                  alertCubit.showDialog(
                    ShowDialogEvent(
                      title: "IMPRIMIENDO",
                      message: "Espere un momento",
                      type: AlertType.info,
                    ),
                  );
                } else {
                  NavigatorService.pushNamedAndRemoveUntil(Routes.settings);
                  alertCubit.showDialog(
                    ShowDialogEvent(
                      title: "ERROR",
                      message: "No hay impresora conectada",
                      type: AlertType.error,
                    ),
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
                homeBloc.add(ShareQRImage(ticket.name ?? "",
                    ticket.password ?? "", session.state.cfg?.host ?? ""));
              },
              icon: const Icon(
                EvaIcons.shareOutline,
                color: StarlinkColors.lightBlue,
              )),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 5, right: 5),
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
                    ticket.name?.toLowerCase() ?? "",
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

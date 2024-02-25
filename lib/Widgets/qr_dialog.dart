import 'package:startickera/Widgets/starlink/colors.dart';
import 'package:startickera/Widgets/starlink/text_style.dart';
import 'package:startickera/models/config_model.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../Data/Services/navigator_service.dart';
import '../models/scheduler_model.dart';

class TicketDialogUtils {
  ///common method for showing progress dialog
  static void showNewTicketDetailDialog(
      {BuildContext? context,
      isCancellable = true,
      String user = "",
      SchedulerModel? used,
      required ConfigModel configModel,
      Function()? printF,
      Function()? shareF,
      String price = "",
      String duration = ""}) async {
    if (NavigatorService.navigatorKey.currentState?.overlay?.context != null) {
      showDialog(
          context: NavigatorService.navigatorKey.currentState!.overlay!.context,
          builder: (context) {
            return Center(
              child: Material(
                type: MaterialType.transparency,
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 36,
                    ),
                    // height: MediaQuery.of(context).size.height * 0.60,
                    // width: MediaQuery.of(context).size.width * 0.860,
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment(0.8, 1),
                        colors: <Color>[
                          Color(0xFFFEEDFC),
                          Colors.white,
                          Color(0xFFE4E6F7),
                          Color(0xFFE2E5F5),
                        ],
                        tileMode: TileMode.mirror,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          height: 240,
                          width: 240,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(
                              Radius.circular(60),
                            ),
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment(0.8, 1),
                              colors: <Color>[
                                Colors.white,
                                Color(0xFFE4E6F7),
                                Colors.white,
                              ],
                              tileMode: TileMode.mirror,
                            ),
                          ),
                          child: Center(
                            child: QrImageView(
                              data:
                                  "http://${configModel.dnsNamed}/login?user=$user&password=$user",
                              size: 180,
                              // foregroundColor: const Color(0xFF8194FE),
                            ),
                          ),
                        ),
                        const Gap(8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Visibility(
                              visible: configModel.dnsNamed.isNotEmpty,
                                child: Column(
                              children: [
                                const Text(
                                  "Para navegar entra en",
                                  style: TextStyle(
                                    fontFamily: 'DDIN',
                                    fontSize: 20,
                                  ),
                                ),
                                Text(
                                  configModel.dnsNamed,
                                  style: const TextStyle(
                                    fontFamily: 'DDIN',
                                    fontSize: 20,
                                    color: Color(0xFF6565FF),
                                  ),
                                ),
                              ],
                            )),
                            const Gap(8),
                            SizedBox(
                              width: 170,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Center(
                                    child: Column(
                                      children: [
                                        const Text(
                                          "Clave",
                                          style: TextStyle(
                                            fontFamily: 'DDIN',
                                            fontSize: 20,
                                          ),
                                        ),
                                        Text(
                                          user,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            fontFamily: 'DDIN',
                                            fontSize: 20,
                                            color: StarlinkColors.black,
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            const Gap(8),
                            SizedBox(
                              width: 170,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    children: [
                                      StarlinkText(
                                        "Precio",
                                        color: StarlinkColors.black,
                                        size: 20,
                                      ),
                                      StarlinkText(
                                        price,
                                        color: StarlinkColors.black,
                                        size: 20,
                                      )
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      StarlinkText(
                                        "Duración",
                                        size: 20,
                                        color: StarlinkColors.black,
                                      ),
                                      StarlinkText(
                                        duration,
                                        size: 20,
                                        color: StarlinkColors.black,
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                            Visibility(
                              visible: used != null,
                              child: Column(
                                children: [
                                  const Gap(8),
                                  SizedBox(
                                    width: 170,
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Center(
                                          child: Column(
                                            children: [
                                              const Text(
                                                "Vencimiento",
                                                style: TextStyle(
                                                  fontFamily: 'DDIN',
                                                  fontSize: 20,
                                                ),
                                              ),
                                              Text(
                                                used?.nextRun?.toString().substring(0,16)??"",
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                  fontFamily: 'DDIN',
                                                  fontSize: 20,
                                                  color: StarlinkColors.black,
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        const Gap(10),
                        SizedBox(
                          width: 220,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Visibility(
                                    visible: printF != null,
                                    child: GestureDetector(
                                      onTap: printF,
                                      child: Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(12),
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              blurRadius: 32.0,
                                              color: const Color.fromARGB(
                                                      255, 133, 142, 212)
                                                  .withOpacity(0.68),
                                            ),
                                          ],
                                        ),
                                        child: const Icon(
                                          EvaIcons.printerOutline,
                                          color: Color(0xFF6565FF),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const Gap(10),
                                  Visibility(
                                    visible: shareF != null,
                                    child: GestureDetector(
                                      onTap: shareF,
                                      child: Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(12),
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              blurRadius: 32.0,
                                              color: const Color.fromARGB(
                                                      255, 133, 142, 212)
                                                  .withOpacity(0.68),
                                            ),
                                          ],
                                        ),
                                        child: const Icon(
                                          EvaIcons.shareOutline,
                                          color: Color(0xFF6565FF),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          });
    }
  }
}

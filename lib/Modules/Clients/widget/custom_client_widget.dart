import 'package:StarTickera/models/ticket_model.dart';
import 'package:flutter/material.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import '../../../Core/Values/Colors.dart';
import '../../../Widgets/starlink/text_style.dart';
export '/core/utils/size_utils.dart';

class CustomClient extends StatelessWidget {
  final TicketModel client;
  final Function()? onTap;
  final Function()? copyTap;

  const CustomClient(
      {super.key, required this.client, this.onTap, this.copyTap});

  @override
  Widget build(BuildContext context) {

   return GestureDetector(
      onTap: onTap,
      child: Card(
        color: StarlinkColors.midDarkGray,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
          width: MediaQuery.of(context).size.width - 20,
          height: 100,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          constraints: const BoxConstraints(
                            minWidth: 40,
                            maxWidth: 140,),
                          child: StarlinkText(
                            client.name ?? "",
                            size: 16,
                            isBold: true,
                          ),
                        ),
                        Visibility(
                          visible: client.getCreationDate() != "",
                          child: Container(
                            constraints: const BoxConstraints(
                                minWidth: 40,
                                maxWidth: 200,
                                minHeight: 40,
                                maxHeight: 60),
                            child: StarlinkText(
                              "Creado: ${client.getCreationDate()}",
                              size: 14,
                              isBold: true,
                            ),
                          ),
                        ),
                        Visibility(
                          visible: client.profile != "",
                          child: Container(
                            constraints: const BoxConstraints(
                                minWidth: 40,
                                maxWidth: 220,
                                minHeight: 10,
                                maxHeight: 20),
                            child: StarlinkText(
                              "Plan: ${client.profile!.replaceAll("d-", "d_").split("_")[1]}",
                              size: 14,
                              isBold: true,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      IconButton(
                          constraints: const BoxConstraints(),
                          onPressed: copyTap,
                          icon: const Icon(
                            EvaIcons.refreshOutline,
                            color: StarlinkColors.white,
                          )),
                      IconButton(
                          constraints: const BoxConstraints(),
                          onPressed: () {
                            // profileBloc.add(DeletedProfile(profile));
                          },
                          icon: const Icon(
                            Icons.delete_outline,
                            color: StarlinkColors.red,
                          ))
                    ],
                  )
                ],
              ),
              const Spacer(), // Duration
              Visibility(
                visible: client.email != null && client.email != "",
                child: StarlinkText(
                  "${client.email}",
                  isBold: true,
                  size: 18,
                ),
              ),
            ],
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
}

import 'package:StarTickera/Data/Provider/MkProvider.dart';
import 'package:StarTickera/models/scheduler_model.dart';
import 'package:StarTickera/models/ticket_model.dart';
import 'package:flutter/material.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import '../../../Widgets/starlink/colors.dart';
import '../../../Widgets/starlink/text_style.dart';
export '/core/utils/size_utils.dart';

class CustomClient extends StatelessWidget {
  final TicketModel client;
  final SchedulerModel? task;
  final Function()? onTap;
  final Function()? copyTap;

  const CustomClient(
      {super.key, required this.client, this.onTap, this.copyTap,this.task});

  Future<SchedulerModel?> getTaskData()async{
    SchedulerModel? current;
    var task =await MkProvider().allScheduler();
    for (var t in task){
      if(t.name == client.name){
        return t;
      }
    }
    return current;
  }

  @override
  Widget build(BuildContext context) {

    if(client.disabled! == "true"){
      return Banner(
        textDirection: TextDirection.ltr,
        layoutDirection: TextDirection.ltr,
        location: BannerLocation.topEnd,
        message: "Vencido",
        child: GestureDetector(
          onTap: onTap,
          child: Card(
            color:  client.disabled! != "true" ? StarlinkColors.midDarkGray:StarlinkColors.gray,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              width: MediaQuery.of(context).size.width - 20,
              // height: 100,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
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
                  // const Spacer(), // Duration
                  FutureBuilder(future: getTaskData(),
                      initialData: null,
                      builder: (context, snapData){
                        if(snapData.data == null){
                          return Container();
                        }else{
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Container(
                                constraints: const BoxConstraints(
                                  minWidth: 120,
                                  maxWidth: 180,),
                                child: StarlinkText(
                                  "Activado: ${snapData.data?.startDate.toString().substring(0,10)}",
                                  size: 12,
                                  isBold: true,
                                ),
                              ),
                              Container(
                                constraints: const BoxConstraints(
                                  minWidth: 40,
                                  maxWidth: 180,),
                                child: StarlinkText(
                                  "Vence: ${snapData.data?.nextRun.toString().substring(0,16)}",
                                  size: 12,
                                  isBold: true,
                                ),
                              ),
                            ],
                          );
                        }
                      }
                  )
                ],
              ),
            ),
          ),
        ),
      );
    }

   return GestureDetector(
      onTap: onTap,
      child: Card(
        color:  StarlinkColors.midDarkGray,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
          width: MediaQuery.of(context).size.width - 20,
          // height: 100,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
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
              // const Spacer(), // Duration
              FutureBuilder(future: getTaskData(),
                  initialData: null,
                  builder: (context, snapData){
                    if(snapData.data == null){
                      return Container();
                    }else{
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Container(
                            constraints: const BoxConstraints(
                              minWidth: 120,
                              maxWidth: 180,),
                            child: StarlinkText(
                              "Activado: ${snapData.data?.startDate.toString().substring(0,10)}",
                              size: 12,
                              isBold: true,
                            ),
                          ),
                          Container(
                            constraints: const BoxConstraints(
                              minWidth: 40,
                              maxWidth: 180,),
                            child: StarlinkText(
                              "Vence: ${snapData.data?.nextRun.toString().substring(0,16)}",
                              size: 12,
                              isBold: true,
                            ),
                          ),
                        ],
                      );
                    }
                  }
              )
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

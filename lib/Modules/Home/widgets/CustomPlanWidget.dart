import 'package:bluetooth_print/bluetooth_print_model.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tickets/Core/utils/rand.dart';
import 'package:tickets/Data/Provider/TicketProvider.dart';
import 'package:tickets/models/profile_model.dart';
import 'package:badges/badges.dart' as badges;

import '../../../Core/Values/Colors.dart';
import '../../../Data/Services/printer_service.dart';
import '../../Session/SessionCubit.dart';
export '/core/utils/size_utils.dart';

class CustomPlanWidget extends StatelessWidget {
  final ProfileModel profile;
  final Function(String) generatedUser;
  const CustomPlanWidget({super.key,required this.generatedUser, required this.profile});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        var user = generateUser();
        generatedUser(user);
      },
      child: Card(
        color: ColorsApp.secondary.withOpacity(.4),
        child: Container(
          padding: const EdgeInsets.all(12.0),
          width: 180,
          height: 110,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: SizedBox(
                  width: 140,
                  child: Text(
                    profile.name ?? "",
                    style: const TextStyle(
                      color: ColorsApp.primary,
                      fontSize: 18,
                      fontFamily: "poppins_regular",
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: Visibility(
                  visible: profile.onLogin?.split(",")[3] != null,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 40),
                    child: badges.Badge(
                      badgeContent: Text(
                        profile.onLogin?.split(",")[3]??"",
                        style: const TextStyle(color: ColorsApp.primary, fontSize: 14),
                      ),
                      badgeStyle: const badges.BadgeStyle(
                        badgeColor: ColorsApp.secondary,
                      ),
                      child: Icon(
                        getIcon(profile.onLogin?.split(",")[3]??""),
                        color: ColorsApp.primary,
                        size: 32,
                      ),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                    profile.onLogin?.split(",")[4] != null ? "${profile.onLogin?.split(",")[4]}":"",
                  style: const TextStyle(
                    color: ColorsApp.primary,
                    fontSize: 18,
                    fontFamily: "poppins_regular",
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  profile.rateLimit != null ? profile.rateLimit! :"",
                  style: const TextStyle(
                    color: ColorsApp.primary,
                    fontSize: 18,
                    fontFamily: "poppins_regular",
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData getIcon(String type){
    if(type.contains("m") || type.contains("h")){
      return  EvaIcons.clockOutline;
    }
    if(type.contains("d")){
      return  EvaIcons.calendarOutline;
    }

    return EvaIcons.activity;
  }
}

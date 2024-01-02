import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import '../../../Core/Values/Colors.dart';
import '../../../Core/utils/rand.dart';
import '../../../models/profile_model.dart';
export '/core/utils/size_utils.dart';

class CustomPlanWidget extends StatelessWidget {
  final ProfileModel profile;
  final Function(String) generatedUser;
  const CustomPlanWidget({super.key,required this.generatedUser, required this.profile});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        var user = generatePassword();
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
                  visible: profile.metadata?.usageTime != null,
                  child: Builder(
                    builder: (context) {
                      var text = profile.metadata?.usageTime ?? "";
                      return Padding(
                        padding: const EdgeInsets.only(left: 40),
                        child: badges.Badge(
                          badgeContent: Text(
                            text,
                            style: const TextStyle(color: ColorsApp.primary, fontSize: 14),
                          ),
                          badgeStyle: const badges.BadgeStyle(
                            badgeColor: ColorsApp.secondary,
                          ),
                          child: Icon(
                            getIcon(text),
                            color: ColorsApp.primary,
                            size: 32,
                          ),
                        ),
                      );
                    }
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  profile.metadata?.price.toString() ?? "",
                    // sp.length >4 ? sp[4].replaceAll("S", "\$"):"",
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

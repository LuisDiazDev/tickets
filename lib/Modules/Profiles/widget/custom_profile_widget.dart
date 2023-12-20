import 'package:flutter/material.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:badges/badges.dart' as badges;

import '../../../Core/Values/Colors.dart';
import '../../../models/profile_model.dart';
import '../bloc/ProfileBloc.dart';
import '../bloc/ProfileEvents.dart';
export '/core/utils/size_utils.dart';

class CustomProfile extends StatelessWidget {
  final ProfileModel profile;
  final Function()? onTap;

  const CustomProfile({super.key, required this.profile, this.onTap});

  @override
  Widget build(BuildContext context) {
    ProfileBloc profileBloc = BlocProvider.of<ProfileBloc>(context);
    var sp = profile.onLogin?.split(",") ?? [];
    var duration = sp.length >= 4 ? sp[3] : "";
    var price = sp.length >= 5 ? sp[4] : "";
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: ColorsApp.secondary.withOpacity(.4),
        child: Container(
          padding: const EdgeInsets.all(12.0),
          width: 195,
          height: 110,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: SizedBox(
                  width: 150,
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
                  visible: sp.length >= 4,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 40),
                    child: badges.Badge(
                      badgeContent: Text(
                        duration,
                        style: const TextStyle(
                            color: ColorsApp.primary, fontSize: 14),
                      ),
                      badgeStyle: const badges.BadgeStyle(
                        badgeColor: ColorsApp.secondary,
                      ),
                      child: Icon(
                        getIcon(duration),
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
                  price,
                  style: const TextStyle(
                    color: ColorsApp.primary,
                    fontSize: 18,
                    fontFamily: "poppins_regular",
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      profile.rateLimit != null ? profile.rateLimit! : "",
                      style: const TextStyle(
                        color: ColorsApp.primary,
                        fontSize: 18,
                        fontFamily: "poppins_regular",
                      ),
                    ),
                    IconButton(
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(),
                        onPressed: () {
                          profileBloc.add(DeletedProfile(profile));
                        },
                        icon: const Icon(
                          EvaIcons.trashOutline,
                          color: Colors.red,
                        ))
                  ],
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

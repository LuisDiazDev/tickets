import 'package:flutter/material.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:badges/badges.dart' as badges;
import 'package:gap/gap.dart';

import '../../../Core/Values/Colors.dart';
import '../../../models/profile_model.dart';
import '../bloc/ProfileBloc.dart';
import '../bloc/ProfileEvents.dart';
export '/core/utils/size_utils.dart';

class CustomProfile extends StatelessWidget {
  final ProfileModel profile;
  final Function()? onTap;
  final Function()? copyTap;

  const CustomProfile(
      {super.key, required this.profile, this.onTap, this.copyTap});

  @override
  Widget build(BuildContext context) {
    ProfileBloc profileBloc = BlocProvider.of<ProfileBloc>(context);
    if (profile.metadata == null) {
      return Container();
    }
    var duration = profile.metadata!.usageTime ?? "";
    String price = "${profile.metadata?.price ?? ""}";
    price = price.replaceAll(".0", "");
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: StarlinkColors.midDarkGray,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
          width: MediaQuery.of(context).size.width-20,
          height: 100,
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    profile.name ?? "",
                    style: const TextStyle(
                      color: StarlinkColors.white,
                      fontSize: 18,
                      fontFamily: "DDIN-Bold",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      IconButton(
                          constraints: const BoxConstraints(),
                          onPressed: copyTap,
                          icon: const Icon(
                            EvaIcons.copyOutline,
                            color: StarlinkColors.white,
                          )),
                      IconButton(
                          constraints: const BoxConstraints(),
                          onPressed: () {
                            profileBloc.add(DeletedProfile(profile));
                          },
                          icon: const Icon(
                            Icons.delete_outline,
                            color: StarlinkColors.red,
                          ))
                    ],
                  )
                ],
              ),
              const Spacer(),              // Duration

              Row(
                children: [
                  Visibility(
                    visible: price.toString().isNotEmpty,
                    child: Text(
                      "Duración: $duration",
                      style: const TextStyle(
                        color: StarlinkColors.white,
                        fontSize: 18,
                        fontFamily: "DDIN-Bold",
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    "Precio: $price\$",
                    style: const TextStyle(
                      color: StarlinkColors.white,
                      fontSize: 18,
                      fontFamily: "DDIN-Bold",
                    ),
                  ),

                ],
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

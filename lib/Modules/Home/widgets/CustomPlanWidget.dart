import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import '../../../Core/Values/Colors.dart';
import '../../../Core/utils/rand.dart';
import '../../../Widgets/starlink/text_style.dart';
import '../../../models/profile_model.dart';
export '/core/utils/size_utils.dart';

class CustomPlanWidget extends StatelessWidget {
  final ProfileModel profile;
  final Function(String) generatedUser;

  const CustomPlanWidget(
      {super.key, required this.generatedUser, required this.profile});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        var user = generatePassword();
        generatedUser(user);
      },
      child: Card(
        color: StarlinkColors.blue.withOpacity(.4),
        child: Container(
          padding: const EdgeInsets.all(12.0),
          width: MediaQuery.of(context).size.width-20,
          height: 110,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: SizedBox(
                  width: 140,
                  child: StarlinkText(
                    profile.name ?? "",
                    size: 16,
                    isBold: true,
                    ),
                  ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: Visibility(
                  visible: profile.metadata?.usageTime != null,
                  child: Builder(builder: (context) {
                    var text = profile.metadata?.usageTime ?? "";
                    return Padding(
                      padding: const EdgeInsets.only(left: 40),
                      child: badges.Badge(
                        badgeContent: StarlinkText(
                          text,
                          size: 14,
                          isBold: true,
                        ),
                        badgeStyle: const badges.BadgeStyle(
                          badgeColor: StarlinkColors.blue,
                        ),
                        child: Icon(
                          getIcon(text),
                          color: StarlinkColors.white,
                          size: 32,
                        ),
                      ),
                    );
                  }),
                ),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: StarlinkText(
                  "${profile.metadata?.price.toString().replaceAll(".0", "") ?? ""}\$",
                  size: 18,
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: StarlinkText(
                  profile.rateLimit != null ? profile.rateLimit! : "",
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

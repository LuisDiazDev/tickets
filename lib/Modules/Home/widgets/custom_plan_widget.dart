import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import '../../../Core/utils/rand.dart';
import '../../../Widgets/starlink/colors.dart';
import '../../../Widgets/starlink/text_style.dart';
import '../../../models/profile_model.dart';



class CustomPlanWidget extends StatelessWidget {
  final ProfileModel profile;
  final Function(String) generatedUser;
  final bool flipColor;

  const CustomPlanWidget(
      {super.key, required this.generatedUser, required this.profile, required this.flipColor});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        var user = generatePassword();
        generatedUser(user);
      },
      child: Card(
        color: flipColor?StarlinkColors.blue.withOpacity(.9):StarlinkColors.blue.withOpacity(.4),
        child: Container(
          padding: const EdgeInsets.all(12.0),
          width: MediaQuery.of(context).size.width - 20,
          height: 110,
          child: Stack(
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
                        "${profile.name}" ?? "",
                        size: 20,
                        isBold: true,
                      ),
                    ),
                    Visibility(
                      visible: profile.metadata?.dataLimit != 0,
                      child: Container(
                        constraints: const BoxConstraints(
                            minWidth: 40,
                            maxWidth: 140,
                            minHeight: 40,
                            maxHeight: 60),
                        child: StarlinkText(
                          "Limite: ${profile.metadata?.dataLimit.toString()}Mbs",
                          size: 16,
                          isBold: true,
                        ),
                      ),
                    ),
                  ],
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
                  "${profile.metadata?.price.toString().replaceAll(".0", "") ?? ""}${profile.metadata?.prefix??"\$"}",
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

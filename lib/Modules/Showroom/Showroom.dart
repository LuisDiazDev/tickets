import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:StarTickera/Core/localization/app_localization.dart';
import 'package:StarTickera/Widgets/starlink/button.dart';
import 'package:StarTickera/Widgets/starlink/progress_circle.dart';
import 'package:StarTickera/Widgets/starlink/section_title.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import '../../Core/Values/Colors.dart';
import '../../Core/utils/progress_dialog_utils.dart';
import '../../Data/Provider/virtualTicketRepository.dart';
import '../../Widgets/custom_appbar.dart';
import '../../Widgets/starlink/button_card.dart';
import '../../Widgets/starlink/card.dart';
import '../Session/SessionCubit.dart';
import '../drawer/drawer.dart';


class ShowRoomPage extends StatelessWidget {
  const ShowRoomPage({super.key});

  @override
  Widget build(BuildContext context) {
    StreamController<String> progressStream = StreamController<String>();
    // Fill the stream with 250 steps async
    for (int i = 0; i < 250; i++) {progressStream.add(i.toString());}
    return BlocBuilder<SessionCubit, SessionState>(builder: (context, state) {
      return Scaffold(
        backgroundColor: StarlinkColors.black.withOpacity(.9),
        drawer: const DrawerCustom(),
        appBar: customAppBar(title: "Showroom"),
        body: Container(
          color: Colors.transparent,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StarlinkButtonCard(
                title: "Janes-iPhone",
                subtitle: "LG Electronics",
                onPressed: () {
                  log("Error");
                },
                // prefixIcon: const Icon(
                //   Icons.error_outline,
                //   color: Colors.white,
                // ),
                suffixWidget: const Icon(
                 Icons.router_outlined,
                  color: Colors.white,
                ),
              ),
              StarlinkProgressCircle(percent: 50),
              const StarlinkCard(
                  type: CardType.error,
                  title: "Error",
                  message: "Este es un error"
              ),
              const StarlinkCard(
                  type: CardType.warning,
                  title: "Warning",
                  message: "Este es un warning"
              ),
              const StarlinkCard(
                  type: CardType.info,
                  title: "Info",
                  message: "Este es un info"
              ),
              const StarlinkCard(
                  type: CardType.success,
                  title: "Success",
                  message: "Este es un success"
              ),
            ],
          )),
        ),
      );
    });
  }
}

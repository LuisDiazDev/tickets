import 'dart:async';
import 'dart:developer';
import 'package:StarTickera/Modules/Alerts/AlertCubit.dart';
import 'package:StarTickera/Widgets/starlink/dialog.dart';
import 'package:StarTickera/Widgets/starlink/progress_circle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import '../../Widgets/custom_appbar.dart';
import '../../Widgets/starlink/button.dart';
import '../../Widgets/starlink/button_card.dart';
import '../../Widgets/starlink/button_group.dart';
import '../../Widgets/starlink/card.dart';
import '../../Widgets/starlink/checkbox.dart';
import '../../Widgets/starlink/colors.dart';
import '../../Widgets/starlink/dropdown.dart';
import '../../Widgets/starlink/text_field.dart';
import '../Session/SessionCubit.dart';
import '../drawer/drawer.dart';
import 'dialogs.dart';

class ShowRoomPage extends StatefulWidget {
  const ShowRoomPage({super.key});

  @override
  State<ShowRoomPage> createState() => _ShowRoomPageState();
}

class _ShowRoomPageState extends State<ShowRoomPage> {
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    StreamController<String> progressStream = StreamController<String>();
    // Fill the stream with 250 steps async
    for (int i = 0; i < 250; i++) {
      progressStream.add(i.toString());
    }
    return BlocBuilder<SessionCubit, SessionState>(builder: (context, state) {
      return Scaffold(
        backgroundColor: StarlinkColors.black.withOpacity(.9),
        drawer: const DrawerCustom(),
        appBar: customAppBar(title: "Showroom"),
        body: Container(
            color: Colors.transparent,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: StarlinkButtonGroup(
              labels: const ["Inputs","Cards", "Dialogs", ],
              onChanged: (index) {
                log("Index: $index");
              },
              widgets: [
                buildInputs(context),
                buildCards(),
                buildDialogs(context),
              ],
            )),
      );
    });
  }


  SingleChildScrollView buildCards() {
    return SingleChildScrollView(
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
        const StarlinkCard(
            type: InfoContextType.error,
            title: "Error",
            message: "Este es un error"),
        const StarlinkCard(
            type: InfoContextType.warning,
            title: "Warning",
            message: "Este es un warning"),
        const StarlinkCard(
            type: InfoContextType.info,
            title: "Info",
            message: "Este es un info"),
        const StarlinkCard(
            type: InfoContextType.success,
            title: "Success",
            message: "Este es un success"),
      ],
    ));
  }

  buildInputs(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StarlinkDropdown(
          onChanged: (str) {
            log("Value: $str");
          },
          values: const ["Minutos", "Horas", "Días", "Semanas"],
          initialValue: "Minutos",
        ),
        StarlinkCheckBox(
            title: "Checkbox",
            onChanged: (bool? value) {
              log("Value: $value");
              setState(() {
                _isChecked = value!;
              });
            },
            initialState: _isChecked,
        ),
        const Gap(20),
        StarlinkTextField(
          title: "Empty",
          textSuffix: "MBs",
          onChanged: (str) {
            log("Value: $str");
          },
          keyboardType: TextInputType.number,
          initialValue: "",
          textHint: 'Max total de mb',
        ),
        const Gap(20),
        StarlinkTextField(
          title: "Disabled",
          textSuffix: "MBs",
          onChanged: (str) {
            log("Value: $str");
          },
          keyboardType: TextInputType.number,
          initialValue: "",
          textHint: 'Max total de mb',
          isEnabled: false,
        ),
        const Gap(20),
        StarlinkTextField(
          title: "Filled",
          textSuffix: "sec",
          onChanged: (str) {
            log("Value: $str");
          },
          keyboardType: TextInputType.number,
          initialValue: "Initial",
          textHint: 'Max total de mb',
        ),
        const Gap(20),
        StarlinkTextField(
          title: "No suffix",
          onChanged: (str) {
            log("Value: $str");
          },
          keyboardType: TextInputType.number,
          initialValue: "Initial",
          textHint: 'Max total de mb',
        ),
        const Gap(20),
        StarlinkTextField(
          title: "Error",
          onChanged: (str) {
            log("Value: $str");
          },
          keyboardType: TextInputType.number,
          initialValue: "bad content",
          textHint: 'Max total de mb',
          errorText: "some error description",
        )
      ],
    ));
  }
}

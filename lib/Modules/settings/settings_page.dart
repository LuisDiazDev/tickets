import 'dart:developer';
import 'dart:io';
import 'package:startickera/Core/localization/app_localization.dart';
import 'package:startickera/Data/database/databse_firebase.dart';
import 'package:startickera/Modules/settings/print_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Widgets/custom_appbar.dart';
import '../../Widgets/starlink/button_group.dart';
import '../../Widgets/starlink/colors.dart';
import '../Alerts/alert_cubit.dart';
import '../Session/session_cubit.dart';
import '../drawer/drawer.dart';
import 'customer_settings.dart';
import 'mikrotik_settings.dart';

import 'dart:convert';
import 'dart:typed_data';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String imageToShow = "assets/printer.png";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final sessionBloc = BlocProvider.of<SessionCubit>(context);
    final alertBloc = BlocProvider.of<AlertCubit>(context);

    DatabaseFirebase databaseFirebase = DatabaseFirebase();
    return Scaffold(
      backgroundColor: StarlinkColors.black.withOpacity(.9),
      drawer: const DrawerCustom(),
      appBar:
      customAppBar(title: "title_configuration".tr, saved: () async {}),
      body: Column(
        children: [
          SizedBox(
            height: 200,
            width: 200,
            // Show
            child: Image.asset(
              imageToShow,
              fit: BoxFit.contain,
            ),
          ),
          Expanded(
              child: StarlinkButtonGroup(
                labels: const ["IMPRESORA", "MIKROTIK", "OTROS"],
                widgets: [
                  buildPrinterSettings(sessionBloc, alertBloc),
                  buildMikrotikSettings(sessionBloc, context, alertBloc),
                  buildCustomerSettings(
                    sessionBloc,
                    alertBloc,
                    databaseFirebase,
                  ),
                ],
                onChanged: (int index) {
                  log("Index: $int");
                  setState(() {
                    if (index == 0) {
                      imageToShow = "assets/printer.png";
                    } else if (index == 1) {
                      imageToShow = "assets/mikrotik.png";
                    } else if (index == 2) {
                      imageToShow = "assets/other.png";
                    }
                  });
                },
              )),
        ],
      ),
    );
  }

  Image imageFromBase64String(String base64String) {
    return Image.memory(base64Decode(base64String));
  }

  Uint8List dataFromBase64String(String base64String) {
    return base64Decode(base64String);
  }

  String base64String(Uint8List data) {
    return base64Encode(data);
  }
}

Future<File> writeToFile(ByteData data, String path) {
  final buffer = data.buffer;
  return File(path).writeAsBytes(buffer.asUint8ClampedList());
}

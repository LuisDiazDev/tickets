import 'package:StarTickera/Widgets/starlink/button.dart';
import 'package:StarTickera/Widgets/starlink/section_title.dart';
import 'package:StarTickera/Widgets/starlink/text_field.dart';
import 'package:StarTickera/models/profile_metadata_model.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../Core/Values/Colors.dart';
import '../../../Widgets/check_box.dart';
import '../../../Widgets/custom_dropdown.dart';
import '../../../Widgets/custom_text_field.dart';
import '../../../Widgets/starlink/checkbox.dart';
import '../../../Widgets/starlink/dropdown.dart';
import '../../../models/config_model.dart';
import '../../../models/profile_model.dart';
import '../bloc/ProfileBloc.dart';
import '../bloc/ProfileEvents.dart';

class FormNewProfileWidget extends StatefulWidget {
  final ProfileModel? current;
  final ProfileBloc bloc;
  final bool newProfile;

  const FormNewProfileWidget(
      {super.key, this.current, required this.bloc, this.newProfile = false});

  @override
  State<FormNewProfileWidget> createState() => _FormNewProfileWidgetState();
}

class _FormNewProfileWidgetState extends State<FormNewProfileWidget> {
  late ProfileModel profile;
  String numberOfSharedUserPerTicket = "1",
      initialDurationUnit = "d",
      initialCurrency = "S",
      durationT = "1",
      price = "1",
      currency = "\$",
      limitUpload = "1",
      limitDownload = "1";

  bool limitSpeed = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    profile = widget.current ?? ProfileModel(name: "Nuevo plan");
    if (widget.current != null) {
      // String currentPrice = profile.metadata?.price.toString() ?? "";
      // initialCurrency = currentPrice.split(RegExp(r"[0-9]")).last;
      // if (initialCurrency == "") {
      //   initialCurrency = "S";
      // }
      //
      // initialDurationUnit = profile.metadata!.usageTime.toString();
      // var num = initialDurationUnit.replaceAll(RegExp(r"\D"), "");
      // initialDurationUnit = initialDurationUnit.replaceAll(num, "");
      // price = currentPrice.replaceAll(initialCurrency, "");
      // durationT = num.toString();
      // limitSpeed =
      //     widget.current?.rateLimit != null && widget.current!.rateLimit != "";
      // if (limitSpeed) {
      //   var str = widget.current!.rateLimit!
      //       .toLowerCase()
      //       .replaceAll("m", "")
      //       .split("/");
      //   limitDownload = str.first;
      //   limitUpload = str.last;
      // }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              // Encaabezado
              StarlinkSectionTitle(
                title: profile.name ?? "",
              ),
              StarlinkTextField(
                onChanged: (str) {
                  profile.name = str;
                },
                title: "Nombre del plan",
                initialValue: profile.name ?? "",
                textHint: "Nombre del plan",
              ),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: StarlinkTextField(
                      title: "Precio",
                      onChanged: (str) {
                        price = str ?? "1";
                      },
                      keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                      initialValue: price,
                      textHint: "Precio del plan",
                      // item: ConfigModel.settings["currency"] ?? [],
                    ),
                  ),
                  Expanded(
                    child: StarlinkTextField(
                      title: "Moneda",
                      maxLength: 1,
                      onChanged: (str) {
                        currency = str;
                      },
                      initialValue: currency,
                      textHint: "Moneda del plan",
                    ),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: StarlinkTextField(
                      title: "Duración",
                      onChanged: (str) {
                        durationT = str;
                      },
                      initialValue: durationT,
                      keyboardType: TextInputType.number,
                      textHint: "Duración del plan",
                    ),
                  ),
                  Expanded(
                    child: StarlinkDropdown(
                      onChanged: (str) {
                        initialDurationUnit = str![0].toLowerCase();
                      },
                      values: const ["Minutos", "Horas", "Días", "Semanas"],
                      initialValue: mapDurationUnit(initialDurationUnit),
                    ),
                  ),
                ],
              ),
              const Gap(1),
              StarlinkTextField(
                title: "Usuarios por ticket",
                onChanged: (str) {
                  numberOfSharedUserPerTicket = str ?? "1";
                },
                keyboardType: TextInputType.number,
                initialValue: numberOfSharedUserPerTicket,
                textHint: "Número de usuarios por ticket",
              ),
              const Gap(8),
              StarlinkCheckBox(
                  title: 'Limitar velocidad',
                  initialState: limitSpeed,
                  onChanged: (check) {
                    setState(() {
                      limitSpeed = check!;
                    });
                  },
              ),
              Visibility(
                visible: limitSpeed,
                child: StarlinkTextField(
                  title: "Bajada",
                  textSuffix: "MBs",
                  onChanged: (str) {
                    limitDownload = str;
                  },
                  keyboardType: TextInputType.number,
                  initialValue: limitDownload,
                  textHint: 'Velocidad de bajada',
                ),
              ),
              Visibility(
                visible: limitSpeed,
                child: StarlinkTextField(
                  title: "Subida",
                  textSuffix: "MBs",
                  onChanged: (str) {
                    limitUpload = str;
                  },
                  keyboardType: TextInputType.number,
                  initialValue: limitUpload,
                  textHint: 'Velocidad de subida',
                ),
              ),
              const Spacer(),
              StarlinkButton(
                text: widget.current != null && !widget.newProfile
                    ? "Modificar"
                    : 'Crear',
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                  }
                  if (durationT == "1") {
                    durationT = "1d";
                  }
                  if (price == "1") {
                    price = "1S";
                  }
                  profile.sharedUsers = numberOfSharedUserPerTicket;
                  profile.rateLimit = limitSpeed
                      ? "${limitDownload.toUpperCase()}M/${limitUpload
                      .toUpperCase()}M"
                      : "";
                  if (widget.current != null) {
                    if (widget.newProfile) {
                      var p = price.substring(0, price.length - 1);
                      profile.metadata = ProfileMetadata(
                        hotspot: "",
                        prefix: price.replaceAll(RegExp(r"\D"), ""),
                        userLength: 5,
                        passwordLength: 5,
                        dataLimit: 0,
                        price: double.parse(p),
                        usageTime: durationT,
                        durationType: DurationType.SaveTime,
                        isNumericUser: true,
                        isNumericPassword: true,
                      );
                      widget.bloc.add(NewProfile(profile, durationT));
                    } else {
                      var p = price.substring(0, price.length - 1);
                      profile.metadata = ProfileMetadata(
                        hotspot: "",
                        prefix: price.replaceAll(RegExp(r"\D"), ""),
                        userLength: 5,
                        passwordLength: 5,
                        dataLimit: 0,
                        price: double.parse(p),
                        usageTime: durationT,
                        durationType: DurationType.SaveTime,
                        isNumericUser: true,
                        isNumericPassword: true,
                      );
                      widget.bloc.add(UpdateProfile(profile));
                    }
                  } else {
                    var p = price.substring(0, price.length - 1);
                    profile.metadata = ProfileMetadata(
                      hotspot: "",
                      prefix: price.replaceAll(RegExp(r"\D"), ""),
                      userLength: 5,
                      passwordLength: 5,
                      dataLimit: 0,
                      price: double.parse(p),
                      usageTime: durationT,
                      durationType: DurationType.SaveTime,
                      isNumericUser: true,
                      isNumericPassword: true,
                    );
                    widget.bloc.add(NewProfile(profile, durationT));
                  }
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ));
  }

  String mapDurationUnit(String str) {
    switch (str) {
      case "m":
        return "Minutos";
      case "h":
        return "Horas";
      case "d":
        return "Días";
      case "s":
        return "Semanas";
      default:
        throw Exception("Invalid duration unit");
    }
  }
}

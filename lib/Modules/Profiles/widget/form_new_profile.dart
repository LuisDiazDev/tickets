import 'package:StarTickera/models/profile_metadata_model.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../Widgets/starlink/button.dart';
import '../../../Widgets/starlink/checkbox.dart';
import '../../../Widgets/starlink/colors.dart';
import '../../../Widgets/starlink/dropdown.dart';
import '../../../Widgets/starlink/section_title.dart';
import '../../../Widgets/starlink/text_field.dart';
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
      limitDownload = "1",
      limitData = "0";

  bool limitSpeed = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    profile = widget.current ?? ProfileModel(name: "Nuevo plan");
    if (widget.current != null) {
      String currentPrice = profile.metadata?.price.toString() ?? "";
      initialCurrency = currentPrice.split(RegExp(r"[0-9]")).last;
      if (initialCurrency == "") {
        initialCurrency = "S";
      }

      initialDurationUnit = profile.metadata!.usageTime.toString();
      var num = initialDurationUnit.replaceAll(RegExp(r"\D"), "");
      initialDurationUnit = initialDurationUnit.replaceAll(num, "");
      price = currentPrice.replaceAll(initialCurrency, "");
      price = price.endsWith(".0") ? price.replaceAll(".0", "") : price;
      durationT = num.toString();
      limitSpeed =
          widget.current?.rateLimit != null && widget.current!.rateLimit != "";
      if (limitSpeed) {
        var str = widget.current!.rateLimit!
            .toLowerCase()
            .replaceAll("m", "")
            .split("/");
        limitDownload = str.first;
        limitUpload = str.last;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: StarlinkColors.darkGray,
      resizeToAvoidBottomInset: true,
      body: Form(
          key: _formKey,
          child: Container(
            height: MediaQuery.of(context).size.height,
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
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
                    validator: (value) {
                      if (value == "") {
                        return "*requerido";
                      }
                      return null;
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
                          validator: (value) {
                            if (value == "") {
                              return "*requerido";
                            }
                            return null;
                          },
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
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
                          readOnly: true,
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
                          validator: (value) {
                            if (value == "") {
                              return "*requerido";
                            }
                            return null;
                          },
                          initialValue: durationT,
                          keyboardType: TextInputType.number,
                          textHint: "Duración del plan",
                        ),
                      ),
                      Column(children: [
                        const Gap(20),
                        StarlinkDropdown(
                          onChanged: (str) {
                            setState(() {
                              initialDurationUnit = str![0].toLowerCase();
                            });
                          },
                          values: const ["Minutos", "Horas", "Días"],
                          initialValue: mapDurationUnit(initialDurationUnit),
                        ),
                      ]),
                    ],
                  ),
                  // const Gap(1),
                  // Row(
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   children: [
                  //     Visibility(
                  //       visible: durationT != "",
                  //         child: Expanded(
                  //       child: StarlinkTextField(
                  //         title: "Duración",
                  //         onChanged: (str) {},
                  //         readOnly: true,
                  //         initialValue: durationT,
                  //         keyboardType: TextInputType.number,
                  //         textHint: "Duración del plan",
                  //       ),
                  //     )),
                  //     Column(children: [
                  //       SizedBox(
                  //         width: 200,
                  //         child: StarlinkButton(
                  //           text: durationT != "" ? "Modificar" : 'Nueva',
                  //           onPressed: () {},
                  //         ),
                  //       ),
                  //     ]),
                  //   ],
                  // ),
                  const Gap(1),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width / 2.2,
                      child: StarlinkTextField(
                        title: "Usuarios por ticket",
                        onChanged: (str) {
                          numberOfSharedUserPerTicket = str ?? "1";
                        },
                        validator: (value) {
                          if (value == "") {
                            return "*requerido";
                          }
                          return null;
                        },
                        keyboardType: TextInputType.number,
                        initialValue: numberOfSharedUserPerTicket,
                        textHint: "Número de usuarios por ticket",
                      ),
                    ),
                  ),
                  const Gap(8),
                  StarlinkCheckBox(
                    title: 'Limitar',
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
                      validator: (value) {
                        if (value == "") {
                          return "*requerido";
                        }
                        return null;
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
                      validator: (value) {
                        if (value == "") {
                          return "*requerido";
                        }
                        return null;
                      },
                      keyboardType: TextInputType.number,
                      initialValue: limitUpload,
                      textHint: 'Velocidad de subida',
                    ),
                  ),
                  Visibility(
                    visible: limitSpeed,
                    child: StarlinkTextField(
                      title: "Max total de mb (0 es ilimitado)",
                      textSuffix: "MBs",
                      onChanged: (str) {
                        limitData = str;
                      },
                      validator: (value) {
                        if (value == "") {
                          return "*requerido";
                        }
                        return null;
                      },
                      keyboardType: TextInputType.number,
                      initialValue: limitData,
                      textHint: 'Max total de mb',
                    ),
                  ),
                  Visibility(
                    visible: !limitSpeed,
                    child: const Gap(160),
                  ),
                  const Gap(8),
                  StarlinkButton(
                    text: widget.current != null && !widget.newProfile
                        ? "Modificar"
                        : 'Crear',
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        if (durationT+initialDurationUnit == "1") {
                          durationT = "1d";
                        }
                        if (price == "1") {
                          price = "1S";
                        }

                        profile.onLogin =
                        '{local voucher \$user; :if ([/system scheduler find name=\$voucher]="") do={/system scheduler add comment=\$voucher name=\$voucher interval="${parseDuration(durationT+initialDurationUnit)}" on-event="/ip hotspot active remove [find user=\$voucher]\r\n/ip hotspot user remove [find name=\$voucher]\r\n/system schedule remove [find name=\$voucher]"}}';

                        profile.sharedUsers = numberOfSharedUserPerTicket;
                        profile.rateLimit = limitSpeed
                            ? "${limitDownload.toUpperCase()}M/${limitUpload.toUpperCase()}M"
                            : "";
                        if (widget.current != null) {
                          if (widget.newProfile) {
                            var p = price.substring(0, price.length - 1);
                            profile.metadata = ProfileMetadata(
                              hotspot: "",
                              type: "1",
                              prefix: price.replaceAll(RegExp(r"\D"), ""),
                              userLength: 5,
                              passwordLength: 5,
                              dataLimit: int.tryParse(limitData) ?? 0,
                              price: double.parse(p),
                              usageTime: parseDuration(durationT+initialDurationUnit),
                              durationType: DurationType.SaveTime,
                              isNumericUser: true,
                              isNumericPassword: true,
                            );
                            widget.bloc.add(NewProfile(profile, durationT+initialDurationUnit));
                          } else {
                            var p = price.substring(0, price.length - 1);
                            profile.metadata = ProfileMetadata(
                              hotspot: "",
                              type: "1",
                              prefix: price.replaceAll(RegExp(r"\D"), ""),
                              userLength: 5,
                              passwordLength: 5,
                              dataLimit: int.tryParse(limitData) ?? 0,
                              price: double.parse(p),
                              usageTime: parseDuration(durationT+initialDurationUnit),
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
                            type: "1",
                            prefix: price.replaceAll(RegExp(r"\D"), ""),
                            userLength: 5,
                            passwordLength: 5,
                            dataLimit: int.tryParse(limitData) ?? 0,
                            price: double.parse(p),
                            usageTime: parseDuration(durationT+initialDurationUnit),
                            durationType: DurationType.SaveTime,
                            isNumericUser: true,
                            isNumericPassword: true,
                          );
                          widget.bloc.add(NewProfile(profile, durationT+initialDurationUnit));
                        }
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                ],
              ),
            ),
          )),
    );
  }

  String parseDuration(String duration){
    String days="0d",hours="00",min="00";

    if(duration.contains("m")){
      min = duration.substring(0,duration.length - 1);
    }else if(duration.contains("h")){
      hours = duration.substring(0,duration.length - 1);
    }else if(duration.contains("d")){
      days = duration;
    }

    return "$days-$hours:$min:00";
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

  String? getScript(String durationT) {
    switch (durationT) {
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

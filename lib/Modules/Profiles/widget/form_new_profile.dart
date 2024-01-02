import 'package:TicketOs/models/profile_metadata_model.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../Core/Values/Colors.dart';
import '../../../Widgets/check_box.dart';
import '../../../Widgets/custom_dropdown.dart';
import '../../../Widgets/custom_text_field.dart';
import '../../../models/config_model.dart';
import '../../../models/profile_model.dart';
import '../bloc/ProfileBloc.dart';
import '../bloc/ProfileEvents.dart';

class FormNewProfileWidget extends StatefulWidget {
  final ProfileModel? current;
  final ProfileBloc bloc;

  const FormNewProfileWidget({super.key, this.current, required this.bloc});

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
      String currentPrice = profile.metadata?.price.toString() ?? "";
      initialCurrency = currentPrice.split(RegExp(r"[0-9]")).last;
      if (initialCurrency == "") {
        initialCurrency = "S";
      }

      initialDurationUnit = profile.metadata!.usageTime.toString();
      price = currentPrice.replaceAll(initialCurrency, "");
      durationT = initialDurationUnit.toString();
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
    return Form(
      child: DefaultTextStyle(
        style: const TextStyle(
            color: ColorsApp.primary,
            fontFamily: 'poppins_bold',
            fontWeight: FontWeight.w600,
            fontSize: 26),
        child: IntrinsicWidth(
          child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    color: ColorsApp.secondary.withOpacity(.8),
                    width: double.infinity,
                    child: Column(
                      children: [
                        const Gap(10),
                        Text(
                          profile.name??"",
                          style: const TextStyle(
                              color: ColorsApp.primary,
                              fontFamily: 'poppins_bold',
                              fontWeight: FontWeight.w600,
                              fontSize: 26),
                        ),
                        const Gap(20),
                      ],
                    ),
                  ),
                  CustomTextField(
                    onChanged: (str) {
                      profile.name = str ?? "";
                    },
                    title: "Nombre",
                    initialValue: profile.name??"",
                  ),
                  const Gap(10),
                  CustomDropDown(
                    onChange: (str) {
                      price = str ?? "1";
                    },
                    keyboard:
                        const TextInputType.numberWithOptions(decimal: true),
                    title: "Precio",
                    initialDropdown: initialCurrency,
                    initialString: price,
                    item: ConfigModel.settings["currency"] ?? [],
                  ),
                  const Gap(10),
                  CustomDropDown(
                    onChange: (str) {
                      durationT = str ?? durationT[durationT.length - 1];
                    },
                    initialString: durationT,
                    keyboard: TextInputType.number,
                    title: "Duracion",
                    initialDropdown: "m",
                    item: ConfigModel.settings["range-datetime"] ?? [],
                  ),
                  CustomTextField(
                    onChanged: (str) {
                      numberOfSharedUserPerTicket = str ?? "1";
                    },
                    keyboard: TextInputType.number,
                    title: "Veces que se puede usar el ticket",
                    initialValue: numberOfSharedUserPerTicket,
                  ),
                  CheckBoxControl(
                    title: "Limitar velocidad",
                    checked: limitSpeed,
                    onChanged: (check) {
                      setState(() {
                        limitSpeed = check;
                      });
                    },
                  ),
                  Visibility(
                    visible: limitSpeed,
                    child: CustomTextField(
                      leathig: "MBs",
                      onChanged: (str) {
                        limitDownload = str!;
                      },
                      keyboard: TextInputType.number,
                      title: "Bajada",
                      initialValue: limitDownload,
                    ),
                  ),
                  Visibility(
                    visible: limitSpeed,
                    child: CustomTextField(
                      leathig: "MBs",
                      onChanged: (str) {
                        limitUpload = str!;
                      },
                      title: "Subida",
                      keyboard: TextInputType.number,
                      initialValue: limitUpload,
                    ),
                  ),
                  const Spacer(),
                  MaterialButton(
                    height: 45,
                    shape: const StadiumBorder(),
                    color: ColorsApp.secondary,
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
                          ? "${limitDownload.toUpperCase()}M/${limitUpload.toUpperCase()}M"
                          : "";
                      if (widget.current != null) {
                        widget.bloc.add(UpdateProfile(profile));
                      } else {
                        var p = price.substring(0, price.length - 1);
                        profile.metadata = ProfileMetadata(
                          hotspot: "",
                          prefix: "",
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
                    child: Text(
                      widget.current != null ? "Modificar" : 'Crear',
                      style: const TextStyle(
                          color: ColorsApp.primary,
                          fontFamily: "poppins_bold",
                          fontWeight: FontWeight.w600,
                          fontSize: 18),
                    ),
                  ),
                  const Gap(10),
                ],
              )),
        ),
      ),
    );
  }
}

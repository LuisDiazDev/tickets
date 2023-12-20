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
  String cant = "1",
      initialDuration = "d",
      initialPrice = "S",
      durationT = "1",
      price = "1",
      limitUpload = "1",
      limitDownload = "1";
  bool limitSpeed = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    profile = widget.current ?? ProfileModel(name: "Nuevo Plan");
    if (widget.current != null) {
      String currentPrice = profile.onLogin?.split(",")[4] ?? "";
      String currentDuration = profile.onLogin?.split(",")[3] ?? "";
      initialPrice = currentPrice
          .split(RegExp(r"[0-9]"))
          .last;
      initialDuration = currentDuration
          .split(RegExp(r"[0-9]"))
          .last;
      price = currentPrice.replaceAll(initialPrice, "");
      durationT = currentDuration.replaceAll(initialDuration, "");
      limitSpeed =
          widget.current?.rateLimit != null && widget.current!.rateLimit != "";
      if (limitSpeed) {
        var str = widget.current!
            .rateLimit!.toLowerCase()
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
                          profile.name!,
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
                    initialValue: profile.name!,
                  ),
                  const Gap(10),
                  CustomDropDown(
                    onChange: (str) {
                      price = str ?? "1";
                    },
                    keyboard: const TextInputType.numberWithOptions(
                        decimal: true),
                    title: "Precio",
                    initialDropdown: initialPrice,
                    initialString: price,
                    item: ConfigModel.settings["currency"] ?? [],
                  ),
                  const Gap(10),
                  CustomDropDown(
                    onChange: (str) {
                      durationT = str ?? "m";
                    },
                    initialString: durationT,
                    keyboard: TextInputType.number,
                    title: "Duracion",
                    initialDropdown: initialDuration,
                    item: ConfigModel.settings["range-datetime"] ?? [],
                  ),
                  CustomTextField(
                    onChanged: (str) {
                      cant = str ?? "1";
                    },

                    keyboard: TextInputType.number,
                    title: "Cantidad de usuarios con mismo codigo",
                    initialValue: cant,
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
                      // var validity = "1d";
                      // var lock = '; [:local mac \$"mac-address"; /ip hotspot user set mac-address=\$mac [find where name=\$user]]';
                      // var sLock = '; [:local mac \$"mac-address"; :local srv [/ip hotspot host get [find where mac-address="\$mac"] server]; /ip hotspot user set server=\$srv [find where name=\$user]]';
                      // var record = '; :local mac \$"mac-address"; :local time [/system clock get time ]; /system script add name="\$date-|-\$time-|-\$user-|-$price-|-\$address-|-\$mac-|-$durationT-|-${profile.name}.-|-\$comment" owner="\$month\$year" source=\$date comment=RouterOs';
                      var remove = '; {put (",rem,$price,$durationT,$price,,Enable,Enable,"); :local voucher \$user; :if ([/system scheduler find name=\$voucher]="") do={/system scheduler add comment=\$voucher name=\$voucher interval=$durationT on-event="/ip hotspot active remove [find user=\$voucher]\r\n/ip hotspot user remove [find name=\$voucher]\r\n/system schedule remove [find name=\$voucher]"}}';
                      // var onLogin = ':put (",rem,$price,$durationT,$price,,Enable,Enable,"); :local mode "X"; {:local date [ /system clock get date ];:local year [ :pick \$date 7 11 ];:local month [ :pick \$date 0 3 ];:local comment [ /ip hotspot user get [/ip hotspot user find where name="\$user"] comment]; :local ucode [:pic \$comment 0 2]; :if (\$ucode = "vc" or \$ucode = "up" or \$comment = "") do={ /sys sch add name="\$user" disable=no start-date=\$date interval="$durationT"; :delay 2s; :local exp [ /sys sch get [ /sys sch find where name="\$user" ] next-run]; :local getxp [len \$exp]; :if (\$getxp = 15) do={ :local d [:pic \$exp 0 6]; :local t [:pic \$exp 7 16]; :local s ("/"); :local exp ("\$d\$s\$year \$t"); /ip hotspot user set comment="\$exp \$mode" [find where name="\$user"];}; :if (\$getxp = 8) do={ /ip hotspot user set comment="\$date \$exp \$mode" [find where name="\$user"];}; :if (\$getxp > 15) do={ /ip hotspot user set comment="\$exp \$mode" [find where name="\$user"];}; /sys sch remove [find where name="\$user"]';

                      profile.onLogin =remove;// "$onLogin$record$lock$sLock}}";
                      profile.sharedUsers = cant;
                      profile.rateLimit =
                      limitSpeed ? "${limitDownload
                          .toUpperCase()}M/${limitUpload.toUpperCase()}M" : "";

                      if (widget.current != null) {
                        widget.bloc.add(UpdateProfile(profile));
                      } else {
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

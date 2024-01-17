import 'package:StarTickera/Modules/Clients/bloc/ClientsBloc.dart';
import 'package:StarTickera/Widgets/starlink/text_style.dart';
import 'package:StarTickera/models/ticket_model.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../Widgets/starlink/button.dart';
import '../../../Widgets/starlink/checkbox.dart';
import '../../../Widgets/starlink/dropdown.dart';
import '../../../Widgets/starlink/section_title.dart';
import '../../../Widgets/starlink/text_field.dart';
import '../bloc/ClientsEvents.dart';

class FormClientWidget extends StatefulWidget {
  final TicketModel? current;
  final ClientsBloc bloc;
  final bool newClient;

  const FormClientWidget(
      {super.key, this.current, required this.bloc, this.newClient = false});

  @override
  State<FormClientWidget> createState() => _FormClientWidgetState();
}

class _FormClientWidgetState extends State<FormClientWidget> {
  late TicketModel client;
   late String profile;

  bool limitSpeed = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    client = widget.current ?? TicketModel(name: "Cliente");
    profile = widget.bloc.state.profiles.first.name!;

    if (widget.current != null) {
      // String currentPrice = client.metadata?.price.toString() ?? "";
      // initialCurrency = currentPrice.split(RegExp(r"[0-9]")).last;
      // if (initialCurrency == "") {
      //   initialCurrency = "S";
      // }
      //
      // initialDurationUnit = client.metadata!.usageTime.toString();
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
        child: Container(
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              // Encaabezado
              StarlinkSectionTitle(
                title: client.name ?? "",
              ),
              StarlinkTextField(
                onChanged: (str) {
                  client.name = str;
                },
                title: "Nombre del Cliente",
                initialValue: client.name ?? "",
                textHint: "Nombre del Cliente",
              ),
              const Gap(8),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: StarlinkText("Seleccione un plan"),
                  ),
                  const Gap(4),
                  StarlinkDropdown(
                    onChanged: (str) {
                      profile = str!;
                    },
                    values: widget.bloc.state.profiles.map((e) => e.name ?? "").toList(),
                    initialValue: profile,
                  ),
                ],
              ),
             Spacer(),
              StarlinkButton(
                text: widget.current != null && !widget.newClient
                    ? "Modificar"
                    : 'Crear',
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                  }

                  var p = widget.bloc.state.profiles.firstWhere((p) => p.name == profile);

                  var duration = p.metadata?.usageTime ?? "";
                  var price = p.metadata?.price ?? "";
                  var limit = p.metadata?.dataLimit ?? 0;
                  widget.bloc.add(GenerateClient(
                      p.metadata!.toMikrotiketNameString(
                          p.name ?? ""),
                      client.name!,
                      duration,
                      price.toString(),
                      limitMb: limit
                  ));

                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ));
  }
}

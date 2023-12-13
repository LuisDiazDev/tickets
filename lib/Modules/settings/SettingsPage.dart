import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:tickets/Core/Widgets/custom_appbar.dart';
import 'package:tickets/Core/localization/app_localization.dart';
import 'package:tickets/Core/utils/navigator_service.dart';
import 'package:tickets/Modules/Alerts/AlertCubit.dart';
import 'package:tickets/models/config_model.dart';
import '../../Core/Values/Colors.dart';
import '../../Core/Widgets/custom_text_field.dart';
import '../../Routes/Route.dart';
import '../Session/SessionCubit.dart';
import '../drawer/drawer.dart';
import 'print_setting.dart';

import 'dart:convert';
import 'dart:typed_data';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final sessionBloc = BlocProvider.of<SessionCubit>(context);
    final alertBloc = BlocProvider.of<AlertCubit>(context);

    return BlocBuilder<SessionCubit, SessionState>(builder: (context, state) {
      return Scaffold(
        backgroundColor: ColorsApp.grey.withOpacity(.9),
        drawer: const DrawerCustom(),
        appBar: customAppBar(title: "title_configuration".tr),
        body: Container(
          color: Colors.transparent,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Gap(20),
              PrintSettings(
                sessionBloc: sessionBloc,
              ),
              const Gap(25),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                child: Text(
                  "Information".tr,
                  style: const TextStyle(
                      fontFamily: 'poppins_bold',
                      fontSize: 20,
                      color: ColorsApp.secondary,
                      fontWeight: FontWeight.w500),
                ),
              ),
              const Divider(
                height: 2,
                color: Colors.black,
                endIndent: 18,
                indent: 18,
              ),
              CustomTextField(
                initialValue: sessionBloc.state.cfg?.nameBusiness ?? "",
                onChanged: (str) {
                  sessionBloc.changeState(sessionBloc.state.copyWith(
                      configModel:
                          sessionBloc.state.cfg!.copyWith(nameBusiness: str)));
                },
                title: "name_bussines".tr,
              ),
              CustomTextField(
                initialValue: sessionBloc.state.cfg?.contact ?? "",
                onChanged: (str) {
                  sessionBloc.changeState(sessionBloc.state.copyWith(
                      configModel:
                          sessionBloc.state.cfg!.copyWith(contact: str ?? "")));
                },
                title: "telephone".tr,
              ),
              const Gap(5),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(
                    // width: MediaQuery.sizeOf(context).width * .6,
                    child: CustomTextField(
                      initialValue: sessionBloc.state.cfg?.dnsNamed ?? "",
                      onChanged: (str) {
                        sessionBloc.changeState(sessionBloc.state.copyWith(
                            configModel: sessionBloc.state.cfg!
                                .copyWith(contact: str ?? "")));
                      },
                      title: "Inicio",
                    ),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.only(top: 42),
                  //   child: MaterialButton(
                  //     onPressed: () async {
                  //       // sessionBloc
                  //     },
                  //     color: ColorsApp.secondary,
                  //     child: const Text(
                  //       "Actualizar",
                  //       style: TextStyle(
                  //           fontFamily: 'poppins_semi_bold',
                  //           fontSize: 12,
                  //           color: ColorsApp.primary,
                  //           fontWeight: FontWeight.w400),
                  //     ),
                  //   ),
                  // )
                ],
              ),
              const Gap(12),
              // Padding(
              //   padding: const EdgeInsets.symmetric(
              //     horizontal: 16,
              //   ),
              //   child: Row(
              //     children: [
              //       Text(
              //         "businnes_logo".tr,
              //         style: const TextStyle(
              //             fontFamily: 'poppins_semi_bold',
              //             fontSize: 18,
              //             color: ColorsApp.secondary,
              //             fontWeight: FontWeight.w400),
              //       ),
              //       const Spacer(),
              //       MaterialButton(
              //         onPressed: () async {
              //           final ImagePicker picker = ImagePicker();
              //           final XFile? pickedFile = await picker.pickImage(
              //               source: ImageSource.gallery,
              //               maxHeight: 80,
              //               maxWidth: 80);
              //           var data = await pickedFile?.readAsBytes();
              //           if (data != null) {
              //             var str = base64String(data);
              //             sessionBloc.changeState(sessionBloc.state.copyWith(
              //                 configModel: sessionBloc.state.cfg!
              //                     .copyWith(pathLogo: str)));
              //           }
              //         },
              //         color: ColorsApp.secondary,
              //         child: const Text(
              //           "seleccionar",
              //           style: TextStyle(
              //               fontFamily: 'poppins_semi_bold',
              //               fontSize: 18,
              //               color: ColorsApp.primary,
              //               fontWeight: FontWeight.w400),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              // Visibility(
              //   visible: sessionBloc.state.cfg!.pathLogo != "",
              //   child: Row(
              //     children: [
              //       const Spacer(),
              //       imageFromBase64String(sessionBloc.state.cfg!.pathLogo),
              //       const Spacer()
              //     ],
              //   ),
              // ),
              const Gap(10),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                child: Text(
                  "conection".tr,
                  style: const TextStyle(
                      fontFamily: 'poppins_bold',
                      fontSize: 20,
                      color: ColorsApp.secondary,
                      fontWeight: FontWeight.w500),
                ),
              ),
              const Divider(
                height: 2,
                color: Colors.black,
                endIndent: 18,
                indent: 18,
              ),
              CustomTextField(
                initialValue: sessionBloc.state.cfg?.host ?? "",
                onChanged: (str) {
                  sessionBloc.changeState(sessionBloc.state.copyWith(
                      configModel: sessionBloc.state.cfg!.copyWith(host: str)));
                },
                title: "Mikrotik",
              ),
              CustomTextField(
                initialValue: sessionBloc.state.cfg?.user ?? "",
                onChanged: (str) {
                  sessionBloc.changeState(sessionBloc.state.copyWith(
                      configModel: sessionBloc.state.cfg!.copyWith(user: str)));
                },
                title: "user".tr,
              ),
              CustomTextField(
                initialValue: sessionBloc.state.cfg?.password ?? "",
                onChanged: (str) {
                  sessionBloc.changeState(sessionBloc.state.copyWith(
                      configModel:
                          sessionBloc.state.cfg!.copyWith(password: str)));
                },
                password: true,
                title: "password".tr,
              ),
              const Gap(8),
              Row(
                children: [
                  const Gap(12),
                  MaterialButton(
                    color: ColorsApp.secondary,
                    onPressed: ()async {
                      await sessionBloc.checkConnection(alertBloc);
                    },
                    child: const Text("Comprobar Conexion",
                        style: TextStyle(
                            color: ColorsApp.primary,
                            fontFamily: 'poppins_normal',
                            fontSize: 18)),
                  ),
                  const Spacer(),
                  MaterialButton(
                    color: ColorsApp.secondary,
                    onPressed: () {
                      sessionBloc.changeState(sessionBloc.state
                          .copyWith(configModel: ConfigModel.defaultConfig));
                      NavigatorService.pushNamedAndRemoveUntil(Routes.settings);
                    },
                    child: Text("Reset".tr,
                        style: const TextStyle(
                            color: ColorsApp.primary,
                            fontFamily: 'poppins_normal',
                            fontSize: 18)),
                  ),
                  const Gap(12),
                ],
              ),
              const Gap(16),
            ],
          )),
        ),
      );
    });
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

/*
*
* */
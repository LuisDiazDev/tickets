import 'dart:developer';
import 'dart:io';

import 'package:TicketOs/Modules/Alerts/AlertCubit.dart';
import 'package:bluetooth_print/bluetooth_print.dart';
import 'package:bluetooth_print/bluetooth_print_model.dart';
import 'package:device_info/device_info.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:flutter_reactive_ble/src/discovered_devices_registry.dart';
import 'package:gap/gap.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../Core/Values/Colors.dart';
import '../../Data/Services/printer_service.dart';
import '../Session/SessionCubit.dart';

class PrintSettings extends StatelessWidget {
  const PrintSettings(
      {super.key, required this.sessionBloc, required this.alertCubit});

  final SessionCubit sessionBloc;
  final AlertCubit alertCubit;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      child: Row(
        children: [
          const Text(
            "Impresora:",
            style: TextStyle(
                fontFamily: 'poppins_semi_bold',
                fontSize: 18,
                color: ColorsApp.secondary,
                fontWeight: FontWeight.w400),
          ),
          const Spacer(),
          connected(context)
        ],
      ),
    );
  }

  Future<bool> checkIfThePermissionIsGranted(
      Map<Permission, PermissionStatus> statuses,
      context,
      printerService) async {
    var perms = await buildPermissionList();
    for (var perm in perms) {
      if (statuses[perm]!.isDenied) {
        openAlertBox(context, printerService);
        return false;
      }
    }
    return true;
  }

  Future<List<Permission>> buildPermissionList() async {
    List<Permission> permissionsToRequest = [];

    // Permisos para ambos, Android y iOS
    permissionsToRequest.add(Permission.locationWhenInUse);

    if (Platform.isAndroid) {
      DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
      final androidInfo = await deviceInfoPlugin.androidInfo;
      var androidVersion = androidInfo.version.sdkInt;
      if (androidVersion <= 30) {
        // Android 11 o inferior
        permissionsToRequest.add(Permission.bluetooth);
      } else {
        // Android 12 o superior
        permissionsToRequest.addAll([
          Permission.bluetoothScan,
          Permission.bluetoothConnect,
        ]);
      }
    } else if (Platform.isIOS) {
      // En iOS, solo necesitas agregar el permiso de Bluetooth si tu aplicación lo usa.
      // Asegúrate de tener los permisos adecuados en el Info.plist.
      permissionsToRequest.add(Permission.bluetooth);
    }
    // Solicitar permisos
    return permissionsToRequest;
  }

  Widget connected(BuildContext context) {
    PrinterService printerService = PrinterService();

    return StreamBuilder<int>(
        stream:  sessionBloc.state.cfg!.bluetoothPrintService.state,
        builder: (context, AsyncSnapshot<int> snapchat) {
          switch (snapchat.data) {
            case 12:
              return Row(
                children: [
                  TextButton(
                      onPressed: () async {
                        await showBluetoothDevicesList(context, printerService);
                      },
                      child: Text(
                        "Conectada",
                        style: TextStyle(color: Colors.blueAccent),
                      )),
                  const Gap(3),
                  const Icon(
                    EvaIcons.printer,
                    color: Colors.green,
                  )
                ],
              );
            case 0:
              return Row(
                children: [
                  TextButton(
                      onPressed: () async {
                        await showBluetoothDevicesList(context, printerService);
                      },
                      child: const Text(
                        "Desconectada",
                        style: TextStyle(
                            fontFamily: 'poppins_semi_bold',
                            fontSize: 18,
                            color: Colors.red,
                            fontWeight: FontWeight.w400),
                      )),
                  const Gap(3),
                  const Icon(
                    EvaIcons.printer,
                    color: Colors.red,
                  )
                ],
              );
            default:
              return Row(
                children: [
                  TextButton(
                      onPressed: () async {
                        await showBluetoothDevicesList(context, printerService);
                      },
                      child: const Text(
                        "Conectar",
                        style: TextStyle(
                            fontFamily: 'poppins_semi_bold',
                            fontSize: 18,
                            color: Colors.red,
                            fontWeight: FontWeight.w400),
                      )),
                  const Gap(3),
                  const Icon(
                    EvaIcons.printer,
                    color: Colors.red,
                  )
                ],
              );
          }
        });
  }

  Future<void> showBluetoothDevicesList(
      BuildContext context, PrinterService printerService) async {
    Map<Permission, PermissionStatus> statuses =
        await (await buildPermissionList()).request();
    var wasApproved =
        await checkIfThePermissionIsGranted(statuses, context, printerService);
    if (wasApproved) {
      await openAlertBox(context, printerService);
    } else {
      alertCubit.showDialog(
          "error", "recuerda mantener activo el bluetooth y el gps");
    }
  }

  Future openAlertBox(BuildContext context, PrinterService printer) async {
    sessionBloc.state.cfg?.bluetoothDevices = {};
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(32.0))),
            contentPadding: const EdgeInsets.only(top: 10.0),
            content: SizedBox(
              width: 300.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        "Dispositivos",
                        style: TextStyle(fontSize: 24.0),
                      ),
                      Icon(
                        EvaIcons.bluetooth,
                        color: ColorsApp.green,
                        size: 30.0,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),
                  const Divider(
                    color: Colors.grey,
                    height: 4.0,
                  ),
                  Container(
                      padding: EdgeInsets.only(left: 30.0, right: 30.0),
                      child: // get devices
                          SingleChildScrollView(
                        child: StreamBuilder<DiscoveredDevice>(
                          stream: sessionBloc.state.cfg!.bluetoothScanService
                              .scanForDevices(
                                  withServices: [],
                                  // scanMode: ScanMode.lowLatency,
                                  requireLocationServicesEnabled: true),
                          builder: (c, snapshot) {
                            if (!snapshot.hasData) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            if (snapshot.data != null) {
                              if (snapshot.data!.name.isNotEmpty) {
                                var bluetooth = snapshot.data!;
                                var btDevice = BluetoothDevice.fromJson({
                                  "name": bluetooth.name,
                                  "address": bluetooth.id,
                                  "type": bluetooth.rssi,
                                  "connected": false,
                                });
                                sessionBloc.state.cfg!
                                        .bluetoothDevices[btDevice.address!] =
                                    btDevice;
                              }
                            }
                            return Column(
                              children: sessionBloc
                                  .state.cfg!.bluetoothDevices.values
                                  .toList()
                                  .map((bluetooth) {
                                late Icon icon;
                                late Widget title;
                                if (bluetooth.name!
                                    .toLowerCase()
                                    .contains("printer")) {
                                  icon = const Icon(
                                    EvaIcons.printerOutline,
                                    color: ColorsApp.green,
                                  );
                                  // bold title
                                  title = Text(
                                    bluetooth.name ?? '',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  );
                                } else {
                                  icon = const Icon(
                                    EvaIcons.bluetooth,
                                    color: ColorsApp.green,
                                  );
                                  title = Text(
                                    bluetooth.name ?? '',
                                  );
                                }

                                return ListTile(
                                  title: title,
                                  subtitle: Text(bluetooth.address ?? ""),
                                  onTap: () async {
                                    alertCubit.showAlertInfo(
                                        title: "Aviso",
                                        subtitle:
                                            "Conectando con el dispositivo ${bluetooth.name}");
                                    sessionBloc.changeState(sessionBloc.state
                                        .copyWith(
                                            configModel: sessionBloc.state.cfg!
                                                .copyWith(
                                                    connected: true,
                                                    bluetoothDevice: bluetooth
                                                      ..connected = false)));
                                    await sessionBloc
                                        .state.cfg!.bluetoothPrintService
                                        .connect(bluetooth);
                                    alertCubit.showAlertInfo(
                                        title: "Conectado",
                                        subtitle:
                                            "Conectado la impresora ${bluetooth.name}");
                                    Navigator.pop(context);
                                  },
                                  trailing: icon,
                                );
                              }).toList(),
                            );
                          },
                        ),
                      )),
                ],
              ),
            ),
          );
        });
  }
}

import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:TicketOs/Modules/Alerts/AlertCubit.dart';
import 'package:device_info/device_info.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_esc_pos_utils/flutter_esc_pos_utils.dart';
import 'package:gap/gap.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../Core/Values/Colors.dart';
import '../Session/SessionCubit.dart';

const validBluetoothCharacteristics = [
  "2af1",
  "bef8d6c9-9c21-4c9e-b632-bd58c1009f9f",
  "49535343-8841-43f4-a8d4-ecbe34729bb3"
];

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
      Map<Permission, PermissionStatus> statuses, context) async {
    var perms = await buildPermissionList();
    for (var perm in perms) {
      if (statuses[perm]!.isDenied) {
        showBluetoothDeviceListPopUp(context);
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
          Permission.bluetoothAdvertise,
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
    if (sessionBloc.state.cfg!.bluetoothDevice == null) {
      return Row(
        children: [
          TextButton(
              onPressed: () async {
                await showBluetoothDevicesList(context);
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
    return StreamBuilder<BluetoothConnectionState>(
        stream: sessionBloc.state.cfg!.bluetoothDevice!.connectionState,
        builder: (context, AsyncSnapshot<BluetoothConnectionState> snapchat) {
          switch (snapchat.data) {
            case BluetoothConnectionState.connected:
              return Row(
                children: [
                  TextButton(
                      onPressed: () async {
                        await showBluetoothDevicesList(context);
                      },
                      child: const Text(
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
            case BluetoothConnectionState.disconnected:
              return Row(
                children: [
                  TextButton(
                      onPressed: () async {
                        await showBluetoothDevicesList(context);
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
                        await showBluetoothDevicesList(context);
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

  Future<void> showBluetoothDevicesList(BuildContext context) async {
    Map<Permission, PermissionStatus> statuses =
        await (await buildPermissionList()).request();
    var wasApproved = await checkIfThePermissionIsGranted(statuses, context);
    if (wasApproved) {
      await showBluetoothDeviceListPopUp(context);
    } else {
      alertCubit.showDialog(
          "error", "recuerda mantener activo el bluetooth y el gps");
    }
  }

  Future showBluetoothDeviceListPopUp(BuildContext context) async {
    FlutterBluePlus.startScan(withServices: [
      Guid.fromString("e7810a71-73ae-499d-8c15-faa9aef0c3f2")
    ]);
    // FlutterBluePlus.startScan();
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
                      padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                      child: // get devices
                          SingleChildScrollView(
                        child: StreamBuilder<List<ScanResult>>(
                          stream: FlutterBluePlus.scanResults,
                          builder: (c, snapshot) {
                            if (!snapshot.hasData) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            var filtered = snapshot.data!.where((element) {
                              return element.device.advName.isNotEmpty;
                            }).toList();
                            return Column(
                              children: filtered.map((ScanResult bluetooth) {
                                late Icon icon;
                                late Widget title;
                                String deviceName =
                                    bluetooth.device.advName.toString();

                                icon = const Icon(
                                  EvaIcons.printerOutline,
                                  color: ColorsApp.green,
                                );
                                // bold title
                                title = Text(
                                  deviceName,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                );
                                return ListTile(
                                  title: title,
                                  subtitle: Text(
                                      bluetooth.device.remoteId.toString()),
                                  onTap: () async {
                                    onBluetoothDeviceSelected(
                                      bluetooth,
                                      context,
                                    );
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

  void onBluetoothDeviceSelected(ScanResult bluetooth, context) async {
    await FlutterBluePlus.stopScan();
    alertCubit.showAlertInfo(
        title: "Aviso",
        subtitle: "Conectando con el dispositivo ${bluetooth.device.advName}");

    sessionBloc.changeState(sessionBloc.state.copyWith(
        configModel: sessionBloc.state.cfg!
            .copyWith(bluetoothDevice: bluetooth.device)));
    sessionBloc.state.cfg!.bluetoothDevice = bluetooth.device;

    await bluetooth.device.connect(
        timeout: const Duration(seconds: 20), mtu: null, autoConnect: true);
    log("MTU: ${bluetooth.device.mtuNow}");
    for (var i = 0; i < 20; i++) {
      if (!bluetooth.device.isConnected) {
        log("Esperando a que se conecte la impresora... ${i + 1}");
        await Future.delayed(const Duration(seconds: 1));
      } else {
        break;
      }
    }

    var service = await bluetooth.device.discoverServices();
    for (BluetoothService service in service) {
      if (!service.isPrimary) {
        continue;
      }

      for (String characteristic in validBluetoothCharacteristics) {
        for (BluetoothCharacteristic c in service.characteristics) {
          if (c.characteristicUuid.toString() == characteristic) {
            sessionBloc.state.cfg!.bluetoothCharacteristic = c;
            log("Se ha encontrado el servicio de impresion: ${c.serviceUuid.toString()}");
            sessionBloc.changeState(sessionBloc.state.copyWith(
                configModel: sessionBloc.state.cfg!
                    .copyWith(bluetoothCharacteristic: c)));
            alertCubit.showAlertInfo(
                title: "Conectado",
                subtitle: "Conectado a la impresora ${bluetooth.device.advName}");
            Navigator.pop(context);
            return;
          }
        }
      }
    }

    alertCubit.showAlertInfo(
        title: "Error",
        subtitle:
            "No se ha encontrado el servicio de impresion en este dispositivo");
    Navigator.pop(context);
  }

  Future<BluetoothCharacteristic> findPrintBTCharacteristic(
      BluetoothDevice device) async {
    List<BluetoothService> services = await device.discoverServices();
    for (BluetoothService service in services) {
      if (!service.isPrimary) {
        continue;
      }
      for (String characteristic in validBluetoothCharacteristics) {
        for (BluetoothCharacteristic c in service.characteristics) {
          if (c.characteristicUuid.toString() == characteristic) {
            return c;
          }
        }
      }
    }
    throw Exception("No se ha encontrado el servicio de impresion");
  }

  Future<List<int>> writeTestPrinter(String test) async {
    // Using default profile
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm58, profile);
    List<int> bytes = [];
    var styles = const PosStyles(
        align: PosAlign.left,
        bold: true,
        width: PosTextSize.size2,
        height: PosTextSize.size2);
    bytes += generator.text(test, styles: styles);
    bytes += generator.cut();
    return bytes;
  }
}

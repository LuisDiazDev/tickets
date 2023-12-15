import 'package:bluetooth_print/bluetooth_print.dart';
import 'package:bluetooth_print/bluetooth_print_model.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:tickets/Data/Services/printer_service.dart';

import '../../Core/Values/Colors.dart';
import '../Session/SessionCubit.dart';

class PrintSettings extends StatelessWidget {
  const PrintSettings({super.key,required this.sessionBloc});
  final SessionCubit sessionBloc;

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

  Widget connected(BuildContext context) {

    PrinterService printerService = PrinterService();

   return StreamBuilder(
        stream: sessionBloc.state.cfg!.bluetoothPrintService.state,
        initialData: BluetoothPrint.DISCONNECTED,
        builder: (context,snapchat){
          switch (snapchat.data) {
            case BluetoothPrint.CONNECTED:
              return Row(
                children: [
                  TextButton(
                      onPressed: ()async {
                        await openAlertBox(context,printerService);
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
            case BluetoothPrint.DISCONNECTED:
              return Row(
                children: [
                  TextButton(
                      onPressed: ()async {
                        await openAlertBox(context,printerService);
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
            default:
              return Row(
                children: [
                  TextButton(
                      onPressed: ()async {
                        await openAlertBox(context,printerService);
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
        }
    );
  }

  Future openAlertBox(BuildContext context,PrinterService printer)async{
    sessionBloc.state.cfg!.bluetoothPrintService.startScan(timeout: Duration(seconds: 4));

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
                      child: StreamBuilder<List<BluetoothDevice>>(
                        stream: sessionBloc.state.cfg!.bluetoothPrintService.scanResults,
                        initialData: const [],
                        builder: (c, snapshot){
                          if(!snapshot.hasData){
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          return Column(
                            children: snapshot.data!.map((bluetooth) => ListTile(
                              title: Text(bluetooth.name??''),
                              subtitle: Text(bluetooth.address??""),
                              onTap: () async {
                                sessionBloc.changeState(
                                    sessionBloc.state.copyWith(
                                        configModel: sessionBloc.state.cfg!.copyWith(connected: true,bluetoothDevice: bluetooth..connected=false)
                                    )
                                );
                                sessionBloc.state.cfg!.bluetoothPrintService.connect(bluetooth);
                                Navigator.pop(context);
                              },
                              trailing: const Icon(
                                Icons.bluetooth,
                                color: Colors.blue,
                              )
                            )).toList(),
                          );
                        },
                      ),
                    )
                  ),
                ],
              ),
            ),
          );
        });
  }
}

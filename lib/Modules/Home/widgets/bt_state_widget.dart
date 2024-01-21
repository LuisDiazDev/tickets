import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import '../../../Widgets/starlink/text_style.dart';
import '../../Session/SessionCubit.dart';
import '../../settings/widgets/print_setting.dart';

class BtStateWidget extends StatefulWidget {
  final BluetoothDevice bluetoothDevice;
  final SessionCubit sessionBloc;

  const BtStateWidget(
      {super.key, required this.bluetoothDevice, required this.sessionBloc});

  @override
  State<BtStateWidget> createState() => _BtStateWidgetState();
}

class _BtStateWidgetState extends State<BtStateWidget> {
  bool _connect = false;
  int attempts = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    onBluetoothDeviceSelected();
  }

  @override
  Widget build(BuildContext context) {

    if(_connect){
      return const Padding(
        padding: EdgeInsets.all(12.0),
        child: CircularProgressIndicator(
          color: Colors.cyan,
        ),
      );
    }

    return StreamBuilder<BluetoothConnectionState>(
        stream: widget.bluetoothDevice.connectionState,
        builder: (context, AsyncSnapshot<BluetoothConnectionState> snapchat) {
          switch (snapchat.data) {
            case BluetoothConnectionState.connected:
              {
                return Container();
              }
            case BluetoothConnectionState.disconnected:
              {
                if(attempts < 3){
                  onBluetoothDeviceSelected();
                }
                return IconButton(onPressed: (){
                  attempts = 0;
                  onBluetoothDeviceSelected();
                }, icon: const Icon(
                  EvaIcons.printer,
                  color: Colors.red,
                ));
              }
            default:
              {
                return IconButton(onPressed: (){
                  attempts = 0;
                  onBluetoothDeviceSelected();
                }, icon: const Icon(
                  EvaIcons.printer,
                  color: Colors.red,
                ));
              }
          }
        });
  }

  void onBluetoothDeviceSelected() async {
    try {
      await FlutterBluePlus.stopScan();
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
      setState(() {
        _connect = !_connect;
        attempts = attempts++;
      });

      widget.sessionBloc.changeState(widget.sessionBloc.state.copyWith(
          configModel: widget.sessionBloc.state.cfg!
              .copyWith(bluetoothDevice: widget.bluetoothDevice)));
      widget.sessionBloc.state.cfg!.bluetoothDevice = widget.bluetoothDevice;

      await widget.bluetoothDevice.connect(timeout: const Duration(seconds: 30));

      for (var i = 0; i < 20; i++) {
        if (!widget.bluetoothDevice.isConnected) {

          await Future.delayed(const Duration(seconds: 1));
        } else {
          break;
        }
      }
      widget.sessionBloc.changeState(widget.sessionBloc.state.copyWith(
          configModel: widget.sessionBloc.state.cfg!.copyWith(
              bluetoothDevice: widget.sessionBloc.state.cfg?.bluetoothDevice)));
      var service = await widget.bluetoothDevice.discoverServices();
      for (BluetoothService service in service) {
        if (!service.isPrimary) {
          continue;
        }

        for (String characteristic in validBluetoothCharacteristics) {
          for (BluetoothCharacteristic c in service.characteristics) {
            if (c.characteristicUuid.toString() == characteristic) {
              widget.sessionBloc.state.cfg!.bluetoothCharacteristic = c;
              widget.sessionBloc.changeState(widget.sessionBloc.state.copyWith(
                  configModel: widget.sessionBloc.state.cfg!
                      .copyWith(bluetoothCharacteristic: c)));
              setState(() {
                _connect = !_connect;
                attempts = 0;
              });
              return;
            }
          }
        }
      }
    } catch (e) {
      setState(() {
        _connect = false;
      });
    } finally {
      setState(() {
        _connect = false;
      });
    }
  }
}

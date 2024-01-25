import 'dart:async';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import '../../../Widgets/starlink/colors.dart';
import '../../Session/SessionCubit.dart';
import '../../settings/widgets/print_setting.dart';



class BtStateWidget extends StatefulWidget {

  final BluetoothDevice? bluetoothDevice;
  final SessionCubit sessionBloc;

  const BtStateWidget({super.key,this.bluetoothDevice,required this.sessionBloc});

  @override
  State<BtStateWidget> createState() => _BtStateWidgetState();
}

class _BtStateWidgetState extends State<BtStateWidget> {

  Widget icon = Container();
  bool _connect = false;
  int attempts = 0;
  StreamSubscription<BluetoothConnectionState>? stream;

  void check(btState){
    if(mounted){
      switch(btState){
        case BluetoothConnectionState.disconnected:{
          onBluetoothDeviceSelected();
          setState(() {
            icon = IconButton(
                onPressed: () {
                  attempts = 0;
                  onBluetoothDeviceSelected();
                },
                icon: const Icon(
                  EvaIcons.printer,
                  color: StarlinkColors.red,
                ));
          });
          break;
        }
        case BluetoothConnectionState.connected:{
          setState(() {
            icon = Container();
          });
          break;
        }
      // TODO: Handle this case.
        case BluetoothConnectionState.connecting:{
          setState(() {
            icon = Container();
          });
          break;
        }
        case BluetoothConnectionState.disconnecting:{
          onBluetoothDeviceSelected();
          setState(() {
            icon = IconButton(
                onPressed: () {
                  attempts = 0;
                  onBluetoothDeviceSelected();
                },
                icon: const Icon(
                  EvaIcons.printer,
                  color: StarlinkColors.red,
                ));
          });
          break;
        }
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    if(widget.bluetoothDevice != null){
      stream = widget.bluetoothDevice?.connectionState.listen(check);
    }

    if (widget.sessionBloc.state.cfg!.lastIdBtPrint != "") {
      searchBluetoothDeviceSelected();
    }

    super.initState();
  }

  void searchBluetoothDeviceSelected() {
    FlutterBluePlus.startScan(withServices: [
      Guid.fromString("e7810a71-73ae-499d-8c15-faa9aef0c3f2")
    ]);
    FlutterBluePlus.scanResults.listen((bts) {
      for (var bt in bts) {
        if (bt.device.remoteId.str ==
            widget.sessionBloc.state.cfg!.lastIdBtPrint) {
          widget.sessionBloc.changeState(widget.sessionBloc.state.copyWith(
              configModel: widget.sessionBloc.state.cfg!
                  .copyWith(bluetoothDevice: bt.device)));
          onBluetoothDeviceSelected(bt: bt.device);
          return;
        }
      }
    });
  }


  @override
  void dispose() {
    // TODO: implement dispose
    stream?.cancel();
    super.dispose();
  }

  void onBluetoothDeviceSelected({BluetoothDevice? bt}) async {
    if(mounted){
      if(_connect){
        return;
      }
      try {
        await FlutterBluePlus.stopScan();
        setState(() {
          _connect = !_connect;
          attempts = attempts++;
        });
        BluetoothDevice _bt = bt ?? widget.bluetoothDevice!;
        widget.sessionBloc.changeState(widget.sessionBloc.state.copyWith(
            configModel: widget.sessionBloc.state.cfg!
                .copyWith(bluetoothDevice: _bt,
                lastIdBtPrint: _bt.remoteId.str
            )));
        widget.sessionBloc.state.cfg!.bluetoothDevice =
            bt ?? widget.bluetoothDevice;

        await _bt.connect(timeout: const Duration(seconds: 30));

        for (var i = 0; i < 20; i++) {
          if (!_bt.isConnected) {
            await Future.delayed(const Duration(seconds: 1));
          } else {
            break;
          }
        }
        widget.sessionBloc.changeState(widget.sessionBloc.state.copyWith(
            configModel: widget.sessionBloc.state.cfg!.copyWith(bluetoothDevice: _bt,
                lastIdBtPrint: _bt.remoteId.str)));
        var service = await widget.bluetoothDevice!.discoverServices();
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
                stream = _bt.connectionState.listen(check);
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

  @override
  Widget build(BuildContext context) {
    if (_connect) {
      return const Padding(
        padding: EdgeInsets.all(12.0),
        child: CircularProgressIndicator(
          color: StarlinkColors.white,
        ),
      );
    }

    return icon;
  }
}



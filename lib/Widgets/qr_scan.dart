import 'package:flutter/material.dart';
import 'package:qr_mobile_vision/qr_camera.dart';


class ScanQrScreen extends StatefulWidget {
  const ScanQrScreen({super.key});

  @override
  State<ScanQrScreen> createState() => _ScanQrScreenState();
}

class _ScanQrScreenState extends State<ScanQrScreen> {

  String? qr;
  bool camState = false;
  bool dirState = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: QrCamera(
        onError: (context, error) => Text(
          error.toString(),
          style: TextStyle(color: Colors.red),
        ),
        cameraDirection: dirState ? CameraDirection.FRONT : CameraDirection.BACK,
        qrCodeCallback: (code) {
          setState(() {
            qr = code;
          });
          if(Navigator.canPop(context)){
            Navigator.pop(context,qr);
          }
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(
              color: Colors.grey,
              width: 2.0,
              style: BorderStyle.solid,
            ),
          ),
        ),
      ),
    );
  }
}

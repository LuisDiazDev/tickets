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
        formats: const [BarcodeFormats.QR_CODE],
        onError: (context, error) => Text(
          error.toString(),
          style: const TextStyle(color: Colors.red),
        ),
        cameraDirection: dirState ? CameraDirection.FRONT : CameraDirection.BACK,
        qrCodeCallback: (code) {
          if (code!.length > 8){
            return;
          }
          setState(() {
            if (qr != ""){
              qr = code;
            }
          });
          if(Navigator.canPop(context)){
            Navigator.pop(context,qr);
          }
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(
              color: Colors.red,
              width: 2.0,
              style: BorderStyle.solid,
            ),
          ),
        ),
      ),
    );
  }
}

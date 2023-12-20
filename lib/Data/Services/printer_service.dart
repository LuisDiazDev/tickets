import 'package:TicketOs/models/profile_model.dart';
import 'package:bluetooth_print/bluetooth_print_model.dart';

import '../../models/config_model.dart';

class PrinterService {
  static PrinterService? _instance;
  static bool isProgress = false;
  factory PrinterService() {
    _instance ??= PrinterService._();
    return _instance!;
  }

  PrinterService._();

  void printerB({String user = "", ConfigModel? configModel,String price="",String duration=""}) async {
    Map<String, dynamic> config = {
      'width':0,
      'height':70,
      "font size":12,
      'gap':2
    };

    if(!isProgress){
      isProgress = true;
      List<LineText> list = [];
      list.add(LineText(
          type: LineText.TYPE_TEXT,
          content: '1- Conectate al WIFI ${configModel?.nameBusiness}',
          weight: 0,
          align: LineText.ALIGN_CENTER,
          linefeed: 1
      ));
      list.add(LineText(
          type: LineText.TYPE_TEXT,
          content: '2- Abre tu navegador y entra en',
          weight: 0,
          align: LineText.ALIGN_CENTER,
          linefeed: 1
      ));
      list.add(LineText(
          type: LineText.TYPE_TEXT,
          content: '${configModel?.dnsNamed}',
          weight: 0,
          align: LineText.ALIGN_CENTER,
          linefeed: 1
      ));
      list.add(LineText(
          type: LineText.TYPE_TEXT,
          content: 'O escanea el codigo QR',
          weight: 0,
          align: LineText.ALIGN_CENTER,
          linefeed: 1
      ));
      list.add(LineText(
          type: LineText.TYPE_TEXT,
          content: '.',
          weight: 0,
          align: LineText.ALIGN_CENTER,
          linefeed: 1
      ));
      list.add(LineText(
        type: LineText.TYPE_QRCODE,
        content:
        'http://${configModel?.dnsNamed}/login?user=$user&password=$user',
        size: 5,
        align: LineText.ALIGN_CENTER,
        linefeed: 1
      ));
      list.add(LineText(
          type: LineText.TYPE_TEXT,
          content: '.',
          weight: 0,
          align: LineText.ALIGN_LEFT,
          linefeed: 0
      ));
      list.add(LineText(
          type: LineText.TYPE_TEXT,
          content: 'Clave: $user',
          weight: 1,
          align: LineText.ALIGN_CENTER,
          linefeed: 1
      ));
      list.add(LineText(
          type: LineText.TYPE_TEXT,
          content: 'Precio           Duracion',
          weight: 0,
          align: LineText.ALIGN_CENTER,
          linefeed: 1
      ));
      list.add(LineText(
          type: LineText.TYPE_TEXT,
          content: '$price             $duration',
          weight: 1,
          align: LineText.ALIGN_CENTER,
          linefeed: 1,
      ));
      if(configModel?.contact != null && configModel?.contact != ""){
        list.add(LineText(
          type: LineText.TYPE_TEXT,
          content: 'Contacto ${configModel?.contact}',
          weight: 0,
          align: LineText.ALIGN_CENTER,
          underline: 1
        ));
      }
      list.add(LineText(
          type: LineText.TYPE_TEXT,
          content: '--------------------------------',
          weight: 1,
          height: 10,
          align: LineText.ALIGN_CENTER,
          linefeed: 1,
      ));
      list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: '--------------------------------',
        weight: 1,
        height: 10,
        align: LineText.ALIGN_CENTER,
        linefeed: 1,
      ));

      // Getting Started
      if(configModel?.pathLogo != ""){
        // list.add(LineText(type: LineText.TYPE_IMAGE, content: configModel!.pathLogo, align: LineText.ALIGN_CENTER, linefeed: 1));
      }
      if (configModel?.connected ?? false) {
        // List<LineText> list1 = [];
        // ByteData data = await rootBundle.load("assets/guide3.png");
        // List<int> imageBytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
        // String base64Image = base64Encode(imageBytes);
        // list1.add(LineText(type: LineText.TYPE_IMAGE, x:10, y:10, content: base64Image,));


        await configModel?.bluetoothPrintService.printReceipt(config, list);
        // await bluetoothPrintService.printReceipt(config, list1);
      }
      isProgress = !isProgress;
    }
  }

  void init({Duration? timeOut, ConfigModel? configModel}) async {
    if (configModel?.connected ?? false) {
      if (configModel?.bluetoothDevice != null && !(await configModel?.bluetoothPrintService.isConnected ?? false)) {
        await configModel?.bluetoothPrintService.connect(configModel.bluetoothDevice!);
      }
      configModel?.bluetoothPrintService.startScan(
          timeout: timeOut ?? const Duration(seconds: 4));

      await configModel?.bluetoothPrintService.scanResults.listen((event) async {
        if (event.isNotEmpty &&
            !(await configModel.bluetoothPrintService.isConnected ?? false)) {
          var results = event.where(
              (element) => element.name == configModel.bluetoothDevice!.name);
          if (results.isNotEmpty) {
            configModel.bluetoothPrintService.connect(results.first);
          }else{
            configModel.connected = false;
          }
        }
      });
    }
  }

  // Stream<int> get state {
  //   return bluetoothPrintService.state;
  // }

  // Stream<List<BluetoothDevice>> get scan {
  //   return bluetoothPrintService.scanResults;
  // }

  // void connect(BluetoothDevice bluetoothDevice) async {
  //   if ((await bluetoothPrintService.isConnected ?? false)) {
  //     await bluetoothPrintService.disconnect();
  //   }
  //
  //   bluetoothPrintService.connect(bluetoothDevice);
  // }

  // void initScan({Duration? duration}) {
  //   bluetoothPrintService.scan(
  //       timeout: duration ?? const Duration(minutes: 4));
  // }
}

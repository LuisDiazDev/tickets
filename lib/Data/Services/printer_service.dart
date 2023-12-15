import 'package:bluetooth_print/bluetooth_print_model.dart';
import 'package:tickets/models/config_model.dart';

class PrinterService {
  static PrinterService? _instance;

  factory PrinterService() {
    _instance ??= PrinterService._();
    return _instance!;
  }

  PrinterService._();

  void printerB({String user = "", ConfigModel? configModel}) async {
    Map<String, dynamic> config = {};

    List<LineText> list = [];
    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: configModel?.nameBusiness ?? "",
        weight: 1,
        align: LineText.ALIGN_CENTER,
        linefeed: 1));
    list.add(LineText(linefeed: 1));
    list.add(LineText(
        type: LineText.TYPE_QRCODE,
        content:
            'http://${configModel?.dnsNamed}/login?user=$user&password=$user',
        size: 10,
        align: LineText.ALIGN_CENTER,
        linefeed: 1));
    list.add(LineText(linefeed: 1));
    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: 'usuario=$user pass=$user',
        weight: 0,
        align: LineText.ALIGN_LEFT,
        linefeed: 1));
    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: 'Contacto ${configModel?.contact}',
        weight: 0,
        align: LineText.ALIGN_LEFT,
        linefeed: 1));
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
  }

  void init({Duration? timeOut, ConfigModel? configModel}) async {
    if (configModel?.connected ?? false) {
      configModel?.bluetoothPrintService.startScan(
          timeout: timeOut ?? const Duration(seconds: 4));

      configModel?.bluetoothPrintService.scanResults.listen((event) async {
        if (event.isNotEmpty &&
            !(await configModel.bluetoothPrintService.isConnected ?? false)) {
          var results = event.where(
              (element) => element.name == configModel!.bluetoothDevice!.name);
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

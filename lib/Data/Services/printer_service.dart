import 'dart:math';

import 'package:flutter_esc_pos_utils/flutter_esc_pos_utils.dart';

import '../../models/config_model.dart';

class PrinterNotSelectedException implements Exception {
  String cause = "No se ha seleccionado una impresora";
}

class PrinterService {
  static PrinterService? _instance;
  static bool isProgress = false;

  factory PrinterService() {
    _instance ??= PrinterService._();
    return _instance!;
  }

  PrinterService._();

  void printTicket(
      {String user = "",
      ConfigModel? configModel,
      String price = "",
      String duration = ""}) async {
    price = price.replaceAll("S", "\$");

    if (configModel!.bluetoothCharacteristic == null) {
      throw PrinterNotSelectedException();
    }

      isProgress = true;
      if (configModel.pathLogo != "") {
        // TODO: Add path logo
        // list.add(LineText(type: LineText.TYPE_IMAGE, content: configModel!.pathLogo, align: LineText.ALIGN_CENTER, linefeed: 1));
      }
      var ticketBytes = await buildTicketBody(
          user: user,
          configModel: configModel,
          price: price,
          duration: duration);
      await printTicketInBTPrinter(configModel, ticketBytes);
      // await configModel.bluetoothCharacteristic!
      //     .write(ticketBytes, withoutResponse: false, allowLongWrite: true );

      isProgress = !isProgress;

  }

  Future<void> printTicketInBTPrinter(ConfigModel? configModel, List<int> value,
      {int timeout = 15}) async {
    int chunk =
        configModel!.bluetoothDevice!.mtuNow - 3; // 3 bytes ble overhead
    for (int i = 0; i < value.length; i += chunk) {
      List<int> subvalue = value.sublist(i, min(i + chunk, value.length));
      try{
        await configModel.bluetoothCharacteristic!
            .write(subvalue, withoutResponse: false, timeout: timeout);
      }catch(e){
        await configModel.bluetoothDevice!.discoverServices();
        await configModel.bluetoothCharacteristic!
            .write(subvalue, withoutResponse: false, timeout: timeout);
        print(e);
      }

    }
  }

  Future<List<int>> buildTicketBody(
      {String user = "",
      ConfigModel? configModel,
      String price = "",
      String duration = ""}) async {
    // Using default profile
    var spacedPassword = user.split('').join(' ').toUpperCase();
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm58, profile);
    List<int> bytes = [];
    var styles = const PosStyles(align: PosAlign.left, bold: false);
    // bytes += generator.qrcode(
    //     'http://${configModel.dnsNamed}/login?user=$user&password=$user',
    //     size: const QRSize(8));
    // bytes += generator.feed(1);
    bytes += generator.text('Clave: $spacedPassword',
        styles: const PosStyles(
            align: PosAlign.left,
            height: PosTextSize.size2,
            width: PosTextSize.size2,
            bold: true));
    bytes += generator.feed(1);
    String priceAndDurationLine = "";
    if (price != "") {
      priceAndDurationLine += "Precio: $price";
    }
    if (duration != "") {
      priceAndDurationLine += "  |  Duracion: $duration";
    }
    bytes += generator.text(priceAndDurationLine);

    // Time in format "day/month/year hh:mm:ss"
    var now = DateTime.now();
    String day = now.day.toString().padLeft(2, '0');
    String month = now.month.toString().padLeft(2, '0');
    String hour = now.hour.toString().padLeft(2, '0');
    String minute = now.minute.toString().padLeft(2, '0');
    String second = now.second.toString().padLeft(2, '0');
    String currentDateTime = "$day/$month/${now.year} - $hour:$minute:$second";
    bytes += generator.text('Fecha: $currentDateTime', styles: styles);

    bytes += generator.text('1- Conectate al wifi', styles: styles);
    bytes += generator.text('2- Abre tu navegador y entra en', styles: styles);
    bytes += generator.text(configModel!.dnsNamed, styles: styles);
    bytes += generator.text('--------------------------------');
    bytes += generator.feed(1);

    return bytes;
  }

  void tryConnect({Duration? timeOut, ConfigModel? configModel}) async {
    if (configModel?.bluetoothDevice != null) {
      await configModel?.bluetoothDevice!.connect(
          timeout: const Duration(seconds: 10), mtu: null, autoConnect: true);
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

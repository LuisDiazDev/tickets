import 'dart:math';

import 'package:flutter_esc_pos_utils/flutter_esc_pos_utils.dart';

import '../../Core/utils/format.dart';
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

  void printTicket({String user = "",
    ConfigModel? configModel,
    String price = "",
    String duration = ""}) async {
    price = price.replaceAll("S", "\$");

    isProgress = true;
    var ticketBytes = await buildTicketBody(
        user: user, configModel: configModel, price: price, duration: duration);
    await printTicketInBTPrinter(configModel, ticketBytes);

    isProgress = !isProgress;
  }

  Future<void> printTicketInBTPrinter(ConfigModel? configModel, List<int> value,
      {int timeout = 15}) async {
    int chunk =
        configModel!.bluetoothDevice!.mtuNow - 3; // 3 bytes ble overhead
    for (int i = 0; i < value.length; i += chunk) {
      List<int> subvalue = value.sublist(i, min(i + chunk, value.length));
      try {
        await configModel.bluetoothCharacteristic!
            .write(subvalue, withoutResponse: false, timeout: timeout);
      } catch (e) {
        await configModel.bluetoothDevice!.discoverServices();
        await configModel.bluetoothCharacteristic!
            .write(subvalue, withoutResponse: false, timeout: timeout);
      }
    }
  }

  Future<List<int>> buildTicketBody({String user = "",
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
    if (configModel?.nameLocal != "" || configModel?.contact != "") {
      var strContact = "";
      if (configModel?.nameLocal != "" && configModel?.contact != "") {
        strContact = "${configModel?.nameLocal} - ${configModel?.contact}";
      } else if (configModel?.nameLocal == "" && configModel?.contact != "") {
        strContact = "${configModel?.contact}";
      } else if (configModel?.nameLocal != "" && configModel?.contact == "") {
        strContact = "${configModel?.nameLocal}";
      }
      bytes += generator.text(strContact, styles: styles);
      bytes += generator.feed(1);
    }
    bytes += generator.text('PIN: $spacedPassword',
        styles: const PosStyles(
            align: PosAlign.left,
            height: PosTextSize.size2,
            width: PosTextSize.size2,
            bold: true));
    bytes += generator.feed(1);

    if (configModel!.wifiCredentials.isNotEmpty &&
        (configModel.wifiCredentials.first.ssid != "" ||
            configModel.wifiCredentials.last.ssid != "")) {
      var sameSSID = false;
      if (configModel.wifiCredentials.first.ssid ==
          configModel.wifiCredentials.last.ssid) {
        sameSSID = true;
      }
      var samePass = false;
      if (configModel.wifiCredentials.first.pass ==
          configModel.wifiCredentials.last.pass) {
        samePass = true;
      }


      if (!sameSSID &&
          configModel.wifiCredentials.first.ssid != "" &&
          configModel.wifiCredentials.last.ssid != "") {
        bytes +=
            generator.text('1- Entra a uno de estos WiFis:', styles: styles);
      } else {
        bytes += generator.text('1-Conectate a este wifi:', styles: styles);
      }

      String fssid = configModel.wifiCredentials.first.ssid.replaceAll(
          "\n", "");
      String lssid = configModel.wifiCredentials.last.ssid.replaceAll("\n", "");
      String fpass = configModel.wifiCredentials.first.pass.replaceAll(
          "\n", "");
      String lpass = configModel.wifiCredentials.last.pass.replaceAll("\n", "");
      List<String> a = [];
      if (sameSSID && !samePass) {
        if (fpass != "" && lpass == "") {
          a = ["Nombre WIFI: $fssid", "Clave WIFI: $fpass"];
        } else if (fpass == "" && lpass != "") {
          a = ["Nombre WIFI: $fssid", "Clave WIFI: $lpass"];
        } else if (fpass != "" && lpass != "") {
          a = [
            "Nombre WIFI: $fssid",
            "Clave WIFI 1: $fpass",
            "Clave WIFI 2: $lpass"
          ];
        }
      } else if (sameSSID && samePass) {
        a = ["Nombre WIFI: $fssid", "Clave WIFI: $fpass"];
      } else if (!sameSSID && samePass) {
        a = [
          "Nombre WIFI 1: $fssid",
          "Nombre WIFI 2: $lssid",
          "Clave WIFI: $fpass"
        ];
      } else if (!sameSSID && !samePass) {
        a = [
          "Nombre WIFI 1: $fssid",
          "Clave WIFI 1: $fpass",
          "Nombre WIFI 2: $lssid",
          "Clave WIFI 2: $lpass"
        ];
      }

      for (var item in a) {
        bytes += generator.text(item, styles: styles);
      }
    }

      var now = DateTime.now();
      String day = now.day.toString().padLeft(2, '0');
      String month = now.month.toString().padLeft(2, '0');
      String hour = now.hour.toString().padLeft(2, '0');
      String minute = now.minute.toString().padLeft(2, '0');
      String currentDateTime = "$day/$month/${now.year} - $hour:$minute";
      bytes += generator.text('Fecha: $currentDateTime', styles: styles);
      String priceAndDurationLine = "";
      if (duration != "") {
        priceAndDurationLine += "Duracion: ${formatDuration(duration)}";
      }
      bytes += generator.text(priceAndDurationLine);
      bytes += generator.text(".                startickera.com");
      bytes += generator.text('--------------------------------');
      bytes += generator.feed(1);
      return bytes;
    }
  }

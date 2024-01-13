import 'dart:convert';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class ConfigModel {
  String host,
      user,
      ip,
      password,
      maxUpload,
      maxDownload,
      shareUser,
      pathLogo,
      dnsNamed,
      port,
      dhcp;

  bool limitSpeedInternet, disablePrint;
  BluetoothDevice? bluetoothDevice;
  BluetoothCharacteristic? bluetoothCharacteristic;
  List<WifiDataModels> wifiCredentials;

  ConfigModel(
      {this.dnsNamed = "",
      this.dhcp = "",
      this.ip = "...",
      this.disablePrint = false,
      this.port = "3000",
      this.password = "1234",
      this.host = "192.168.20.5",
      this.user = "tickets",
      this.shareUser = "1",
      this.pathLogo = "",
      this.limitSpeedInternet = false,
      this.maxDownload = "1M",
      this.maxUpload = "1M",
      this.bluetoothDevice,
      this.bluetoothCharacteristic,
      this.wifiCredentials = const []});

  static Map settings = {
    "download": ["1", "3", "5", "10", "20", "30", "50", "100", "250"],
    "upload": ["1", "3", "5", "10", "20", "30", "50", "100", "250"],
    "range-datetime": ["m", "h", "d", "s"],
    "range-datetime-full": ["min", "horas", "dias", "semanas"],
    "currency": ["S", "bs"]
  };

  ConfigModel copyWith({
    String? dnsNamed,
    bool? limitSpeedInternet,
    bool? disablePrint,
    String? password,
    String? host,
    String? user,
    String? ip,
    String? dhcp,
    String? shareUser,
    String? pathLogo,
    String? maxDownload,
    String? maxUpload,
    String? port,
    BluetoothDevice? bluetoothDevice,
    BluetoothCharacteristic? bluetoothCharacteristic,
    List<WifiDataModels>? wifiCredentials,
  }) {
    return ConfigModel(
        dhcp: dhcp ?? this.dhcp,
        disablePrint: disablePrint ?? this.disablePrint,
        dnsNamed: dnsNamed ?? this.dnsNamed,
        limitSpeedInternet: limitSpeedInternet ?? this.limitSpeedInternet,
        password: password ?? this.password,
        host: host ?? this.host,
        ip: ip ?? this.ip,
        port: port ?? this.port,
        user: user ?? this.user,
        shareUser: shareUser ?? this.shareUser,
        pathLogo: pathLogo ?? this.pathLogo,
        maxDownload: maxDownload ?? this.maxDownload,
        maxUpload: maxUpload ?? this.maxUpload,
        wifiCredentials: wifiCredentials ?? this.wifiCredentials,
        bluetoothDevice: bluetoothDevice ?? this.bluetoothDevice,
        bluetoothCharacteristic:
            bluetoothCharacteristic ?? this.bluetoothCharacteristic);
  }

  factory ConfigModel.fromJson(Map<String, dynamic> json) => ConfigModel(
      limitSpeedInternet: json["limit-speed-internet"],
      disablePrint: json["disablePrint"],
      password: json["password"],
      host: json["host"],
      user: json["user"],
      ip: json["ip"],
      dhcp: json["dhcp"],
      shareUser: json["share-user"],
      pathLogo: json["path-logo"],
      maxDownload: json["max-download"],
      port: json["port"],
      maxUpload: json["max-upload"],
      dnsNamed: json["dns-name"],
      bluetoothDevice: json["bt_service"] != null
          ? BluetoothDevice.fromId(json["bt_service"])
          : null,
      bluetoothCharacteristic: json["bt_char"] != null
          ? bluetoothCharacteristicFromJson(json["bt_char"])
          : null);

  static String bluetoothCharacteristicToJson(
      BluetoothCharacteristic? bluetoothCharacteristic) {
    if (bluetoothCharacteristic == null) {
      return "";
    }
    var m = <String, dynamic>{
      "remoteId": bluetoothCharacteristic.remoteId.toString(),
      "serviceUuid": bluetoothCharacteristic.serviceUuid.toString(),
      "secondaryServiceUuid":
          bluetoothCharacteristic.secondaryServiceUuid.toString(),
      "characteristicUuid":
          bluetoothCharacteristic.characteristicUuid.toString(),
    };
    return json.encode(m);
  }

  static BluetoothCharacteristic bluetoothCharacteristicFromJson(
      String bluetoothCharacteristic) {
    var m = json.decode(bluetoothCharacteristic);
    return BluetoothCharacteristic(
      remoteId: DeviceIdentifier(m["remoteId"]),
      serviceUuid: Guid.fromString(m["serviceUuid"]),
      characteristicUuid: Guid.fromString(m["characteristicUuid"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "dns-name": dnsNamed,
        "limit-speed-internet": limitSpeedInternet,
        "password": password,
        "host": host,
        "ip": ip,
        "port": port,
        "disablePrint":disablePrint,
        "user": user,
        "dhcp": dhcp,
        "share-user": shareUser,
        "path-logo": pathLogo,
        "max-download": maxDownload,
        "max-upload": maxUpload,
        "bt_service": bluetoothDevice?.remoteId.toString(),
        "bt_char": bluetoothCharacteristicToJson(bluetoothCharacteristic)
      };
}

class WifiDataModels {
  String ssid;
  String pass;

  WifiDataModels({this.pass = "", this.ssid = ""});

  WifiDataModels copyWith({
    String? ssid,
    String? pass,
  }) {
    return WifiDataModels(ssid: ssid ?? this.ssid, pass: pass ?? this.pass);
  }

  factory WifiDataModels.fromJson(Map<String, dynamic> json) => WifiDataModels(
        ssid: json["ssid"],
        pass: json["pass"],
      );

  Map<String, dynamic> toJson() => {
        "ssid": ssid,
        "pass": pass,
      };
}

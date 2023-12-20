import 'package:bluetooth_print/bluetooth_print.dart';
import 'package:bluetooth_print/bluetooth_print_model.dart';

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
      nameBusiness,
      port,
      dchcp,
      contact;

  bool limitSpeedInternet, connected;
  BluetoothDevice? bluetoothDevice;

  final BluetoothPrint bluetoothPrintService = BluetoothPrint.instance;

  ConfigModel(
      {
        this.dnsNamed = "",
      this.contact = "",
      this.dchcp = "",
      this.ip = "...",
      this.port = "3000",
      this.connected = false,
      this.nameBusiness = "",
      this.password = "1234",
      this.host = "192.168.20.5",
      this.user = "tickets",
      this.shareUser = "1",
      this.pathLogo = "",
      this.limitSpeedInternet = false,
      this.maxDownload = "1M",
      this.maxUpload = "1M",
      this.bluetoothDevice});

  static Map settings = {
    "download": ["1", "3", "5", "10", "20", "30", "50", "100", "250"],
    "upload": ["1", "3", "5", "10", "20", "30", "50", "100", "250"],
    "range-datetime": ["m", "h", "d", "s"],
    "currency": ["S", "bs"]
  };

  ConfigModel copyWith({
    bool? connected,
    String? dnsNamed,
    String? contact,
    bool? limitSpeedInternet,
    String? nameBusiness,
    String? password,
    String? host,
    String? user,
    String? ip,
    String? dchcp,
    String? shareUser,
    String? pathLogo,
    String? maxDownload,
    String? maxUpload,
    String? port,
    BluetoothDevice? bluetoothDevice,
  }) {
    return ConfigModel(
        dchcp: dchcp ?? this.dchcp,
        dnsNamed: dnsNamed ?? this.dnsNamed,
        connected: connected ?? this.connected,
        contact: contact ?? this.contact,
        limitSpeedInternet: limitSpeedInternet ?? this.limitSpeedInternet,
        nameBusiness: nameBusiness ?? this.nameBusiness,
        password: password ?? this.password,
        host: host ?? this.host,
        ip: ip ?? this.ip,
        port: port ?? this.port,
        user: user ?? this.user,
        shareUser: shareUser ?? this.shareUser,
        pathLogo: pathLogo ?? this.pathLogo,
        maxDownload: maxDownload ?? this.maxDownload,
        maxUpload: maxUpload ?? this.maxUpload,
        bluetoothDevice: bluetoothDevice ?? this.bluetoothDevice);
  }

  factory ConfigModel.fromJson(Map<String, dynamic> json) => ConfigModel(
      connected: json["connected"],
      contact: json["contact"],
      limitSpeedInternet: json["limit-speed-internet"],
      nameBusiness: json["name-business"],
      password: json["password"],
      host: json["host"],
      user: json["user"],
      ip: json["ip"],
      dchcp: json["dchcp"],
      shareUser: json["share-user"],
      pathLogo: json["path-logo"],
      maxDownload: json["max-download"],
      port: json["port"],
      maxUpload: json["max-upload"],
      dnsNamed: json["dns-name"],
      bluetoothDevice:
          json["blue"] != null ? BluetoothDevice.fromJson(json["blue"]) : null);

  Map<String, dynamic> toJson() => {
        "dns-name": dnsNamed,
        "connected": connected,
        "contact": contact,
        "limit-speed-internet": limitSpeedInternet,
        "name-business": nameBusiness,
        "password": password,
        "host": host,
        "ip":ip,
        "port": port,
        "user": user,
        "dchcp":dchcp,
        "share-user": shareUser,
        "path-logo": pathLogo,
        "max-download": maxDownload,
        "max-upload": maxUpload,
        "blue": bluetoothDevice?.toJson(),
      };
}

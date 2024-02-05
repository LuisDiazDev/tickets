import 'dart:convert';

import 'package:http/src/response.dart' show Response;

class AuthResponse {
  Response rawResponse;
  String? boardName;
  String? currentFirmware;
  String? factoryFirmware;
  String? firmwareType;
  String? model;
  String? routerboard;
  String? serialNumber;
  String? upgradeFirmware;

  AuthResponse({
    required this.rawResponse,
    this.boardName,
    this.currentFirmware,
    this.factoryFirmware,
    this.firmwareType,
    this.model,
    this.routerboard,
    this.serialNumber,
    this.upgradeFirmware,
  });

  factory AuthResponse.fromRawJson(String str, Response r) {
    return AuthResponse.fromJson(json.decode(str),r);
  }

  String toRawJson() => json.encode(toJson());

  factory AuthResponse.fromJson(Map<String, dynamic> json, Response r) => AuthResponse(
    rawResponse: r,
    boardName: json["board-name"],
    currentFirmware: json["current-firmware"],
    factoryFirmware: json["factory-firmware"],
    firmwareType: json["firmware-type"],
    model: json["model"],
    routerboard: json["routerboard"],
    serialNumber: json["serial-number"],
    upgradeFirmware: json["upgrade-firmware"],
  );

  Map<String, dynamic> toJson() => {
    "board-name": boardName,
    "current-firmware": currentFirmware,
    "factory-firmware": factoryFirmware,
    "firmware-type": firmwareType,
    "model": model,
    "routerboard": routerboard,
    "serial-number": serialNumber,
    "upgrade-firmware": upgradeFirmware,
  };
}

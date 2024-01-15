import 'dart:convert';

List<ActiveModel> activeModelFromJson(String str) => List<ActiveModel>.from(json.decode(str).map((x) => ActiveModel.fromJson(x)));

String activeModelToJson(List<ActiveModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ActiveModel {
  String? id;
  String? address;
  String? bytesIn;
  String? bytesOut;
  String? idleTime;
  String? keepaliveTimeout;
  String? loginBy;
  String? macAddress;
  String? packetsIn;
  String? packetsOut;
  String? radius;
  String? server;
  String? uptime;
  String? user;

  ActiveModel({
    this.id,
    this.address,
    this.bytesIn,
    this.bytesOut,
    this.idleTime,
    this.keepaliveTimeout,
    this.loginBy,
    this.macAddress,
    this.packetsIn,
    this.packetsOut,
    this.radius,
    this.server,
    this.uptime,
    this.user,
  });

  factory ActiveModel.fromJson(Map<String, dynamic> json) => ActiveModel(
    id: json[".id"],
    address: json["address"],
    bytesIn: json["bytes-in"],
    bytesOut: json["bytes-out"],
    idleTime: json["idle-time"],
    keepaliveTimeout: json["keepalive-timeout"],
    loginBy: json["login-by"],
    macAddress: json["mac-address"],
    packetsIn: json["packets-in"],
    packetsOut: json["packets-out"],
    radius: json["radius"],
    server: json["server"],
    uptime: json["uptime"],
    user: json["user"],
  );

  Map<String, dynamic> toJson() => {
    ".id": id,
    "address": address,
    "bytes-in": bytesIn,
    "bytes-out": bytesOut,
    "idle-time": idleTime,
    "keepalive-timeout": keepaliveTimeout,
    "login-by": loginBy,
    "mac-address": macAddress,
    "packets-in": packetsIn,
    "packets-out": packetsOut,
    "radius": radius,
    "server": server,
    "uptime": uptime,
    "user": user,
  };
}

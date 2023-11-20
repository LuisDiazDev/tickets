import 'dart:convert';

HostspotServerModel hostspotServerModelFromJson(String str) => HostspotServerModel.fromJson(json.decode(str));

String hostspotServerModelToJson(HostspotServerModel data) => json.encode(data.toJson());

class HostspotServerModel {
  String? id;
  String? https;
  String? addressPool;
  String? addressesPerMac;
  String? disabled;
  String? idleTimeout;
  String? hostspotServerModelInterface;
  String? invalid;
  String? ipOfDnsName;
  String? keepaliveTimeout;
  String? loginTimeout;
  String? name;
  String? profile;
  String? proxyStatus;

  HostspotServerModel({
    this.id,
    this.https,
    this.addressPool,
    this.addressesPerMac,
    this.disabled,
    this.idleTimeout,
    this.hostspotServerModelInterface,
    this.invalid,
    this.ipOfDnsName,
    this.keepaliveTimeout,
    this.loginTimeout,
    this.name,
    this.profile,
    this.proxyStatus,
  });

  factory HostspotServerModel.fromJson(Map<String, dynamic> json) => HostspotServerModel(
    id: json[".id"],
    https: json["HTTPS"],
    addressPool: json["address-pool"],
    addressesPerMac: json["addresses-per-mac"],
    disabled: json["disabled"],
    idleTimeout: json["idle-timeout"],
    hostspotServerModelInterface: json["interface"],
    invalid: json["invalid"],
    ipOfDnsName: json["ip-of-dns-name"],
    keepaliveTimeout: json["keepalive-timeout"],
    loginTimeout: json["login-timeout"],
    name: json["name"],
    profile: json["profile"],
    proxyStatus: json["proxy-status"],
  );

  Map<String, dynamic> toJson() => {
    ".id": id,
    "HTTPS": https,
    "address-pool": addressPool,
    "addresses-per-mac": addressesPerMac,
    "disabled": disabled,
    "idle-timeout": idleTimeout,
    "interface": hostspotServerModelInterface,
    "invalid": invalid,
    "ip-of-dns-name": ipOfDnsName,
    "keepalive-timeout": keepaliveTimeout,
    "login-timeout": loginTimeout,
    "name": name,
    "profile": profile,
    "proxy-status": proxyStatus,
  };
}
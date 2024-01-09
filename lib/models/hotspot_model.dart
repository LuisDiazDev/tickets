// To parse this JSON data, do
//
//     final hotspot = hotspotFromJson(jsonString);

import 'dart:convert';

List<Hotspot> hotspotFromJson(String str) => List<Hotspot>.from(json.decode(str).map((x) => Hotspot.fromJson(x)));

String hotspotToJson(List<Hotspot> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Hotspot {
  String id;
  String https;
  String addressPool;
  String addressesPerMac;
  String disabled;
  String idleTimeout;
  String hotspotInterface;
  String invalid;
  String ipOfDnsName;
  String keepaliveTimeout;
  String loginTimeout;
  String name;
  String profile;
  String proxyStatus;

  Hotspot({
    required this.id,
    required this.https,
    required this.addressPool,
    required this.addressesPerMac,
    required this.disabled,
    required this.idleTimeout,
    required this.hotspotInterface,
    required this.invalid,
    required this.ipOfDnsName,
    required this.keepaliveTimeout,
    required this.loginTimeout,
    required this.name,
    required this.profile,
    required this.proxyStatus,
  });

  factory Hotspot.fromJson(Map<String, dynamic> json) => Hotspot(
    id: json[".id"],
    https: json["HTTPS"],
    addressPool: json["address-pool"],
    addressesPerMac: json["addresses-per-mac"],
    disabled: json["disabled"],
    idleTimeout: json["idle-timeout"],
    hotspotInterface: json["interface"],
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
    "interface": hotspotInterface,
    "invalid": invalid,
    "ip-of-dns-name": ipOfDnsName,
    "keepalive-timeout": keepaliveTimeout,
    "login-timeout": loginTimeout,
    "name": name,
    "profile": profile,
    "proxy-status": proxyStatus,
  };
}

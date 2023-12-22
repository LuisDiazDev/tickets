import 'dart:convert';

List<DhcpServerModel> dhcpServerModelFromJson(String str) => List<DhcpServerModel>.from(json.decode(str).map((x) => DhcpServerModel.fromJson(x)));

String dhcpServerModelToJson(List<DhcpServerModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DhcpServerModel {
  String? id;
  String? addressPool;
  String? authoritative;
  String? disabled;
  String? dhcpServerModelDynamic;
  String? dhcpServerModelInterface;
  String? invalid;
  String? leaseScript;
  String? leaseTime;
  String? name;
  String? useRadius;

  DhcpServerModel({
    this.id,
    this.addressPool,
    this.authoritative,
    this.disabled,
    this.dhcpServerModelDynamic,
    this.dhcpServerModelInterface,
    this.invalid,
    this.leaseScript,
    this.leaseTime,
    this.name,
    this.useRadius,
  });

  factory DhcpServerModel.fromJson(Map<String, dynamic> json) => DhcpServerModel(
    id: json[".id"],
    addressPool: json["address-pool"],
    authoritative: json["authoritative"],
    disabled: json["disabled"],
    dhcpServerModelDynamic: json["dynamic"],
    dhcpServerModelInterface: json["interface"],
    invalid: json["invalid"],
    leaseScript: json["lease-script"],
    leaseTime: json["lease-time"],
    name: json["name"],
    useRadius: json["use-radius"],
  );

  Map<String, dynamic> toJson() => {
    ".id": id,
    "address-pool": addressPool,
    "authoritative": authoritative,
    "disabled": disabled,
    "dynamic": dhcpServerModelDynamic,
    "interface": dhcpServerModelInterface,
    "invalid": invalid,
    "lease-script": leaseScript,
    "lease-time": leaseTime,
    "name": name,
    "use-radius": useRadius,
  };
}

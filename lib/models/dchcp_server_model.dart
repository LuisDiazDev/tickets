import 'dart:convert';

List<DhcpServerModel> dchcpServerModelFromJson(String str) => List<DhcpServerModel>.from(json.decode(str).map((x) => DhcpServerModel.fromJson(x)));

String dchcpServerModelToJson(List<DhcpServerModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DhcpServerModel {
  String? id;
  String? addressPool;
  String? authoritative;
  String? disabled;
  String? dchcpServerModelDynamic;
  String? dchcpServerModelInterface;
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
    this.dchcpServerModelDynamic,
    this.dchcpServerModelInterface,
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
    dchcpServerModelDynamic: json["dynamic"],
    dchcpServerModelInterface: json["interface"],
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
    "dynamic": dchcpServerModelDynamic,
    "interface": dchcpServerModelInterface,
    "invalid": invalid,
    "lease-script": leaseScript,
    "lease-time": leaseTime,
    "name": name,
    "use-radius": useRadius,
  };
}

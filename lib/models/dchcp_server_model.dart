import 'dart:convert';

List<DchcpServerModel> dchcpServerModelFromJson(String str) => List<DchcpServerModel>.from(json.decode(str).map((x) => DchcpServerModel.fromJson(x)));

String dchcpServerModelToJson(List<DchcpServerModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DchcpServerModel {
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

  DchcpServerModel({
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

  factory DchcpServerModel.fromJson(Map<String, dynamic> json) => DchcpServerModel(
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

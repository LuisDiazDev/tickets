import 'dart:convert';

List<TicketModel> ticketModelFromJson(String str) => List<TicketModel>.from(json.decode(str).map((x) => TicketModel.fromJson(x)));

String ticketModelToJson(List<TicketModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TicketModel {
  String? id;
  String? bytesIn;
  String? bytesOut;
  String? comment;
  String? ticketModelDefault;
  String? disabled;
  String? limitUptime;
  String? ticketModelDynamic;
  String? name;
  String? packetsIn;
  String? packetsOut;
  String? uptime;
  String? password;
  String? profile;

  TicketModel({
    this.id,
    this.bytesIn,
    this.bytesOut,
    this.comment,
    this.limitUptime,
    this.ticketModelDefault,
    this.disabled,
    this.ticketModelDynamic,
    this.name,
    this.packetsIn,
    this.packetsOut,
    this.uptime,
    this.password,
    this.profile,
  });

  factory TicketModel.fromJson(Map<String, dynamic> json) => TicketModel(
    id: json[".id"],
    limitUptime: json["limit-uptime"],
    bytesIn: json["bytes-in"],
    bytesOut: json["bytes-out"],
    comment: json["comment"],
    ticketModelDefault: json["default"],
    disabled: json["disabled"],
    ticketModelDynamic: json["dynamic"],
    name: json["name"],
    packetsIn: json["packets-in"],
    packetsOut: json["packets-out"],
    uptime: json["uptime"],
    password: json["password"],
    profile: json["profile"],
  );

  String getDownloadedInMB(){
    var bytes = int.parse(bytesIn?? "0");
    var mb = bytes / 1024 / 1024;
    return mb.toStringAsFixed(2);
  }

  String getUploadedInMB(){
    var bytes = int.parse(bytesOut?? "0");
    var mb = bytes / 1024 / 1024;
    return mb.toStringAsFixed(2);
  }

  Map<String, dynamic> toJson() => {
    ".id": id,
    "bytes-in": bytesIn,
    "bytes-out": bytesOut,
    "limit-uptime":limitUptime,
    "comment": comment,
    "default": ticketModelDefault,
    "disabled": disabled,
    "dynamic": ticketModelDynamic,
    "name": name,
    "packets-in": packetsIn,
    "packets-out": packetsOut,
    "uptime": uptime,
    "password": password,
    "profile": profile,
  };
}

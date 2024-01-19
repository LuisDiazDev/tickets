import 'dart:convert';

List<SchedulerModel> schedulerModelFromJson(String str) => List<SchedulerModel>.from(json.decode(str).map((x) => SchedulerModel.fromJson(x)));

String schedulerModelToJson(List<SchedulerModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SchedulerModel {
  String? id;
  String? comment;
  String? disabled;
  String? interval;
  String? name;
  DateTime? nextRun;
  String? onEvent;
  String? owner;
  String? policy;
  String? runCount;
  DateTime? startDate;
  String? startTime;

  SchedulerModel({
    this.id,
    this.comment,
    this.disabled,
    this.interval,
    this.name,
    this.nextRun,
    this.onEvent,
    this.owner,
    this.policy,
    this.runCount,
    this.startDate,
    this.startTime,
  });

  factory SchedulerModel.fromJson(Map<String, dynamic> json) => SchedulerModel(
    id: json[".id"],
    comment: json["comment"],
    disabled: json["disabled"],
    interval: json["interval"],
    name: json["name"],
    nextRun: json["next-run"] == null ? null : DateTime.parse(json["next-run"]),
    onEvent: json["on-event"],
    owner: json["owner"],
    policy: json["policy"],
    runCount: json["run-count"],
    startDate: json["start-date"] == null ? null : DateTime.parse(json["start-date"]),
    startTime: json["start-time"],
  );

  Map<String, dynamic> toJson() => {
    ".id": id,
    "comment": comment,
    "disabled": disabled,
    "interval": interval,
    "name": name,
    "next-run": nextRun?.toIso8601String(),
    "on-event": onEvent,
    "owner": owner,
    "policy": policy,
    "run-count": runCount,
    "start-date": "${startDate!.year.toString().padLeft(4, '0')}-${startDate!.month.toString().padLeft(2, '0')}-${startDate!.day.toString().padLeft(2, '0')}",
    "start-time": startTime,
  };
}

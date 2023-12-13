import 'dart:convert';

List<ProfileHotspotModel> profileHotspotModelFromJson(String str) => List<ProfileHotspotModel>.from(json.decode(str).map((x) => ProfileHotspotModel.fromJson(x)));

String profileHotspotModelToJson(List<ProfileHotspotModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ProfileHotspotModel {
  String? id;
  String? profileHotspotModelDefault;
  String? dnsName;
  String? hotspotAddress;
  String? htmlDirectory;
  String? htmlDirectoryOverride;
  String? httpCookieLifetime;
  String? httpProxy;
  String? installHotspotQueue;
  String? loginBy;
  String? name;
  String? smtpServer;
  String? splitUserDomain;
  String? useRadius;

  ProfileHotspotModel({
    this.id,
    this.profileHotspotModelDefault,
    this.dnsName,
    this.hotspotAddress,
    this.htmlDirectory,
    this.htmlDirectoryOverride,
    this.httpCookieLifetime,
    this.httpProxy,
    this.installHotspotQueue,
    this.loginBy,
    this.name,
    this.smtpServer,
    this.splitUserDomain,
    this.useRadius,
  });

  factory ProfileHotspotModel.fromJson(Map<String, dynamic> json) => ProfileHotspotModel(
    id: json[".id"],
    profileHotspotModelDefault: json["default"],
    dnsName: json["dns-name"],
    hotspotAddress: json["hotspot-address"],
    htmlDirectory: json["html-directory"],
    htmlDirectoryOverride: json["html-directory-override"],
    httpCookieLifetime: json["http-cookie-lifetime"],
    httpProxy: json["http-proxy"],
    installHotspotQueue: json["install-hotspot-queue"],
    loginBy: json["login-by"],
    name: json["name"],
    smtpServer: json["smtp-server"],
    splitUserDomain: json["split-user-domain"],
    useRadius: json["use-radius"],
  );

  Map<String, dynamic> toJson() => {
    ".id": id,
    "default": profileHotspotModelDefault,
    "dns-name": dnsName,
    "hotspot-address": hotspotAddress,
    "html-directory": htmlDirectory,
    "html-directory-override": htmlDirectoryOverride,
    "http-cookie-lifetime": httpCookieLifetime,
    "http-proxy": httpProxy,
    "install-hotspot-queue": installHotspotQueue,
    "login-by": loginBy,
    "name": name,
    "smtp-server": smtpServer,
    "split-user-domain": splitUserDomain,
    "use-radius": useRadius,
  };
}

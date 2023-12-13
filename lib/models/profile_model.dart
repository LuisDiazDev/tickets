import 'dart:convert';

List<ProfileModel> profileModelFromJson(String str) => List<ProfileModel>.from(json.decode(str).map((x) => ProfileModel.fromJson(x)));

String profileModelToJson(List<ProfileModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ProfileModel {
  String? id;
  String? addMacCookie;
  String? addressList;
  String? profileModelDefault;
  String? idleTimeout;
  String? keepaliveTimeout;
  String? macCookieTimeout;
  String? name;
  String? parentQueue;
  String? sharedUsers;
  String? statusAutorefresh;
  String? transparentProxy;
  String? addressPool;
  String? onLogin;
  String? rateLimit;

  ProfileModel({
    this.id,
    this.addMacCookie,
    this.rateLimit,
    this.addressList,
    this.profileModelDefault,
    this.idleTimeout,
    this.keepaliveTimeout,
    this.macCookieTimeout,
    this.name,
    this.parentQueue,
    this.sharedUsers,
    this.statusAutorefresh,
    this.transparentProxy,
    this.addressPool,
    this.onLogin,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
    id: json[".id"],
    addMacCookie: json["add-mac-cookie"],
    addressList: json["address-list"],
    profileModelDefault: json["default"],
    idleTimeout: json["idle-timeout"],
    keepaliveTimeout: json["keepalive-timeout"],
    macCookieTimeout: json["mac-cookie-timeout"],
    name: json["name"],
    parentQueue: json["parent-queue"],
    sharedUsers: json["shared-users"],
    statusAutorefresh: json["status-autorefresh"],
    transparentProxy: json["transparent-proxy"],
    addressPool: json["address-pool"],
    onLogin: json["on-login"],
    rateLimit: json["rate-limit"],
  );

  Map<String, dynamic> toJson() => {
    ".id": id,
    "add-mac-cookie": addMacCookie,
    "address-list": addressList,
    "default": profileModelDefault,
    "idle-timeout": idleTimeout,
    "keepalive-timeout": keepaliveTimeout,
    "mac-cookie-timeout": macCookieTimeout,
    "name": name,
    "parent-queue": parentQueue,
    "shared-users": sharedUsers,
    "status-autorefresh": statusAutorefresh,
    "transparent-proxy": transparentProxy,
    "address-pool": addressPool,
    "on-login": onLogin,
    "rate-limit":rateLimit
  };
}

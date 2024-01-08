import 'dart:convert';
import 'dart:developer';

import 'package:StarTickera/models/profile_metadata_model.dart';

List<ProfileModel> profileModelFromJson(String str) {
  var m = json.decode(str);
  List<ProfileModel> list = [];
  for (var item in m) {
    try {
      var n = item["name"] ?? "";
      if (n != "default") {
        var a = ProfileModel.fromJson(item);
        if (a.isValid) {
          list.add(a);
        } else {
          log("Error parsing profile - is invalid: $n");
        }
      }
    } catch (e) {
      log("Error parsing profile: $e");
    }
  }
  return list;
}

String profileModelToJson(List<ProfileModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ProfileModel {
  String? id;
  String? name = "";
  String? addMacCookie;
  String? addressList;
  String? profileModelDefault;
  String? idleTimeout;
  String? keepaliveTimeout;
  String? macCookieTimeout;
  String? storeName;
  String? parentQueue;
  String? sharedUsers;
  String? statusAutorefresh;
  String? transparentProxy;
  String? addressPool;
  String? onLogin;
  String? rateLimit;
  ProfileMetadata? metadata;
  bool isValid = true;

  ProfileModel({
    this.id,
    this.name,
    this.addMacCookie,
    this.rateLimit,
    this.addressList,
    this.profileModelDefault,
    this.idleTimeout,
    this.keepaliveTimeout,
    this.macCookieTimeout,
    this.parentQueue,
    this.sharedUsers,
    this.statusAutorefresh,
    this.transparentProxy,
    this.addressPool,
    this.onLogin,
    this.metadata,
    this.isValid = true,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    if (json["name"] == "default") {
      return ProfileModel(isValid: false);
    }
    bool isValid = true;
    ParseResult m = ParseResult([],"", null);
    try {
      m = ProfileMetadata.parseFromMikrotiketNameString(json["name"]);
      for (var warn in m.warnings) {
        if (warn != "") {
          isValid = false;
          log("Error parsing profile: $warn");
        }
      }
    } catch (e) {
      isValid = false;
    }
    return ProfileModel(
      id: json[".id"],
      addMacCookie: json["add-mac-cookie"],
      addressList: json["address-list"],
      profileModelDefault: json["default"],
      idleTimeout: json["idle-timeout"],
      keepaliveTimeout: json["keepalive-timeout"],
      macCookieTimeout: json["mac-cookie-timeout"],
      name: m.profileName,
      parentQueue: json["parent-queue"],
      sharedUsers: json["shared-users"],
      statusAutorefresh: json["status-autorefresh"],
      transparentProxy: json["transparent-proxy"],
      addressPool: json["address-pool"],
      onLogin: json["on-login"],
      rateLimit: json["rate-limit"],
      metadata: m.profile,
      isValid: isValid,
    );
  }

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
        "rate-limit": rateLimit
        // skip metadata
      };
}

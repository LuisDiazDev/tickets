import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:StarTickera/models/scheduler_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:mikrotik_mndp/decoder.dart';
import 'package:mikrotik_mndp/listener.dart';
import 'package:mikrotik_mndp/product_info_provider.dart';
import 'package:network_info_plus/network_info_plus.dart';

import '../../models/active_user_models.dart';
import '../../models/dhcp_server_model.dart';
import '../../models/hotspot_model.dart';
import '../../models/profile_hotspot_model.dart';
import '../../models/profile_model.dart';
import '../../models/ticket_model.dart';
import 'restApiProvider.dart';

class UserAlreadyExist implements Exception {
  final String message;

  UserAlreadyExist(this.message);

  @override
  String toString() {
    return "UserAlreadyExist: $message";
  }
}

class FoundMikrotik {
  final bool isConnected;
  String? ipv4;
  String? ipv6;
  String? mac;
  String? identity;
  String? softwareVersion;
  Duration? uptime;
  String? boardName;
  String? boardImageUrl;
  String? interfaceName;
  String? name;
  String? model;

  FoundMikrotik(this.isConnected);
}

class MkProvider {
  final restApi = RestApiProvider();

  Future<String> identity() async {
    var response = await restApi.get(endpoint: "/system/identity");

    if (response.statusCode == 200) {
      try {
        var decode = jsonDecode(response.body)["name"] ?? "";
        return decode;
      } catch (e) {
        log(e.toString());
        return "";
      }
    }
    return "";
  }

  Future<List<TicketModel>> allTickets() async {
    var response = await restApi.get(endpoint: "/ip/hotspot/user");

    if (response.statusCode == 200) {
      try {
        var decode = ticketModelFromJson(response.body);
        return decode;
      } catch (e) {
        log(e.toString());
        return [];
      }
    }
    return [];
  }

  Future<List<SchedulerModel>> allScheduler() async {
    var response = await restApi.get(endpoint: "/system/scheduler");

    if (response.statusCode == 200) {
      try {
        var decode = schedulerModelFromJson(response.body);
        return decode;
      } catch (e) {
        log(e.toString());
        return [];
      }
    }
    return [];
  }

  Future<List<ActiveModel>> allActiveTickets() async {
    var response = await restApi.get(endpoint: "/ip/hotspot/active");

    if (response.statusCode == 200) {
      try {
        var decode = activeModelFromJson(response.body);
        return decode;
      } catch (e) {
        log(e.toString());
        return [];
      }
    }
    return [];
  }

  Future<List<Hotspot>> allHotspot() async {
    var response = await restApi.get(endpoint: "/ip/hotspot");

    if (response.statusCode == 200) {
      try {
        var decode = hotspotFromJson(response.body);
        return decode;
      } catch (e) {
        log(e.toString());
        return [];
      }
    }
    return [];
  }

  Future<List<ProfileModel>> allProfiles() async {
    var response = await restApi.get(endpoint: "/ip/hotspot/user/profile");

    if (response.statusCode == 200) {
      try {
        var decode = profileModelFromJson(response.body);
        return decode;
      } catch (e) {
        log(e.toString());
        return [];
      }
    }

    return [];
  }

  Future<Object> allDhcpServer(
      {String? user, String? pass, String? host}) async {
    var response = await restApi.get(
        endpoint: "/ip/dhcp-server", user: user, pass: pass, host: host);

    if (response.statusCode == 200) {
      try {
        var decode = dhcpServerModelFromJson(response.body);
        return decode;
      } catch (e) {
        log(e.toString());
        return [];
      }
    } else {
      return false;
    }
  }

  Future<Response> exportData({String file = "default"}) async {
    return await restApi
        .post(endpoint: "/export", body: {"file": file, "show-sensitive": true});
  }

  Future<List<ProfileHotspotModel>> allProfilesHotspot() async {
    var response = await restApi.get(endpoint: "/ip/hotspot/profile");

    if (response.statusCode == 200) {
      try {
        var decode = profileHotspotModelFromJson(response.body);
        return decode;
      } catch (e) {
        log(e.toString());
        return [];
      }
    }
    return [];
  }

  Future<Response> newTicket(String name, String profile, String duration,
      {int limitBytesTotal = 0}) async {
    var r = await restApi.post(endpoint: "/ip/hotspot/user/add", body: {
      "server": "hotspot1",
      "name": name,
      "password": name,
      "profile": profile,
      "disabled": "false",
      "limit-uptime": duration,
      "limit-bytes-total":
          limitBytesTotal != 0 ? "${limitBytesTotal}M" : limitBytesTotal,
      "comment": "Creado desde StarTickera | ${getLatinDate()}"
    });
    if (r.statusCode == 200 || r.statusCode == 201) {
      return r;
    }
    if (r.body.contains("already have user with this name for this server")) {
      throw UserAlreadyExist(name);
    }
    throw Exception("Ah ocurrido un error");
  }

  String getLatinDate() {
    var now = DateTime.now();
    var y = now.year;
    var m = now.month.toString().padLeft(2, "0");
    var d = now.day.toString().padLeft(2, "0");
    var h = now.hour.toString().padLeft(2, "0");
    var min = now.minute.toString().padLeft(2, "0");
    var sec = now.second.toString().padLeft(2, "0");
    return "$d-$m-$y $h:$min:$sec";
  }

  Future<Response> backup(String name, String pass) async {
    return await restApi.post(endpoint: "/system/backup/load", body: {
      "name": name,
      "password": pass,
      "force-v6-to-v7-configuration-upgrade": true
    });
  }

  Future<Response> changePass(
      String oldPass, String newPass, String verifyPass) async {
    return await restApi.post(endpoint: "/password", body: {
      "new-password": newPass,
      "confirm-new-password": verifyPass,
      "old-password": oldPass
    });
  }

  Future<Response> removeTicket(String id) async {
    var result = await restApi.delete(url: "/ip/hotspot/user/$id");
    return result;
  }

  Future<Response> disconnectTicket(String id) async {
    return  await restApi.delete(url: "/ip/hotspot/active/$id");
  }

  Future<Response> removeProfile(String id) async {
    return await restApi.delete(url: "/ip/hotspot/user/profile/$id");
  }

  Future<Response> resetClient(String id) async {
    return await restApi
        .post(endpoint: "/ip/hotspot/user/reset-counters", body: {".id": id});
  }

  Future<Response> newProfile(ProfileModel profile, String duration) async {
    if (profile.name == "") {
      throw Exception("El nombre no puede estar vacio");
    }
    var p = await allProfiles();
    var h = await allHotspot();
    profile.metadata!.hotspot = h[0].name; // TODO
    for (var i = 0; i < p.length; i++) {
      if (p[i].name == profile.name) {
        profile.name = "${profile.name} (copy)";
        return newProfile(profile, duration);
      }
    }
    return await restApi.post(endpoint: "/ip/hotspot/user/profile/add", body: {
      "name": profile.metadata!.toMikrotiketNameString(profile.name ?? ""),
      // TODO mover toMikrotiketNameString a esta clase
      "address-pool": "dhcp",
      "rate-limit": profile.rateLimit,
      "shared-users": profile.sharedUsers,
      "status-autorefresh": "1m",
      "mac-cookie-timeout": duration,
      "on-login": profile.onLogin,
      "transparent-proxy": "yes"
    });
  }

  Future<Response> updateProfile(ProfileModel profile) async {
    return await restApi
        .put(url: "/ip/hotspot/user/profile/${profile.id}", body: {
      "name": profile.metadata!.toMikrotiketNameString(profile.name ?? ""),
      "address-pool": "dhcp",
      "rate-limit": profile.rateLimit,
      "shared-users": profile.sharedUsers,
      "status-autorefresh": "1m",
      "on-login": profile.onLogin,
    });
  }

  Future<Response> reactiveUserHotspot(TicketModel t) async {
    t.disabled = "false";
    return await restApi
        .put(url: "/ip/hotspot/user/${t.id}", body: {
          "disabled":"false",
          "name":t.name,
          ".id":t.id,
          "profile":t.profile,
          "comment":t.comment,
          "password": t.password,
          "limit-uptime": t.limitUptime,
    });
  }

  Stream<FoundMikrotik> findMikrotiksInLocalNetwork(
      ValueNotifier<int> progressNotifier,
      {int timeoutSecs = 5}) {
    var poolStream = _findMikrotiksInLocalNetworkByPolling(
        progressNotifier,
        timeoutSecs: timeoutSecs);

    var productProvider = MikrotikProductInfoProviderImpl();
    var decoder = MndpMessageDecoderImpl(productProvider);
    MNDPListener mndpListener = MNDPListener(decoder);
    var mnpdStream = mndpListener.listen();

    var joinController = StreamController<FoundMikrotik>();

    poolStream?.listen((event) {
      joinController.add(event);
    });
    mnpdStream.listen((event) {
      var m = FoundMikrotik(false);
      m.ipv4 = event.unicastIpv4Address;
      m.ipv6 = event.unicastIpv6Address;
      m.mac = event.macAddress;
      m.boardName = event.boardName;
      m.boardImageUrl = event.productInfo?.imageUrl;
      m.name = event.productInfo?.name;
      joinController.add(m);
    });
    return joinController.stream;
  }

  Stream<FoundMikrotik>? _findMikrotiksInLocalNetworkByPolling(
      ValueNotifier<int> count,
      {int timeoutSecs = 5}) {
    StreamController<FoundMikrotik> controller = StreamController();
    NetworkInfo().getWifiIP().then((String? localIp) {
      if (localIp == null) {
        log("No se pudo obtener la ip local");
        return null;
      }
      String ipRange = _getIpRange(localIp);
      var internalCount = 0;
      for (int i = 1; i < 255; i++) {
        var ip = "$ipRange.$i";
        restApi
            .get(
          host: ip,
          endpoint: "/system/routerboard",
          timeoutSecs: timeoutSecs,
        )
            .then((Response e) {
          internalCount++;
          if (internalCount % 10 == 0 || internalCount == 255) {
            count.value = internalCount;
          }
          if (e.statusCode < 500) {
            var body = e.body;
            // if the mikrotik is found, the body contains "Bad Request"
            if (body.contains("Unauthorized") ||
                body.contains("board-name") ||
                body.contains("Bad Request")) {
              count.value = 255;
              var ipv4 = e.request!.url.host;
              var isConnected = body.contains("board-name");
              var m = FoundMikrotik(isConnected);
              m.ipv4 = ipv4;
              controller.add(m);
            }
          }
        });
      }
    });
    return controller.stream;
  }

  String _getIpRange(String ip) {
    var split = ip.split(".");
    return "${split[0]}.${split[1]}.${split[2]}";
  }
}

import 'dart:convert';

import 'package:http/http.dart';

import '../../models/dchcp_server_model.dart';
import '../../models/profile_hotspot_model.dart';
import '../../models/profile_model.dart';
import '../../models/ticket_model.dart';
import 'restApiProvider.dart';

class TicketProvider {
  final restApi = RestApiProvider();

  Future<List<TicketModel>> allTickets() async {
    var response = await restApi.get(url: "/ip/hotspot/user");

    if (response.statusCode == 200) {
      try {
        var decode = ticketModelFromJson(response.body);
        return decode;
      } catch (e) {
        // restApi.alertCubit?.showAlertInfo(title: "", subtitle: e.toString());
        return [];
      }
    }

    return [];
  }

  Future<List<ProfileModel>> allProfiles() async {
    var response = await restApi.get(url: "/ip/hotspot/user/profile");

    if (response.statusCode == 200) {
      try {
        var decode = profileModelFromJson(response.body);
        return decode;
      } catch (e) {
        // restApi.alertCubit?.showAlertInfo(title: "", subtitle: e.toString());
        return [];
      }
    }

    return [];
  }

  Future<Object> allDhcpServer({
    String? user, String? pass, String? host
  }) async {
    var response = await restApi.get(url: "/ip/dhcp-server",
      user: user,
      pass: pass,
      host: host
    );

    if (response.statusCode == 200) {
      try {
        var decode = dchcpServerModelFromJson(response.body);
        return decode;
      } catch (e) {
        // restApi.alertCubit?.showAlertInfo(title: "", subtitle: e.toString());
        return [];
      }
    }else{
      // restApi.alertCubit?.showAlertInfo(title: "", subtitle: response.body);
      return false;
    }
  }

  Future<List<ProfileHotspotModel>> allProfilesHotspot() async {
    var response = await restApi.get(url: "/ip/hotspot/profile");

    if (response.statusCode == 200) {
      try {
        var decode = profileHotspotModelFromJson(response.body);
        return decode;
      } catch (e) {
        // restApi.alertCubit?.showAlertInfo(title: "", subtitle: e.toString());
        return [];
      }
    }else{
      // restApi.alertCubit?.showAlertInfo(title: "", subtitle: response.body);
    }

    return [];
  }

  Future<Response> newTicket(String name, String profile,String duration) async {
    return await restApi.post(url: "/ip/hotspot/user/add", body: {
      "server": "hotspot1",
      "name": name,
      "password": name,
      "profile": profile,
      "disabled": "no",
      "limit-uptime": duration,
      "limit-bytes-total": "0",
      "comment": "usuario (ticket creado desde app)"
    });
  }

  Future<Response> backup(String name, String pass) async {
    return await restApi.post(url: "/system/backup/load", body: {
      "name": name,
      "password": pass,
      "force-v6-to-v7-configuration-upgrade":true
    });
  }

  Future<Response> removeTicket(String id) async {
    return await restApi.delete(url: "/ip/hotspot/user/$id");
  }

  Future<Response> removeProfile(String id) async {
    return await restApi.delete(url: "/ip/hotspot/user/profile/$id");
  }

  Future<Response> newProfile(ProfileModel profile,String duration) async {
    var p = await allProfiles();
    for (var i = 0; i < p.length; i++) {
      if(p[i].name == profile.name){
        profile.name = "${profile.name} (copy)";
        return newProfile(profile,duration);
      }
    }
    return await restApi.post(url: "/ip/hotspot/user/profile/add", body: {
      "name": profile.name,
      "address-pool": "dhcp",
      "rate-limit": profile.rateLimit,
      "shared-users": profile.sharedUsers,
      "status-autorefresh": "1m",
      "mac-cookie-timeout":duration,
      "on-login": profile.onLogin,
      // "parent-queue": "",
    });
  }

  Future<Response> updateProfile(ProfileModel profile) async {
    return await restApi.put(url: "/ip/hotspot/user/profile/${profile.id}", body: {
      "name": profile.name,
      "address-pool": "dhcp",
      "rate-limit": profile.rateLimit,
      "shared-users": profile.sharedUsers,
      "status-autorefresh": "1m",
      "on-login": profile.onLogin,
      // "parent-queue": ""
    });
  }
}

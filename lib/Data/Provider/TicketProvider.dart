import 'dart:convert';

import 'package:http/http.dart';
import 'package:tickets/models/profile_model.dart';
import 'package:tickets/models/ticket_model.dart';

import '../../models/profile_hotspot_model.dart';
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
        return [];
      }
    }

    return [];
  }

  Future<List<ProfileHotspotModel>> allProfilesHotspot() async {
    var response = await restApi.get(url: "/ip/hotspot/profile");

    if (response.statusCode == 200) {
      try {
        var decode = profileHotspotModelFromJson(response.body);
        return decode;
      } catch (e) {
        return [];
      }
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

  Future<Response> removeTicket(String id) async {
    return await restApi.delete(url: "/ip/hotspot/user/$id");
  }

  Future<Response> removeProfile(String id) async {
    return await restApi.delete(url: "/ip/hotspot/user/profile/$id");
  }

  Future<Response> newProfile(ProfileModel profile) async {
    return await restApi.post(url: "/ip/hotspot/user/profile/add", body: {
      "name": profile.name,
      "address-pool": "dhcp",
      "rate-limit": profile.rateLimit,
      "shared-users": profile.sharedUsers,
      "status-autorefresh": "1m",
      "on-login": profile.onLogin,
      "parent-queue": ""
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
      "parent-queue": ""
    });
  }
}

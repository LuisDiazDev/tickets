import 'dart:convert';

import 'package:tickets/models/profile_model.dart';
import 'package:tickets/models/ticket_model.dart';

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

  Future newTicket(String name, String profile) async {
    return await restApi.post(url: "/ip/hotspot/user/add", body: {
      "server": "ticket",
      "name": name,
      "password": name,
      "profile": profile,
      "disabled": "no",
      "limit-uptime": "0",
      "limit-bytes-total": "0",
      "comment": "usuario (ticket creado desde postman)"
    });
  }
}

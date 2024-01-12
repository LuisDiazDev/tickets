import 'package:http/http.dart';

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

class MkProvider {
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



  Future<List<Hotspot>> allHotspot() async {
    var response = await restApi.get(url: "/ip/hotspot");

    if (response.statusCode == 200) {
      try {
        var decode = hotspotFromJson(response.body);
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
        var decode = dhcpServerModelFromJson(response.body);
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

  Future<Response> exportData({String file="default"})async{
    return await restApi.post(url: "/export", body: {
      "file": file,
      "show-sensitive":true
    });
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

  Future<Response> newTicket(String name, String profile,String duration,{int limitBytesTotal=0}) async {
    var r = await restApi.post(url: "/ip/hotspot/user/add", body: {
      "server": "hotspot1",
      "name": name,
      "password": name,
      "profile": profile,
      "disabled": "no",
      "limit-uptime": duration,
      "limit-bytes-total": limitBytesTotal,
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
    return await restApi.post(url: "/system/backup/load", body: {
      "name": name,
      "password": pass,
      "force-v6-to-v7-configuration-upgrade":true
    });
  }

  Future<Response> removeTicket(String id) async {
    // id = id.replaceAll("*", "");
    var result = await restApi.delete(url: "/ip/hotspot/user/$id");
    return result;
  }

  Future<Response> removeProfile(String id) async {
    return await restApi.delete(url: "/ip/hotspot/user/profile/$id");
  }

  Future<Response> newProfile(ProfileModel profile,String duration) async {
    if (profile.name == "") {
      throw Exception("El nombre no puede estar vacio");
    }
    var p = await allProfiles();
    var h = await allHotspot();
    profile.metadata!.hotspot = h[0].name; // TODO
    for (var i = 0; i < p.length; i++) {
      if(p[i].name == profile.name){
        profile.name = "${profile.name} (copy)";
        return newProfile(profile,duration);
      }
    }
    return await restApi.post(url: "/ip/hotspot/user/profile/add", body: {
      "name": profile.metadata!.toMikrotiketNameString(profile.name??""), // TODO mover toMikrotiketNameString a esta clase
      "address-pool": "dhcp",
      "rate-limit": profile.rateLimit,
      "shared-users": profile.sharedUsers,
      "status-autorefresh": "1m",
      "mac-cookie-timeout":duration,
      "on-login": profile.onLogin,
      "transparent-proxy":"yes"
      // "parent-queue": "",
    });
  }

  Future<Response> updateProfile(ProfileModel profile) async {
    return await restApi.put(url: "/ip/hotspot/user/profile/${profile.id}", body: {
      "name": profile.metadata!.toMikrotiketNameString(profile.name??""),
      "address-pool": "dhcp",
      "rate-limit": profile.rateLimit,
      "shared-users": profile.sharedUsers,
      "status-autorefresh": "1m",
      "on-login": profile.onLogin,
      // "parent-queue": ""
    });
  }
}

//required network_info_plus: ^3.0.5

import 'dart:developer';

import 'package:http/http.dart';
import 'package:network_info_plus/network_info_plus.dart';

import '../../Data/Provider/MkProvider.dart';

Future<Map> getIp()async{
  var localIp = await NetworkInfo().getWifiIP();

  int current = 0;
  var lst = localIp?.split(".") ?? [];
  current = int.parse(lst.last);
  var locate = lst[2];
  // if (locate == "20") {
  //   current = 5;
  // }
  return _check(current,locate);
}

Future<Map> _check(int current,String locate) async {
  const int requestCount = 128;
  var ticketProvider = MkProvider();
  for (int i = 2; i < 255; i += requestCount) {

    List<Future<Response>> promises = [];
    for (int j = i; j < requestCount+i; j ++) {
      var ip = "192.168.$locate.$j";
      promises.add(ticketProvider.restApi.get(
        host: ip,
        url: "/ip/hotspot/user",
        user: "admin",
        pass: "1234",
      ));
    }

    var responses = await Future.wait(promises);
    for (int i = 0; i < responses.length; i++) {
      if (responses[i].statusCode < 500) {
        // var body = responses[i].body;
        if(i == current){
          continue;
        }

        if(responses[i].statusCode == 200){
          return {
            "ip":responses[i].request?.url.host,
            "connect":true
          };
        }else{
          return {
            "ip":responses[i].request?.url.host,
            "connect":false
          };
        }

      }
    }
  }
   return {
    "ip":"...",
    "connect":false
  };
}
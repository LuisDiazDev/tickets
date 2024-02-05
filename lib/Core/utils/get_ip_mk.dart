import 'package:network_info_plus/network_info_plus.dart';
import 'package:startickera/Modules/Session/session_cubit.dart';
import 'package:startickera/models/auth_model.dart';

import '../../Data/Provider/mikrotik/mk_provider.dart';

Future<Map> getIp(SessionCubit sessionCubit) async{
  var localIp = await NetworkInfo().getWifiIP();

  int current = 0;
  var lst = localIp?.split(".") ?? [];
  current = int.tryParse(lst.last) ?? 0;
  var locate = lst[2];
  return _check(current,locate, sessionCubit);
}

Future<Map> _check(int current,String locate, SessionCubit sessionCubit) async {
  const int requestCount = 128;
  var ticketProvider = MkProvider(sessionCubit);
  for (int i = 2; i < 255; i += requestCount) {

    List<Future<AuthResponse>> promises = [];
    for (int j = i; j < requestCount+i; j ++) {
      var ip = "192.168.$locate.$j";
      promises.add(ticketProvider.auth(ip, "admin", "1234"));
    }

    var responses = await Future.wait(promises);
    for (int i = 0; i < responses.length; i++) {
      if (responses[i].rawResponse.statusCode < 500) {
        // var body = responses[i].body;
        if(i == current){
          continue;
        }

        if(responses[i].rawResponse.statusCode == 200){
          return {
            "ip":responses[i].rawResponse.request?.url.host,
            "connect":true
          };
        }else{
          return {
            "ip":responses[i].rawResponse.request?.url.host,
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
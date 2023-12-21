import 'dart:developer';

import 'package:TicketOs/Core/Values/Colors.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../../../Data/Provider/TicketProvider.dart';
import '../../../Data/Services/navigator_service.dart';

class IpSearch {
  ///common method for showing progress dialog
  static Future showDialogSearch(
      {BuildContext? context, isCancellable = true, String ip = ""}) async {
    if (NavigatorService.navigatorKey.currentState?.overlay?.context != null) {
      return await showDialog(
          barrierDismissible: false,
          context: NavigatorService.navigatorKey.currentState!.overlay!.context,
          builder: (context) {
            return AlertDialog(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(32.0))),
              contentPadding: const EdgeInsets.only(top: 10.0),
              content: SizedBox(
                width: 300.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          "Buscando",
                          style: TextStyle(fontSize: 24.0),
                        ),
                        Icon(
                          EvaIcons.navigation2Outline,
                          color: ColorsApp.green,
                          size: 30.0,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5.0,
                    ),
                    const Divider(
                      color: Colors.grey,
                      height: 4.0,
                    ),
                    Container(
                        padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                        width: 50,
                        child: FindIp(
                          ip: ip,
                        )),
                  ],
                ),
              ),
            );
          });
    }
  }
}

class FindIp extends StatefulWidget {
  const FindIp({super.key, this.ip = ""});

  final String ip;

  @override
  State<FindIp> createState() => _FindIpState();
}

class _FindIpState extends State<FindIp> {
  late TicketProvider ticketProvider;
  String findIp = "", locate = "";
  int current = 0;
  bool limitUp = false, limitDown = false;

  @override
  void initState() {
    super.initState();
    ticketProvider = TicketProvider();
    if (widget.ip == "..." || widget.ip == "") {
      findIp = "...";
    } else {
      var lst = widget.ip.split(".");
      current = int.parse(lst.last);
      locate = lst[2];
      if (locate == "20") {
        current = 5;
      }
    }
    search();
  }

  void search() {
    if (findIp == "...") {
      Navigator.pop(context, "...");
    }
    check(current);
  }

  void check(int ip) async {
    const int requestCount = 128;
    for (int i = 1; i < 255; i += requestCount) {
      List<Future<Response>> promises = [];
      for (int j = i; j < requestCount+i; j ++) {
        var ip = "192.168.$locate.$j";
        log("$ip ->");
        promises.add(ticketProvider.restApi.get(
          host: ip,
          url: "/system/health",
          user: "",
          pass: "",
        ));
      }
      var responses = await Future.wait(promises);
      for (int i = 0; i < responses.length; i++) {
        if (responses[i].statusCode < 500) {
          var body = responses[i].body;
          Navigator.pop(context, responses[i].request?.url.host);
          return;
        }
      }
    }
    Navigator.pop(context, "...");
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 35,
      height: 35,
      child: CircularProgressIndicator(
        color: ColorsApp.secondary,
      ),
    );
  }
}

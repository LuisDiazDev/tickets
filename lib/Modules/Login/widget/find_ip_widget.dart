import 'package:TicketOs/Core/Values/Colors.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

import '../../../Data/Provider/TicketProvider.dart';
import '../../../Data/Services/navigator_service.dart';

class IpSearch {

  ///common method for showing progress dialog
  static Future showDialogSearch(
      {BuildContext? context, isCancellable = true, String ip = ""}) async {
    if (
    NavigatorService.navigatorKey.currentState?.overlay?.context != null) {
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
                        child: FindIp(ip: ip,)
                    ),
                  ],
                ),
              ),
            );
          }
       );
    }
  }
}


class FindIp extends StatefulWidget {

  const FindIp({super.key,this.ip=""});
  final String ip;
  @override

  State<FindIp> createState() => _FindIpState();
}

class _FindIpState extends State<FindIp> {
  late TicketProvider ticketProvider;
  String findIp="",locate="",current="",limit="";
  bool limitUp = false, limitDown = false,finish = false;

  @override
  void initState() {
    super.initState();
    ticketProvider =TicketProvider();
    if(widget.ip == "..." || widget.ip == ""){
      findIp = "...";
    }else{
      var lst = widget.ip.split(".");
      current = lst.last;
      locate = lst[2];
      if(locate =="20"){
        limit = "10";
      }else{
        limit = "1";
      }
    }

    search();
  }

  void search(){
    if(findIp == "..."){
      Navigator.pop(context,"...");
    }
    if(locate == "20"){
      check(2, "+");
    }else{
      int ip = int.parse(current);
      check(++ip, "+");
      check(--ip, "-");
    }
  }

  void check(int ip,String operation)async{
    var ips = "192.168.$locate.$ip";

    var r = await ticketProvider.restApi.get(host:ips,url: "/rest/ip/hotspot/user",user: "",pass: "");
    if(r.statusCode < 500){
      finish = true;
      Navigator.pop(context,ips);
    }else{
      if(locate == "20"){
        if(!limitUp){
          limitUp = ip++ == 254;
          check(ip++,'+');
        }else{
          Navigator.pop(context,"...");
        }
      }else if(!finish){
        if(operation == '+'){
          if(!limitUp){
            limitUp = ip++ == 254;
            check(++ip,'+');
          }else if(limitUp && limitDown){
            Navigator.pop(context,"...");
          }
        }else{
          if(!limitDown){
            limitDown = ip-- == 1;
            check(--ip,'-');
          }else if(limitUp && limitDown){
            Navigator.pop(context,"...");
          }
        }
      }
    }
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

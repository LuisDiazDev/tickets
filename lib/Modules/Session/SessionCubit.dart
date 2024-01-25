import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:StarTickera/Data/database/databse_firebase.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import '../../Core/Values/Enums.dart';
import '../../Core/utils/get_device_details.dart';
import '../../Core/utils/get_ip_mk.dart';
import '../../Core/utils/progress_dialog_utils.dart';
import '../../Data/Provider/MkProvider.dart';
import '../../Data/Provider/restApiProvider.dart';
import '../../Data/Services/ftp_service.dart';
import '../../Data/Services/navigator_service.dart';
import '../../Widgets/DialogApp.dart';
import '../../Widgets/starlink/dialog.dart';
import '../../models/config_model.dart';
import '../Alerts/AlertCubit.dart';

part 'SessionState.dart';

class SessionCubit extends HydratedCubit<SessionState> {

  SessionCubit() : super(const SessionState()) {
    RestApiProvider().sessionCubit = this;
  }

  Future checkUserData() async {
    final database = DatabaseFirebase();

    if (await database.checkUUID()) {
      var phone = await database.getContact();
      var name = await database.getName();

      emit(state.copyWith(
        active: true,
        configModel: state.cfg!.copyWith(
          contact: phone??"",
          nameLocal: name??""
        )
      ));
    } else {
      // await database.updateLicense("eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c");
      // emit(state.copyWith(active: false));
    }
  }

  Future<void> verify() async {
    ConfigModel? cfg = state.cfg;
    var isAuthenticated = state.isAuthenticated;

    var deviceDetails = await getDeviceDetails();
    var uuid = deviceDetails.last?.replaceAll(".", "-") ??
        ""; //uuid: "TP1A.220624.014"

    cfg ??= ConfigModel();
    changeState(state.copyWith(configModel: cfg,uuid: uuid));

    authListener();
    checkUserData();
  }

  void loadSetting() async {
    var exist = await FtpService.checkFile(remoteName: "info.rsc");

    if (exist) {
      final Directory directory = Directory.systemTemp.createTempSync();
      File file = File("${directory.path}/info.rsc")..createSync();

      var d = await FtpService.downloadFile(file: file, remoteName: "info.rsc");

      if (d) {
        List<WifiDataModels> wDetails = [];
        var data = await file.readAsString();
        var interfaces = data.split("/");
        var wifiInterface = interfaces
            .firstWhere((element) => element.contains("interface wifi"));
        var wifiInterfaceDetails = wifiInterface.split("add");
        for (var interfaceW in wifiInterfaceDetails) {
          var details = interfaceW.split(" ");
          if (!interfaceW.contains("interface")) {
            try {
              wDetails.add(WifiDataModels(
                ssid: details
                        .firstWhere((element) => element.contains("ssid"))
                        .replaceAll(".ssid=", "")
                        .replaceAll("\n", "")  ,
                pass: details
                        .firstWhere((element) => element.contains("pass"))
                        .replaceAll(".passphrase=", "")
                        .replaceAll("\n", ""),
              ));
            } catch (e) {
              log(e.toString()); // TODO: emit domain error
            }
          }
        }
       if(state.cfg != null){
         emit(state.copyWith(
             configModel: state.cfg!.copyWith(wifiCredentials: wDetails)));
         var identity = interfaces
             .firstWhere((element) => element.contains("system identity"));
         var identitySplit = identity.split("=");
         emit(state.copyWith(
             configModel: state.cfg!.copyWith(
                 identity: identitySplit.last
                     .replaceAll("\n", "")
                     .replaceAll("\r", ""))));
       }
      }
    } else {
      MkProvider provider = MkProvider();
      var r = await provider.exportData(file: "info.rsc");
      if (r.statusCode == 200 || r.statusCode == 201) {
        loadSetting();
      }
    }
  }

  void logOutMK(){
    emit(SessionState(sessionStatus: SessionStatus.mikrotik,firebaseID:state.firebaseID,uuid: state.uuid,ip: state.ip,wifi: state.wifi));
  }

  void exitSession()async {
    await FirebaseAuth.instance.signOut();
    state.listener?.cancel();
    emit(SessionState(sessionStatus: SessionStatus.finish,firebaseID:"",uuid: state.uuid,ip: state.ip,wifi: state.wifi));
  }

  Future<void> changeState(SessionState newState) async {
    emit(newState);
  }

  void initData()async{
    if (state.isAuthenticated && state.firebaseID != "") {
      MkProvider provider = MkProvider();
      var profilesH = await provider.allProfilesHotspot();
      if (profilesH.isNotEmpty) {
        emit(state.copyWith(
            configModel: state.cfg!.copyWith(
              dnsNamed: profilesH.last.dnsName,
            )));
      } else {
        emit(state.copyWith(
            sessionStatus: SessionStatus.mikrotik,
            isAuthenticated: false,
            configModel: ConfigModel()));
        return;
      }

      FtpService.initService(
          address: state.cfg?.host ?? "",
          user: state.cfg?.user ?? "",
          pass: state.cfg?.password ?? "");

      emit(state.copyWith(sessionStatus: SessionStatus.started));
      loadSetting();
      // loginHotspot();
    } else if(state.firebaseID != ""){
      var ip = await getIp();
      if (ip["connect"]) {
        MkProvider provider = MkProvider();
        var profilesH = await provider.allProfilesHotspot();
        if (profilesH.isNotEmpty) {
          emit(state.copyWith(
              configModel: state.cfg!.copyWith(
                dnsNamed: profilesH.last.dnsName,
              )));
        }

        FtpService.initService(address: ip["ip"], user: "admin", pass: "1234");

        emit(state.copyWith(
            configModel: state.cfg!
                .copyWith(host: ip["ip"], user: "admin", password: "1234"),
            isAuthenticated: true,
            sessionStatus: SessionStatus.started));

        loadSetting();
        // loginHotspot();
      } else if(state.firebaseID != ""){
        emit(state.copyWith(
            sessionStatus: SessionStatus.finish, configModel: ConfigModel()));
      }
      // // ip["connect"] ||
      // if(cfg != null){
      //     connect(cfg);
      //   }
    }
  }

  Future<void> authListener() async {
    try {
     var steam =  FirebaseAuth.instance
          .authStateChanges()
          .listen((User? user) {
        if (user == null) {
          emit(state.copyWith(sessionStatus: SessionStatus.finish));
        } else {
          emit(state.copyWith(firebaseID: user.uid));
          initData();
          final ref = FirebaseDatabase.instance.ref("users/${user.uid}");
          ref.onValue.listen((event) async {
            if (event.snapshot.value != null) {
              final value = event.snapshot.value as Map<dynamic, dynamic>;
              // Check if the same id, if not same then logout and navigate to login screen
              if (value['id'] != state.uuid) {
                exitSession();
               Future.delayed(const Duration(seconds: 1)).then((value){
                 StarlinkDialog.show(
                     context: NavigatorService.navigatorKey.currentState!.context,
                     title: "Cierre de sesión",
                     message: "Se ha abierto la aplicacion en otro dispositivo.\nRecuerde que solo puede tener una sesión abierta a la vez.",
                     type: AlertType.warning,
                     onTap: () {
                       NavigatorService.goBack();
                     },
                     actions: [],
                     error: null,
                     metadata: {}
                 );
               });
              }
            }
          });
        }
      });

     emit(state.copyWith(listener: steam));
    } catch (e) {
      //
      exitSession();
    }
  }

  @override
  SessionState? fromJson(Map<String, dynamic> json) {
    return SessionState.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(SessionState state) {
    return state.toJson();
  }

  Future checkConnection(AlertCubit alertCubit) async {
    ProgressDialogUtils.showProgressDialog();
    MkProvider provider = MkProvider();

    var r = await provider.allProfilesHotspot();
    ProgressDialogUtils.hideProgressDialog();
    if (r.isNotEmpty) {
      alertCubit.showDialog(
        ShowDialogEvent(
            title: "CONECTADO",
            message: "Se estableció la conexión con el mikrotik",
            type: AlertType.success,
        ),
      );
    } else {
      alertCubit.showDialog(
        ShowDialogEvent(
          title: "ERROR",
          message: "1. revise si el mikrotik está encendido\n"
            "2. chequee la direccion del mikrotik y que las credenciales sean correctas",
          type: AlertType.success,
        ));
    }
  }

  Future loginHotspot() async {
    var fileContents = await rootBundle.load('assets/login.html');
    File file = await writeToFile(fileContents,
        "${(await getApplicationDocumentsDirectory()).path}/login.html");
    bool upload = await FtpService.uploadFile(
        file: file, remoteName: "hotspot/login.html");
    if (!upload) {
      log("error subiendo login");
      return;
    }
  }

  Future<File> writeToFile(ByteData data, String path) {
    final buffer = data.buffer;
    return File(path).writeAsBytes(buffer.asUint8ClampedList());
  }

  Future backUp(AlertCubit alertCubit) async {
    MkProvider provider = MkProvider();

    var r = await provider.backup("backup.backup", "");
    if (r.statusCode == 200) {
      await Future.delayed(const Duration(seconds: 20));
      ProgressDialogUtils.hideProgressDialog();
    } else {
      ProgressDialogUtils.hideProgressDialog();
    alertCubit.showDialog(
        ShowDialogEvent(
          title: "ERROR",
          message: "No se pudo realizar el backup",
          type: AlertType.error,
        ),
      );
    }
  }
}

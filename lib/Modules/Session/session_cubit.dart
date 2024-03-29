import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:startickera/Data/database/databse_firebase.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import '../../Core/Values/enums.dart';
import '../../Core/utils/get_device_details.dart';
import '../../Core/utils/get_ip_mk.dart';
import '../../Core/utils/progress_dialog_utils.dart';
import '../../Data/Provider/mikrotik/mk_provider.dart';
import '../../Data/Services/ftp_service.dart';
import '../../Data/Services/navigator_service.dart';
import '../../Widgets/starlink/dialog.dart';
import '../../models/config_model.dart';
import '../Alerts/alert_cubit.dart';

part 'session_state.dart';

class SessionCubit extends HydratedCubit<SessionState> {
  SessionCubit() : super(const SessionState());

  Future checkUserData() async {
    final database = DatabaseFirebase();

    if (await database.checkUUID()) {
      var data = await database.getContact() as Map<dynamic, dynamic>?;
      emit(state.copyWith(
        active: true,
        configModel: state.cfg!.copyWith(
          contact: data?["phone"]??"",
          nameLocal: data?["name"]??""
        )
      ));
    }
  }

  Future<void> verify() async {
    ConfigModel? cfg = state.cfg;

    var deviceDetails = await getDeviceDetails();
    var uuid = deviceDetails.last?.replaceAll(".", "-") ?? "";
    cfg ??= ConfigModel();
    changeState(state.copyWith(configModel: cfg,uuid: uuid));
    User? user = FirebaseAuth.instance.currentUser;

    if(user == null){
      exitSession();
    }else{
      authListener();
      checkUserData();
    }
  }



  void loadSetting() async {
    var exist = await FtpService.checkFile(remoteName: "info.rsc");

    if (exist) {
      final Directory directory = Directory.systemTemp.createTempSync();
      File file = File("${directory.path}/info.rsc")..createSync();

      var d = await FtpService.downloadFile(file: file, remoteName: "info.rsc");

      if (d) {
        // TODO: move to provider
        var data = await file.readAsString();
        var interfaces = data.split("/");
        var wifiInterface = interfaces
            .firstWhere((element) => element.contains("interface wifi"));
        RegExp ssidRegex = RegExp(r'\.ssid=([^\s]+)');
        RegExp passphraseRegex = RegExp(r'\.passphrase=(\S+)');
        List<WifiDataModels> wDetails = wifiInterface
            .replaceAll("    ", "")
            .replaceAll("\\\r\n", "")
            .split("\n")
            .where((x) => x.contains(".ssid") || x.contains(".passphrase"))
            .map((String line) {
          String ssid = '';
          String passphrase = '';

          var ssidMatch = ssidRegex.firstMatch(line);
          var passphraseMatch = passphraseRegex.firstMatch(line);

          if (ssidMatch != null) {
            ssid = ssidMatch.group(1)!;
          }

          if (passphraseMatch != null) {
            passphrase = passphraseMatch.group(1)!;
          }
          return WifiDataModels(ssid: ssid, pass: passphrase);
        }).toList();

        if (state.cfg != null) {
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
      MkProvider provider = MkProvider(this);
      var r = await provider.exportData(file: "info.rsc");
      if (r.statusCode == 200 || r.statusCode == 201) {
        loadSetting();
      }
    }
  }

  void logOutMK(){
    emit(SessionState(sessionStatus: SessionStatus.mikrotik,firebaseID:state.firebaseID,uuid: state.uuid,ip: state.ip,wifi: state.wifi,cfg: ConfigModel()));
  }

  void exitSession()async {
    await FirebaseAuth.instance.signOut();
    emit(SessionState(sessionStatus: SessionStatus.finish,firebaseID:"",uuid: state.uuid,ip: state.ip,wifi: state.wifi,cfg: ConfigModel()));
  }

  Future<void> changeState(SessionState newState) async {
    emit(newState);
  }

  void initData() async {
    if (state.isAuthenticated /*&& state.firebaseID != ""*/) {
      MkProvider provider = MkProvider(this);
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
      try{
        ProgressDialogUtils.showProgressDialog();
        var ip = await getIp(this);
        if (ip["connect"] && state.sessionStatus == SessionStatus.mikrotik) {
          MkProvider provider = MkProvider(this);
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
        } else if (state.firebaseID != "") {
          emit(state.copyWith(
              sessionStatus: SessionStatus.finish, configModel: ConfigModel()));
        }
      }catch(e){
        //todo
      }finally{
        ProgressDialogUtils.hideProgressDialog();
      }
      // // ip["connect"] ||
      // if(cfg != null){
      //     connect(cfg);
      //   }
    }
  }

  Future<void> authListener() async {
    try {


      late StreamSubscription<User?> steam;
      late StreamSubscription<DatabaseEvent> database;
      steam =  FirebaseAuth.instance
          .authStateChanges()
          .listen((User? user) {
        if (user == null) {
          emit(state.copyWith(sessionStatus: SessionStatus.finish));
        } else {
          emit(state.copyWith(firebaseID: user.uid));
          initData();
          var ref = FirebaseDatabase.instance.ref("users/${user.uid}");
          database = ref.onValue.listen((event) async {
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
               database.cancel();
               steam.cancel();
              }
            }
          });
        }
      });
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
    MkProvider provider = MkProvider(this);

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
      alertCubit.showDialog(ShowDialogEvent(
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
    MkProvider provider = MkProvider(this);

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

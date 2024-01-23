import 'dart:io';

import 'package:StarTickera/Data/database/databse_firebase.dart';
import 'package:equatable/equatable.dart';
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
import '../../models/config_model.dart';
import '../Alerts/AlertCubit.dart';

part 'SessionState.dart';

class SessionCubit extends HydratedCubit<SessionState> {
  SessionCubit() : super(const SessionState()) {
    RestApiProvider().sessionCubit = this;
  }

  Future checkSerial() async {
    final database = DatabaseFirebase();

    if (await database.checkUUID()) {

      var phone = await database.getContact();
      var name = await database.getName();

      emit(state.copyWith(
        active: true,
        configModel: state.cfg!.copyWith(
          contact: phone,
          nameLocal: name
        )
      ));
    } else {
      await database.updateLicense("eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c");
      emit(state.copyWith(active: false));
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

    checkSerial();

    if (isAuthenticated) {
      MkProvider provider = MkProvider();
      var profilesH = await provider.allProfilesHotspot();
      if (profilesH.isNotEmpty) {
        emit(state.copyWith(
            configModel: state.cfg!.copyWith(
          dnsNamed: profilesH.last.dnsName,
        )));
      } else {
        emit(state.copyWith(
            sessionStatus: SessionStatus.finish,
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
    } else {
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
      } else {
        emit(state.copyWith(
            sessionStatus: SessionStatus.finish, configModel: ConfigModel()));
      }
      // // ip["connect"] ||
      // if(cfg != null){
      //     connect(cfg);
      //   }
    }
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
                        .replaceAll("\n", "") ??
                    "",
                pass: details
                        .firstWhere((element) => element.contains("pass"))
                        .replaceAll(".passphrase=", "")
                        .replaceAll("\n", "") ??
                    "",
              ));
            } catch (e) {
              print(e);
            }
          }
        }
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
    } else {
      MkProvider provider = MkProvider();
      var r = await provider.exportData(file: "info.rsc");
      if (r.statusCode == 200 || r.statusCode == 201) {
        loadSetting();
      }
    }
  }

  void exitSession() {
    emit(const SessionState(sessionStatus: SessionStatus.finish));
  }

  Future<void> changeState(SessionState newState) async {
    emit(newState);
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
      alertCubit.showErrorDialog("CONECTADO", "Se estableció la conexión con el mikrotik");
    } else {
      alertCubit.showInfoDialog(
        AlertInfo(
            "ERROR",
            "1. revise si el mikrotik está encendido\n"
            "2. chequee la direccion del mikrotik y que las credenciales sean correctas"),
      );
    }
  }

  Future loginHotspot() async {
    var fileContents = await rootBundle.load('assets/login.html');
    File file = await writeToFile(fileContents,
        "${(await getApplicationDocumentsDirectory()).path}/login.html");
    bool upload = await FtpService.uploadFile(
        file: file, remoteName: "hotspot/login.html");
    if (!upload) {
      print("error subiendo login");
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
      await Future.delayed(Duration(seconds: 20));
      ProgressDialogUtils.hideProgressDialog();
    } else {
      ProgressDialogUtils.hideProgressDialog();
      alertCubit.showInfoDialog(
        AlertInfo("error", r.body),
      );
    }
  }
}

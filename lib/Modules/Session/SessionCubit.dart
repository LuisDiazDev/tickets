import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:tickets/Data/Services/printer_service.dart';
import 'package:tickets/Data/Provider/TicketProvider.dart';
import 'package:tickets/models/config_model.dart';

import '../../Core/Values/Enums.dart';
import '../../Core/utils/progress_dialog_utils.dart';
import '../../Data/Provider/restApiProvider.dart';
import '../../Data/Services/ftp_service.dart';
import '../Alerts/AlertCubit.dart';

part 'SessionState.dart';

class SessionCubit extends HydratedCubit<SessionState> {
  SessionCubit() : super(const SessionState()) {
    RestApiProvider().sessionCubit = this;
  }

  Future<void> verify() async {
    ConfigModel? cfg = state.cfg;

    PrinterService().init(configModel: cfg);
    await Future.delayed(Duration(seconds: 3));
    if (state.isAuthenticated!) {

      TicketProvider provider = TicketProvider();
      var profilesH =await provider.allProfilesHotspot();
      if(profilesH.isNotEmpty){
        emit(state.copyWith(
            configModel: state.cfg!.copyWith(
                dnsNamed: profilesH.last.dnsName
            )
        ));
      }

      FtpService.initService(
          address: state.cfg?.host ?? "",
          user: state.cfg?.user ?? "",
          pass: state.cfg?.password ?? ""
      );

      emit(state.copyWith(
          sessionStatus: SessionStatus.started,
          configModel: cfg ?? ConfigModel()));
    } else {
      emit(state.copyWith(
          sessionStatus: SessionStatus.finish,
          configModel: ConfigModel()));
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

  Future checkConnection(AlertCubit alertCubit) async{
    ProgressDialogUtils.showProgressDialog();
    TicketProvider provider = TicketProvider();

    var r =await provider.allProfilesHotspot();
    ProgressDialogUtils.hideProgressDialog();
    if(r.isNotEmpty){
        alertCubit.showDialog("Conectado", "se extablecio la conexion");
    }else{
      alertCubit.showAlertInfo(title: "Ah ocurrido un error",subtitle: ""
          "1. revise que el mikrotik este encendido"
          "2. chequee la direccion del mikrotik y sus credemnciales sean correctas");
    }

  }

  Future backUp(AlertCubit alertCubit) async{

    TicketProvider provider = TicketProvider();

    var r = await provider.backup("backup.backup", "");
    if(r.statusCode == 200){
      await Future.delayed(Duration(seconds: 20));
      ProgressDialogUtils.hideProgressDialog();
    }else{
      ProgressDialogUtils.hideProgressDialog();
      alertCubit.showAlertInfo(title: "error", subtitle:r.body);
    }

  }
}

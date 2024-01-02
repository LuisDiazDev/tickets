import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import '../../Core/Values/Enums.dart';
import '../../Core/utils/get_ip_mk.dart';
import '../../Core/utils/progress_dialog_utils.dart';
import '../../Data/Provider/TicketProvider.dart';
import '../../Data/Provider/restApiProvider.dart';
import '../../Data/Services/ftp_service.dart';
import '../../Data/Services/printer_service.dart';
import '../../models/config_model.dart';
import '../Alerts/AlertCubit.dart';

part 'SessionState.dart';

class SessionCubit extends HydratedCubit<SessionState> {
  SessionCubit() : super(const SessionState()) {
    RestApiProvider().sessionCubit = this;
  }

  Future<void> verify() async {
    ConfigModel? cfg = state.cfg;

    var ip = await getIp();

    if (ip["connect"] || state.isAuthenticated!) {
      if(cfg != null){
        connect(cfg);
      }
      cfg ??= ConfigModel();


      cfg = cfg.copyWith(
          host: ip["ip"],
          user: ip["connect"] ? "admin":null,
          password: ip["connect"] ? "1234":null
      );

      emit(state.copyWith(
          sessionStatus: SessionStatus.started,
          configModel: cfg));

      TicketProvider provider = TicketProvider();
      var profilesH =await provider.allProfilesHotspot();
      if(profilesH.isNotEmpty){
        emit(state.copyWith(
            sessionStatus: SessionStatus.started,
            configModel: cfg.copyWith(
              dnsNamed: profilesH.last.dnsName,)));
      }

      FtpService.initService(
          address: state.cfg?.host ?? "",
          user: ip["connect"] ? "admin":state.cfg?.user ?? "",
          pass: ip["connect"] ? "1234":state.cfg?.password ?? ""
      );

      emit(state.copyWith(
          sessionStatus: SessionStatus.started));
    } else {
      emit(state.copyWith(
          sessionStatus: SessionStatus.finish,
          configModel: ConfigModel()));
    }

  }

  void connect( ConfigModel? cfg ){
    PrinterService().tryConnect(configModel: cfg);
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
        alertCubit.showDialog("Conectado", "se estableció la conexión");
    }else{
      alertCubit.showAlertInfo(title: "Ah ocurrido un error",subtitle: ""
          "1. revise que el mikrotik este encendido"
          "2. chequee la direccion del mikrotik y que las credenciales sean correctas");
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

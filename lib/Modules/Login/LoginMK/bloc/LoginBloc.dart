import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import '../../../../Core/Values/Enums.dart';
import '../../../../Core/utils/TextsInputs.dart';
import '../../../../Core/utils/progress_dialog_utils.dart';
import '../../../../Data/Provider/MkProvider.dart';
import '../../../../Data/Services/ftp_service.dart';
import '../../../../models/config_model.dart';
import '../../../../models/dhcp_server_model.dart';
import '../../../Alerts/AlertCubit.dart';
import '../../../Session/SessionCubit.dart';
import 'LoginState.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'LoginEvents.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AlertCubit alertCubit;
  final SessionCubit sessionCubit;

  LoginBloc(this.alertCubit,this.sessionCubit) : super(const LoginState()){
    on<ChangeUser>(
          (event, emit) {
        final newUser = TextInput.dirty(value: event.user);
        emit(
          state.copyWith(
            user: newUser,
          ),
        );
      },
    );
    on<ChangePassword>(
          (event, emit) {
        final newPassword = TextInput.dirty(value: event.password);
        emit(
          state.copyWith(
            password: newPassword,
          ),
        );
      },
    );
    on<ChangeHost>(
          (event, emit) {
        final newHost = IpInput.dirty(value: event.host);
        emit(
          state.copyWith(
            host: newHost,
          ),
        );
      },
    );
    on<ChangeInitialHost>(
          (event, emit) {
        final newHost = IpInput.dirty(value: event.host);
        if(newHost.value == "..."){
          alertCubit.showDialog(
            ShowDialogEvent(
              title: "ERROR",
              message: "Ingrese una dirección IP válida",
              type: AlertType.error,
            ),
          );
        }else{
          emit(
            state.copyWith(
              initialHost: event.host,
              host: newHost
            ),
          );
        }

      },
    );
    on<LogIn>(
          (event, emit) async {

        emit(state.copyWith(
          isLoading: true,
        ));


        try {
          ProgressDialogUtils.showProgressDialog();
          MkProvider provider = MkProvider();
          var host = event.host == "" ? "192.168.20.5" : event.host;
          var r = await provider.allDhcpServer(
            user: event.user,
            pass: event.password,
            host: host
          );

          emit(state.copyWith(
            isLoading: false,
          ));
          ProgressDialogUtils.hideProgressDialog();
          if(r is !bool){
            r as List;
            DhcpServerModel dhcpServer = (r.first) ?? DhcpServerModel();

            ConfigModel? cfg = sessionCubit.state.cfg;
            cfg ??= ConfigModel();

            sessionCubit.changeState(sessionCubit.state.copyWith(
                isAuthenticated: true,
                sessionStatus: SessionStatus.started,
                state: "logged",
                configModel: cfg.copyWith(
                    host: host,
                    user: event.user,
                    password: event.password,
                    dhcp:dhcpServer.name,
                )
              // sessionStatus: SessionStatus.started,
            ));

            FtpService.initService(
                address: host,
                user: event.user,
                pass: event.password
            );

            var r2 = await provider.allProfilesHotspot();
            sessionCubit.changeState(sessionCubit.state.copyWith(
                configModel: sessionCubit.state.cfg!.copyWith(
                    dnsNamed: r2.length > 1 ? r2.last.dnsName : "wifi.com"
                )
              // sessionStatus: SessionStatus.started,
            ));

            sessionCubit.loadSetting();

            emit(const LoginState());
          }else{
            alertCubit.showDialog(
              ShowDialogEvent(
                title: "DATOS INCORRECTOS",
                message: "Verifique los datos ingresados",
                type: AlertType.error,
              ),
            );
          }
        } catch (e) {
          alertCubit.showDialog(
            ShowDialogEvent(
              title: "DATOS INCORRECTOS",
              message: "Verifique los datos ingresados",
              type: AlertType.error,
            ),
          );
        }finally{
          emit(state.copyWith(
            isLoading: false,
          ));
        }
      },
    );
  }

}

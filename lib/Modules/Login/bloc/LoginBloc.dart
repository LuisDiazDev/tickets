import '../../../../Core/Values/Enums.dart';
import '../../../../Core/utils/TextsInputs.dart';
import '../../../Core/utils/progress_dialog_utils.dart';
import '../../../Data/Provider/TicketProvider.dart';
import '../../../Data/Services/ftp_service.dart';
import '../../../models/dhcp_server_model.dart';
import '../../Alerts/AlertCubit.dart';
import '../../Session/SessionCubit.dart';
import 'LoginState.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'LoginEvents.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AlertCubit alertCubit;
  final SessionCubit sessionCubit;

  LoginBloc(this.alertCubit,this.sessionCubit) : super(const LoginState()){
    on<ChangeEmail>(
          (event, emit) {
        final newEmail = EmailInput.dirty(value: event.email);
        emit(
          state.copyWith(
            email: newEmail,
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
        final newHost = TextInput.dirty(value: event.host);
        emit(
          state.copyWith(
            host: newHost,
          ),
        );
      },
    );
    on<ChangeInitialHost>(
          (event, emit) {
        final newHost = TextInput.dirty(value: event.host);
        if(newHost.value == "..."){
          alertCubit.showAlertInfo(
            title: "Error",
            subtitle: "No se ha reconocido el mikrotik",
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
          TicketProvider provider = TicketProvider();
          var host = event.host == "" ? "192.168.20.5" : event.host;
          var r = await provider.allDhcpServer(
            user: event.email,
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
            var r2 = await provider.allProfilesHotspot();
            sessionCubit.changeState(sessionCubit.state.copyWith(
              isAuthenticated: true,
              sessionStatus: SessionStatus.started,
              state: "logged",
              configModel: sessionCubit.state.cfg!.copyWith(
                host: host,
                user: event.email,
                password: event.password,
                dhcp:dhcpServer.name,
                dnsNamed: r2.length > 1 ? r2.last.dnsName : "wifi.com"
              )
              // sessionStatus: SessionStatus.started,
            ));

            FtpService.initService(
              address: event.host,
              user: event.email,
              pass: event.password
            );

            emit(const LoginState());
          }else{
            alertCubit.showAlertInfo(
              title: "Error",
              subtitle: "Datos incorrectos",
            );
          }
        } catch (e) {
          alertCubit.showAlertInfo(
            title: "Error",
            subtitle: "Datos incorrectos",
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

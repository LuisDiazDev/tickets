import '../../../../Core/Values/Enums.dart';
import '../../../../Core/utils/TextsInputs.dart';
import '../../../Core/utils/progress_dialog_utils.dart';
import '../../../Data/Provider/TicketProvider.dart';
import '../../../Data/Services/ftp_service.dart';
import '../../../models/dchcp_server_model.dart';
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
    on<LogIn>(
          (event, emit) async {

        emit(state.copyWith(
          isLoading: true,
        ));


        try {
          ProgressDialogUtils.showProgressDialog();
          TicketProvider provider = TicketProvider();
          var r = await provider.allDchcpServer(
            user: event.email,
            pass: event.password,
            host: event.host
          );

          emit(state.copyWith(
            isLoading: false,
          ));
          ProgressDialogUtils.hideProgressDialog();
          if(r is !bool){
            r as List;
            DchcpServerModel dchcpServer = (r.first) ?? DchcpServerModel();
            sessionCubit.changeState(sessionCubit.state.copyWith(
              isAuthenticated: true,
              sessionStatus: SessionStatus.started,
              state: "logged",
              configModel: sessionCubit.state.cfg!.copyWith(
                host: event.host,
                user: event.email,
                password: event.password,
                dchcp:dchcpServer.name
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
              title: "Verification Failed",
              subtitle: "Invalid credentials",
            );
          }
        } catch (e) {
          alertCubit.showAlertInfo(
            title: "Verification Failed",
            subtitle: "Invalid credentials",
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

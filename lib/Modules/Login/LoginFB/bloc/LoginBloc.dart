import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import '../../../../Core/Values/Enums.dart';
import '../../../../Core/utils/TextsInputs.dart';
import '../../../../Core/utils/progress_dialog_utils.dart';
import '../../../Alerts/AlertCubit.dart';
import '../../../Session/SessionCubit.dart';
import 'LoginState.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'LoginEvents.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AlertCubit alertCubit;
  final SessionCubit sessionCubit;

  LoginBloc(this.alertCubit, this.sessionCubit) : super(const LoginState()) {
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

    on<LogIn>(
      (event, emit) async {
        emit(state.copyWith(
          isLoading: true,
        ));

        try {
          ProgressDialogUtils.showProgressDialog();

          emit(state.copyWith(
            isLoading: false,
          ));
          final credential =
              await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: event.user,
            password: event.password,
          );

          // Get current device id and saved it to database
          final ref =
              FirebaseDatabase.instance.ref("users/${credential.user!.uid}");
          ref.set({"id": sessionCubit.state.uuid});

          // ignore: use_build_context_synchronously
          sessionCubit.changeState(sessionCubit.state.copyWith(
              firebaseID: credential.user!.uid,
              sessionStatus: SessionStatus.mikrotik));
        } on FirebaseAuthException catch (e) {
          if (e.code == 'user-not-found') {
            alertCubit.showDialog(ShowDialogEvent(
              title: "ERROR AL INICIAR SESIÓN",
              message: "No se ha encontrado el usuario ingresado",
              type: AlertType.error,
            ));
          } else if (e.code == 'wrong-password' || e.code == 'invalid-credential') {
            alertCubit.showDialog(
              ShowDialogEvent(
                title: "ERROR AL INICIAR SESIÓN",
                message: "Contraseña incorrecta",
                type: AlertType.error,
              ),
            );
          }
        } catch (e) {
          alertCubit.showDialog(
            ShowDialogEvent(
              title: "ERROR AL INICIAR SESIÓN",
              message: "Ocurrió un error al iniciar sesión",
              type: AlertType.error,
            ),
          );
        } finally {
          ProgressDialogUtils.hideProgressDialog();
          emit(state.copyWith(
            isLoading: false,
          ));
        }
      },
    );
  }
}

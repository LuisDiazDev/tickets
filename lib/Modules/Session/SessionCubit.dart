import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:tickets/models/config_model.dart';

import '../../Core/Values/Enums.dart';
import '../../Data/Provider/restApiProvider.dart';

part 'SessionState.dart';

class SessionCubit extends HydratedCubit<SessionState> {
  SessionCubit() : super(const SessionState()) {
    RestApiProvider().sessionCubit = this;
  }

  Future<void> verifyUser() async {
    if (state.isAuthenticated!) {
      emit(state.copyWith(sessionStatus: SessionStatus.started));
    } else {
      emit(state.copyWith(
        sessionStatus: SessionStatus.finish,
      ));
    }
  }

  void setAccessToken(String accessToken) {
    emit(state.copyWith(
      accessToken: accessToken,
    ));
  }

  void setRefreshToken(String refreshToken) {
    emit(state.copyWith(refreshToken: refreshToken));
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
}

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Data/Provider/mikrotik/mk_provider.dart';
import '../../Alerts/alert_cubit.dart';
import 'profile_events.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final AlertCubit alertCubit;
  final MkProvider provider;

  ProfileBloc(this.alertCubit, {required this.provider})
      : super(const ProfileState()) {

    on<FetchData>(
      (FetchData event, Emitter<ProfileState> emit) async {
        emit(state.copyWith(load: true));
        var data = await provider.allProfiles();
        emit(state.copyWith(load: false, profiles: data));
      },
    );

    on<NewProfile>(
      (NewProfile event, Emitter<ProfileState> emit) async {
        emit(state.copyWith(load: true));
        var r = await provider.newProfile(event.newProfile, event.duration);
        if (r.statusCode == 200 || r.statusCode == 201) {
          var data = await provider.allProfiles();
          emit(state.copyWith(load: false, profiles: data));
          alertCubit.showDialog(
            ShowDialogEvent(
              title: "ÉXITO",
              message: "Se ha creado un nuevo plan",
              type: AlertType.success,
            ),
          );
        } else {
          alertCubit.showDialog(
            ShowDialogEvent(
              title: "ERROR",
              message: "Ha ocurrido un error inesperado registrando el plan",
              type: AlertType.error,
            ),
          );
          emit(state.copyWith(load: false));
        }
      },
    );

    on<UpdateProfile>(
      (UpdateProfile event, Emitter<ProfileState> emit) async {
        emit(state.copyWith(load: true));

        var r = await provider.updateProfile(event.updateProfile);

        if (r.statusCode == 200 || r.statusCode == 201) {
          var data = await provider.allProfiles();
          emit(state.copyWith(load: false, profiles: data));
          alertCubit.showDialog(
            ShowDialogEvent(
              title: "ÉXITO",
              message: "Se ha actualizado un plan",
              type: AlertType.success,
            ),
          );
        } else {
          emit(state.copyWith(load: false));
          alertCubit.showDialog(
            ShowDialogEvent(
              title: "ERROR",
              message: "Ha ocurrido un error inesperado actualizando el plan",
              type: AlertType.error,
            ),
          );
        }
      },
    );

    on<DeletedProfile>(
      (event, emit) async {
        emit(state.copyWith(load: true));

        var r = await provider.removeProfile(event.id);
        if (r.statusCode <= 205) {
          add(FetchData());
          alertCubit.showDialog(
            ShowDialogEvent(
              title: "PLAN ELIMINADO",
              message: "Se ha eliminado un plan",
              type: AlertType.success,
            ),
          );
        } else {
          alertCubit.showDialog(
            ShowDialogEvent(
              title: "ERROR ELIMINANDO PLAN",
              message:
                  "Ha ocurrido un error inesperado eliminando el plan: ${r.body}",
              type: AlertType.error,
            ),
          );
        }
      },
    );
  }

  init() {
    add(FetchData());
  }
}

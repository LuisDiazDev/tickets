import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Data/Provider/MkProvider.dart';
import '../../Alerts/AlertCubit.dart';
import 'ProfileEvents.dart';
import 'ProfileState.dart';

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
          alertCubit.showInfoDialog(
            AlertInfo(
              "ÉXITO",
              "Se ha registrado un nuevo plan",
            ),
          );
        } else {
          alertCubit.showInfoDialog(
            AlertInfo(
              "ERROR AL REGISTRAR UN NUEVO PLAN",
              "Ha ocurrido un error al registrar un nuevo plan: ${r.body}"
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
          alertCubit.showInfoDialog(
            AlertInfo(
              "ÉXITO",
              "Se ha actualizado un plan",
            ),
          );
        } else {
          emit(state.copyWith(load: false));
          alertCubit.showErrorDialog("ERROR", r.body);
        }
      },
    );

    on<DeletedProfile>(
      (event, emit) async {
        emit(state.copyWith(load: true));

        var r = await provider.removeProfile(event.deletedProfile.id!);
        if (r.statusCode <= 205) {
          add(FetchData());
          alertCubit.showErrorDialog("", "Se ha eliminado un plan");
        } else {
          alertCubit.showErrorDialog("error", r.body);
        }
      },
    );
  }

  init() {
    add(FetchData());
  }
}

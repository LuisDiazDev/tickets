
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Data/Provider/TicketProvider.dart';
import '../../Alerts/AlertCubit.dart';
import 'ProfileEvents.dart';
import 'ProfileState.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final AlertCubit alertCubit;
  final TicketProvider provider;

  ProfileBloc(this.alertCubit,{required this.provider}) : super(const ProfileState()){
    on<FetchData>(
          (event, emit) async {
            emit(state.copyWith(load: true));
            var data = await provider.allProfiles();
            emit(state.copyWith(load: false,profiles: data));
      },
    );
  }

  init(){
   add(FetchData());
  }
}

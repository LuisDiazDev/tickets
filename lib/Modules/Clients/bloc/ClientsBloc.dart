import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Data/Provider/MkProvider.dart';
import '../../Alerts/AlertCubit.dart';
import 'ClientsEvents.dart';
import 'ClientState.dart';

class ClientsBloc extends Bloc<ClientsEvent, ClientsState> {
  final AlertCubit alertCubit;
  final MkProvider provider;

  ClientsBloc(this.alertCubit, {required this.provider})
      : super(const ClientsState()) {
    on<FetchData>(
      (event, emit) async {
        emit(state.copyWith(load: event.load));

        var data = (await provider.allTickets())..sort((a,b)=>b.id!.compareTo(a.id!));//todo: only users whit client plans
        var profiles = await provider.allProfiles();//todo: only users client plans
        emit(state.copyWith(load: false, clients: data, profiles: profiles));
      },
    );

    on<GenerateClient>(
      (event, emit) async {



        // TODO: evaluar si esto es necesario
        var data = await provider.allTickets();
        emit(state.copyWith(load: false, clients: data));
      },
    );


    on<DeletedClient>((event,emit)async{
      var r = await provider.removeTicket(event.id);
      if(r.statusCode <= 205 ){
        add(FetchData(load: false));
        alertCubit.showDialog("", "Se ha eliminado un cliente");
      } else{
        add(FetchData(load: false));
        alertCubit.showDialog("error", r.body);
      }

    });
  }

  init() {
    add(FetchData());
  }
}

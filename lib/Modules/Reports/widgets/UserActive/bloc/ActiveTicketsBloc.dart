import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../Data/Provider/MkProvider.dart';
import 'ActiveTicketsEvent.dart';
import 'ActiveTicketsState.dart';

class ActiveTicketsBloc extends Bloc<ActiveTicketsEvent, ActiveTicketState> {
  final MkProvider provider;

  ActiveTicketsBloc({required this.provider})
      : super(const ActiveTicketState()) {
    on<FetchData>(
      (event, emit) async {
        emit(state.copyWith(load: event.load));
        // Hacer en paralelo
        var data = (await provider.allActiveTickets())..sort((a,b)=>b.id!.compareTo(a.id!));
        var profiles = await provider.allProfiles();
        emit(state.copyWith(load: false, ticketsA: data, ));
      },
    );

    on<DisconecTicket>((event,emit)async{
      var r = await provider.disconnectTicket(event.id);
      if(r.statusCode <= 205 ){
        add(FetchData(load: false));
      } else{
        add(FetchData(load: false));
      }
    });
  }

  init() {
    add(FetchData());
  }
}

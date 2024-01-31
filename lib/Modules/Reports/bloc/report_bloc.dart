import 'dart:convert';
import 'package:startickera/Data/database/databse_firebase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Data/Provider/mk_provider.dart';
import '../../Alerts/alert_cubit.dart';
import 'report_events.dart';
import 'report_state.dart';

class ReportBloc extends Bloc<ReportEvent, ReportState> {
  final AlertCubit alertCubit;
  final MkProvider provider;

  ReportBloc(this.alertCubit, {required this.provider})
      : super(const ReportState()) {
    on<FetchData>(
          (event, emit) async {
        emit(state.copyWith(load: event.load));

        var profiles = await provider.allProfiles();

        DateTime now = DateTime.now();
        List tod = [];

        var sellers = await DatabaseFirebase().getSellers();

        for (var t in sellers) {
          var data = jsonDecode(t);

          DateTime tDate = DateTime.parse(data["date_seller"]);
          if (tDate.day == now.day &&
              tDate.year == now.year &&
              tDate.month == now.month) {
            tod.add(t);
          }
        }

        emit(state.copyWith(load: false, sellers: tod, profiles: profiles));
      },
    );

  }

  getTotal() {
    double total = 0;
    for (var t in state.sellers) {
      var data = jsonDecode(t);
      total += double.tryParse(data["price"]) ?? 0;
    }
    return total;
  }

  init() {
    add(FetchData());
  }
}

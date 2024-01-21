import 'dart:convert';
import 'dart:io';

import 'package:StarTickera/Data/database/databse_firebase.dart';
import 'package:StarTickera/models/profile_model.dart';
import 'package:StarTickera/models/ticket_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import '../../../Core/utils/rand.dart';
import '../../../Data/Provider/MkProvider.dart';
import '../../Alerts/AlertCubit.dart';
import 'ReportEvents.dart';
import 'ReportState.dart';

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

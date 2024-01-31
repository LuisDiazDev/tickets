import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
part 'alert_state.dart';



class AlertCubit extends Cubit<AlertState> {
  AlertCubit() : super(AlertInitial());

  void showDialog(ShowDialogEvent event) {
    emit(event);
  }
}

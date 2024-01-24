import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

part 'AlertState.dart';



class AlertCubit extends Cubit<AlertState> {
  AlertCubit() : super(AlertInitial());

  void showDialog(ShowDialogEvent event) {
    emit(event);
  }
}

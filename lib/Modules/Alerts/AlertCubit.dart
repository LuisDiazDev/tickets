import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'AlertState.dart';



class AlertCubit extends Cubit<AlertState> {
  AlertCubit() : super(AlertInitial());

  void showAlertAction(String message, Function onTap) {
    emit(AlertAction(
      message,
      onTap,
    ));
  }

  void showErrorDialog(String title, String message,
      {Function? onTap, String? titleAction}) {
    emit(ErrorDialogEvent(
      title,
      message,
      onTap,
      titleAction,
    ));
  }

  void showInfoDialog(AlertInfo alertInfo) {
    emit(alertInfo);
  }
}

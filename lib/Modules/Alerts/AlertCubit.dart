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

  void showDialog(String title, String message) {
    emit(AlertDialog(
      title,
      message,
    ));

  }

  void showAlertInfo({required String title,required String subtitle}) {
    emit(AlertInfo(
      title,
      subtitle,
    ));
  }
}

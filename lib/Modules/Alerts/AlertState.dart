part of 'AlertCubit.dart';

@immutable
abstract class AlertState {}

class AlertInitial extends AlertState {}

class AlertAction extends AlertState {
  final String message;
  final Function onTap;

  AlertAction(this.message, this.onTap);
}

class AlertInfo extends AlertState {
  final String title;
  final String subtitle;

  AlertInfo(this.title, this.subtitle);
}


class ErrorDialogEvent extends AlertState {
  final String title;
  final String message;
  final Function? onTap;
  final String? titleAction;
  ErrorDialogEvent(this.title, this.message, this.onTap, this.titleAction);
}
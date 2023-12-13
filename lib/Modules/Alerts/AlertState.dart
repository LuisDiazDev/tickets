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


class AlertDialogEvent extends AlertState {
  final String title;
  final String message;

  AlertDialogEvent(this.title, this.message);
}

abstract class LoginEvent {}

class SendLogin extends LoginEvent {}

class LogIn extends LoginEvent {
  final String user;
  final String password;
  LogIn(this.user, this.password);
}

class ChangeUser extends LoginEvent {
  final String user;
  ChangeUser(this.user);
}

class ChangePassword extends LoginEvent {
  final String password;
  ChangePassword(this.password);
}

class ChangeHost extends LoginEvent {
  final String host;
  ChangeHost(this.host);
}

class ChangeInitialHost extends LoginEvent {
  final String host;
  ChangeInitialHost(this.host);
}

class ClearLogin extends LoginEvent {}
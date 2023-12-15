
abstract class LoginEvent {}

class SendLogin extends LoginEvent {}

class LogIn extends LoginEvent {
  final String email;
  final String password;
  final String host;
  LogIn(this.email, this.host, this.password);
}

class ChangeEmail extends LoginEvent {
  final String email;
  ChangeEmail(this.email);
}

class ChangePassword extends LoginEvent {
  final String password;
  ChangePassword(this.password);
}

class ChangeHost extends LoginEvent {
  final String host;
  ChangeHost(this.host);
}


class ClearLogin extends LoginEvent {}
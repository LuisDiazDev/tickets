
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



class ClearLogin extends LoginEvent {}
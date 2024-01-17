import 'package:equatable/equatable.dart';
import '../../../../Core/utils/TextsInputs.dart';

class LoginState extends Equatable {

  final TextInput user;
  final IpInput host;
  final TextInput password;
  final String? messageSuccessSignup;
  final bool? isLoading;
  final String initialHost;
  final String initialUser;

  const LoginState({
    this.user = const TextInput.dirty(value: "admin"),
    this.password = const TextInput.pure(),
    this.messageSuccessSignup = '',
    this.isLoading = false,
    this.initialHost = "192.168.20.5",
    this.initialUser = "admin",
    this.host = const IpInput.dirty(value: "192.168.20.5"),
  });


  LoginState copyWith({
    TextInput? user,
    TextInput? password,
    String? messageSuccessSignup,
    bool? isLoading,
    String? initialHost,
    IpInput? host,
  }) {
    return LoginState(
      user: user ?? this.user,
      host: host ?? this.host,
      initialHost: initialHost ?? this.initialHost,
      password: password ?? this.password,
      isLoading: isLoading ?? this.isLoading,
      messageSuccessSignup: messageSuccessSignup ?? this.messageSuccessSignup,
    );
  }

  @override
  List<Object?> get props => [
    user,
    password,
    messageSuccessSignup,
    isLoading,
    host,
    initialHost
  ];
}
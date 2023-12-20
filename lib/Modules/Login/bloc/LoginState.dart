import 'package:equatable/equatable.dart';
import '../../../../Core/utils/TextsInputs.dart';

class LoginState extends Equatable {

  final EmailInput email;
  final TextInput host;
  final TextInput password;
  final String? messageSuccessSignup;
  final bool? isLoading;
  final String initialHost;

  const LoginState({
    this.email = const EmailInput.pure(),
    this.password = const TextInput.pure(),
    this.messageSuccessSignup = '',
    this.isLoading = false,
    this.initialHost = "192.168.20.5",
    this.host = const TextInput.pure(),
  });


  LoginState copyWith({
    EmailInput? email,
    TextInput? password,
    String? messageSuccessSignup,
    bool? isLoading,
    String? initialHost,
    TextInput? host,
  }) {
    return LoginState(
      email: email ?? this.email,
      host: host ?? this.host,
      initialHost: initialHost ?? this.initialHost,
      password: password ?? this.password,
      isLoading: isLoading ?? this.isLoading,
      messageSuccessSignup: messageSuccessSignup ?? this.messageSuccessSignup,
    );
  }

  @override
  List<Object?> get props => [
    email,
    password,
    messageSuccessSignup,
    isLoading,
    host,
    initialHost
  ];
}
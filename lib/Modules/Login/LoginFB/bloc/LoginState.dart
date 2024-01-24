import 'package:equatable/equatable.dart';
import '../../../../Core/utils/TextsInputs.dart';

class LoginState extends Equatable {

  final TextInput user;
  final TextInput password;
  final bool? isLoading;

  const LoginState({
    this.user = const TextInput.pure(),
    this.password = const TextInput.pure(),
    this.isLoading = false,
  });


  LoginState copyWith({
    TextInput? user,
    TextInput? password,
    bool? isLoading,
  }) {
    return LoginState(
      user: user ?? this.user,
      password: password ?? this.password,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [
    user,
    password,
    isLoading,
  ];
}
import 'package:formz/formz.dart';

// Define input validation errors
enum TextInputError { empty }

class TextInput extends FormzInput<String, TextInputError> {
  const TextInput.pure() : super.pure('');

  const TextInput.dirty({String value = ''}) : super.dirty(value);

  @override
  TextInputError? validator(String value) {
    return value.isNotEmpty ? null : TextInputError.empty;
  }
}

class EmailInput extends FormzInput<String, TextInputError>{
  const EmailInput.pure() : super.pure('');

  const EmailInput.dirty({String value = ''}) : super.dirty(value);

  @override
  TextInputError? validator(String value) {
    return RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(value)
        ? null
        : TextInputError.empty;
  }
}

class MobileInput extends FormzInput<String, TextInputError>{
  const MobileInput.pure() : super.pure('');

  const MobileInput.dirty({String value = ''}) : super.dirty(value);

  @override
  TextInputError? validator(String value) {
    return RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)')
        .hasMatch(value)
        ? null
        : TextInputError.empty;
  }
}
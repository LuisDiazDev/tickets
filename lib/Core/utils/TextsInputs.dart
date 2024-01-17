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

class MobileInput extends FormzInput<String, TextInputError> {
  const MobileInput.pure() : super.pure('');

  const MobileInput.dirty({String value = ''}) : super.dirty(value);

  @override
  TextInputError? validator(String value) {
    return RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)').hasMatch(value)
        ? null
        : TextInputError.empty;
  }
}

class IpInput extends FormzInput<String, TextInputError> {
  const IpInput.pure() : super.pure('');

  const IpInput.dirty({String value = ''}) : super.dirty(value);

  @override
  TextInputError? validator(String value) {
    if (value == "") {
      return TextInputError.empty;
    }
    if (value.length < 7) {
      return TextInputError.empty;
    }
    var sp = value.split(".");
    if (sp.length != 4) {
      return TextInputError.empty;
    }
    for (var i = 0; i < sp.length; i++) {
      var octeto = sp[i];
      if (octeto == "") {
        return TextInputError.empty;
      }
      if (int.tryParse(octeto) == null) {
        return TextInputError.empty;
      }
      if (int.parse(octeto) > 255) {
        return TextInputError.empty;
      }
    }
    return null;
  }
}



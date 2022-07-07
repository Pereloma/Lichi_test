import 'package:formz/formz.dart';

enum BodyValidationError { empty }

class BodyValidator extends FormzInput<String, BodyValidationError> {
  const BodyValidator.pure() : super.pure('');
  const BodyValidator.dirty([String value = '']) : super.dirty(value);

  @override
  BodyValidationError? validator(String? value) {
    return value?.isNotEmpty == true ? null : BodyValidationError.empty;
  }
}
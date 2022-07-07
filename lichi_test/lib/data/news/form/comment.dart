import 'package:formz/formz.dart';

enum CommentValidationError { empty }

class CommentValidator extends FormzInput<String, CommentValidationError> {
  const CommentValidator.pure() : super.pure('');
  const CommentValidator.dirty([String value = '']) : super.dirty(value);

  @override
  CommentValidationError? validator(String? value) {
    return value?.isNotEmpty == true ? null : CommentValidationError.empty;
  }
}
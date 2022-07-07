part of 'login_bloc.dart';

@immutable
abstract class LoginState {}

class Authorized extends LoginState {
  final String token;
  final UserModel user;

  Authorized(this.token, this.user);
}

class NotAuthorized extends LoginState {
  final FormzStatus status;
  final Username username;
  final Password password;

  NotAuthorized({
    this.status = FormzStatus.pure,
    this.username = const Username.pure(),
    this.password = const Password.pure(),
  });

  NotAuthorized copyWith(
      {FormzStatus? status, Username? username, Password? password}) {
    return NotAuthorized(
      status: status?? this.status,
      username: username?? this.username,
      password: password?? this.password,

    );
  }

}
class LoadingState extends LoginState {
  LoadingState();
}

part of 'login_bloc.dart';

@immutable
abstract class LoginEvent {}

class LoginUsernameChanged extends LoginEvent {
  LoginUsernameChanged(this.username);

  final String username;

}

class LoginPasswordChanged extends LoginEvent {
  LoginPasswordChanged(this.password);

  final String password;
}

class LoginSubmitted extends LoginEvent {
  LoginSubmitted();
}

class GetState extends LoginEvent {
  GetState();
}

class LogOut extends LoginEvent {
  LogOut();
}
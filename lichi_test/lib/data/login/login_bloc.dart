import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:formz/formz.dart';
import 'package:meta/meta.dart';

import '../../domain/model/user.dart';
import '../../domain/repository/login.dart';
import 'form/password.dart';
import 'form/username.dart';

part 'login_event.dart';

part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginRepository loginRepository;

  LoginBloc(this.loginRepository) : super(LoadingState()) {
    on<LoginUsernameChanged>(
            (event, emit) => _onLoginUsernameChanged(event, emit));
    on<LoginPasswordChanged>(
            (event, emit) => _onLoginPasswordChanged(event, emit));
    on<LoginSubmitted>(
            (event, emit) => _onLoginSubmitted(event, emit));
    on<GetState>(
            (event, emit) => _onGetState(event, emit));
    on<LogOut>(
            (event, emit) => _onLogOut(event, emit));

    add(GetState());
  }

  _onLoginUsernameChanged(LoginUsernameChanged event,
      Emitter<LoginState> emit) {
    NotAuthorized notAuthorizedState = state as NotAuthorized;
    final username = Username.dirty(event.username);
    emit(notAuthorizedState.copyWith(
      username: username,
      status: Formz.validate([notAuthorizedState.password, username]),
    ));
  }

  _onLoginPasswordChanged(LoginPasswordChanged event,
      Emitter<LoginState> emit) {
    NotAuthorized notAuthorizedState = state as NotAuthorized;
    final password = Password.dirty(event.password);
    emit(notAuthorizedState.copyWith(
      password: password,
      status: Formz.validate([notAuthorizedState.username, password]),
    ));
  }

  _onLoginSubmitted(LoginSubmitted event, Emitter<LoginState> emit) async {
    NotAuthorized notAuthorizedState = state as NotAuthorized;
    String? token = await loginRepository.login(
        notAuthorizedState.username.value, notAuthorizedState.password.value);
    UserModel? user = await loginRepository.getLoginUser();

    token != null && user != null?
      emit(Authorized(token,user)):
      emit(NotAuthorized());
  }
  _onGetState(GetState event, Emitter<LoginState> emit) async {
    String? token = await loginRepository.getToken();
    UserModel? user = await loginRepository.getLoginUser();
    token != null && user != null?
        emit(Authorized(token,user)):
        emit(NotAuthorized());
  }
  _onLogOut(LogOut event, Emitter<LoginState> emit) async {
    loginRepository.logOut();
    emit(NotAuthorized());
  }
}
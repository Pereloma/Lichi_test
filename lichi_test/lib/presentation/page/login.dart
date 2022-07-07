import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

import '../../data/login/login_bloc.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<LoginBloc, LoginState>(
        buildWhen: (previous, current) {
          if(current.runtimeType == NotAuthorized){
            if(previous.runtimeType == NotAuthorized){
              previous as NotAuthorized;
              current as NotAuthorized;

              return previous.password != current.password ||
                  previous.username != current.username ||
                  previous.status != current.status;
            }
            return true;
          }
          return false;
        },
        builder: (context, state) {
          state as NotAuthorized;
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  TextField(
                    key: const Key('loginForm_Name'),
                    onChanged: (name) => context
                        .read<LoginBloc>()
                        .add(LoginUsernameChanged(name)),
                    decoration: InputDecoration(
                      labelText: 'User name',
                      errorText:
                          state.username.invalid ? 'invalid user name' : null,
                    ),
                  ),
                  TextField(
                    key: const Key('loginForm_Password'),
                    onChanged: (password) => context
                        .read<LoginBloc>()
                        .add(LoginPasswordChanged(password)),
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      errorText:
                          state.password.invalid ? 'invalid password' : null,
                    ),
                  ),
                  ElevatedButton(
                      onPressed: state.status.isValidated
                          ? () =>
                              context.read<LoginBloc>().add(LoginSubmitted())
                          : null,
                      child: const Text("Log in"))
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

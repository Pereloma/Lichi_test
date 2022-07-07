import 'package:hive_flutter/hive_flutter.dart';

import '../model/user.dart';

class LoginRepository {
  static const String tokenKey = "tokenKey";
  static const String userKey = "userKey";
  static const String boxName = "loginBox";
  static const String userBoxName = "userBox";
  final Box<String> loginBox;
  final Box<UserModel> userBox;
  static LoginRepository? _loginRepository;

  LoginRepository._(this.loginBox, this.userBox);

  static Future<LoginRepository> getLoginRepository() async {
    if (_loginRepository != null) {
      return _loginRepository!;
    }

    Box<String> loginBox;
    if (Hive.isBoxOpen(boxName)) {
      loginBox = Hive.box(boxName);
    } else {
      loginBox = await Hive.openBox(boxName);
    }

    Box<UserModel> userBox;
    if (Hive.isBoxOpen(userBoxName)) {
      userBox = Hive.box(userBoxName);
    } else {
      userBox = await Hive.openBox(userBoxName);
    }

    return LoginRepository._(loginBox,userBox);
  }

  Future<String?> getToken() async {
    return Future.delayed(const Duration(seconds: 1),() => loginBox.get(tokenKey));
  }

  Future<String?> login(String user, String password) async {
    loginBox.put(tokenKey, "${user}_$password");
    loginBox.put(userKey, user);
    if(!userBox.containsKey(loginBox.get(userKey))){
      userBox.put(loginBox.get(userKey), UserModel(name: loginBox.get(userKey)!, newsID: []));
    }
    return Future.delayed(
        const Duration(seconds: 2), () => "${user}_$password");
  }

  Future<void> logOut() async {
    loginBox.delete(tokenKey);
    userBox.delete(userKey);
    return Future.delayed(const Duration(seconds: 2));
  }

  Future<void> close() async {
    await loginBox.close();
    await userBox.close();
  }

  Future<UserModel?> getUser(dynamic key) async {
    return userBox.get(key);
  }

  Future<UserModel?> getLoginUser() async {
    return userBox.get(loginBox.get(userKey));
  }
}

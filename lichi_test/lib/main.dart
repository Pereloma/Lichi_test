import 'package:flutter/material.dart';
import 'domain/repository/login.dart';
import 'domain/repository/news.dart';
import 'internal/application.dart';

void main() async {
  await Application.init();
  LoginRepository loginRepository = await LoginRepository.getLoginRepository();
  NewsRepository newsRepository = await NewsRepository.getNewsRepository();
  runApp(Application(
    loginRepository: loginRepository,
    newsRepository: newsRepository,
  ));
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lichi_test/domain/model/coment.dart';
import 'package:lichi_test/domain/model/user.dart';

import '../data/login/login_bloc.dart';
import '../data/news/news_bloc.dart';
import '../domain/model/news.dart';
import '../domain/repository/login.dart';
import '../domain/repository/news.dart';
import '../presentation/page/home.dart';
import '../presentation/page/login.dart';

class Application extends StatelessWidget {
  final LoginRepository loginRepository;
  final NewsRepository newsRepository;

  const Application({Key? key, required this.loginRepository, required this.newsRepository})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, child) {
        return BlocProvider(
          create: (context) => LoginBloc(loginRepository),
          child: BlocBuilder<LoginBloc, LoginState>(
              buildWhen: (previous, current) =>
              previous.runtimeType != current.runtimeType,
              builder: (context, state) {
                if (state.runtimeType == LoadingState){
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (state.runtimeType == Authorized) {
                  return BlocProvider(
                    create: (context) => NewsBloc(newsRepository),
                    child: child,
                  );
                }
                return Navigator(
                  onGenerateRoute: (_) => MaterialPageRoute(
                    builder: (ctx) => const LoginPage(),
                  ),
                );;
              }),
        );
      },
      home: const HomePage(),
    );
  }

  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter<NewsModel>(NewsModelAdapter());
    Hive.registerAdapter<UserModel>(UserModelAdapter());
    Hive.registerAdapter<CommentModel>(CommentModelAdapter());
  }
}

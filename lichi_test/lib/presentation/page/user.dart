import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/login/login_bloc.dart';
import '../../data/news/news_bloc.dart';
import 'create_or_edit_news.dart';
import 'element_page/news_card.dart';
import 'home.dart';
import 'news.dart';

class UserPage extends StatelessWidget {
  const UserPage({Key? key}) : super(key: key);

  static Route getRout() {
    return MaterialPageRoute(builder: (context) => const UserPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back)),
        title: const Text("Posts you have rated"),
        actions: [
          IconButton(onPressed: () {
            context.read<LoginBloc>().add(LogOut());
          }, icon: const Icon(Icons.logout)),
        ],
      ),
      body: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, stateLogin) {
          stateLogin as Authorized;
          return BlocBuilder<NewsBloc, NewsState>(
            builder: (context, state) {
              if (state.runtimeType == LoadingNews) {
                return const CircularProgressIndicator();
              }
              state as NewsList;
              return ListView.builder(
                itemCount: state.ids.length,
                itemBuilder: (context, index) {
                  return News(
                      futureModel: state.getNews(state.ids.elementAt(index)),
                      onTap: () async {
                        NewsBloc newsBloc = context.read<NewsBloc>();
                        newsBloc.add(OpenNews(
                            state.getNews(state.ids.elementAt(index))));
                        await Navigator.push(context,
                            NewsPage.getRout());
                        newsBloc.add(GetUserNewsList(stateLogin.user));
                      });
                },
              );
            },
          );
        },
      ),
    );
  }
}

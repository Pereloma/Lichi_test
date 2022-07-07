import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lichi_test/presentation/page/user.dart';
import '../../data/login/login_bloc.dart';
import '../../data/news/news_bloc.dart';
import 'create_or_edit_news.dart';
import 'element_page/news_card.dart';
import 'news.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  static Route getRout() {
    return MaterialPageRoute(builder: (context) => const HomePage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BlocBuilder<LoginBloc, LoginState>(
          builder: (context, stateLogin) {
            stateLogin as Authorized;
            return IconButton(
                onPressed: () async {
                  NewsBloc newsBloc = context.read<NewsBloc>();
                  newsBloc.add(GetUserNewsList(stateLogin.user));
                  await Navigator.push(context, UserPage.getRout());
                  newsBloc.add(GetNewsList());
                },
                icon: const Icon(Icons.supervised_user_circle));
          },
        ),
        title: const Text("News"),
        actions: [
          IconButton(onPressed: () async {
            NewsBloc newsBloc = context.read<NewsBloc>();
            Sort sort = await showDialog(
                context: context,
                builder: (BuildContext context) => SimpleDialog(
                  title: const Text('Sort as'),
                  children: Sort.values.map((e) => OutlinedButton(onPressed: () {
                    Navigator.pop(context, e);
                  },
                  child: Text(e.name))).toList(),
            ));
            newsBloc.add(GetNewsList(sort: sort));
          }
          , icon: const Icon(Icons.sort)),
          IconButton(
              onPressed: () async {
                NewsBloc newsBloc = context.read<NewsBloc>();
                newsBloc.add(CreateNews());
                await Navigator.push(context, CreateOrEditNewsPage.getRout());
                newsBloc.add(GetNewsList());
              },
              icon: const Icon(Icons.add)),
        ],
      ),
      body: SafeArea(
          child: BlocBuilder<NewsBloc, NewsState>(
        buildWhen: (previous, current) =>
            current.runtimeType == NewsList ||
            current.runtimeType == LoadingNews,
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
                  newsBloc.add(OpenNews(state.getNews(state.ids.elementAt(index))));
                  await Navigator.push(context, NewsPage.getRout());
                  newsBloc.add(GetNewsList());
                },
              );
            },
          );
        },
      )),
    );
  }
}

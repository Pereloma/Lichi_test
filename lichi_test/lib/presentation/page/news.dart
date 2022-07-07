import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lichi_test/domain/model/coment.dart';
import 'package:lichi_test/presentation/page/user.dart';

import '../../data/login/login_bloc.dart';
import '../../data/news/news_bloc.dart';
import 'create_or_edit_news.dart';

class NewsPage extends StatelessWidget {
  const NewsPage({Key? key}) : super(key: key);

  static Route getRout() {
    return MaterialPageRoute(builder: (context) => const NewsPage());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, stateLogin) {
        stateLogin as Authorized;
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back)),
            title: const Text("Posts you have rated"),
            actions: [
              BlocBuilder<NewsBloc, NewsState>(
                builder: (context, state) {
                  if (state.runtimeType != ReadNews) {
                    return const IconButton(
                        onPressed: null, icon: Icon(Icons.star_half));
                  }
                  state as ReadNews;
                  return Center(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () {
                        if (state.news.favorite.contains(stateLogin.user.key)) {
                          context
                              .read<NewsBloc>()
                              .add(RemoveFavorite(stateLogin.user));
                        } else {
                          context
                              .read<NewsBloc>()
                              .add(AddFavorite(stateLogin.user));
                        }
                      },
                      onLongPress: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: const Text('in favorite'),
                            content: SizedBox(
                              width: double.maxFinite,
                              child: ListView.builder(
                                itemCount: state.news.favorite.length,
                                itemBuilder: (context, index) {
                                  return Card(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                            state.news.favorite[index].toString()),
                                      ));
                                },
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, 'OK'),
                                child: const Text('OK'),
                              )
                            ],
                          ),
                        );
                      },
                      child: state.news.favorite.contains(stateLogin.user.key)
                          ? const Icon(Icons.star)
                          : const Icon(Icons.star_border),
                    ),
                  );
                },
              ),
              BlocBuilder<NewsBloc, NewsState>(
                builder: (context, state) {
                  return IconButton(
                      onPressed: state.runtimeType != ReadNews
                          ? null
                          : () async {
                              state as ReadNews;
                              NewsBloc newsBloc = context.read<NewsBloc>();
                              newsBloc.add(EditNews(state.news));
                              await Navigator.push(
                                  context, CreateOrEditNewsPage.getRout());
                              newsBloc
                                  .add(OpenNews(state.getNews(state.news.key)));
                            },
                      icon: const Icon(Icons.edit));
                },
              ),
            ],
          ),
          body: BlocBuilder<NewsBloc, NewsState>(
            builder: (context, state) {
              if (state.runtimeType != ReadNews) {
                return const Center(child: CircularProgressIndicator());
              }
              state as ReadNews;
              return ListView.builder(
                itemCount: state.news.comments.length + 4,
                itemBuilder: (context, index) {
                  switch (index) {
                    case 0:
                      if (state.news.image == null) {
                        return const SizedBox();
                      } else {
                        if (state.news.image!.startsWith("http")) {
                          return Image.network(state.news.image!,
                              height: 192,
                              width: double.infinity,
                              fit: BoxFit.fitWidth);
                        } else {
                          return Image.file(File(state.news.image!),
                              height: 128,
                              width: double.infinity,
                              fit: BoxFit.fitWidth);
                        }
                      }
                    case 1:
                      return Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(
                          state.news.title,
                          style: Theme.of(context).textTheme.headline6,
                          maxLines: 2,
                        ),
                      );
                    case 2:
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(state.news.body,
                            style: Theme.of(context).textTheme.bodyText1,
                            maxLines: 5),
                      );
                    case 3:
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Flexible(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(4, 8, 4, 8),
                              child: TextFormField(
                                  controller: state.newComment.value.isEmpty
                                      ? TextEditingController()
                                      : null,
                                  key: const Key('News_comment'),
                                  onChanged: (comment) => context
                                      .read<NewsBloc>()
                                      .add(CommentTitleChanged(comment)),
                                  minLines: 2,
                                  maxLines: 8,
                                  decoration: const InputDecoration(
                                    filled: true,
                                    focusColor: Colors.black,
                                    labelText: 'Comment',
                                  )),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: state.newComment.valid
                                ? () {
                                    context
                                        .read<NewsBloc>()
                                        .add(AddComment(stateLogin.user));
                                  }
                                : null,
                            child: const Icon(Icons.message_outlined),
                          )
                        ],
                      );
                    default:
                      return _Comment(state.news.comments[index - 4]);
                  }
                },
              );
            },
          ),
        );
      },
    );
  }
}

class _Comment extends StatelessWidget {
  final CommentModel comment;

  const _Comment(this.comment);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 4, 8, 4),
            child: Text(
              comment.user.name,
              style: Theme.of(context).textTheme.headline6,
              maxLines: 1,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 4, 4, 4),
            child: Text(
              comment.comment,
              style: Theme.of(context).textTheme.bodySmall,
              maxLines: 8,
            ),
          ),
        ],
      ),
    );
  }
}

part of 'news_bloc.dart';

@immutable
abstract class NewsEvent {}

class GetNewsList extends NewsEvent {
  final Sort? sort;

  GetNewsList({this.sort});

}

class GetUserNewsList extends NewsEvent {
  final UserModel user;

  GetUserNewsList(this.user);

}

class CreateNews extends NewsEvent {
  CreateNews();
}

class NewsTitleChanged extends NewsEvent {
  NewsTitleChanged(this.title);

  final String title;
}

class NewsBodyChanged extends NewsEvent {
  NewsBodyChanged(this.body);

  final String body;
}

class NewsImageChanged extends NewsEvent {
  NewsImageChanged(this.image);

  final String image;
}

class SaveNews extends NewsEvent {
  SaveNews();
}

class EditNews extends NewsEvent {
final NewsModel news;
  EditNews(this.news);
}

class OpenNews extends NewsEvent {
  final Future<NewsModel> futureNews;
  OpenNews(this.futureNews);
}

class AddFavorite extends NewsEvent{
  final UserModel user;

  AddFavorite(this.user);
}
class RemoveFavorite extends NewsEvent{
  final UserModel user;

  RemoveFavorite(this.user);
}

class AddComment extends NewsEvent{
  final UserModel user;

  AddComment(this.user);
}

class CommentTitleChanged extends NewsEvent {
  CommentTitleChanged(this.comment);

  final String comment;
}
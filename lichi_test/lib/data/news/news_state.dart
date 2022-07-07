part of 'news_bloc.dart';

enum Sort { date, favorite }

@immutable
abstract class NewsState {
  final NewsRepository _newsRepository;

  Future<NewsModel> getNews(dynamic id) {
    return _newsRepository.getNews(id);
  }
  const NewsState(this._newsRepository);
}

class LoadingNews extends NewsState {
  const LoadingNews(super.newsRepository);
}

class NewsList extends NewsState {
  final Sort sort;
  final dynamic ids;

  NewsList(super.newsRepository, {this.sort = Sort.date, required this.ids});

  NewsList copyWith(Sort? sort, Iterable? ids) {
    return NewsList(_newsRepository,
        ids: ids ?? this.ids, sort: sort ?? this.sort);
  }
}

class ReadNews extends NewsState {
  final NewsModel news;
  final CommentValidator newComment;

  const ReadNews(super.newsRepository,
      {required this.news, this.newComment = const CommentValidator.pure()});

  ReadNews copyWith(
      {NewsModel? news,
        CommentValidator? newComment}) {
    return ReadNews(
      _newsRepository,
      news: news ?? this.news,
      newComment: newComment ?? this.newComment,
    );
  }
}

class CreateOrEditNews extends NewsState {
  final bool newEdit;
  final dynamic id;
  final TitleValidator title;
  final BodyValidator body;
  final String? image;
  final FormzStatus status;

  const CreateOrEditNews(super.newsRepository,
      {this.title = const TitleValidator.pure(),
      this.body = const BodyValidator.pure(),
      this.image,
      this.status = FormzStatus.pure,
      this.id,
      this.newEdit = false});

  CreateOrEditNews copyWith(
      {TitleValidator? title,
      BodyValidator? body,
      String? image,
      FormzStatus? status,
      dynamic id}) {
    return CreateOrEditNews(
      _newsRepository,
      title: title ?? this.title,
      body: body ?? this.body,
      image: image ?? this.image,
      status: status ?? this.status,
      id: id ?? this.id,
    );
  }
}

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:formz/formz.dart';
import 'package:lichi_test/data/news/form/body.dart';
import 'package:lichi_test/data/news/form/title.dart';
import 'package:lichi_test/domain/model/coment.dart';
import 'package:lichi_test/domain/model/user.dart';
import 'package:meta/meta.dart';

import '../../domain/model/news.dart';
import '../../domain/repository/news.dart';
import 'form/comment.dart';

part 'news_event.dart';

part 'news_state.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final NewsRepository _newsRepository;

  NewsBloc(this._newsRepository) : super(LoadingNews(_newsRepository)) {
    on<GetNewsList>((event, emit) => onGetNewsList(event, emit));
    on<CreateNews>((event, emit) => onCreateNews(event, emit));
    on<EditNews>((event, emit) => onEditNews(event, emit));
    on<NewsTitleChanged>((event, emit) => onNewsTitleChanged(event, emit));
    on<NewsBodyChanged>((event, emit) => onNewsBodyChanged(event, emit));
    on<NewsImageChanged>((event, emit) => onNewsImageChanged(event, emit));
    on<SaveNews>((event, emit) => onSaveNews(event, emit));
    on<GetUserNewsList>((event, emit) => onGetUserNewsList(event, emit));
    on<OpenNews>((event, emit) => onOpenNews(event, emit));
    on<AddFavorite>((event, emit) => onAddFavorite(event, emit));
    on<RemoveFavorite>((event, emit) => onRemoveFavorite(event, emit));
    on<CommentTitleChanged>(
        (event, emit) => onCommentTitleChanged(event, emit));
    on<AddComment>((event, emit) => onAddComment(event, emit));

    add(GetNewsList());
  }

  void onGetNewsList(GetNewsList event, Emitter<NewsState> emit) async {
    emit(LoadingNews(_newsRepository));
    Iterable ids = await _newsRepository.getIDs(sort: event.sort);
    emit(NewsList(_newsRepository, ids: ids));
  }

  void onCreateNews(CreateNews event, Emitter<NewsState> emit) async {
    emit(CreateOrEditNews(
      _newsRepository,
    ));
  }

  void onEditNews(EditNews event, Emitter<NewsState> emit) async {
    final title = TitleValidator.dirty(event.news.title);
    final body = BodyValidator.dirty(event.news.body);
    emit(CreateOrEditNews(_newsRepository,
        newEdit: true,
        title: title,
        body: body,
        image: event.news.image,
        id: event.news.key,
        status: Formz.validate([body, title])));
  }

  void onNewsTitleChanged(
      NewsTitleChanged event, Emitter<NewsState> emit) async {
    CreateOrEditNews createOrEditNewsState = state as CreateOrEditNews;
    final title = TitleValidator.dirty(event.title);
    emit(createOrEditNewsState.copyWith(
        title: title,
        status: Formz.validate([createOrEditNewsState.body, title])));
  }

  void onNewsBodyChanged(NewsBodyChanged event, Emitter<NewsState> emit) async {
    CreateOrEditNews createOrEditNewsState = state as CreateOrEditNews;
    final body = BodyValidator.dirty(event.body);
    emit(createOrEditNewsState.copyWith(
        body: body,
        status: Formz.validate([createOrEditNewsState.title, body])));
  }

  void onNewsImageChanged(
      NewsImageChanged event, Emitter<NewsState> emit) async {
    CreateOrEditNews createOrEditNewsState = state as CreateOrEditNews;
    emit(createOrEditNewsState.copyWith(image: event.image));
  }

  void onSaveNews(SaveNews event, Emitter<NewsState> emit) async {
    if (state.runtimeType == CreateOrEditNews) {
      CreateOrEditNews createOrEditNewsState = state as CreateOrEditNews;
      if (_newsRepository.newsBox.containsKey(createOrEditNewsState.id)) {
        NewsModel news =
            await _newsRepository.getNews(createOrEditNewsState.id);
        _newsRepository.newsBox.put(
            createOrEditNewsState.id,
            NewsModel(
                title: createOrEditNewsState.title.value,
                body: createOrEditNewsState.body.value,
                image: createOrEditNewsState.image,
                comments: news.comments,
                favorite: news.favorite,
                date: news.date));
      } else {
        _newsRepository.newsBox.add(NewsModel(
            title: createOrEditNewsState.title.value,
            body: createOrEditNewsState.body.value,
            image: createOrEditNewsState.image,
            comments: [],
            favorite: [],
            date: DateTime.now()));
      }
    }
  }

  void onGetUserNewsList(GetUserNewsList event, Emitter<NewsState> emit) async {
    emit(LoadingNews(_newsRepository));
    Iterable ids = await _newsRepository.getIDsFavoriteUser(event.user);
    emit(NewsList(_newsRepository, ids: ids));
  }

  void onOpenNews(OpenNews event, Emitter<NewsState> emit) async {
    emit(LoadingNews(_newsRepository));
    NewsModel news = await event.futureNews;
    emit(ReadNews(_newsRepository, news: news));
  }

  void onAddFavorite(AddFavorite event, Emitter<NewsState> emit) async {
    if (state.runtimeType == ReadNews) {
      ReadNews readNewsState = state as ReadNews;

      readNewsState.news.favorite.add(event.user.key);
      readNewsState.news.save();

      emit(ReadNews(_newsRepository,
          news: await _newsRepository.getNews(readNewsState.news.key)));
    }
  }

  void onRemoveFavorite(RemoveFavorite event, Emitter<NewsState> emit) async {
    if (state.runtimeType == ReadNews) {
      ReadNews readNewsState = state as ReadNews;

      // ignore: list_remove_unrelated_type
      if(readNewsState.news.favorite.remove(event.user)){
        readNewsState.news.save();

        emit(ReadNews(_newsRepository,
            news: await _newsRepository.getNews(readNewsState.news.key)));
      }

    }
  }

  void onCommentTitleChanged(
      CommentTitleChanged event, Emitter<NewsState> emit) {
    if (state.runtimeType == ReadNews) {
      ReadNews readNewsState = state as ReadNews;

      emit(ReadNews(_newsRepository,
          news: readNewsState.news,
          newComment: CommentValidator.dirty(event.comment)));
    }
  }

  void onAddComment(AddComment event, Emitter<NewsState> emit) async {
    if (state.runtimeType == ReadNews) {
      ReadNews readNewsState = state as ReadNews;

      readNewsState.news.comments.add(CommentModel(
          user: event.user, comment: readNewsState.newComment.value));
      readNewsState.news.save();

      emit(ReadNews(_newsRepository,
          news: await _newsRepository.getNews(readNewsState.news.key)));
    }
  }
}

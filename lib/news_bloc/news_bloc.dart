import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_era_dev/repositories/news/models/article.dart';
import 'package:flutter_era_dev/repositories/news/news_repository.dart';

part 'news_event.dart';
part 'news_state.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  NewsBloc(this.repository) : super(NewsInitial()) {
    on<NewsEvent>(
      (event, emit) async {
        switch (event) {
          case LoadAllNews():
            await _loadAllNews(event, emit);
          case LoadNewsDetails():
            await _loadNewsDetails(event, emit);
          case MarkReadAllNews():
            _markReadAllNews(event, emit);
        }
      },
      transformer: sequential(),
    );
  }

  final AbstractNewsRepository repository;
  List<Article> featuredArticles = [];
  List<Article> latestArticles = [];
  Article? article;

  Future<void> _loadAllNews(
    LoadAllNews event,
    Emitter<NewsState> emit,
  ) async {
    emit(NewsLoading());
    try {
      featuredArticles = await repository.getFeaturedArticles();
      latestArticles = await repository.getLatestArticles();
      emit(AllNewsLoaded());
    } catch (e) {
      emit(NewsLoadingFailure(exception: e.toString()));
    }
  }

  Future<void> _loadNewsDetails(
    LoadNewsDetails event,
    Emitter<NewsState> emit,
  ) async {
    emit(NewsLoading());
    try {
      article = await repository.getArticle(event.id);
      emit(NewsDetailsLoaded());
    } catch (e) {
      emit(NewsLoadingFailure(exception: e.toString()));
    }
  }

  void _markReadAllNews(
    MarkReadAllNews event,
    Emitter<NewsState> emit,
  ) {
    for (var e in featuredArticles) {
      e.readed = true;
    }
    for (var e in latestArticles) {
      e.readed = true;
    }
    emit(NewsMarkedAllReaded());
  }
}

part of 'news_bloc.dart';

sealed class NewsEvent extends Equatable {}

class LoadAllNews extends NewsEvent {
  @override
  List<Object?> get props => [];
}

class LoadNewsDetails extends NewsEvent {
  final String id;

  LoadNewsDetails({required this.id});

  @override
  List<Object?> get props => [id];
}

class MarkReadAllNews extends NewsEvent {
  @override
  List<Object?> get props => [];
}

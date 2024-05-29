part of 'news_bloc.dart';

sealed class NewsState extends Equatable {}

class NewsInitial extends NewsState {
  @override
  List<Object?> get props => [];
}

class NewsLoading extends NewsState {
  @override
  List<Object?> get props => [];
}

class AllNewsLoaded extends NewsState {
  @override
  List<Object?> get props => [];
}

class NewsDetailsLoaded extends NewsState {
  @override
  List<Object?> get props => [];
}

class NewsMarkedAllReaded extends NewsState {
  @override
  List<Object?> get props => [];
}

class NewsLoadingFailure extends NewsState {
  NewsLoadingFailure({
    required this.exception,
  });

  final Object? exception;

  @override
  List<Object?> get props => [exception];
}

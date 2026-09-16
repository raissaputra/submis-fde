part of 'movie_detail_bloc.dart';

abstract class MovieDetailEvent extends Equatable {
  const MovieDetailEvent();

  @override
  List<Object> get props => [];
}

class OnMovieDetailRequested extends MovieDetailEvent {
  final int id;

  const OnMovieDetailRequested(this.id);

  @override
  List<Object> get props => [id];
}

class OnLoadMovieWatchlistStatus extends MovieDetailEvent {
  final int id;

  const OnLoadMovieWatchlistStatus(this.id);

  @override
  List<Object> get props => [id];
}

class OnAddMovieToWatchlist extends MovieDetailEvent {
  final MovieDetail movie;

  const OnAddMovieToWatchlist(this.movie);

  @override
  List<Object> get props => [movie];
}

class OnRemoveMovieFromWatchlist extends MovieDetailEvent {
  final MovieDetail movie;

  const OnRemoveMovieFromWatchlist(this.movie);

  @override
  List<Object> get props => [movie];
}

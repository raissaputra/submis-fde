part of 'movie_detail_bloc.dart';

class MovieDetailState extends Equatable {
  final RequestState movieState;
  final MovieDetail? movie;
  final RequestState recommendationState;
  final List<Movie> movieRecommendations;
  final bool isAddedToWatchlist;
  final String watchlistMessage;
  final String message;

  const MovieDetailState({
    required this.movieState,
    required this.movie,
    required this.recommendationState,
    required this.movieRecommendations,
    required this.isAddedToWatchlist,
    required this.watchlistMessage,
    required this.message,
  });

  factory MovieDetailState.initial() => const MovieDetailState(
        movieState: RequestState.Empty,
        movie: null,
        recommendationState: RequestState.Empty,
        movieRecommendations: [],
        isAddedToWatchlist: false,
        watchlistMessage: '',
        message: '',
      );

  MovieDetailState copyWith({
    RequestState? movieState,
    MovieDetail? movie,
    RequestState? recommendationState,
    List<Movie>? movieRecommendations,
    bool? isAddedToWatchlist,
    String? watchlistMessage,
    String? message,
  }) {
    return MovieDetailState(
      movieState: movieState ?? this.movieState,
      movie: movie ?? this.movie,
      recommendationState: recommendationState ?? this.recommendationState,
      movieRecommendations: movieRecommendations ?? this.movieRecommendations,
      isAddedToWatchlist: isAddedToWatchlist ?? this.isAddedToWatchlist,
      watchlistMessage: watchlistMessage ?? this.watchlistMessage,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [
        movieState,
        movie,
        recommendationState,
        movieRecommendations,
        isAddedToWatchlist,
        watchlistMessage,
        message,
      ];
}

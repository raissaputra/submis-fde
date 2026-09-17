import 'package:bloc/bloc.dart';
import 'package:core/common/state_enum.dart';
import 'package:movie/domain/entities/movie.dart';
import 'package:movie/domain/entities/movie_detail.dart';
import 'package:movie/domain/usecases/get_movie_detail.dart';
import 'package:movie/domain/usecases/get_movie_recommendations.dart';
import 'package:movie/domain/usecases/get_watchlist_status.dart';
import 'package:movie/domain/usecases/remove_watchlist.dart';
import 'package:movie/domain/usecases/save_watchlist.dart';
import 'package:equatable/equatable.dart';

part 'movie_detail_event.dart';
part 'movie_detail_state.dart';

class MovieDetailBloc extends Bloc<MovieDetailEvent, MovieDetailState> {
  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  final GetMovieDetail getMovieDetail;
  final GetMovieRecommendations getMovieRecommendations;
  final GetWatchListStatus getWatchListStatus;
  final SaveWatchlist saveWatchlist;
  final RemoveWatchlist removeWatchlist;

  MovieDetailBloc({
    required this.getMovieDetail,
    required this.getMovieRecommendations,
    required this.getWatchListStatus,
    required this.saveWatchlist,
    required this.removeWatchlist,
  }) : super(MovieDetailState.initial()) {
    on<OnMovieDetailRequested>(_onMovieDetailRequested);
    on<OnLoadMovieWatchlistStatus>(_onLoadWatchlistStatus);
    on<OnAddMovieToWatchlist>(_onAddWatchlist);
    on<OnRemoveMovieFromWatchlist>(_onRemoveWatchlist);
  }

  Future<void> _onMovieDetailRequested(
    OnMovieDetailRequested event,
    Emitter<MovieDetailState> emit,
  ) async {
    emit(state.copyWith(movieState: RequestState.Loading));
    final detailResult = await getMovieDetail.execute(event.id);
    final recommendationResult =
        await getMovieRecommendations.execute(event.id);

    detailResult.fold(
      (failure) {
        emit(state.copyWith(
          movieState: RequestState.Error,
          message: failure.message,
        ));
      },
      (movie) {
        emit(state.copyWith(
          movieState: RequestState.Loaded,
          movie: movie,
          recommendationState: RequestState.Loading,
        ));
        recommendationResult.fold(
          (failure) {
            emit(state.copyWith(
              recommendationState: RequestState.Error,
              message: failure.message,
            ));
          },
          (movies) {
            emit(state.copyWith(
              recommendationState: RequestState.Loaded,
              movieRecommendations: movies,
            ));
          },
        );
      },
    );
  }

  Future<void> _onLoadWatchlistStatus(
    OnLoadMovieWatchlistStatus event,
    Emitter<MovieDetailState> emit,
  ) async {
    final status = await getWatchListStatus.execute(event.id);
    emit(state.copyWith(isAddedToWatchlist: status));
  }

  Future<void> _onAddWatchlist(
    OnAddMovieToWatchlist event,
    Emitter<MovieDetailState> emit,
  ) async {
    final result = await saveWatchlist.execute(event.movie);
    final message = result.fold(
      (failure) => failure.message,
      (successMessage) => successMessage,
    );
    emit(state.copyWith(watchlistMessage: message));
    final status = await getWatchListStatus.execute(event.movie.id);
    emit(state.copyWith(isAddedToWatchlist: status));
  }

  Future<void> _onRemoveWatchlist(
    OnRemoveMovieFromWatchlist event,
    Emitter<MovieDetailState> emit,
  ) async {
    final result = await removeWatchlist.execute(event.movie);
    final message = result.fold(
      (failure) => failure.message,
      (successMessage) => successMessage,
    );
    emit(state.copyWith(watchlistMessage: message));
    final status = await getWatchListStatus.execute(event.movie.id);
    emit(state.copyWith(isAddedToWatchlist: status));
  }
}

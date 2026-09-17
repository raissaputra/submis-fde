import 'package:core/common/exception.dart';
import 'package:core/common/failure.dart';
import 'package:core/common/state_enum.dart';
import 'package:core/common/utils.dart';
import 'package:core/utils/routes.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Failure', () {
    test('subclasses carry the message and support value equality', () {
      expect(ServerFailure('x').props, ['x']);
      expect(ConnectionFailure('y').props, ['y']);
      expect(DatabaseFailure('z').props, ['z']);
      expect(ServerFailure('x'), ServerFailure('x'));
    });
  });

  group('Exception', () {
    test('ServerException is an Exception', () {
      expect(ServerException(), isA<Exception>());
    });

    test('DatabaseException carries a message', () {
      expect(DatabaseException('db error').message, 'db error');
    });
  });

  test('RequestState exposes the expected values', () {
    expect(RequestState.values, [
      RequestState.Empty,
      RequestState.Loading,
      RequestState.Loaded,
      RequestState.Error,
    ]);
  });

  test('routeObserver is a RouteObserver', () {
    expect(routeObserver, isA<RouteObserver<ModalRoute>>());
  });

  test('AppRoutes exposes distinct route names', () {
    final routes = {
      AppRoutes.home,
      AppRoutes.popularMovies,
      AppRoutes.topRatedMovies,
      AppRoutes.movieDetail,
      AppRoutes.searchMovies,
      AppRoutes.watchlistMovies,
      AppRoutes.homeTvSeries,
      AppRoutes.popularTvSeries,
      AppRoutes.topRatedTvSeries,
      AppRoutes.tvSeriesDetail,
      AppRoutes.searchTvSeries,
      AppRoutes.watchlistTvSeries,
      AppRoutes.about,
    };
    expect(routes.length, 13);
  });
}

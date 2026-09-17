import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:core/common/exception.dart';
import 'package:core/common/failure.dart';
import 'package:core/data/models/genre_model.dart';
import 'package:tv_series/data/models/season_model.dart';
import 'package:tv_series/data/models/tv_series_detail_model.dart';
import 'package:tv_series/data/models/tv_series_model.dart';
import 'package:tv_series/data/repositories/tv_series_repository_impl.dart';
import 'package:tv_series/domain/entities/tv_series.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late TvSeriesRepositoryImpl repository;
  late MockTvSeriesRemoteDataSource mockRemoteDataSource;
  late MockTvSeriesLocalDataSource mockLocalDataSource;

  setUp(() {
    mockRemoteDataSource = MockTvSeriesRemoteDataSource();
    mockLocalDataSource = MockTvSeriesLocalDataSource();
    repository = TvSeriesRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
    );
  });

  final tTvSeriesModel = TvSeriesModel(
    backdropPath: '/path.jpg',
    firstAirDate: '2021-01-01',
    genreIds: [10765, 18],
    id: 1,
    name: 'Name',
    originalName: 'Original Name',
    overview: 'Overview',
    popularity: 100.0,
    posterPath: '/path.jpg',
    voteAverage: 8.0,
    voteCount: 100,
  );

  final tTvSeries = TvSeries(
    backdropPath: '/path.jpg',
    firstAirDate: '2021-01-01',
    genreIds: [10765, 18],
    id: 1,
    name: 'Name',
    originalName: 'Original Name',
    overview: 'Overview',
    popularity: 100.0,
    posterPath: '/path.jpg',
    voteAverage: 8.0,
    voteCount: 100,
  );

  final tTvSeriesModelList = <TvSeriesModel>[tTvSeriesModel];
  final tTvSeriesList = <TvSeries>[tTvSeries];

  group('Now Playing Tv Series', () {
    test('should return remote data when call to remote source is successful',
        () async {
      when(mockRemoteDataSource.getNowPlayingTvSeries())
          .thenAnswer((_) async => tTvSeriesModelList);
      final result = await repository.getNowPlayingTvSeries();
      verify(mockRemoteDataSource.getNowPlayingTvSeries());
      final resultList = result.getOrElse(() => []);
      expect(resultList, tTvSeriesList);
    });

    test('should return server failure when call to remote source is failed',
        () async {
      when(mockRemoteDataSource.getNowPlayingTvSeries())
          .thenThrow(ServerException());
      final result = await repository.getNowPlayingTvSeries();
      verify(mockRemoteDataSource.getNowPlayingTvSeries());
      expect(result, equals(Left(ServerFailure(''))));
    });

    test('should return connection failure when device is not connected',
        () async {
      when(mockRemoteDataSource.getNowPlayingTvSeries())
          .thenThrow(SocketException('Failed to connect to the network'));
      final result = await repository.getNowPlayingTvSeries();
      verify(mockRemoteDataSource.getNowPlayingTvSeries());
      expect(result,
          equals(Left(ConnectionFailure('Failed to connect to the network'))));
    });
  });

  group('Popular Tv Series', () {
    test('should return tv series list when call to data source is success',
        () async {
      when(mockRemoteDataSource.getPopularTvSeries())
          .thenAnswer((_) async => tTvSeriesModelList);
      final result = await repository.getPopularTvSeries();
      final resultList = result.getOrElse(() => []);
      expect(resultList, tTvSeriesList);
    });

    test('should return server failure when call to data source is failed',
        () async {
      when(mockRemoteDataSource.getPopularTvSeries())
          .thenThrow(ServerException());
      final result = await repository.getPopularTvSeries();
      expect(result, equals(Left(ServerFailure(''))));
    });

    test('should return connection failure when device is not connected',
        () async {
      when(mockRemoteDataSource.getPopularTvSeries())
          .thenThrow(SocketException('Failed to connect to the network'));
      final result = await repository.getPopularTvSeries();
      expect(result,
          equals(Left(ConnectionFailure('Failed to connect to the network'))));
    });
  });

  group('Top Rated Tv Series', () {
    test('should return tv series list when call to data source is success',
        () async {
      when(mockRemoteDataSource.getTopRatedTvSeries())
          .thenAnswer((_) async => tTvSeriesModelList);
      final result = await repository.getTopRatedTvSeries();
      final resultList = result.getOrElse(() => []);
      expect(resultList, tTvSeriesList);
    });

    test('should return server failure when call to data source is failed',
        () async {
      when(mockRemoteDataSource.getTopRatedTvSeries())
          .thenThrow(ServerException());
      final result = await repository.getTopRatedTvSeries();
      expect(result, equals(Left(ServerFailure(''))));
    });

    test('should return connection failure when device is not connected',
        () async {
      when(mockRemoteDataSource.getTopRatedTvSeries())
          .thenThrow(SocketException('Failed to connect to the network'));
      final result = await repository.getTopRatedTvSeries();
      expect(result,
          equals(Left(ConnectionFailure('Failed to connect to the network'))));
    });
  });

  group('Get Tv Series Detail', () {
    final tId = 1;
    final tTvSeriesDetailResponse = TvSeriesDetailResponse(
      backdropPath: 'backdropPath',
      genres: [GenreModel(id: 1, name: 'Action')],
      id: 1,
      name: 'name',
      originalName: 'originalName',
      overview: 'overview',
      posterPath: 'posterPath',
      firstAirDate: 'firstAirDate',
      numberOfSeasons: 2,
      numberOfEpisodes: 16,
      episodeRunTime: [45],
      seasons: [
        SeasonModel(
          airDate: '2021-01-01',
          episodeCount: 8,
          id: 1,
          name: 'Season 1',
          overview: 'overview',
          posterPath: 'posterPath',
          seasonNumber: 1,
        ),
      ],
      voteAverage: 8.0,
      voteCount: 100,
    );

    test('should return tv series detail when call is successful', () async {
      when(mockRemoteDataSource.getTvSeriesDetail(tId))
          .thenAnswer((_) async => tTvSeriesDetailResponse);
      final result = await repository.getTvSeriesDetail(tId);
      verify(mockRemoteDataSource.getTvSeriesDetail(tId));
      expect(result, equals(Right(testTvSeriesDetail)));
    });

    test('should return server failure when call is unsuccessful', () async {
      when(mockRemoteDataSource.getTvSeriesDetail(tId))
          .thenThrow(ServerException());
      final result = await repository.getTvSeriesDetail(tId);
      expect(result, equals(Left(ServerFailure(''))));
    });

    test('should return connection failure when device is not connected',
        () async {
      when(mockRemoteDataSource.getTvSeriesDetail(tId))
          .thenThrow(SocketException('Failed to connect to the network'));
      final result = await repository.getTvSeriesDetail(tId);
      expect(result,
          equals(Left(ConnectionFailure('Failed to connect to the network'))));
    });
  });

  group('Get Tv Series Recommendations', () {
    final tId = 1;

    test('should return data when call is successful', () async {
      when(mockRemoteDataSource.getTvSeriesRecommendations(tId))
          .thenAnswer((_) async => tTvSeriesModelList);
      final result = await repository.getTvSeriesRecommendations(tId);
      final resultList = result.getOrElse(() => []);
      expect(resultList, equals(tTvSeriesList));
    });

    test('should return server failure when call is unsuccessful', () async {
      when(mockRemoteDataSource.getTvSeriesRecommendations(tId))
          .thenThrow(ServerException());
      final result = await repository.getTvSeriesRecommendations(tId);
      expect(result, equals(Left(ServerFailure(''))));
    });

    test('should return connection failure when device is not connected',
        () async {
      when(mockRemoteDataSource.getTvSeriesRecommendations(tId))
          .thenThrow(SocketException('Failed to connect to the network'));
      final result = await repository.getTvSeriesRecommendations(tId);
      expect(result,
          equals(Left(ConnectionFailure('Failed to connect to the network'))));
    });
  });

  group('Search Tv Series', () {
    final tQuery = 'Squid Game';

    test('should return tv series list when call is successful', () async {
      when(mockRemoteDataSource.searchTvSeries(tQuery))
          .thenAnswer((_) async => tTvSeriesModelList);
      final result = await repository.searchTvSeries(tQuery);
      final resultList = result.getOrElse(() => []);
      expect(resultList, tTvSeriesList);
    });

    test('should return server failure when call is unsuccessful', () async {
      when(mockRemoteDataSource.searchTvSeries(tQuery))
          .thenThrow(ServerException());
      final result = await repository.searchTvSeries(tQuery);
      expect(result, equals(Left(ServerFailure(''))));
    });

    test('should return connection failure when device is not connected',
        () async {
      when(mockRemoteDataSource.searchTvSeries(tQuery))
          .thenThrow(SocketException('Failed to connect to the network'));
      final result = await repository.searchTvSeries(tQuery);
      expect(result,
          equals(Left(ConnectionFailure('Failed to connect to the network'))));
    });
  });

  group('save watchlist', () {
    test('should return success message when saving is successful', () async {
      when(mockLocalDataSource.insertWatchlist(testTvSeriesTable))
          .thenAnswer((_) async => 'Added to Watchlist');
      final result = await repository.saveWatchlist(testTvSeriesDetail);
      expect(result, Right('Added to Watchlist'));
    });

    test('should return DatabaseFailure when saving is unsuccessful',
        () async {
      when(mockLocalDataSource.insertWatchlist(testTvSeriesTable))
          .thenThrow(DatabaseException('Failed to add watchlist'));
      final result = await repository.saveWatchlist(testTvSeriesDetail);
      expect(result, Left(DatabaseFailure('Failed to add watchlist')));
    });
  });

  group('remove watchlist', () {
    test('should return success message when removing is successful', () async {
      when(mockLocalDataSource.removeWatchlist(testTvSeriesTable))
          .thenAnswer((_) async => 'Removed from Watchlist');
      final result = await repository.removeWatchlist(testTvSeriesDetail);
      expect(result, Right('Removed from Watchlist'));
    });

    test('should return DatabaseFailure when removing is unsuccessful',
        () async {
      when(mockLocalDataSource.removeWatchlist(testTvSeriesTable))
          .thenThrow(DatabaseException('Failed to remove watchlist'));
      final result = await repository.removeWatchlist(testTvSeriesDetail);
      expect(result, Left(DatabaseFailure('Failed to remove watchlist')));
    });
  });

  group('get watchlist status', () {
    test('should return watch status whether data is found', () async {
      final tId = 1;
      when(mockLocalDataSource.getTvSeriesById(tId))
          .thenAnswer((_) async => null);
      final result = await repository.isAddedToWatchlist(tId);
      expect(result, false);
    });
  });

  group('get watchlist tv series', () {
    test('should return list of TvSeries', () async {
      when(mockLocalDataSource.getWatchlistTvSeries())
          .thenAnswer((_) async => [testTvSeriesTable]);
      final result = await repository.getWatchlistTvSeries();
      final resultList = result.getOrElse(() => []);
      expect(resultList, [testWatchlistTvSeries]);
    });
  });
}

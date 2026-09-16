import 'dart:convert';

import 'package:ditonton/common/exception.dart';
import 'package:ditonton/data/datasources/tv_series_remote_data_source.dart';
import 'package:ditonton/data/models/tv_series_response.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';
import '../../json_reader.dart';

void main() {
  const API_KEY = 'api_key=2174d146bb9c0eab47529b2e77d6b526';
  const BASE_URL = 'https://api.themoviedb.org/3';

  late TvSeriesRemoteDataSourceImpl dataSource;
  late MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = TvSeriesRemoteDataSourceImpl(client: mockHttpClient);
  });

  group('get Now Playing Tv Series', () {
    final tTvSeriesList = TvSeriesResponse.fromJson(
            json.decode(readJson('dummy_data/tv_now_playing.json')))
        .tvSeriesList;

    test('should return list of Tv Series Model when response code is 200',
        () async {
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/on_the_air?$API_KEY')))
          .thenAnswer((_) async =>
              http.Response(readJson('dummy_data/tv_now_playing.json'), 200));
      final result = await dataSource.getNowPlayingTvSeries();
      expect(result, equals(tTvSeriesList));
    });

    test('should throw a ServerException when response code is 404 or other',
        () async {
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/on_the_air?$API_KEY')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      final call = dataSource.getNowPlayingTvSeries();
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('get Popular Tv Series', () {
    final tTvSeriesList = TvSeriesResponse.fromJson(
            json.decode(readJson('dummy_data/tv_popular.json')))
        .tvSeriesList;

    test('should return list of tv series when response is success (200)',
        () async {
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/popular?$API_KEY')))
          .thenAnswer((_) async =>
              http.Response(readJson('dummy_data/tv_popular.json'), 200));
      final result = await dataSource.getPopularTvSeries();
      expect(result, tTvSeriesList);
    });

    test('should throw a ServerException when response code is 404 or other',
        () async {
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/popular?$API_KEY')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      final call = dataSource.getPopularTvSeries();
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('get Top Rated Tv Series', () {
    final tTvSeriesList = TvSeriesResponse.fromJson(
            json.decode(readJson('dummy_data/tv_top_rated.json')))
        .tvSeriesList;

    test('should return list of tv series when response code is 200', () async {
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/top_rated?$API_KEY')))
          .thenAnswer((_) async =>
              http.Response(readJson('dummy_data/tv_top_rated.json'), 200));
      final result = await dataSource.getTopRatedTvSeries();
      expect(result, tTvSeriesList);
    });

    test('should throw ServerException when response code is 404 or other',
        () async {
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/top_rated?$API_KEY')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      final call = dataSource.getTopRatedTvSeries();
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('get Tv Series Detail', () {
    final tId = 1;

    test('should return tv series detail when response code is 200', () async {
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/$tId?$API_KEY')))
          .thenAnswer((_) async =>
              http.Response(readJson('dummy_data/tv_series_detail.json'), 200));
      final result = await dataSource.getTvSeriesDetail(tId);
      expect(result.id, 1);
      expect(result.name, 'Name');
    });

    test('should throw ServerException when response code is 404 or other',
        () async {
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/$tId?$API_KEY')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      final call = dataSource.getTvSeriesDetail(tId);
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('get Tv Series Recommendations', () {
    final tId = 1;
    final tTvSeriesList = TvSeriesResponse.fromJson(
            json.decode(readJson('dummy_data/tv_recommendations.json')))
        .tvSeriesList;

    test('should return list of tv series when response code is 200', () async {
      when(mockHttpClient
              .get(Uri.parse('$BASE_URL/tv/$tId/recommendations?$API_KEY')))
          .thenAnswer((_) async => http.Response(
              readJson('dummy_data/tv_recommendations.json'), 200));
      final result = await dataSource.getTvSeriesRecommendations(tId);
      expect(result, equals(tTvSeriesList));
    });

    test('should throw ServerException when response code is 404 or other',
        () async {
      when(mockHttpClient
              .get(Uri.parse('$BASE_URL/tv/$tId/recommendations?$API_KEY')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      final call = dataSource.getTvSeriesRecommendations(tId);
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('search Tv Series', () {
    final tQuery = 'Squid Game';
    final tTvSeriesList = TvSeriesResponse.fromJson(
            json.decode(readJson('dummy_data/search_tv.json')))
        .tvSeriesList;

    test('should return list of tv series when response code is 200', () async {
      when(mockHttpClient
              .get(Uri.parse('$BASE_URL/search/tv?$API_KEY&query=$tQuery')))
          .thenAnswer((_) async =>
              http.Response(readJson('dummy_data/search_tv.json'), 200));
      final result = await dataSource.searchTvSeries(tQuery);
      expect(result, tTvSeriesList);
    });

    test('should throw ServerException when response code is 404 or other',
        () async {
      when(mockHttpClient
              .get(Uri.parse('$BASE_URL/search/tv?$API_KEY&query=$tQuery')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      final call = dataSource.searchTvSeries(tQuery);
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });
}

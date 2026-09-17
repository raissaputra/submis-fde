import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:core/common/failure.dart';
import 'package:tv_series/domain/usecases/search_tv_series.dart';
import 'package:tv_series/presentation/bloc/tv_series/search_tv_series_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'search_tv_series_bloc_test.mocks.dart';

@GenerateMocks([SearchTvSeries])
void main() {
  late MockSearchTvSeries mockUsecase;
  late SearchTvSeriesBloc bloc;

  setUp(() {
    mockUsecase = MockSearchTvSeries();
    bloc = SearchTvSeriesBloc(mockUsecase);
  });

  const tQuery = 'squid game';

  test('initial state should be empty', () {
    expect(bloc.state, SearchTvSeriesEmpty());
  });

  blocTest<SearchTvSeriesBloc, SearchTvSeriesState>(
    'should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockUsecase.execute(tQuery))
          .thenAnswer((_) async => Right(testTvSeriesList));
      return bloc;
    },
    act: (bloc) => bloc.add(const OnTvSeriesQueryChanged(tQuery)),
    expect: () => [
      SearchTvSeriesLoading(),
      SearchTvSeriesHasData(testTvSeriesList),
    ],
    verify: (bloc) => verify(mockUsecase.execute(tQuery)),
  );

  blocTest<SearchTvSeriesBloc, SearchTvSeriesState>(
    'should emit [Loading, Error] when getting data fails',
    build: () {
      when(mockUsecase.execute(tQuery))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return bloc;
    },
    act: (bloc) => bloc.add(const OnTvSeriesQueryChanged(tQuery)),
    expect: () => [
      SearchTvSeriesLoading(),
      const SearchTvSeriesError('Server Failure'),
    ],
  );
}

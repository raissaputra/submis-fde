import 'package:bloc_test/bloc_test.dart';
import 'package:core/common/state_enum.dart';
import 'package:tv_series/domain/entities/tv_series.dart';
import 'package:tv_series/presentation/bloc/tv_series/tv_series_detail_bloc.dart';
import 'package:tv_series/presentation/pages/tv_series_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../dummy_data/dummy_objects.dart';

class MockTvSeriesDetailBloc
    extends MockBloc<TvSeriesDetailEvent, TvSeriesDetailState>
    implements TvSeriesDetailBloc {}

class FakeTvSeriesDetailEvent extends Fake implements TvSeriesDetailEvent {}

class FakeTvSeriesDetailState extends Fake implements TvSeriesDetailState {}

void main() {
  late MockTvSeriesDetailBloc mockBloc;

  setUpAll(() {
    registerFallbackValue(FakeTvSeriesDetailEvent());
    registerFallbackValue(FakeTvSeriesDetailState());
  });

  setUp(() {
    mockBloc = MockTvSeriesDetailBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<TvSeriesDetailBloc>.value(
      value: mockBloc,
      child: MaterialApp(home: body),
    );
  }

  final loadedState = TvSeriesDetailState.initial().copyWith(
    tvSeriesState: RequestState.Loaded,
    tvSeries: testTvSeriesDetail,
    recommendationState: RequestState.Loaded,
    tvSeriesRecommendations: <TvSeries>[],
  );

  testWidgets('should display progress bar when loading',
      (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(TvSeriesDetailState.initial()
        .copyWith(tvSeriesState: RequestState.Loading));

    await tester.pumpWidget(makeTestableWidget(TvSeriesDetailPage(id: 1)));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('should display error message when detail fails',
      (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(TvSeriesDetailState.initial()
        .copyWith(
            tvSeriesState: RequestState.Error, message: 'Server Failure'));

    await tester.pumpWidget(makeTestableWidget(TvSeriesDetailPage(id: 1)));

    expect(find.text('Server Failure'), findsOneWidget);
  });

  testWidgets('Watchlist button should display add icon when not added',
      (WidgetTester tester) async {
    when(() => mockBloc.state)
        .thenReturn(loadedState.copyWith(isAddedToWatchlist: false));

    await tester.pumpWidget(makeTestableWidget(TvSeriesDetailPage(id: 1)));

    expect(find.byIcon(Icons.add), findsOneWidget);
  });

  testWidgets('Watchlist button should display check icon when added',
      (WidgetTester tester) async {
    when(() => mockBloc.state)
        .thenReturn(loadedState.copyWith(isAddedToWatchlist: true));

    await tester.pumpWidget(makeTestableWidget(TvSeriesDetailPage(id: 1)));

    expect(find.byIcon(Icons.check), findsOneWidget);
  });

  testWidgets('should display season information', (WidgetTester tester) async {
    when(() => mockBloc.state)
        .thenReturn(loadedState.copyWith(isAddedToWatchlist: false));

    await tester.pumpWidget(makeTestableWidget(TvSeriesDetailPage(id: 1)));

    expect(find.textContaining('Seasons'), findsOneWidget);
    expect(find.text('Season 1'), findsOneWidget);
  });

  testWidgets('should display recommendation list when recommendation loaded',
      (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(loadedState.copyWith(
      recommendationState: RequestState.Loaded,
      tvSeriesRecommendations: testTvSeriesList,
    ));

    await tester.pumpWidget(makeTestableWidget(TvSeriesDetailPage(id: 1)));

    expect(find.text('Recommendations'), findsOneWidget);
  });

  testWidgets('should display progress in recommendation when loading',
      (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(loadedState.copyWith(
      recommendationState: RequestState.Loading,
    ));

    await tester.pumpWidget(makeTestableWidget(TvSeriesDetailPage(id: 1)));

    expect(find.byType(CircularProgressIndicator), findsWidgets);
  });

  testWidgets('should display message when recommendation error',
      (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(loadedState.copyWith(
      recommendationState: RequestState.Error,
      message: 'Failed',
    ));

    await tester.pumpWidget(makeTestableWidget(TvSeriesDetailPage(id: 1)));

    expect(find.text('Failed'), findsOneWidget);
  });

  testWidgets('should display SnackBar when added to watchlist',
      (WidgetTester tester) async {
    final base = loadedState.copyWith(isAddedToWatchlist: false);
    whenListen(
      mockBloc,
      Stream.fromIterable([
        base.copyWith(
            watchlistMessage: TvSeriesDetailBloc.watchlistAddSuccessMessage),
      ]),
      initialState: base,
    );

    await tester.pumpWidget(makeTestableWidget(TvSeriesDetailPage(id: 1)));
    await tester.pump();

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Added to Watchlist'), findsOneWidget);
  });

  testWidgets('should display AlertDialog when add to watchlist failed',
      (WidgetTester tester) async {
    final base = loadedState.copyWith(isAddedToWatchlist: false);
    whenListen(
      mockBloc,
      Stream.fromIterable([
        base.copyWith(watchlistMessage: 'Failed'),
      ]),
      initialState: base,
    );

    await tester.pumpWidget(makeTestableWidget(TvSeriesDetailPage(id: 1)));
    await tester.pump();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Failed'), findsOneWidget);
  });

  testWidgets('tapping watchlist button dispatches add event when not added',
      (WidgetTester tester) async {
    when(() => mockBloc.state)
        .thenReturn(loadedState.copyWith(isAddedToWatchlist: false));

    await tester.pumpWidget(makeTestableWidget(TvSeriesDetailPage(id: 1)));
    await tester.tap(find.byType(FilledButton));
    await tester.pump();

    verify(() => mockBloc.add(OnAddTvSeriesToWatchlist(testTvSeriesDetail)))
        .called(1);
  });

  testWidgets('tapping watchlist button dispatches remove event when added',
      (WidgetTester tester) async {
    when(() => mockBloc.state)
        .thenReturn(loadedState.copyWith(isAddedToWatchlist: true));

    await tester.pumpWidget(makeTestableWidget(TvSeriesDetailPage(id: 1)));
    await tester.tap(find.byType(FilledButton));
    await tester.pump();

    verify(() =>
            mockBloc.add(OnRemoveTvSeriesFromWatchlist(testTvSeriesDetail)))
        .called(1);
  });
}

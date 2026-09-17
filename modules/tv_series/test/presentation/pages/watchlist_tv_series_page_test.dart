import 'package:bloc_test/bloc_test.dart';
import 'package:tv_series/domain/entities/tv_series.dart';
import 'package:tv_series/presentation/bloc/tv_series/watchlist_tv_series_bloc.dart';
import 'package:tv_series/presentation/pages/watchlist_tv_series_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockWatchlistTvSeriesBloc
    extends MockBloc<WatchlistTvSeriesEvent, WatchlistTvSeriesState>
    implements WatchlistTvSeriesBloc {}

class FakeWatchlistTvSeriesEvent extends Fake
    implements WatchlistTvSeriesEvent {}

class FakeWatchlistTvSeriesState extends Fake
    implements WatchlistTvSeriesState {}

void main() {
  late MockWatchlistTvSeriesBloc mockBloc;

  setUpAll(() {
    registerFallbackValue(FakeWatchlistTvSeriesEvent());
    registerFallbackValue(FakeWatchlistTvSeriesState());
  });

  setUp(() {
    mockBloc = MockWatchlistTvSeriesBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<WatchlistTvSeriesBloc>.value(
      value: mockBloc,
      child: MaterialApp(home: body),
    );
  }

  testWidgets('should display progress bar when loading',
      (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(WatchlistTvSeriesLoading());
    await tester.pumpWidget(makeTestableWidget(WatchlistTvSeriesPage()));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('should display ListView when data is loaded',
      (WidgetTester tester) async {
    when(() => mockBloc.state)
        .thenReturn(WatchlistTvSeriesHasData(<TvSeries>[]));
    await tester.pumpWidget(makeTestableWidget(WatchlistTvSeriesPage()));
    expect(find.byType(ListView), findsOneWidget);
  });

  testWidgets('should display error message when error',
      (WidgetTester tester) async {
    when(() => mockBloc.state)
        .thenReturn(const WatchlistTvSeriesError('Error message'));
    await tester.pumpWidget(makeTestableWidget(WatchlistTvSeriesPage()));
    expect(find.byKey(const Key('error_message')), findsOneWidget);
  });

  testWidgets('should display empty state when no request yet',
      (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(WatchlistTvSeriesEmpty());
    await tester.pumpWidget(makeTestableWidget(WatchlistTvSeriesPage()));
    expect(find.byType(ListView), findsNothing);
  });
}

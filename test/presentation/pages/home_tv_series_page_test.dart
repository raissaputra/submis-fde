import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/presentation/bloc/tv_series/now_playing_tv_series_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_series/popular_tv_series_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_series/top_rated_tv_series_bloc.dart';
import 'package:ditonton/presentation/pages/home_tv_series_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../dummy_data/dummy_objects.dart';

class MockNowPlayingTvSeriesBloc
    extends MockBloc<NowPlayingTvSeriesEvent, NowPlayingTvSeriesState>
    implements NowPlayingTvSeriesBloc {}

class MockPopularTvSeriesBloc
    extends MockBloc<PopularTvSeriesEvent, PopularTvSeriesState>
    implements PopularTvSeriesBloc {}

class MockTopRatedTvSeriesBloc
    extends MockBloc<TopRatedTvSeriesEvent, TopRatedTvSeriesState>
    implements TopRatedTvSeriesBloc {}

void main() {
  late MockNowPlayingTvSeriesBloc nowPlayingBloc;
  late MockPopularTvSeriesBloc popularBloc;
  late MockTopRatedTvSeriesBloc topRatedBloc;

  setUp(() {
    nowPlayingBloc = MockNowPlayingTvSeriesBloc();
    popularBloc = MockPopularTvSeriesBloc();
    topRatedBloc = MockTopRatedTvSeriesBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<NowPlayingTvSeriesBloc>.value(value: nowPlayingBloc),
        BlocProvider<PopularTvSeriesBloc>.value(value: popularBloc),
        BlocProvider<TopRatedTvSeriesBloc>.value(value: topRatedBloc),
      ],
      child: MaterialApp(
        home: body,
        onGenerateRoute: (settings) => MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(),
            body: Text('Route: ${settings.name}'),
          ),
        ),
      ),
    );
  }

  void stubData(List<TvSeries> data) {
    when(() => nowPlayingBloc.state)
        .thenReturn(NowPlayingTvSeriesHasData(data));
    when(() => popularBloc.state).thenReturn(PopularTvSeriesHasData(data));
    when(() => topRatedBloc.state).thenReturn(TopRatedTvSeriesHasData(data));
  }

  Future<void> openDrawer(WidgetTester tester) async {
    tester.firstState<ScaffoldState>(find.byType(Scaffold)).openDrawer();
    await tester.pumpAndSettle();
  }

  testWidgets('should display progress bars when all sections are loading',
      (WidgetTester tester) async {
    when(() => nowPlayingBloc.state).thenReturn(NowPlayingTvSeriesLoading());
    when(() => popularBloc.state).thenReturn(PopularTvSeriesLoading());
    when(() => topRatedBloc.state).thenReturn(TopRatedTvSeriesLoading());

    await tester.pumpWidget(makeTestableWidget(HomeTvSeriesPage()));

    expect(find.byType(CircularProgressIndicator), findsNWidgets(3));
  });

  testWidgets('should display tv series lists when data is loaded',
      (WidgetTester tester) async {
    stubData(testTvSeriesList);

    await tester.pumpWidget(makeTestableWidget(HomeTvSeriesPage()));

    expect(find.byType(TvSeriesList), findsNWidgets(3));
    expect(find.text('TV Series'), findsOneWidget);
  });

  testWidgets('should display messages when all sections error',
      (WidgetTester tester) async {
    when(() => nowPlayingBloc.state)
        .thenReturn(const NowPlayingTvSeriesError('Failed'));
    when(() => popularBloc.state)
        .thenReturn(const PopularTvSeriesError('Failed'));
    when(() => topRatedBloc.state)
        .thenReturn(const TopRatedTvSeriesError('Failed'));

    await tester.pumpWidget(makeTestableWidget(HomeTvSeriesPage()));

    expect(find.text('Failed'), findsNWidgets(3));
  });

  testWidgets('should navigate to detail when a tv series poster is tapped',
      (WidgetTester tester) async {
    stubData(testTvSeriesList);

    await tester.pumpWidget(makeTestableWidget(HomeTvSeriesPage()));

    final poster = find
        .descendant(
          of: find.byType(TvSeriesList).first,
          matching: find.byType(InkWell),
        )
        .first;
    await tester.tap(poster);
    await tester.pumpAndSettle();

    expect(find.textContaining('Route:'), findsOneWidget);
  });

  testWidgets('search icon navigates to search page',
      (WidgetTester tester) async {
    stubData(<TvSeries>[]);
    await tester.pumpWidget(makeTestableWidget(HomeTvSeriesPage()));

    await tester.tap(find.byIcon(Icons.search));
    await tester.pumpAndSettle();

    expect(find.textContaining('Route:'), findsOneWidget);
  });

  testWidgets('drawer About item navigates', (WidgetTester tester) async {
    stubData(<TvSeries>[]);
    await tester.pumpWidget(makeTestableWidget(HomeTvSeriesPage()));

    await openDrawer(tester);
    await tester.tap(find.text('About'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Route:'), findsOneWidget);
  });

  testWidgets('drawer Watchlist item navigates', (WidgetTester tester) async {
    stubData(<TvSeries>[]);
    await tester.pumpWidget(makeTestableWidget(HomeTvSeriesPage()));

    await openDrawer(tester);
    await tester.tap(find.text('Watchlist TV Series'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Route:'), findsOneWidget);
  });

  testWidgets('drawer Movies item navigates', (WidgetTester tester) async {
    stubData(<TvSeries>[]);
    await tester.pumpWidget(makeTestableWidget(HomeTvSeriesPage()));

    await openDrawer(tester);
    await tester.tap(find.text('Movies'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Route:'), findsOneWidget);
  });

  testWidgets('drawer TV Series item closes the drawer',
      (WidgetTester tester) async {
    stubData(<TvSeries>[]);
    await tester.pumpWidget(makeTestableWidget(HomeTvSeriesPage()));

    await openDrawer(tester);
    await tester.tap(
      find.descendant(
        of: find.byType(Drawer),
        matching: find.text('TV Series'),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('TV Series'), findsWidgets);
  });
}

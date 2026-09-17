import 'package:bloc_test/bloc_test.dart';
import 'package:movie/domain/entities/movie.dart';
import 'package:movie/presentation/bloc/movie/now_playing_movies_bloc.dart';
import 'package:movie/presentation/bloc/movie/popular_movies_bloc.dart';
import 'package:movie/presentation/bloc/movie/top_rated_movies_bloc.dart';
import 'package:movie/presentation/pages/home_movie_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../dummy_data/dummy_objects.dart';

class MockNowPlayingMoviesBloc
    extends MockBloc<NowPlayingMoviesEvent, NowPlayingMoviesState>
    implements NowPlayingMoviesBloc {}

class MockPopularMoviesBloc
    extends MockBloc<PopularMoviesEvent, PopularMoviesState>
    implements PopularMoviesBloc {}

class MockTopRatedMoviesBloc
    extends MockBloc<TopRatedMoviesEvent, TopRatedMoviesState>
    implements TopRatedMoviesBloc {}

void main() {
  late MockNowPlayingMoviesBloc nowPlayingBloc;
  late MockPopularMoviesBloc popularBloc;
  late MockTopRatedMoviesBloc topRatedBloc;

  setUp(() {
    nowPlayingBloc = MockNowPlayingMoviesBloc();
    popularBloc = MockPopularMoviesBloc();
    topRatedBloc = MockTopRatedMoviesBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<NowPlayingMoviesBloc>.value(value: nowPlayingBloc),
        BlocProvider<PopularMoviesBloc>.value(value: popularBloc),
        BlocProvider<TopRatedMoviesBloc>.value(value: topRatedBloc),
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

  void stubData(List<Movie> data) {
    when(() => nowPlayingBloc.state)
        .thenReturn(NowPlayingMoviesHasData(data));
    when(() => popularBloc.state).thenReturn(PopularMoviesHasData(data));
    when(() => topRatedBloc.state).thenReturn(TopRatedMoviesHasData(data));
  }

  Future<void> openDrawer(WidgetTester tester) async {
    tester.firstState<ScaffoldState>(find.byType(Scaffold)).openDrawer();
    await tester.pumpAndSettle();
  }

  testWidgets('should display progress bars when all sections are loading',
      (WidgetTester tester) async {
    when(() => nowPlayingBloc.state).thenReturn(NowPlayingMoviesLoading());
    when(() => popularBloc.state).thenReturn(PopularMoviesLoading());
    when(() => topRatedBloc.state).thenReturn(TopRatedMoviesLoading());

    await tester.pumpWidget(makeTestableWidget(HomeMoviePage()));

    expect(find.byType(CircularProgressIndicator), findsNWidgets(3));
  });

  testWidgets('should display movie lists when data is loaded',
      (WidgetTester tester) async {
    stubData(testMovieList);

    await tester.pumpWidget(makeTestableWidget(HomeMoviePage()));

    expect(find.byType(MovieList), findsNWidgets(3));
    expect(find.text('Ditonton'), findsOneWidget);
  });

  testWidgets('should display messages when all sections error',
      (WidgetTester tester) async {
    when(() => nowPlayingBloc.state)
        .thenReturn(const NowPlayingMoviesError('Failed'));
    when(() => popularBloc.state)
        .thenReturn(const PopularMoviesError('Failed'));
    when(() => topRatedBloc.state)
        .thenReturn(const TopRatedMoviesError('Failed'));

    await tester.pumpWidget(makeTestableWidget(HomeMoviePage()));

    expect(find.text('Failed'), findsNWidgets(3));
  });

  testWidgets('should navigate to detail when a movie poster is tapped',
      (WidgetTester tester) async {
    stubData(testMovieList);

    await tester.pumpWidget(makeTestableWidget(HomeMoviePage()));

    final poster = find
        .descendant(
          of: find.byType(MovieList).first,
          matching: find.byType(InkWell),
        )
        .first;
    await tester.tap(poster);
    await tester.pumpAndSettle();

    expect(find.textContaining('Route:'), findsOneWidget);
  });

  testWidgets('search icon navigates to search page',
      (WidgetTester tester) async {
    stubData(<Movie>[]);
    await tester.pumpWidget(makeTestableWidget(HomeMoviePage()));

    await tester.tap(find.byIcon(Icons.search));
    await tester.pumpAndSettle();

    expect(find.textContaining('Route:'), findsOneWidget);
  });

  testWidgets('drawer About item navigates', (WidgetTester tester) async {
    stubData(<Movie>[]);
    await tester.pumpWidget(makeTestableWidget(HomeMoviePage()));

    await openDrawer(tester);
    await tester.tap(find.text('About'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Route:'), findsOneWidget);
  });

  testWidgets('drawer Watchlist item navigates', (WidgetTester tester) async {
    stubData(<Movie>[]);
    await tester.pumpWidget(makeTestableWidget(HomeMoviePage()));

    await openDrawer(tester);
    await tester.tap(find.text('Watchlist'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Route:'), findsOneWidget);
  });

  testWidgets('drawer TV Series item navigates', (WidgetTester tester) async {
    stubData(<Movie>[]);
    await tester.pumpWidget(makeTestableWidget(HomeMoviePage()));

    await openDrawer(tester);
    await tester.tap(find.text('TV Series'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Route:'), findsOneWidget);
  });

  testWidgets('drawer Movies item closes the drawer',
      (WidgetTester tester) async {
    stubData(<Movie>[]);
    await tester.pumpWidget(makeTestableWidget(HomeMoviePage()));

    await openDrawer(tester);
    await tester.tap(find.text('Movies'));
    await tester.pumpAndSettle();

    expect(find.text('Ditonton'), findsOneWidget);
  });
}

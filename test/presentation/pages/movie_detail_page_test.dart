import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/presentation/bloc/movie/movie_detail_bloc.dart';
import 'package:ditonton/presentation/pages/movie_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../dummy_data/dummy_objects.dart';

class MockMovieDetailBloc
    extends MockBloc<MovieDetailEvent, MovieDetailState>
    implements MovieDetailBloc {}

class FakeMovieDetailEvent extends Fake implements MovieDetailEvent {}

class FakeMovieDetailState extends Fake implements MovieDetailState {}

void main() {
  late MockMovieDetailBloc mockBloc;

  setUpAll(() {
    registerFallbackValue(FakeMovieDetailEvent());
    registerFallbackValue(FakeMovieDetailState());
  });

  setUp(() {
    mockBloc = MockMovieDetailBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<MovieDetailBloc>.value(
      value: mockBloc,
      child: MaterialApp(home: body),
    );
  }

  final loadedState = MovieDetailState.initial().copyWith(
    movieState: RequestState.Loaded,
    movie: testMovieDetail,
    recommendationState: RequestState.Loaded,
    movieRecommendations: <Movie>[],
  );

  testWidgets('should display progress bar when loading',
      (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(
        MovieDetailState.initial().copyWith(movieState: RequestState.Loading));

    await tester.pumpWidget(makeTestableWidget(MovieDetailPage(id: 1)));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('should display error message when detail fails',
      (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(MovieDetailState.initial()
        .copyWith(movieState: RequestState.Error, message: 'Server Failure'));

    await tester.pumpWidget(makeTestableWidget(MovieDetailPage(id: 1)));

    expect(find.text('Server Failure'), findsOneWidget);
  });

  testWidgets('Watchlist button should display add icon when not in watchlist',
      (WidgetTester tester) async {
    when(() => mockBloc.state)
        .thenReturn(loadedState.copyWith(isAddedToWatchlist: false));

    await tester.pumpWidget(makeTestableWidget(MovieDetailPage(id: 1)));

    expect(find.byIcon(Icons.add), findsOneWidget);
  });

  testWidgets('Watchlist button should display check icon when in watchlist',
      (WidgetTester tester) async {
    when(() => mockBloc.state)
        .thenReturn(loadedState.copyWith(isAddedToWatchlist: true));

    await tester.pumpWidget(makeTestableWidget(MovieDetailPage(id: 1)));

    expect(find.byIcon(Icons.check), findsOneWidget);
  });

  testWidgets('should display recommendation list when recommendation loaded',
      (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(loadedState.copyWith(
      recommendationState: RequestState.Loaded,
      movieRecommendations: testMovieList,
    ));

    await tester.pumpWidget(makeTestableWidget(MovieDetailPage(id: 1)));

    expect(find.text('Recommendations'), findsOneWidget);
  });

  testWidgets('should display progress in recommendation when loading',
      (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(loadedState.copyWith(
      recommendationState: RequestState.Loading,
    ));

    await tester.pumpWidget(makeTestableWidget(MovieDetailPage(id: 1)));

    expect(find.byType(CircularProgressIndicator), findsWidgets);
  });

  testWidgets('should display message when recommendation error',
      (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(loadedState.copyWith(
      recommendationState: RequestState.Error,
      message: 'Failed',
    ));

    await tester.pumpWidget(makeTestableWidget(MovieDetailPage(id: 1)));

    expect(find.text('Failed'), findsOneWidget);
  });

  testWidgets('should display SnackBar when added to watchlist',
      (WidgetTester tester) async {
    final base = loadedState.copyWith(isAddedToWatchlist: false);
    whenListen(
      mockBloc,
      Stream.fromIterable([
        base.copyWith(
            watchlistMessage: MovieDetailBloc.watchlistAddSuccessMessage),
      ]),
      initialState: base,
    );

    await tester.pumpWidget(makeTestableWidget(MovieDetailPage(id: 1)));
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

    await tester.pumpWidget(makeTestableWidget(MovieDetailPage(id: 1)));
    await tester.pump();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Failed'), findsOneWidget);
  });

  testWidgets('tapping watchlist button dispatches add event when not added',
      (WidgetTester tester) async {
    when(() => mockBloc.state)
        .thenReturn(loadedState.copyWith(isAddedToWatchlist: false));

    await tester.pumpWidget(makeTestableWidget(MovieDetailPage(id: 1)));
    await tester.tap(find.byType(FilledButton));
    await tester.pump();

    verify(() => mockBloc.add(OnAddMovieToWatchlist(testMovieDetail)))
        .called(1);
  });

  testWidgets('tapping watchlist button dispatches remove event when added',
      (WidgetTester tester) async {
    when(() => mockBloc.state)
        .thenReturn(loadedState.copyWith(isAddedToWatchlist: true));

    await tester.pumpWidget(makeTestableWidget(MovieDetailPage(id: 1)));
    await tester.tap(find.byType(FilledButton));
    await tester.pump();

    verify(() => mockBloc.add(OnRemoveMovieFromWatchlist(testMovieDetail)))
        .called(1);
  });
}

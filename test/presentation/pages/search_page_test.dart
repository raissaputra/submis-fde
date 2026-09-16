import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/presentation/bloc/movie/search_movies_bloc.dart';
import 'package:ditonton/presentation/pages/search_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSearchMoviesBloc
    extends MockBloc<SearchMoviesEvent, SearchMoviesState>
    implements SearchMoviesBloc {}

class FakeSearchMoviesEvent extends Fake implements SearchMoviesEvent {}

class FakeSearchMoviesState extends Fake implements SearchMoviesState {}

void main() {
  late MockSearchMoviesBloc mockBloc;

  setUpAll(() {
    registerFallbackValue(FakeSearchMoviesEvent());
    registerFallbackValue(FakeSearchMoviesState());
  });

  setUp(() {
    mockBloc = MockSearchMoviesBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<SearchMoviesBloc>.value(
      value: mockBloc,
      child: MaterialApp(home: body),
    );
  }

  testWidgets('should display progress bar when loading',
      (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(SearchMoviesLoading());

    await tester.pumpWidget(makeTestableWidget(SearchPage()));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('should display ListView when data is loaded',
      (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(SearchMoviesHasData(<Movie>[]));

    await tester.pumpWidget(makeTestableWidget(SearchPage()));

    expect(find.byType(ListView), findsOneWidget);
  });

  testWidgets('should display error message when error',
      (WidgetTester tester) async {
    when(() => mockBloc.state)
        .thenReturn(const SearchMoviesError('Error message'));

    await tester.pumpWidget(makeTestableWidget(SearchPage()));

    expect(find.text('Error message'), findsOneWidget);
  });

  testWidgets('should dispatch OnMovieQueryChanged when typing',
      (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(SearchMoviesEmpty());

    await tester.pumpWidget(makeTestableWidget(SearchPage()));
    await tester.enterText(find.byType(TextField), 'spiderman');

    verify(() => mockBloc.add(const OnMovieQueryChanged('spiderman')))
        .called(1);
  });
}

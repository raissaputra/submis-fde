import 'package:bloc_test/bloc_test.dart';
import 'package:tv_series/domain/entities/tv_series.dart';
import 'package:tv_series/presentation/bloc/tv_series/search_tv_series_bloc.dart';
import 'package:tv_series/presentation/pages/search_tv_series_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSearchTvSeriesBloc
    extends MockBloc<SearchTvSeriesEvent, SearchTvSeriesState>
    implements SearchTvSeriesBloc {}

class FakeSearchTvSeriesEvent extends Fake implements SearchTvSeriesEvent {}

class FakeSearchTvSeriesState extends Fake implements SearchTvSeriesState {}

void main() {
  late MockSearchTvSeriesBloc mockBloc;

  setUpAll(() {
    registerFallbackValue(FakeSearchTvSeriesEvent());
    registerFallbackValue(FakeSearchTvSeriesState());
  });

  setUp(() {
    mockBloc = MockSearchTvSeriesBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<SearchTvSeriesBloc>.value(
      value: mockBloc,
      child: MaterialApp(home: body),
    );
  }

  testWidgets('should display progress bar when loading',
      (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(SearchTvSeriesLoading());
    await tester.pumpWidget(makeTestableWidget(SearchTvSeriesPage()));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('should display ListView when data is loaded',
      (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(SearchTvSeriesHasData(<TvSeries>[]));
    await tester.pumpWidget(makeTestableWidget(SearchTvSeriesPage()));
    expect(find.byType(ListView), findsOneWidget);
  });

  testWidgets('should display error message when error',
      (WidgetTester tester) async {
    when(() => mockBloc.state)
        .thenReturn(const SearchTvSeriesError('Error message'));
    await tester.pumpWidget(makeTestableWidget(SearchTvSeriesPage()));
    expect(find.text('Error message'), findsOneWidget);
  });

  testWidgets('should dispatch OnTvSeriesQueryChanged when typing',
      (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(SearchTvSeriesEmpty());
    await tester.pumpWidget(makeTestableWidget(SearchTvSeriesPage()));
    await tester.enterText(find.byType(TextField), 'squid');
    verify(() => mockBloc.add(const OnTvSeriesQueryChanged('squid')))
        .called(1);
  });
}

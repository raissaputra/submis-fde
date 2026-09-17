import 'package:bloc_test/bloc_test.dart';
import 'package:tv_series/domain/entities/tv_series.dart';
import 'package:tv_series/presentation/bloc/tv_series/top_rated_tv_series_bloc.dart';
import 'package:tv_series/presentation/pages/top_rated_tv_series_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTopRatedTvSeriesBloc
    extends MockBloc<TopRatedTvSeriesEvent, TopRatedTvSeriesState>
    implements TopRatedTvSeriesBloc {}

class FakeTopRatedTvSeriesEvent extends Fake implements TopRatedTvSeriesEvent {}

class FakeTopRatedTvSeriesState extends Fake implements TopRatedTvSeriesState {}

void main() {
  late MockTopRatedTvSeriesBloc mockBloc;

  setUpAll(() {
    registerFallbackValue(FakeTopRatedTvSeriesEvent());
    registerFallbackValue(FakeTopRatedTvSeriesState());
  });

  setUp(() {
    mockBloc = MockTopRatedTvSeriesBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<TopRatedTvSeriesBloc>.value(
      value: mockBloc,
      child: MaterialApp(home: body),
    );
  }

  testWidgets('should display progress bar when loading',
      (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(TopRatedTvSeriesLoading());
    await tester.pumpWidget(makeTestableWidget(TopRatedTvSeriesPage()));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('should display ListView when data is loaded',
      (WidgetTester tester) async {
    when(() => mockBloc.state)
        .thenReturn(TopRatedTvSeriesHasData(<TvSeries>[]));
    await tester.pumpWidget(makeTestableWidget(TopRatedTvSeriesPage()));
    expect(find.byType(ListView), findsOneWidget);
  });

  testWidgets('should display error message when error',
      (WidgetTester tester) async {
    when(() => mockBloc.state)
        .thenReturn(const TopRatedTvSeriesError('Error message'));
    await tester.pumpWidget(makeTestableWidget(TopRatedTvSeriesPage()));
    expect(find.byKey(const Key('error_message')), findsOneWidget);
  });

  testWidgets('should display empty state when no request yet',
      (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(TopRatedTvSeriesEmpty());
    await tester.pumpWidget(makeTestableWidget(TopRatedTvSeriesPage()));
    expect(find.byType(ListView), findsNothing);
  });
}

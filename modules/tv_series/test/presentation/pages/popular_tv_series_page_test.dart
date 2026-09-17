import 'package:bloc_test/bloc_test.dart';
import 'package:tv_series/domain/entities/tv_series.dart';
import 'package:tv_series/presentation/bloc/tv_series/popular_tv_series_bloc.dart';
import 'package:tv_series/presentation/pages/popular_tv_series_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockPopularTvSeriesBloc
    extends MockBloc<PopularTvSeriesEvent, PopularTvSeriesState>
    implements PopularTvSeriesBloc {}

class FakePopularTvSeriesEvent extends Fake implements PopularTvSeriesEvent {}

class FakePopularTvSeriesState extends Fake implements PopularTvSeriesState {}

void main() {
  late MockPopularTvSeriesBloc mockBloc;

  setUpAll(() {
    registerFallbackValue(FakePopularTvSeriesEvent());
    registerFallbackValue(FakePopularTvSeriesState());
  });

  setUp(() {
    mockBloc = MockPopularTvSeriesBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<PopularTvSeriesBloc>.value(
      value: mockBloc,
      child: MaterialApp(home: body),
    );
  }

  testWidgets('should display progress bar when loading',
      (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(PopularTvSeriesLoading());
    await tester.pumpWidget(makeTestableWidget(PopularTvSeriesPage()));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('should display ListView when data is loaded',
      (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(PopularTvSeriesHasData(<TvSeries>[]));
    await tester.pumpWidget(makeTestableWidget(PopularTvSeriesPage()));
    expect(find.byType(ListView), findsOneWidget);
  });

  testWidgets('should display error message when error',
      (WidgetTester tester) async {
    when(() => mockBloc.state)
        .thenReturn(const PopularTvSeriesError('Error message'));
    await tester.pumpWidget(makeTestableWidget(PopularTvSeriesPage()));
    expect(find.byKey(const Key('error_message')), findsOneWidget);
  });

  testWidgets('should display empty state when no request yet',
      (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(PopularTvSeriesEmpty());
    await tester.pumpWidget(makeTestableWidget(PopularTvSeriesPage()));
    expect(find.byType(ListView), findsNothing);
  });
}

import 'package:ditonton/presentation/pages/tv_series_detail_page.dart';
import 'package:ditonton/presentation/widgets/tv_series_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../dummy_data/dummy_objects.dart';

void main() {
  Widget _makeTestableWidget(Widget body) {
    return MaterialApp(
      home: Scaffold(body: body),
      onGenerateRoute: (settings) {
        if (settings.name == TvSeriesDetailPage.ROUTE_NAME) {
          return MaterialPageRoute(
            builder: (_) => Scaffold(body: Text('Detail Page')),
          );
        }
        return null;
      },
    );
  }

  testWidgets('TvSeriesCard should display name and overview',
      (WidgetTester tester) async {
    await tester.pumpWidget(_makeTestableWidget(TvSeriesCard(testTvSeries)));

    expect(find.text('Name'), findsOneWidget);
    expect(find.text('Overview'), findsOneWidget);
  });

  testWidgets('TvSeriesCard should navigate to detail when tapped',
      (WidgetTester tester) async {
    await tester.pumpWidget(_makeTestableWidget(TvSeriesCard(testTvSeries)));

    await tester.tap(find.byType(InkWell));
    await tester.pumpAndSettle();

    expect(find.text('Detail Page'), findsOneWidget);
  });
}

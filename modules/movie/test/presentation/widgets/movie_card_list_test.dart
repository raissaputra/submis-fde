import 'package:movie/presentation/pages/movie_detail_page.dart';
import 'package:movie/presentation/widgets/movie_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../dummy_data/dummy_objects.dart';

void main() {
  Widget _makeTestableWidget(Widget body) {
    return MaterialApp(
      home: Scaffold(body: body),
      onGenerateRoute: (settings) {
        if (settings.name == MovieDetailPage.ROUTE_NAME) {
          return MaterialPageRoute(
            builder: (_) => Scaffold(body: Text('Detail Page')),
          );
        }
        return null;
      },
    );
  }

  testWidgets('MovieCard should display title and overview',
      (WidgetTester tester) async {
    await tester.pumpWidget(_makeTestableWidget(MovieCard(testMovie)));

    expect(find.text('Spider-Man'), findsOneWidget);
  });

  testWidgets('MovieCard should navigate to detail when tapped',
      (WidgetTester tester) async {
    await tester.pumpWidget(_makeTestableWidget(MovieCard(testMovie)));

    await tester.tap(find.byType(InkWell));
    await tester.pumpAndSettle();

    expect(find.text('Detail Page'), findsOneWidget);
  });
}

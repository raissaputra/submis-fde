import 'package:ditonton/presentation/pages/about_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('AboutPage should display description text and back button',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: AboutPage()));

    expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    expect(
      find.textContaining('Ditonton merupakan sebuah aplikasi katalog film'),
      findsOneWidget,
    );
  });

  testWidgets('AboutPage back button should pop the route',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Builder(
        builder: (context) => ElevatedButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AboutPage()),
          ),
          child: Text('Go'),
        ),
      ),
    ));

    await tester.tap(find.text('Go'));
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.arrow_back), findsOneWidget);

    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();
    expect(find.text('Go'), findsOneWidget);
  });
}

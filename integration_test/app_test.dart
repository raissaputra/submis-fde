import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:ditonton/injection.dart' as di;
import 'package:ditonton/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    await di.locator.reset();
  });

  group('Ditonton end-to-end', () {
    testWidgets('app boots and shows the movie home page', (tester) async {
      await app.main();
      await tester.pump(const Duration(seconds: 3));

      expect(find.text('Ditonton'), findsOneWidget);
      expect(find.text('Now Playing'), findsOneWidget);
    });

    testWidgets('user can navigate from movies to the TV series page',
        (tester) async {
      await app.main();
      await tester.pump(const Duration(seconds: 3));

      // Open the navigation drawer.
      final scaffoldState = tester.firstState<ScaffoldState>(
        find.byType(Scaffold),
      );
      scaffoldState.openDrawer();
      await tester.pump(const Duration(seconds: 1));

      expect(find.text('TV Series'), findsWidgets);

      // Navigate to the TV Series home page.
      await tester.tap(find.text('TV Series').last);
      await tester.pump(const Duration(seconds: 3));

      expect(find.text('Now Playing'), findsOneWidget);
      expect(find.text('Popular'), findsOneWidget);
      expect(find.text('Top Rated'), findsOneWidget);
    });
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:leaguestats_mobile/features/news/ui/news_detail_page.dart';

void main() {
  testWidgets('NewsDetailPage renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: NewsDetailPage(),
      ),
    );
    tester.takeException();

    // Verify title
    expect(find.text('MKOI arrasa en una partida decisiva contra Fnatic'), findsOneWidget);

    // Verify author
    expect(find.text('Harry Harper'), findsOneWidget);

    // Verify some section title
    expect(find.text('Dominio desde el Early Game'), findsOneWidget);

    // Verify button
    expect(find.text('Read Comments'), findsOneWidget);

    // Verify back button exists
    expect(find.byIcon(Icons.arrow_back), findsOneWidget);
  });
}

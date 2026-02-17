import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:leaguestats_mobile/features/news/news.dart';

void main() {
  testWidgets('NewsPage builds correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: NewsPage()));

    // Consume the expected NetworkImageLoadException to prevent test failure
    tester.takeException();

    expect(find.byType(NewsPage), findsOneWidget);
    expect(find.text('Noticias'), findsAtLeastNWidgets(1));
    // We use findsAtLeastNWidgets(1) because ListView might not render all if it's small,
    // though in standard tests it usually renders some.
    expect(find.byType(NewsCard), findsAtLeastNWidgets(1));
  });

  testWidgets('NewsCard builds correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: NewsCard(
            tag: 'TEST',
            time: '1h',
            title: 'Test Title',
            description: 'Test Description',
            imageUrl: 'https://example.com/image.png',
          ),
        ),
      ),
    );

    // Consume the expected NetworkImageLoadException
    tester.takeException();

    expect(find.text('TEST'), findsOneWidget);
    expect(find.text('Test Title'), findsOneWidget);
    expect(find.text('Test Description'), findsOneWidget);
  });
}

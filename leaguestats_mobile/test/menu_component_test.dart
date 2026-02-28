import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:leaguestats_mobile/features/login/ui/menu_component.dart';

void main() {
  testWidgets('MenuComponent builds correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: MenuComponent(),
        ),
      ),
    );
    tester.takeException();

    // Handle NetworkImage exceptions in tests
    tester.takeException();

    // Verify that the logo text is present
    expect(
      find.byWidgetPredicate((widget) =>
          widget is RichText && widget.text.toPlainText().contains('LEAGUE')),
      findsOneWidget,
    );
    expect(
      find.byWidgetPredicate((widget) =>
          widget is RichText && widget.text.toPlainText().contains('STATS')),
      findsOneWidget,
    );

    // Verify that some menu items are present
    expect(find.text('Noticias'), findsOneWidget);
    expect(find.text('Premium'), findsOneWidget);

    // Verify profile name
    expect(find.text('Alex Rivera'), findsOneWidget);
  });
}

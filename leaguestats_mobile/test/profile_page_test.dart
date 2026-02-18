import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:leaguestats_mobile/features/profile/profile.dart';

void main() {
  testWidgets('ProfilePageView renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: ProfilePageView(),
      ),
    );

    // Handle NetworkImage exceptions
    tester.takeException();

    // Verify profile name
    expect(find.text('Faker_Fan_99'), findsOneWidget);
    expect(find.text('@faker_fan_99'), findsOneWidget);

    // Verify stats
    expect(find.text('2.5k'), findsOneWidget);
    expect(find.text('FOLLOWERS'), findsOneWidget);
    expect(find.text('150'), findsOneWidget);
    expect(find.text('FOLLOWING'), findsOneWidget);
    expect(find.text('342'), findsOneWidget);
    expect(find.text('MATCHES'), findsOneWidget);

    // Verify buttons
    expect(find.text('Edit Profile'), findsOneWidget);
    expect(find.byIcon(Icons.share_outlined), findsOneWidget);

    // Verify Information section
    expect(find.text('INFORMATION'), findsOneWidget);
    expect(find.text('Rank'), findsOneWidget);
    expect(find.text('Diamond I'), findsOneWidget);
    expect(find.text('Favorite Team'), findsOneWidget);
    expect(find.text('T1 Esports'), findsOneWidget);
  });
}

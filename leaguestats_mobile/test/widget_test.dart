import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:leaguestats_mobile/features/champion_detail/ui/champion_detail_view.dart';

void main() {
  testWidgets('Champion Detail View renders correctly', (WidgetTester tester) async {
    // Increase surface size to avoid off-screen issues
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;

    // Build our widget and trigger a frame.
    // We use a custom error handler to ignore image network errors during test
    final originalOnError = FlutterError.onError;
    FlutterError.onError = (FlutterErrorDetails details) {
      if (details.silent) return;
      if (details.exception.toString().contains('NetworkImageLoadException') ||
          details.exception.toString().contains('HTTP request failed')) {
        return;
      }
      originalOnError?.call(details);
    };

    await tester.pumpWidget(const MaterialApp(home: ChampionDetailView()));

    // Verify that champion name is present
    expect(find.text('EZREAL'), findsAtLeastNWidgets(1));

    // Verify skill detail card initially shows Q
    expect(find.text('DISPARO MÍSTICO'), findsOneWidget);

    // Tap on another skill (the first one, Passive)
    // Skill icons are the Image widgets.
    final skillIcons = find.byType(Image);
    expect(skillIcons, findsNWidgets(5));

    await tester.ensureVisible(skillIcons.at(0));
    await tester.tap(skillIcons.at(0));
    await tester.pump();

    // Verify description changed (Pasiva description)
    // Now "PASIVA" should appear twice (title and key)
    expect(find.text('PASIVA'), findsNWidgets(2));
    expect(find.textContaining('Ezreal gana velocidad de ataque'), findsOneWidget);

    // Restore error handler
    FlutterError.onError = originalOnError;
  });
}

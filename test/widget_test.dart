// This is a basic Flutter widget test.

import 'package:flutter_test/flutter_test.dart';
import 'package:starbuck_app/main.dart';

void main() {
  testWidgets('Starbucks app launches', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const StarbucksApp());

    // Verify the app builds without errors
    expect(find.byType(StarbucksApp), findsOneWidget);
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:my_rabai/app.dart';

void main() {
  testWidgets('App basic smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyRabaiApp());

    // Verify that our app builds without crashing
    expect(find.byType(MyRabaiApp), findsOneWidget);
  });
}
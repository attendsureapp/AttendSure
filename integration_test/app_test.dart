import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:SmartTrack/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('App startup test', (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();

    // Verify that the app starts and shows something (e.g., Login screen or similar)
    // Since we don't know exactly what the first screen is without running it,
    // we can just check if it doesn't crash.
    // Or we can check for a common widget like Scaffold.
    expect(find.byType(app.MyApp), findsOneWidget);
  });
}

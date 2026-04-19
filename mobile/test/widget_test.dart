import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hydraflow/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    // Since this app uses Riverpod, we wrap the app in a ProviderScope.
    await tester.pumpWidget(const ProviderScope(child: HydraFlowApp()));

    // Success if we find the app title or a key widget
    expect(find.text('HydraFlow'), findsOneWidget);
  });
}

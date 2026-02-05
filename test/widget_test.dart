import 'package:flutter_test/flutter_test.dart';
import 'package:investment_app/main.dart';

void main() {
  testWidgets('App renders without crashing', (WidgetTester tester) async {
    expectLater(
      () => tester.pumpWidget(const MyApp()),
      returnsNormally,
    );
  });
}

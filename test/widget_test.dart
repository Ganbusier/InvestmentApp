import 'package:flutter_test/flutter_test.dart';
import 'package:investment_app/main.dart';

void main() {
  testWidgets('App renders without crashing', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('理财App'), findsOneWidget);
  });
}

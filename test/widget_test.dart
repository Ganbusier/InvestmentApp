import 'package:flutter_test/flutter_test.dart';
import 'package:investment_app/main.dart';

void main() {
  testWidgets('App renders without crashing', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('永久投资组合模拟器'), findsOneWidget);
  });
}

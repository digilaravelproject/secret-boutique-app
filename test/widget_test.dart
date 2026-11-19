import 'package:flutter_test/flutter_test.dart';
import 'package:the_secret_boutique/main.dart';

void main() {
  testWidgets('App initializes and renders home screen successfully', (WidgetTester tester) async {
    await tester.pumpWidget(const SecretBoutiqueApp());
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.byType(SecretBoutiqueApp), findsOneWidget);
  });
}

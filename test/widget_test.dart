import 'package:flutter_test/flutter_test.dart';
import 'package:smiley_painter/main.dart';

void main() {
  testWidgets('Smiley Painter app loads correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const SmileyApp());

    expect(find.text('CustomPainter Smiley Lab'), findsOneWidget);
    expect(find.text('Face: Classic'), findsOneWidget);
    expect(find.text('Classic'), findsOneWidget);
    expect(find.text('Sleepy'), findsOneWidget);
    expect(find.text('Surprised'), findsOneWidget);
    expect(find.text('Mood: 0.80'), findsOneWidget);
  });
}
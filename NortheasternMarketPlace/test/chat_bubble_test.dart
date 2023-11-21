import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gtk_flutter/Chat.dart';
import 'package:gtk_flutter/chat_bubble_widget.dart';

void main() {
  testWidgets('past message', (WidgetTester tester) async {
    DateTime timestamp = DateTime(2023, 1, 1, 1, 0, 0);
    final message = Message(
      text: "text",
      sender: "sender",
      timestamp: timestamp,
    );
    await tester.pumpWidget(
      MaterialApp(
        home: ChatBubble(
          message: message,
          isCurrentUser: true,
        ),
      ),
    );
    var formattedTime = '1/1/2023 1:00AM';
    var semanticLabel = 'January 1, 2023 1:00AM';

    expect(find.text('text'), findsOneWidget);
    expect(find.textContaining(formattedTime), findsOneWidget);
    expect(find.bySemanticsLabel(semanticLabel), findsOneWidget);
  });

  testWidgets('current date', (WidgetTester tester) async {
    final message = Message(
      text: "text",
      sender: "sender",
      timestamp: DateTime.now(),
    );
    await tester.pumpWidget(
      MaterialApp(
        home: ChatBubble(
          message: message,
          isCurrentUser: true,
        ),
      ),
    );
    expect(find.textContaining("Today"), findsOneWidget);
  });

  testWidgets('current date and accessibility', (WidgetTester tester) async {
    final message = Message(
      text: "text",
      sender: "sender",
      timestamp: DateTime.now(),
    );
    await tester.pumpWidget(
      MaterialApp(
        home: ChatBubble(
          message: message,
          isCurrentUser: true,
        ),
      ),
    );

    await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
    await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
    await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
    await expectLater(tester, meetsGuideline(textContrastGuideline));
  });
}

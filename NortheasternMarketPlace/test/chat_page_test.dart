import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gtk_flutter/chat_bubble_widget.dart';
import 'package:provider/provider.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:gtk_flutter/Address.dart';
import 'package:gtk_flutter/User.dart';
import 'package:gtk_flutter/chat_page.dart';
import 'package:gtk_flutter/login.dart';

void main() {
  group('ChatPage', () {
    late FakeFirebaseFirestore instance;
    late User user;
    late UserProvider userProvider;

    setUpAll(() async {
      instance = FakeFirebaseFirestore();
      user = User(
          username: "username",
          firstName: "firstName",
          lastName: "lastName",
          password: "password",
          campus: "campus",
          email: "email",
          address: Address(
              streetName: "streetName",
              unitNo: "unitNo",
              city: "city",
              state: "state",
              zipcode: "zipcode"),
          profilePicture: "profilePicture");
      userProvider = UserProvider();
      userProvider.setUser(user);
      instance.collection('Conversations').doc('1234').set({
        'user': 'username',
        'chats': [
          {
            'user': 'username',
            'other': 'otheruser',
            'messages': [
              {
                'sender': 'username',
                'text': 'text1',
                'timestamp': DateTime.now().toIso8601String()
              },
            ]
          }
        ]
      });
    });

    testWidgets('Rendering', (WidgetTester tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider.value(
          value: userProvider,
          child: MaterialApp(
            home: ChatPage(
              firebaseFirestore: instance,
              other: 'otheruser',
            ),
          ),
        ),
      );

      expect(find.text('Northeastern Marketplace'), findsOneWidget);
      expect(find.text('@otheruser'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Send'), findsOneWidget);
    });

    testWidgets(
        'sending a message displays it on the chat page and navigate to their profile',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider.value(
          value: userProvider,
          child: MaterialApp(
            home: ChatPage(
              firebaseFirestore: instance,
              other: 'otheruser',
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final textFieldFinder = find.byType(TextField);
      await tester.enterText(textFieldFinder, 'Hello!');
      final sendButtonFinder = find.widgetWithText(ElevatedButton, 'Send');
      await tester.tap(sendButtonFinder);
      await tester.pumpAndSettle();
      final chatBubbleFinder = find.widgetWithText(ChatBubble, 'Hello!');
      expect(chatBubbleFinder, findsOneWidget);
      await tester.longPress(find.byType(TextButton));
      await tester.pump();
    });

    testWidgets('press back button', (WidgetTester tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider.value(
          value: userProvider,
          child: MaterialApp(
            home: ChatPage(
              firebaseFirestore: instance,
              other: 'otheruser',
            ),
          ),
        ),
      );
      await tester.tap(find.byType(TextField));
      await tester.pump();
      await tester.tap(find.text('Send'));
      await tester.pumpAndSettle();
      await tester.longPress(find.byIcon(Icons.arrow_back));
      await tester.pump();
    });
  });
}
//flutter test --coverage
//genhtml coverage/lcov.info -o coverage/html

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:gtk_flutter/Address.dart';
import 'package:gtk_flutter/User.dart';
import 'package:gtk_flutter/chat_history.dart';
import 'package:gtk_flutter/login.dart';

void main() {
  group('ChatHistory', () {
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
      await instance.collection('Conversations').doc('1234').set({
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
            home: ChatHistory(
              firebaseFirestore: instance,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
      await tester.enterText(find.byType(TextField), 'username');
      expect(find.text('username'), findsOneWidget);
    });
  });
}
//flutter test --coverage
//genhtml coverage/lcov.info -o coverage/html

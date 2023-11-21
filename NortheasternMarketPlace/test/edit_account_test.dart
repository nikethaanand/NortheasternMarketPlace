import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:gtk_flutter/Address.dart';
import 'package:gtk_flutter/User.dart';
import 'package:gtk_flutter/login.dart';

void main() {
  group('Edit Account Form', () {
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
          campus: "Seattle",
          email: "email",
          address: Address(
              streetName: "streetName",
              unitNo: "unitNo",
              city: "city",
              state: "state",
              zipcode: "zipcode"),
          profilePicture: "profilePicture");
      await instance.collection("Users").add(user.toJson());
      userProvider = UserProvider();
      userProvider.setUser(user);
    });
    testWidgets('form logic', (WidgetTester tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider.value(
          value: userProvider,
          child: MaterialApp(
            home: EditAccountForm(
              firebaseFirestore: instance,
              user: user,
            ),
          ),
        ),
      );
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
      expect(find.byIcon(Icons.person), findsOneWidget);
      expect(
          (find
                  .widgetWithText(TextFormField, 'Full Name')
                  .evaluate()
                  .single
                  .widget as TextFormField)
              .initialValue,
          user.getFullName());
      expect(find.byIcon(Icons.email), findsOneWidget);
      expect(
          (find
                  .widgetWithText(TextFormField, 'NEU Email')
                  .evaluate()
                  .single
                  .widget as TextFormField)
              .initialValue,
          user.email);
      expect(find.byIcon(Icons.school), findsOneWidget);
      expect(find.byIcon(Icons.map), findsOneWidget);
      expect(
          (find
                  .widgetWithText(TextFormField, 'Street Name')
                  .evaluate()
                  .single
                  .widget as TextFormField)
              .initialValue,
          user.address.streetName);
      expect(
          (find
                  .widgetWithText(TextFormField, 'Unit Number')
                  .evaluate()
                  .single
                  .widget as TextFormField)
              .initialValue,
          user.address.unitNo);
      expect(
          (find.widgetWithText(TextFormField, 'City').evaluate().single.widget
                  as TextFormField)
              .initialValue,
          user.address.city);
      expect(
          (find.widgetWithText(TextFormField, 'State').evaluate().single.widget
                  as TextFormField)
              .initialValue,
          user.address.state);
      expect(
          (find
                  .widgetWithText(TextFormField, 'Zipcode')
                  .evaluate()
                  .single
                  .widget as TextFormField)
              .initialValue,
          user.address.zipcode);
      expect(find.byIcon(Icons.add_a_photo), findsOneWidget);
    });
  });
}
//flutter test --coverage
//genhtml coverage/lcov.info -o coverage/html

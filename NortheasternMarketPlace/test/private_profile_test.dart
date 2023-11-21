import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gtk_flutter/private_profile.dart';
import 'package:provider/provider.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:gtk_flutter/Address.dart';
import 'package:gtk_flutter/User.dart';
import 'package:gtk_flutter/login.dart';

void main() {
  group('PrivateProfilePage', () {
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
        profilePicture: '',
      );
      userProvider = UserProvider();
      userProvider.setUser(user);
      instance.collection('Users').doc('1234').set(user.toJson());
    });

    testWidgets('Rendering', (WidgetTester tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider.value(
          value: userProvider,
          child: MaterialApp(
            home: PrivateProfilePage(
              firebaseFirestore: instance,
            ),
          ),
        ),
      );
    });
  });
}
//flutter test --coverage
//genhtml coverage/lcov.info -o coverage/html

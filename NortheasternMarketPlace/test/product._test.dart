import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gtk_flutter/Address.dart';
import 'package:gtk_flutter/User.dart';
import 'package:gtk_flutter/login.dart';
import 'package:gtk_flutter/products.dart';
import 'package:provider/provider.dart';

void main() {
  group('group name', () {
    FirebaseFirestore instance;
    var user;
    late UserProvider userProvider;

    instance = FakeFirebaseFirestore();
    instance.collection('posts').doc("abddfed").set({
      'username': '_username',
      'productName': "_productName",
      'price': "_price",
      'imageURL': "url",
      'description': "_description",
      'pickupAddress': "_pickupAddress",
      'category': "_selectedCategory",
      'condition': "_selectedCondition",
      'timestamp': "",
      'status': "Available" // add timestamp field;
    });
    setUpAll(() {
    });

    testWidgets('description', (tester) async {
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
      await tester.pumpWidget(ChangeNotifierProvider.value(
        value: userProvider,
        child: MaterialApp(
          home: Product(firebaseFirestore: instance),
        ),
      ));

       expect(find.text('Northeastern Marketplace'), findsOneWidget);
    });

    // testWidgets('Rendering', (WidgetTester tester) async {
    //   await tester.pumpWidget(
    //     ChangeNotifierProvider.value(
    //       value: userProvider,
    //       child: MaterialApp(
    //         home: Product(
    //           firebaseFirestore: instance,
    //         ),
    //       ),
    //     ),
    //   );

    //   expect(find.text('Northeastern Marketplace'), findsOneWidget);
    //   expect(find.byType(TextField), findsOneWidget);
    //   expect(find.text('View'), findsOneWidget);
    // });

   
  });
}

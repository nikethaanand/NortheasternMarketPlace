import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gtk_flutter/Address.dart';
import 'package:gtk_flutter/User.dart';
import 'package:gtk_flutter/login.dart';
import 'package:gtk_flutter/products.dart';
import 'package:gtk_flutter/userProductsAvail.dart';
import 'package:gtk_flutter/userProductsSold.dart';
import 'package:provider/provider.dart';

void main() {

 testWidgets('ElevatedButton', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: ElevatedButton(
        onPressed: () {},
        child: Text('Mark as Sold'),
      ),
    ));
    expect(find.text('Mark as Sold'), findsWidgets);
  });
  
  group('group name', () {
    FirebaseFirestore instance;
    var user;
    UserProvider userProvider;

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
      'status': "Sold" // add timestamp field;
    });
    setUpAll(() {
      // instance = FakeFirebaseFirestore();
      // instance.collection('posts').doc("abddfed").set({
      // 'username': '_username',
      // 'product name': "_productName",
      // 'price': "_price",
      // 'image URL': "url",
      // 'description': "_description",
      // 'pickup address': "_pickupAddress",
      // 'category': "_selectedCategory",
      // 'condition': "_selectedCondition",
      // 'times': ""  // add timestamp field;
      // });
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
          home: productsSold(firebaseFirestore: instance),
        ),
      ));
    });
  });
}

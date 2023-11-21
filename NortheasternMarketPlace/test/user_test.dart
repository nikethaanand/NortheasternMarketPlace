import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gtk_flutter/User.dart';
import 'package:gtk_flutter/Address.dart';

void main() async {
  group('User', () {
    test('non-database related', () {
      final user = User(
        username: 'alying',
        firstName: 'John',
        lastName: 'Doe',
        password: '1122',
        campus: 'Seattle',
        email: 'ying.al@northeastern.edu',
        address: Address(
          streetName: '255 Terry Ave N',
          unitNo: '',
          city: 'Seattle',
          state: 'WA',
          zipcode: '98104',
        ),
        profilePicture: '',
      );
      expect(user.getFullName(), 'John Doe');
      user.setFullName('Allison Ying');
      expect(user.firstName, 'Allison');
      expect(user.lastName, 'Ying');

      expect(user.toJson(), {
        'username': 'alying',
        'firstName': 'Allison',
        'lastName': 'Ying',
        'email': 'ying.al@northeastern.edu',
        'password': '1122',
        'campus': 'Seattle',
        'address': {
          'streetName': '255 Terry Ave N',
          'unitNo': '',
          'city': 'Seattle',
          'state': 'WA',
          'zipCode': '98104',
        },
        'profilePicture': '',
      });

      expect(
          User.fromJson({
            'username': 'alying',
            'firstName': 'Allison',
            'lastName': 'Ying',
            'email': 'ying.al@northeastern.edu',
            'password': '1122',
            'campus': 'Seattle',
            'address': {
              'streetName': '255 Terry Ave N',
              'unitNo': '',
              'city': 'Seattle',
              'state': 'WA',
              'zipCode': '98104',
            },
            'profilePicture': '',
          }).toString(),
          user.toString());
      User user2 = new User(
        username: 'alying',
        firstName: 'John',
        lastName: 'Doe',
        password: '1122',
        campus: 'Seattle',
        email: 'ying.al@northeastern.edu',
        address: Address(
          streetName: '',
          unitNo: '',
          city: '',
          state: '',
          zipcode: '',
        ),
        profilePicture: '',
      );
      expect(
          User.fromJson({
            'username': 'alying',
            'firstName': 'Allison',
            'lastName': 'Ying',
            'email': 'ying.al@northeastern.edu',
            'password': '1122',
            'campus': 'Seattle',
          }).toString(),
          user2.toString());
    });

    test('read', () async {
      final fakeFirestore = FakeFirebaseFirestore();
      // add a user to the fake firestore
      await fakeFirestore.collection('Users').doc("1234").set({
        'username': 'alying',
        'firstName': 'Allison',
        'lastName': 'Ying',
        'email': 'ying.al@northeastern.edu',
        'password': '1122',
        'campus': 'Seattle',
        'address': {
          'streetName': '255 Terry Ave N',
          'unitNo': '',
          'city': 'Seattle',
          'state': 'WA',
          'zipCode': '98104',
        },
        'profilePicture': '',
      });

      // retrieve the user from the fake firestore
      User user = await User.read(fakeFirestore, 'alying');
      expect(user.username, 'alying');
      expect(user.firstName, 'Allison');
      expect(user.lastName, 'Ying');
      expect(user.email, 'ying.al@northeastern.edu');
      expect(user.password, '1122');
      expect(user.campus, 'Seattle');
      expect(user.address.streetName, '255 Terry Ave N');
      expect(user.address.unitNo, '');
      expect(user.address.city, 'Seattle');
      expect(user.address.state, 'WA');
      expect(user.address.zipcode, '98104');
    });
  });
}
//flutter test --coverage
//genhtml coverage/lcov.info -o coverage/html

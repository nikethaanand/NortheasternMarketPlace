import 'package:flutter_test/flutter_test.dart';
import 'package:gtk_flutter/Address.dart';

void main() {
  test('fromJson', () {
    final address1 = Address(
      streetName: '221 Terry Ave N',
      unitNo: '101',
      city: 'Seattle',
      state: 'WA',
      zipcode: '98109',
    );
    final json = {
      'streetName': '221 Terry Ave N',
      'unitNo': '101',
      'city': 'Seattle',
      'state': 'WA',
      'zipCode': '98109',
    };
    final address = Address.fromJson(json);
    expect(address.toString(), equals(address1.toString()));
  });

  test('toJson', () {
    final address1 = Address(
      streetName: '221 Terry Ave N',
      unitNo: '101',
      city: 'Seattle',
      state: 'WA',
      zipcode: '98109',
    );
    final json = {
      'streetName': '221 Terry Ave N',
      'unitNo': '101',
      'city': 'Seattle',
      'state': 'WA',
      'zipCode': '98109',
    };
    expect(address1.toJson(), equals(json));
  });
  test('toString() method', () {
    final address1 = Address(
      streetName: '221 Terry Ave N',
      unitNo: '101',
      city: 'Seattle',
      state: 'WA',
      zipcode: '98109',
    );
    final expectedString = '221 Terry Ave N, \nUnit 101 \nSeattle, WA, 98109';
    expect(address1.toString(), equals(expectedString));
    final address2 = Address(
      streetName: '',
      unitNo: '',
      city: '',
      state: '',
      zipcode: '',
    );
    final errorMessage = "No address information";
    expect(address2.toString(), equals(errorMessage));
  });

/// UNUSED
  /*test('calculate distance between two addresses', () async {
    final address1 = Address(
      streetName: '221 Terry Ave N',
      unitNo: '',
      city: 'Seattle',
      state: 'WA',
      zipcode: '98109',
    );

    final address2 = Address(
      streetName: '401 Terry Ave N',
      unitNo: '',
      city: 'Seattle',
      state: 'WA',
      zipcode: '98109',
    );

    /// valid address
    final distance = await address1.calculateDistance(address2);
    print(distance);
    expect(distance, greaterThan(0));
    expect(distance, lessThan(1));

    final invalid = Address(
      streetName: 'FakeStreet',
      unitNo: 'FakeUnitNo',
      city: 'FakeCity',
      state: 'FakeState',
      zipcode: 'FakeZipCode',
    );

    /// invalid address
    /// return should be null, so method can not work---> N
    expect(() => address1.calculateDistance(invalid),
        throwsA(isA<NoSuchMethodError>()));
  });

  test('validate an input addresses', () async {
    final expectedValid = Address(
      streetName: '225 Terry Ave N',
      unitNo: '',
      city: 'Seattle',
      state: 'WA',
      zipcode: '98109',
    );

    /// valid addresss
    final ret = await expectedValid.validateAddress();
    print(ret);
    expect(ret, true);
    final invalid = Address(
      streetName: 'FakeStreet',
      unitNo: 'FakeUnitNo',
      city: 'FakeCity',
      state: 'FakeState',
      zipcode: 'FakeZipCode',
    );

    /// invalid address

    final ret2 = await invalid.validateAddress();
    print(ret2);
    expect(ret2, false);
  });*/
}
//flutter test --coverage
//genhtml coverage/lcov.info -o coverage/html
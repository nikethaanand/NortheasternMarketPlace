/// import
//import 'dart:convert';
//import 'package:http/http.dart' as http;
//import "package:google_maps_webservice_ex/places.dart";
/// API BASE
//const String GOOGLE_MAPS_API_KEY = "AIzaSyAtY8uHyhHDIyvkJjC2r8DXSrlyGsA4mAA";

/// A class representing a street address.
class Address {
  String streetName;
  String unitNo;
  String city;
  String state;
  String zipcode;

  Address({
    required this.streetName,
    required this.unitNo,
    required this.city,
    required this.state,
    required this.zipcode,
  });

  /// convert from json to Address obj
  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      streetName: json['streetName'] as String,
      unitNo: json['unitNo'] as String,
      city: json['city'] as String,
      state: json['state'] as String,
      zipcode: json['zipCode'] as String,
    );
  }

  /// convert obj to Json map
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['streetName'] = streetName;
    data['unitNo'] = unitNo;
    data['city'] = city;
    data['state'] = state;
    data['zipCode'] = zipcode;
    return data;
  }

  /// Returns a string representation of this address.
  String toString() {
    if (streetName != "") {
      return '$streetName, \nUnit $unitNo \n$city, $state, $zipcode';
    }
    return "No address information";
  }

  /// UNUSED
/*
  /// Compares this address with another address for equality.
  bool equals(Address o) {
    return this.streetName == o.streetName &&
        this.unitNo == o.unitNo &&
        this.city == o.city &&
        this.state == o.state &&
        this.zipcode == o.zipcode;
  }

  /// Validates the current address using Google Web Services places.
  /// Returns `true` if the address is valid and `false` otherwise.
  Future<bool> validateAddress() async {
    /// use google web services places and autocomplete to check if an address exists
    final places = GoogleMapsPlaces(apiKey: GOOGLE_MAPS_API_KEY);

    /// required fields:
    /// string representation of address
    /// default country = US (NEU App scope)
    /// type of location input: address
    final response = await places.autocomplete(
      '${toString()}',
      components: [Component(Component.country, 'US')],
      types: ['address'],
    );

    /// if response is valid return true
    if (response.isOkay) {
      return response.predictions.isNotEmpty;
    } else {
      // else return false
      return false;
    }
  }

  /// Calculates the distance between this address and another address.
  ///
  /// Returns the distance in miles, rounded to 2 decimal places.
  Future<double> calculateDistance(Address o) async {
    // convert addresses to string representations
    //final String originAddress = toString();
    //final String destinationAddress = o.toString();
    // base api + required fields
    // origins: origin location
    // destinations: destination location
    // mode: travel mode (ie. walking, drivnig, transit, bike)
    // key: api key
    final String apiUrl =
        'https://maps.googleapis.com/maps/api/distancematrix/json?' +
            'origins=${toString()}&' +
            'destinations=${o.toString()}&' +
            'mode=walking&' +
            'key=$GOOGLE_MAPS_API_KEY';
    // get http request response
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      // if valid, parse response and only extract distaance
      final data = jsonDecode(response.body);
      final distance = data['rows'][0]['elements'][0]['distance']['value'];
      // convert to miles and round 2 decimal places
      return double.parse((distance / 1609.344).toStringAsFixed(2));
    } else {
      //error handling
      throw Exception('Unable to calculate distance.');
    }
  }*/
}

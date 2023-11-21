import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:gtk_flutter/Address.dart';
import 'firebase_options.dart';
import 'login.dart';

///SignUpPage is the signup page
class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

///_SignUpPageState has all the user information for signing up
class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  String _username = '';
  String _firstName = '';
  String _lastName = '';
  String _email = '';
  String _campus = '';
  String _password = '';
  String _passwordConfirmation = '';
  String _streetName = '';
  String _unitNo = '';
  String _city = '';
  String _state = '';
  String _zipcode = '';

  ///isValidEmail check if the email is valid
  bool isValidEmail(String email) {
    final RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  ///make sure the password is valid
  List<String> validatePassword(String password) {
    List<String> errors = [];

    if (password.isEmpty) {
      errors.add("Password is required.");
    }

    if (password.length < 8) {
      errors.add("Password must be at least 8 characters long.");
    }

    if (!password.contains(new RegExp(r'[A-Z]'))) {
      errors.add("Password must contain at least one uppercase letter.");
    }

    if (!password.contains(new RegExp(r'[a-z]'))) {
      errors.add("Password must contain at least one lowercase letter.");
    }

    if (!password.contains(new RegExp(r'[0-9]'))) {
      errors.add("Password must contain at least one digit.");
    }

    if (!password.contains(new RegExp(r'[!@#\$%^&*(),.?":{}|<>]'))) {
      errors.add("Password must contain at least one special character.");
    }

    return errors;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          ///app bar
          title: const Text(
            "Northeastern Marketplace",
            style: TextStyle(
              fontFamily: "Times New Roman",
            ),
          ),
          backgroundColor: Color.fromARGB(212, 221, 9, 44),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    ///receives user name from user
                    decoration: InputDecoration(labelText: 'Username'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your username';
                      }
                      if (value.length > 20) {
                        return 'Username too long. 20 letters maximum.';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _username = value!;
                    },
                  ),
                  TextFormField(
                    ///receives first name from user
                    decoration: InputDecoration(labelText: 'First Name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your First Name';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _firstName = value!;
                    },
                  ),
                  TextFormField(
                    ///receives last name from user
                    decoration: InputDecoration(labelText: 'Last Name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your Last Name';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _lastName = value!;
                    },
                  ),
                  TextFormField(
                    ///receives email id from user and it has to be a northeastern email id
                    decoration: InputDecoration(labelText: 'Email'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      } else if (!isValidEmail(value) ||
                          !value.contains('northeastern.edu')) {
                        return 'Please enter a valid northeastern email';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _email = value!;
                    },
                  ),
                  TextFormField(
                    ///receives campus location  from user
                    decoration: InputDecoration(labelText: 'Campus'),
                    // TODO: Add more rules
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your campus';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _campus = value!;
                    },
                  ),
                  Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            ///adddress from user
                            child: TextFormField(
                              decoration:
                                  InputDecoration(labelText: 'Street Name'),
                              onSaved: (value) {
                                _streetName = value!;
                              },
                            ),
                          ),
                          SizedBox(width: 16.0),
                          Expanded(
                            child: TextFormField(
                              decoration:
                                  InputDecoration(labelText: 'Unit Number'),
                              onSaved: (value) {
                                _unitNo = value!;
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.0),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              decoration: InputDecoration(labelText: 'City'),
                              onSaved: (value) {
                                _city = value!;
                              },
                            ),
                          ),
                          SizedBox(width: 16.0),
                          Expanded(
                            child: TextFormField(
                              decoration: InputDecoration(labelText: 'State'),
                              onSaved: (value) {
                                _state = value!;
                              },
                            ),
                          ),
                          SizedBox(width: 16.0),
                          Expanded(
                            child: TextFormField(
                              decoration: InputDecoration(labelText: 'Zipcode'),
                              onSaved: (value) {
                                _zipcode = value!;
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  TextFormField(
                    ///receive password from the user
                    decoration: InputDecoration(labelText: 'Password'),
                     obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      List<String> errors = validatePassword(value);
                      if (!errors.isEmpty) {
                        // The password is invalid
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text("Password is invalid"),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: errors
                                    .map((error) => Text("- $error"))
                                    .toList(),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text("OK"),
                                ),
                              ],
                            );
                          },
                        );
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _password = value!;
                    },
                  ),
                  TextFormField(
                    ///validate password
                    decoration: InputDecoration(labelText: 'Re-enter Password'),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please re-enter your password';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _passwordConfirmation = value!;
                    },
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Color.fromARGB(212, 221, 9, 44),
                    ),
                    onPressed: () async {
                      print(_password);
                      print(_passwordConfirmation);
                      if (_password != _passwordConfirmation) {
                        // Passwords do not match, show an error message
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text("Passwords do not match"),
                              content: Text(
                                  "Please make sure both passwords match."),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text("OK"),
                                ),
                              ],
                            );
                          },
                        );
                      }
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        // Initialize Firebase
                        await Firebase.initializeApp(
                          options: DefaultFirebaseOptions.currentPlatform,
                        );
                        // Add data to Firestore
                        // TODO: create an Address obj and pass properties to it
                        Address address = Address(
                            streetName: _streetName,
                            city: _city,
                            state: _state,
                            unitNo: _unitNo,
                            zipcode: _zipcode);
                        FirebaseFirestore.instance.collection('Users').add({
                          'username': _username,
                          'firstName': _firstName,
                          'lastName': _lastName,
                          'email': _email,
                          'campus': _campus,
                          'password': _password,
                          'address': address.toJson(),
                        });

                        // Navigate to success page
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                      }
                    },
                    child: Text('Submit'),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}

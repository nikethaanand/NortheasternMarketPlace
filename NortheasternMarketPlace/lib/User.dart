/// import libraries
import 'dart:io';
import 'package:file_picker/file_picker.dart';
//import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'Address.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// User class represents a NEU account holder
class User {
  /// a user may have a username, first name, last name, password, campus, NEU email, address, and profile picture
  String username;
  String firstName;
  String lastName;
  String password;
  String campus;
  String email;
  Address address;
  String profilePicture;

  User({
    /// required parameters for creating a User instance
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.password,
    required this.campus,
    required this.email,
    required this.address,
    required this.profilePicture,
  });

  /// getFullName returns a concatenated version of the first and last name
  String getFullName() {
    return "$firstName $lastName";
  }

  /// setFullName splits "First_name Last_name" into two different fields and saves accordingly
  void setFullName(String fullName) {
    List<String> name = fullName.split(" ");
    firstName = name.first;
    lastName = name.last;
  }

  /// toJson will map user fields to meet json criteria
  Map<String, dynamic> toJson() => {
        'username': username,
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'password': password,
        'campus': campus,
        'address': address.toJson(),
        'profilePicture': profilePicture,
      };

  /// fromJson will unpackage json map and convert it into a User instance
  static User fromJson(Map<String, dynamic> json) {
    return User(
      campus: json['campus'] as String,
      password: json['password'] as String,

      /// if no address is found, an empty address will be used
      address: json.containsKey('address')
          ? Address.fromJson(json['address'])
          : new Address(
              streetName: '', unitNo: '', city: '', state: '', zipcode: ''),
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      username: json['username'] as String,
      email: json['email'] as String,

      /// if no profile picture is found, a default profile picture will be used
      profilePicture: json.containsKey('profilePicture')
          ? json['profilePicture']
          : 'https://firebasestorage.googleapis.com/v0/b/neumarket-fd017.appspot.com/o/profilePictures%2Fhusky.png?alt=media&token=9e7403c0-2e70-49d3-a13f-762bffc93395',
    );
  }

  /// read user from database and returns it as a User instance
  static Future<User> read(
      FirebaseFirestore firebaseFirestore, String username) async {
    final querySnapshot = await firebaseFirestore
        .collection('Users')
        .where('username', isEqualTo: username)
        .get();
    //print("QS: " + querySnapshot.toString());
    if (querySnapshot.docs.isEmpty) {
      throw Exception('No user found with username: $username');
    }
    final data = querySnapshot.docs.first.data();
    //print("Data: " + data.toString());
    return fromJson(data);
  }

  /// update user infromation in database
  static Future<void> update(
      FirebaseFirestore firebaseFirestore, User updatedUser) async {
    final querySnapshot = await firebaseFirestore
        .collection('Users')
        .where('username', isEqualTo: updatedUser.username)
        .get();
    if (querySnapshot.docs.isEmpty) {
      throw Exception('No user found with username: $updatedUser.username');
    }
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(querySnapshot.docs.first.id)
        .update(updatedUser.toJson());
  }

  /// delete user from database
  Future<void> deactivate(
    FirebaseFirestore firebaseFirestore,
  ) async {
    final querySnapshot = await firebaseFirestore
        .collection('Users')
        .where('username', isEqualTo: username)
        .get();
    if (querySnapshot.docs.isEmpty) {
      throw Exception('No user found with username: $username');
    }
    final docId = querySnapshot.docs.first.id;
    await FirebaseFirestore.instance.collection('Users').doc(docId).delete();
  }
}

/// Edit Account Form is a separate form that user's can access to change their account infromation
class EditAccountForm extends StatefulWidget {
  /// takes in a User instance
  final User user;
  late FirebaseFirestore firebaseFirestore;
  EditAccountForm({required this.user, required this.firebaseFirestore});
  @override
  _EditAccountFormState createState() => _EditAccountFormState();
}

/// Edit Account Form State will control the values in the form
class _EditAccountFormState extends State<EditAccountForm> {
  final _formKey = GlobalKey<FormState>();

  /// for uploading images
  PlatformFile? _file;
  UploadTask? _task;
  final picker = ImagePicker();

  /// allows users to pick their own image file and sets it t the global _file key
  void getImage() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;
    setState(() {
      _file = result.files.first;
    });
  }

  /// allows users to upload their selected file and returns the downloadable url from Firebase Storage
  Future<String?> _uploadFile() async {
    if (_file == null) return null;
    final path = 'profilePictures/${_file!.name}';
    final file = File(_file!.path!);
    final ref = FirebaseStorage.instance.ref().child(path);
    final metadata = SettableMetadata(
      contentType: 'application/${_file!.extension}',
    );
    final uploadTask = ref.putFile(file, metadata);
    setState(() {
      _task = uploadTask;
    });
    final snapshot = await uploadTask.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();
    widget.user.profilePicture = urlDownload;
    return urlDownload;
  }

  /// when user's are ready and validators are satisfied, they can save their changes in the database
  Future<void> _submitForm(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      _uploadFile();
      User.update(widget.firebaseFirestore, widget.user);
      Navigator.pop(context);
    }
  }

  /// allows user to cancel edits
  void _cancelEdit() {
    Navigator.pop(context);
  }

  /// build form using current information
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Tooltip(
          message: 'Go Back',
          child: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        title: const Text(
          "Northeastern Marketplace",
          style: TextStyle(
            fontFamily: "Times New Roman",
          ),
        ),
        backgroundColor: Color.fromARGB(212, 221, 9, 44),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 20),
                TextFormField(
                  initialValue: widget.user.getFullName(),
                  decoration: InputDecoration(
                    labelText: 'Full Name',
                    prefixIcon: Icon(Icons.person),
                    hintText: 'First and last name',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your full name';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    widget.user.setFullName(value!);
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  initialValue: widget.user.email,
                  decoration: InputDecoration(
                    labelText: 'NEU Email',
                    semanticCounterText:
                        'Enter a valid Northeastern University email address',
                    prefixIcon: Icon(Icons.email),
                  ),
                  validator: (value) {
                    if (value!.isEmpty || !value.contains("northeastern.edu")) {
                      return 'Please provide a valid Northeastern email address';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    widget.user.email = value!;
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'NEU Campus',
                    semanticCounterText:
                        'Select a valid Northeastern University Campus',
                    prefixIcon: Icon(Icons.school),
                  ),
                  value: widget.user.campus,
                  onChanged: (newValue) {
                    setState(() {
                      widget.user.campus = newValue!;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a campus';
                    }
                    return null;
                  },
                  items: <String>[
                    "Arlington",
                    "Boston",
                    "Charlotte",
                    "Miami",
                    "Oakland",
                    "Portland",
                    "San Francisco",
                    "Silicon Valley",
                    "Seattle",
                    "Toronto",
                    "Vancouver"
                  ].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.map,
                            color: Colors.grey,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Address',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        initialValue: widget.user.address.streetName,
                        decoration: InputDecoration(labelText: 'Street Name'),
                        onSaved: (value) {
                          widget.user.address.streetName = value!;
                        },
                      ),
                      TextFormField(
                        initialValue: widget.user.address.unitNo,
                        decoration: InputDecoration(labelText: 'Unit Number'),
                        onSaved: (value) {
                          widget.user.address.unitNo = value!;
                        },
                      ),
                      TextFormField(
                        initialValue: widget.user.address.city,
                        decoration: InputDecoration(labelText: 'City'),
                        onSaved: (value) {
                          widget.user.address.city = value!;
                        },
                      ),
                      TextFormField(
                        initialValue: widget.user.address.state,
                        decoration: InputDecoration(labelText: 'State'),
                        onSaved: (value) {
                          widget.user.address.state = value!;
                        },
                      ),
                      TextFormField(
                        initialValue: widget.user.address.zipcode,
                        decoration: InputDecoration(labelText: 'Zipcode'),
                        onSaved: (value) {
                          widget.user.address.zipcode = value!;
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    SizedBox(
                      width: 5,
                    ),
                    Icon(
                      Icons.add_a_photo,
                      size: 25,
                      color: Colors.grey,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      'Profile Picture',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: getImage,
                  style: ElevatedButton.styleFrom(
                    primary: Color.fromARGB(212, 221, 9, 44),
                  ),
                  child: Tooltip(
                    message: 'Select a new image from your device',
                    child: Text('Select New Image'),
                  ),
                ),
                if (_file == null)
                  Text('No image selected')
                else
                  Text('Please confirm image'),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _uploadFile,
                  style: ElevatedButton.styleFrom(
                    primary: Color.fromARGB(212, 221, 9, 44),
                  ),
                  child: Tooltip(
                    message: 'Upload your selected image',
                    child: Text('Confirm Image'),
                  ),
                ),
                if (_task != null)
                  StreamBuilder<TaskSnapshot>(
                    stream: _task!.snapshotEvents,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final progress = snapshot.data!.bytesTransferred /
                            snapshot.data!.totalBytes;
                        final percentage =
                            (progress * 100).toStringAsFixed(2) + '%';
                        return Text('Upload Progress: $percentage');
                      } else {
                        return SizedBox();
                      }
                    },
                  ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  decoration: InputDecoration(
                      labelText: 'Please confirm your password'),
                  validator: (value) {
                    if (value != widget.user.password) {
                      return 'Invalid password';
                    }
                    return null;
                  },
                  obscureText: true,
                  autovalidateMode: AutovalidateMode.always,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Color.fromARGB(212, 221, 9, 44),
                  ),
                  onPressed: () async {
                    await _submitForm(context);
                  },
                  child: Tooltip(
                    message: 'Submit changes to your account',
                    child: Text('Save Changes'),
                  ),
                ),
                TextButton(
                  onPressed: _cancelEdit,
                  child: Tooltip(
                    message: 'Delete your changes',
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        color: Color.fromARGB(212, 221, 9, 44),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:gtk_flutter/home_page.dart';
import 'package:gtk_flutter/login.dart';
import 'package:gtk_flutter/navbar_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';

//NewPostPage is used to add a post to firebase
class NewPostPage extends StatefulWidget {
  late FirebaseFirestore firebaseFirestore;
  //NewPostPage is called to get the username from homepage
  NewPostPage({ required this.firebaseFirestore  });

  @override
  _NewPostPageState createState() => _NewPostPageState();
}

//_NewPostPageState receives input from the user
class _NewPostPageState extends State<NewPostPage> {
  String _username = '';
  String _productName = '';
  String _description = '';
  String _pickupAddress = '';
  String _price = '';
  String _selectedCategory = 'Furniture';
  String _selectedCondition = 'New';
  String status = 'Available';

  var editedUser;
  List<String> _categories = [
    'Furniture',
    'Books',
    'House Appliances',
    'Sports Equipment',
    'Others',
  ];

  List<String> _conditions = [
    'New',
    'Like New',
    'Good',
    'Acceptable',
  ];

  PlatformFile? _file;
  UploadTask? _task;

  final picker = ImagePicker();
  //getImage selects images from the system, any file can be selected
  void getImage() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;
    setState(() {
      _file = result.files.first;
    });
  }

  //_uploadFile stores the uploaded image to fire storage and returns the link
  Future<String?> _uploadFile() async {
    if (_file == null) return null;
    final path = 'products/${_file!.name}';
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
    print('Download Link: $urlDownload');
    //the url link is returned after uploaded to fire storage
    return urlDownload;
  }

  Future<void> addPost(BuildContext context) async {
    CollectionReference posts = FirebaseFirestore.instance.collection('posts');

    // upload file to Firebase Storage and get download URL
    await _uploadFile();
    String url = await FirebaseStorage.instance
        .ref()
        .child('products/${basename(_file!.name)}')
        .getDownloadURL();

    // add post data to Firestore
    posts.add({
      'username': _username,
      'productName': _productName,
      'price': _price,
      'imageURL': url,
      'description': _description,
      'pickupAddress': _pickupAddress,
      'category': _selectedCategory,
      'condition': _selectedCondition,
      'status': status,
      //  'timestamp': FieldValue.serverTimestamp() // add timestamp field
    });

    // Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    editedUser = userProvider.user;
    //Current logged in username
    _username = editedUser.username;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
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
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            //crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                //crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Text(
                      'Product Name',
                      style: TextStyle(
                        fontSize: 16.0,
                        //fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 7,
                    child: TextField(
                      //Product name received from user and stored
                      decoration: InputDecoration(
                        labelText: 'Enter your product name',
                        hintText: 'Please enter your product name',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _productName = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Description',
                      style: TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 7,
                    child: TextField(
                      //Product description received from user and stored
                      decoration: InputDecoration(
                        labelText: 'Enter a description',
                        hintText: 'Please enter your product description',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _description = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Pickup Address',
                      style: TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 7,
                    child: TextField(
                      // //Product address received from user and stored
                      decoration: InputDecoration(
                        labelText: 'Enter pickup address',
                        hintText: 'Please enter your pickup address',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _pickupAddress = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Price',
                      style: TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 7,
                    child: TextField(
                      // //Product price received from user and stored
                      decoration: InputDecoration(
                        labelText: '\$',
                        hintText: 'Please enter your product price',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _price = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Category',
                      style: TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                  Expanded(
                    // //Product category received from user and stored
                    flex: 7,
                    child: DropdownButton<String>(
                      value: _selectedCategory,
                      items: _categories.map((String item) {
                        return DropdownMenuItem<String>(
                          value: item,
                          child: Text(item),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          _selectedCategory = newValue!;
                        });
                      },
                      isExpanded: true,
                      underline: Container(
                        height: 2,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              Row(
                children: [
                  Expanded(
                    // //Product condition received from user and stored
                    child: Text(
                      'Condition',
                      style: TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 7,
                    child: DropdownButton<String>(
                      value: _selectedCondition,
                      items: _conditions.map((String item) {
                        return DropdownMenuItem<String>(
                          value: item,
                          child: Text(item),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          _selectedCondition = newValue!;
                        });
                      },
                      isExpanded: true,
                      underline: Container(
                        height: 2,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
              ...[
                if (_file == null)
                  Text('No file selected')
                else
                  Text('Selected file: ${_file!.name!}'),
                SizedBox(height: 20),
                ElevatedButton(
                  //select file button that allows users to select a file
                  onPressed: getImage,
                  style: ElevatedButton.styleFrom(
                    primary: Color.fromARGB(212, 221, 9, 44),
                  ),
                  child: Text('Select File'),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  //after selecting an image uplaod it to fire storage
                  onPressed: _uploadFile,
                  style: ElevatedButton.styleFrom(
                    primary: Color.fromARGB(212, 221, 9, 44),
                  ),
                  child: Text('Upload File'),
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
              ],
              ElevatedButton(
                //create post button that stores all the values with the image link to firebase and navigate to homepage
                onPressed: () async {
                  await addPost(context);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => MyHomePage(firebaseFirestore: FirebaseFirestore.instance,),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  primary: Color.fromARGB(212, 221, 9, 44),
                ),
                child: Text('Create Post'),
              ),
            ],
          ),
        ),
        //navigation bar in the bottom
        bottomNavigationBar: NavBar(),
      ),
    );
  }
}

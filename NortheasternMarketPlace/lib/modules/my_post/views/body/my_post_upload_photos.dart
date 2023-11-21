/*import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gtk_flutter/modules/my_post/pages/page_my_post.dart';
//import 'package:gtk_flutter/ui/units/common_ui.dart';
//import 'package:gtk_flutter/ui/widgets/text.dart';
import 'package:image_picker/image_picker.dart';

class MyPostUploadPhotosWidget extends StatefulWidget {
  MyPostUploadPhotosWidget({super.key});

  @override
  State<StatefulWidget> createState() {
    return MyPostUploadPhotosWidgetState();
  }
}

class MyPostUploadPhotosWidgetState extends State<MyPostUploadPhotosWidget> {
  final picker = ImagePicker();
  List<File> _imageFiles = [];

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _imageFiles.add(File(pickedFile.path));
      }
    });
  }

  void removeImage(int index) {
    setState(() {
      _imageFiles.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text(
              'Northeastern Market Place\nMy post > New Post > Upload Photos'),
          backgroundColor: Color.fromARGB(212, 221, 9, 44),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Please upload up to 12 pictures for your item:',
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
                itemCount: _imageFiles.length + 1,
                itemBuilder: (BuildContext context, int index) {
                  if (index == _imageFiles.length) {
                    return GestureDetector(
                      onTap: () => getImage(),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                        ),
                        child: Icon(Icons.add),
                      ),
                    );
                  }
                  return Stack(
                    children: [
                      Container(
                        margin: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          image: DecorationImage(
                            image: FileImage(_imageFiles[index]),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: () => removeImage(index),
                          child: Icon(
                            Icons.cancel,
                            color: Colors.red,
                            size: 20.0,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyPostPage()),
                  );
                },
                //onPressed: getImage,
                child: Text('Confirm Upload'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/*
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
    );
  }
}
*/
*/
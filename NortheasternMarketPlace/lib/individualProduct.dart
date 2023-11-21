import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gtk_flutter/chat_page.dart';
import 'package:gtk_flutter/navbar_widget.dart';

//Class individualProduct contains all the values that will be added to a list from firebase
class individualProduct extends StatelessWidget {
  final String image;
  final String name;
  final String price;
  final String description;
  final String category;
  final String condition;
  final String username;
  final String status;

  individualProduct(
      {Key? key,
      required this.image,
      required this.name,
      required this.price,
      required this.description,
      required this.category,
      required this.condition,
      required this.username,
      required this.status})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        ///appbar that has a back button
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
      body: Column(
        //The image selected in products page is visible in a bigger size
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: Container(
              width: double.infinity,
              child: Image(
                image: NetworkImage(image),
              ),
            ),
          ),
          //Product name is displayed
          Container(
            margin: EdgeInsets.only(top: 5),
            // margin: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                name,
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
          Row(
            ///the product description is visible
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: EdgeInsets.only(left: 40, top: 0),
                child: Text(
                  description,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
              //Price is displayed
              Container(
                margin: EdgeInsets.only(right: 40, top: 0),
                child: Text(
                  '\$' + price,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
            //Chat with seller option that navigates to user chat, current username is passed to the chatpage
          ),
          Container(
            margin: EdgeInsets.only(top: 20),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatPage(other: username, firebaseFirestore: FirebaseFirestore.instance),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                primary: Color.fromARGB(212, 221, 9, 44),
              ),
              child: Text('Chat With Seller'),
            ),
          ),
        ],
      ),
      //Navbar at the bottom
      bottomNavigationBar: NavBar(),
    );
  }
}

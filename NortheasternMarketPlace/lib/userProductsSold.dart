import 'package:flutter/material.dart';
import 'package:gtk_flutter/login.dart';
import 'package:gtk_flutter/navbar_widget.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'home_page.dart';
///Stores list of all the variables to get from firebase
class PhotoItem {
  final String imageURL;
  final String productName;
  final String price;
  final String description;
  final String category;
  final String condition;
  final String username;
   String status;
  PhotoItem(this.imageURL, this.productName,this.price,this.description,this.category,this.condition,
  this.username,this.status);
}
///class productsSold gets user value passed via provider
class productsSold extends StatefulWidget {
     late FirebaseFirestore firebaseFirestore;

  //To get the username from homepage
  productsSold({ required this.firebaseFirestore  });
  @override
  productsSoldState createState() => productsSoldState();
}
///productsSoldState is the products sold page, that shows the list of products sod by the user
class productsSoldState extends State<productsSold>  {
  List<PhotoItem> _items = [];
  List<PhotoItem> originalList = [];
  String username = '';
  var firebaseFirestore;
  String _sortValue = 'Popularity';
  String? _filterValue = 'All';
  var editedUser;
  
 @override
void initState() {
  super.initState();
  firebaseFirestore = widget.firebaseFirestore;
  firebaseFirestore.collection('posts')
  //.where('username', isNotEqualTo: editedUser?.username)
  .get().then((querySnapshot) {
    querySnapshot.docs.forEach((doc) {
      ///here we check if the produt is sold and add it to the item list
      if (doc.exists && doc['status'] == 'Sold' && doc['username']==editedUser.username) {
          PhotoItem item = new PhotoItem(
          doc['imageURL'] ?? '', // Use ?? to provide a default value if the image URL is null
          doc['productName'] ?? '',
          doc['price']?.toString() ?? '',
          doc['description'] ?? '',
          doc['category'] ?? '',
          doc['condition'] ?? '',
          doc['username'] ?? '',
          doc['status'] ?? '',
         );
        _items.add(item);
      }
    });
    setState(() {}); // Call setState to rebuild the UI with the new data
  });

  originalList=_items;
}

///Here the provider gets the username
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    editedUser = userProvider.user;
    username=editedUser.username;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        ///AppBar that has a back button
        appBar: AppBar(
            leading: Tooltip(
          message: 'Go Back',
          child: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
          title: Text('Northeastern Market Place'),
          backgroundColor: Color.fromARGB(212, 221, 9, 44),
        ),

body: Column(
  children: [
       Text(
            'Products Sold',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
    Expanded(
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisSpacing: 0,
          mainAxisSpacing: 0,
          crossAxisCount: 2,
        ),
        itemCount: _items.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
         
            },
            ///the image is loaded as a network image
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      scale: 2,
                      fit: BoxFit.contain,
                      image: NetworkImage(_items[index].imageURL),
                    ),
                  ),
                  height: 150,
                  width:200 // set the height to a smaller value
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 40, top: 0),
                      child: Text(

                                _items[index].productName,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                    ///the price of the image is
              Container(
                margin: EdgeInsets.only(right: 40, top: 0),
                child: Text(
                  '\$' + _items[index].price,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
          ///We have a button that show if the item is sold
            Container(
                margin: EdgeInsets.only(top: 0),
                child: ElevatedButton(
                  onPressed: () {
                    setState(() { // Call setState to update the state of the widget
                      //status = "Sold"; // Set the value of status to "Sold"
                    });
                  },
                  style: ElevatedButton.styleFrom(primary: Color.fromARGB(212, 221, 9, 44)),
                  child: Text('Sold'),
                ),
              ),
                ],
              ),
            );
          },
        ),
      ),
        ],
      ), 
      ///bottom navbar for navigation
       bottomNavigationBar: NavBar(),
    ),
    );

  }
}

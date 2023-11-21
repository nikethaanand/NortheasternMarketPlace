import 'package:flutter/material.dart';
import 'package:gtk_flutter/login.dart';
import 'package:gtk_flutter/navbar_widget.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'home_page.dart';
///PhotoItem has a list of all the values to get from firebase
class PhotoItem {
  final String imageURL;
  final String productName;
  final String price;
  final String description;
  final String category;
  final String condition;
  final String username;
   String status;
   String documentId;
  PhotoItem(this.imageURL, this.productName,this.price,this.description,this.category,this.condition,
  this.username,this.status,this.documentId);
}
///orderHistory shows all the prodcuts available
class orderHistory extends StatefulWidget {
   late FirebaseFirestore firebaseFirestore;

  //To get the username from homepage
  orderHistory({ required this.firebaseFirestore  });
 // @override
  //orderHistory();
  @override
  orderHistoryState createState() => orderHistoryState();
}
///orderHistoryState is the products page fro the user to mark as sold

class orderHistoryState extends State<orderHistory>  {
  List<PhotoItem> _items = [];
  List<PhotoItem> originalList = [];
  String username = '';
  var firebaseFirestore;
  String _sortValue = 'Popularity';
  String? _filterValue = 'All';
  ////the user name is stored
  var editedUser;
  
 @override
void initState() {
  super.initState();
    firebaseFirestore = widget.firebaseFirestore;
  firebaseFirestore.collection('posts')
  //.where('username', isNotEqualTo: editedUser?.username)
  .get().then((querySnapshot) {
    querySnapshot.docs.forEach((doc) {
      ///here we check if the status is available and then add it to the list
      if (doc.exists && doc['status'] == 'Available' && doc['username']==editedUser.username) {
        PhotoItem item = new PhotoItem(
          doc['imageURL'] ?? '', // Use ?? to provide a default value if the image URL is null
          doc['productName'] ?? '',
          doc['price']?.toString() ?? '',
          doc['description'] ?? '',
          doc['category'] ?? '',
          doc['condition'] ?? '',
          doc['username'] ?? '',
          doc['status'] ?? '',
          doc.id,
        );
        _items.add(item);
        //item.documentId = doc.id;
      }
    });
    setState(() {}); // Call setState to rebuild the UI with the new data
  });

  originalList=_items;
}


Future<void> updateStatus(String docId) async {
    FirebaseFirestore.instance.collection('posts').doc(docId).update({'status': 'Sold'});
}


  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    editedUser = userProvider.user;
    username=editedUser.username;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        ///we have an appbar that has a back button
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
            'Products History',
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
            ///we use network image to load the image
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
                  ///the product name is printef
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
                    
              Container(
                ///the price is printed
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
            Container(
                margin: EdgeInsets.only(top: 0),
               child: 
              ElevatedButton(
                ///we have an update status whoch updated the status to sold
                  onPressed: () {
                    updateStatus(_items[index].documentId);
                  },
                  style: ElevatedButton.styleFrom(primary: Color.fromARGB(212, 221, 9, 44)),
                  child: Text('Mark as Sold'),
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
      ///Navbar in the bottom 
       bottomNavigationBar: NavBar(),
    ),
    );

  }
}

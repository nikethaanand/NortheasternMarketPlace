import 'package:flutter/material.dart';
import 'package:gtk_flutter/login.dart';
import 'package:gtk_flutter/navbar_widget.dart';
import 'package:provider/provider.dart';
import 'individualProduct.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'home_page.dart';

//Class PhotoItem contains all the values that will be added to a list from firebase
class PhotoItem {
  final String imageURL;
  final String productName;
  final String price;
  final String description;
  final String category;
  final String condition;
  final String username;
  final String status;
  PhotoItem(this.imageURL, this.productName, this.price, this.description,
      this.category, this.condition, this.username, this.status);
}

//Product class is called to get a list of all the products
class Product extends StatefulWidget {

  late FirebaseFirestore firebaseFirestore;

  //To get the username from homepage
  Product({ required this.firebaseFirestore  });
  @override
  ProductState createState() => ProductState();
}

//ProductState populates all the available prodcuts to a list
class ProductState extends State<Product> {
  //_items contains a list of all the products available to a user
  List<PhotoItem> _items = [];
  //originalList contains a list of all the products available
  List<PhotoItem> originalList = [];
  //Current username is got from the homepage
  String username = '';

  String _sortValue = 'Popularity';
  String? _filterValue = 'All';
  var editedUser;
  var firebaseFirestore;


  @override
  void initState() {
    super.initState();
    firebaseFirestore = widget.firebaseFirestore;
    //Get the values from the post collection of firebase which stores values about products
    firebaseFirestore
        .collection('posts')
        //.where('username', isNotEqualTo: editedUser?.username)
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        //If the product is available and username of person who posted the product and user name of user who logged in
        //are not equal we add to the _items list
        if (doc.exists &&
            doc['status'] == 'Available' &&
            doc['username'] != editedUser.username) {
          _items.add(PhotoItem(
            doc['imageURL'] ??
                '', // Use ?? to provide a default value if the image URL is null
            doc['productName'] ?? '',
            doc['price']?.toString() ?? '',
            doc['description'] ?? '',
            doc['category'] ?? '',
            doc['condition'] ?? '',
            doc['username'] ?? '',
            doc['status'] ?? '',
          ));
        }
      });
      setState(() {}); // Call setState to rebuild the UI with the new data
    });
    // print('username');
    // print(editedUser.username);
    originalList = _items;
  }

  @override
  Widget build(BuildContext context) {
    //We get the current user logged in details and store it
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    editedUser = userProvider.user;
    //current logged in username
    username = editedUser.username;
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

        body: Column(
          children: [
            Row(
              //Filter for filter by price
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  child: DropdownButton<String>(
                    icon: Icon(Icons.arrow_drop_down, color: Colors.grey),
                    dropdownColor: Colors.white,
                    focusColor: Colors.white,
                    value: _sortValue,
                    items: [
                      DropdownMenuItem<String>(
                        value: 'Popularity',
                        child: Text('Popularity'),
                      ),
                      DropdownMenuItem<String>(
                        value: 'Price: Low to High',
                        child: Text('Price: Low to High'),
                      ),
                      DropdownMenuItem<String>(
                        value: 'Price: High to Low',
                        child: Text('Price: High to Low'),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _sortValue = value!;
                        if (_sortValue == 'Price: Low to High') {
                          _items.sort((a, b) => a.price.compareTo(b.price));
                        } else if (_sortValue == 'Price: High to Low') {
                          _items.sort((a, b) => b.price.compareTo(a.price));
                        }
                      });
                    },
                  ),
                ),
                Container(
                  //Filter for filtering based on the category details
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  child: DropdownButton<String>(
                    icon: Icon(Icons.arrow_drop_down, color: Colors.grey),
                    dropdownColor: Colors.white,
                    focusColor: Colors.white,
                    value: _filterValue,
                    items: [
                      DropdownMenuItem<String>(
                        value: 'All',
                        child: Text('All'),
                      ),
                      DropdownMenuItem<String>(
                        value: 'Furniture',
                        child: Text('Furniture'),
                      ),
                      DropdownMenuItem<String>(
                        value: 'Others',
                        child: Text('Others'),
                      ),
                      DropdownMenuItem<String>(
                        value: 'Books',
                        child: Text('Books'),
                      ),
                      DropdownMenuItem<String>(
                        value: 'House Appliances',
                        child: Text('House Appliances'),
                      ),
                      DropdownMenuItem<String>(
                        value: 'Sports Equipment',
                        child: Text('Sports Equipment'),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _filterValue = value!;
                        //default filter value is all
                        if (_filterValue == 'All') {
                          _items = originalList;
                        } else {
                          _items = originalList
                              .where((item) => item.category == _filterValue)
                              .toList();
                        }
                      });
                    },
                  ),
                ),
              ],
            ),
            //each row has only 2 products
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
                      //pushing all the values to the next page individualProduct
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => individualProduct(
                            image: _items[index].imageURL,
                            name: _items[index].productName,
                            price: _items[index].price,
                            description: _items[index].description,
                            category: _items[index].category,
                            condition: _items[index].condition,
                            username: _items[index].username,
                            status: _items[index].status,
                          ),
                        ),
                      );
                    },
                    child: Column(
                      children: [
                        Container(
                            //image of the product is displayed
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                scale: 2,
                                fit: BoxFit.contain,
                                image: NetworkImage(_items[index].imageURL),
                              ),
                            ),
                            height: 150,
                            width: 200 // set the height to a smaller value
                            ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: 40, top: 0),
                              child: Text(
                                //Product name is displayed
                                _items[index].productName,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(right: 40, top: 0),
                              child: Text(
                                //product price is displayed
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
                          //view button navigates to the individual products page
                          margin: EdgeInsets.only(top: 0),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => individualProduct(
                                    image: _items[index].imageURL,
                                    name: _items[index].productName,
                                    price: _items[index].price,
                                    description: _items[index].description,
                                    category: _items[index].category,
                                    condition: _items[index].condition,
                                    username: _items[index].username,
                                    status: _items[index].status,
                                  ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Color.fromARGB(212, 221, 9, 44),
                            ),
                            child: Text('View'),
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
        //Navbar at the button
        bottomNavigationBar: NavBar(),
      ),
    );
  }
}

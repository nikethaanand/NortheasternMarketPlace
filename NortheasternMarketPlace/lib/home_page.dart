import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, PhoneAuthProvider;
import 'package:flutter/material.dart';
import 'package:gtk_flutter/userProductsAvail.dart';
import 'package:gtk_flutter/userProductsSold.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'individualProduct.dart';

import 'navbar_widget.dart';
import 'private_profile.dart';
import 'new_post.dart';
import 'dart:math';

/**
 * The home page is the first page navigated to after user login.
 * It displays several recommended products and provides a pop up menu.
 * A nav bar at the bottom is also included for better user experience.
 */
class MyHomePage extends StatefulWidget {
  late FirebaseFirestore firebaseFirestore;
  MyHomePage({required this.firebaseFirestore});
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class ProductProvider with ChangeNotifier {
  User? _user;

  User? get user => _user;

  void setProduct(User user) {
    _user = user;
    notifyListeners();
  }
}

class _MyHomePageState extends State<MyHomePage> {
  List<Map<String, dynamic>> _randomPosts = [];

  @override
  void initState() {
    super.initState();
    getRandomPosts();
  }

  Future<void> getRandomPosts() async {
    // Get a reference to the Firestore collection
    final postsCollection = FirebaseFirestore.instance.collection('posts');
    // Get the total number of documents in the collection
    final snapshot = await postsCollection.get();
    final totalDocuments = snapshot.size;

    // Generate two random indexes between 0 and totalDocuments
    final random = Random();
    final randomIndex1 = random.nextInt(totalDocuments);

    // Retrieve the documents at the random indexes
    final randomDocuments = await postsCollection
        .orderBy(FieldPath.documentId)
        .startAt([snapshot.docs[randomIndex1].id])
        .limit(2)
        .get();

    final randomPosts = randomDocuments.docs.map((doc) => doc.data()).toList();

    setState(() {
      _randomPosts = randomPosts;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Northeastern Marketplace",
          style: TextStyle(
            fontFamily: "Times New Roman",
          ),
        ),
        backgroundColor: Color.fromARGB(212, 221, 9, 44),
        actions: [
          PopupMenuButton(
              // add icon, by default "3 dot" icon
              // icon: Icon(Icons.book)
              itemBuilder: (context) {
            return [
              PopupMenuItem<int>(
                value: 1,
                child: Text("New Post"),
              ),
              PopupMenuItem<int>(
                value: 2,
                child: Text("User Profile"),
              ),
              PopupMenuItem<int>(
                value: 3,
                child: Text("Products Available"),
              ),
              PopupMenuItem<int>(
                value: 4,
                child: Text("Products Sold"),
              ),
            ];
          }, onSelected: (value) {
            if (value == 1) {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => NewPostPage(
                          firebaseFirestore: FirebaseFirestore.instance,
                        )),
              );
            } else if (value == 2) {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PrivateProfilePage(
                          firebaseFirestore: FirebaseFirestore.instance,
                        )),
              );
            } else if (value == 3) {
              // get user from stored
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => orderHistory(
                          firebaseFirestore: FirebaseFirestore.instance,
                        )),
              );
            } else if (value == 4) {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => productsSold(
                          firebaseFirestore: FirebaseFirestore.instance,
                        )),
              );
            }
          }),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Welcome Husky. Start your navigation here :-)',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
                SizedBox(height: 60.0), // add some space between the two lines
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Picks for you',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
              ],
            ),
            _randomPosts.isEmpty
                ? CircularProgressIndicator()
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                scale: 2,
                                fit: BoxFit.contain,
                                image:
                                    NetworkImage(_randomPosts[0]['imageURL']),
                              ),
                            ),
                            height: 150, // set the height to a smaller value
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                margin: EdgeInsets.only(left: 40, top: 0),
                                child: Text(
                                  _randomPosts[0]['productName'],
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(right: 40, top: 0),
                                child: Text(
                                  '\$' + _randomPosts[0]['price'],
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
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => individualProduct(
                                      image: _randomPosts[0]['imageURL'],
                                      name: _randomPosts[0]['productName'],
                                      price: _randomPosts[0]['price'],
                                      description: _randomPosts[0]
                                          ['description'],
                                      category: _randomPosts[0]['category'],
                                      condition: _randomPosts[0]['condition'],
                                      username: _randomPosts[0]['username'],
                                      status: _randomPosts[0]['status'],
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
                      Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                scale: 2,
                                fit: BoxFit.contain,
                                image:
                                    NetworkImage(_randomPosts[1]['imageURL']),
                              ),
                            ),
                            height: 150, // set the height to a smaller value
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                margin: EdgeInsets.only(left: 40, top: 0),
                                child: Text(
                                  _randomPosts[1]['productName'],
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(right: 40, top: 0),
                                child: Text(
                                  '\$' + _randomPosts[1]['price'],
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
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => individualProduct(
                                      image: _randomPosts[1]['imageURL'],
                                      name: _randomPosts[1]['productName'],
                                      price: _randomPosts[1]['price'],
                                      description: _randomPosts[1]
                                          ['description'],
                                      category: _randomPosts[1]['category'],
                                      condition: _randomPosts[1]['condition'],
                                      username: _randomPosts[1]['username'],
                                      status: _randomPosts[1]['status'],
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
                    ],
                  ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getRandomPosts,
        child: Icon(Icons.refresh),
      ),
      bottomNavigationBar: NavBar(),
    );
  }
}

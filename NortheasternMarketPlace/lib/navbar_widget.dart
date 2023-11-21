/// import statement
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'home_page.dart';
import 'products.dart';
import 'new_post.dart';
import 'private_profile.dart';
import 'chat_history.dart';

/// a navigation bar widget
class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

/// controls the state of the NavBar
class _NavBarState extends State<NavBar> {
  static List<Widget> _widgetOptions = <Widget>[
    MyHomePage(firebaseFirestore: FirebaseFirestore.instance,),
    Product(firebaseFirestore: FirebaseFirestore.instance,),
    NewPostPage(firebaseFirestore: FirebaseFirestore.instance,),
    PrivateProfilePage(firebaseFirestore: FirebaseFirestore.instance,),
    ChatHistory(firebaseFirestore: FirebaseFirestore.instance,),
  ];

  /// change page route when user taps on a specific icon
  void _onItemTapped(int index) {
    setState(() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => _widgetOptions[index]),
      );
    });
  }

  /// build nav bar using icons
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      child: BottomNavigationBar(
        ///home page
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
            backgroundColor: Color.fromARGB(212, 221, 9, 44),
          ),
          BottomNavigationBarItem(
            ///prodcuts page
            icon: Icon(Icons.shopping_basket_outlined),
            label: 'Market',
            backgroundColor: Color.fromARGB(212, 221, 9, 44),
          ),
          BottomNavigationBarItem(
            ///create post page
            icon: Icon(Icons.add_circle_outlined),
            label: 'Create',
            backgroundColor: Color.fromARGB(240, 221, 9, 44),
          ),
          BottomNavigationBarItem(
            ///user profile page
            icon: Icon(Icons.account_circle_outlined),
            label: 'Profile',
            backgroundColor: Color.fromARGB(240, 221, 9, 44),
          ),
          BottomNavigationBarItem(
            ///user chat page
            icon: Icon(Icons.message_outlined),
            label: 'Messages',
            backgroundColor: Color.fromARGB(212, 221, 9, 44),
          ),
        ],
        currentIndex: 2,

        /// makes the center icon the largest
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedFontSize: 12,
        unselectedFontSize: 10,
        onTap: _onItemTapped,
      ),
    );
  }
}

/// import statements
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'User.dart';
import 'chat_page.dart';
import 'navbar_widget.dart';

/// A page for displaying a user's public information to other users
class PublicProfilePage extends StatefulWidget {
  // other user's username as String
  final String other;
  late FirebaseFirestore firebaseFirestore;

  /// Required parameters for a PublicProfilePage constructor
  PublicProfilePage({
    super.key,
    required this.other,
    required this.firebaseFirestore,
  });
  @override
  _PublicProfilePageState createState() => _PublicProfilePageState();
}

/// PublicProfilePageState controls the contents of the profile page
class _PublicProfilePageState extends State<PublicProfilePage> {
  /// build the page using two user inputs
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FutureBuilder<User>(
              future: User.read(widget.firebaseFirestore, widget.other),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData) {
                  User other = snapshot.data!;
                  return Column(
                    children: [
                      Container(
                        width: 300,
                        height: 300,
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          border: Border.all(
                            color: Colors.black,
                            width: 2,
                          ),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(other.profilePicture),
                          ),
                        ),

                        /// accessibility
                        child: Tooltip(
                          message: '${other.firstName}\'s profile picture',
                          child: Container(),
                        ),
                      ),
                      const SizedBox(height: 40.0),
                      Text(
                        "Username: @${other.username}",
                        semanticsLabel: "Username is ${other.username}",
                        style: const TextStyle(
                          fontFamily: "Times New Roman",
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5.0),
                      Text(
                        "First Name: ${other.firstName}",
                        style: const TextStyle(
                          fontFamily: "Times New Roman",
                          fontSize: 16.0,
                        ),
                      ),
                      const SizedBox(height: 5.0),
                      Text(
                        "NEU Campus: ${other.campus}",
                        semanticsLabel:
                            "Northeastern University Campus: ${other.campus}",
                        style: const TextStyle(
                          fontFamily: "Times New Roman",
                          fontSize: 16.0,
                        ),
                      ),
                      const SizedBox(height: 20.0),
                    ],
                  );
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                primary: Color.fromARGB(212, 221, 9, 44),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatPage(
                      other: widget.other,
                      firebaseFirestore: FirebaseFirestore.instance,
                    ),
                  ),
                );
              },

              /// accessibility
              icon: Tooltip(
                message: 'Message ${widget.other}',
                child: const Icon(
                  Icons.message,
                ),
              ),
              label: const Text(
                'Message',
                style: TextStyle(
                  fontFamily: "Times New Roman",
                  fontSize: 14.0,
                ),
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: NavBar(),
    );
  }
}

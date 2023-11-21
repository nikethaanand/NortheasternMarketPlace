// import libraries
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'User.dart';
import 'login.dart';
import 'package:provider/provider.dart';
import 'navbar_widget.dart';

/// Private Profile Page will display the logged in user's account information
class PrivateProfilePage extends StatefulWidget {
  late FirebaseFirestore firebaseFirestore;
  PrivateProfilePage({required this.firebaseFirestore});

  @override
  _PrivateProfilePageState createState() => _PrivateProfilePageState();
}

/// Private Profile Page State will control the state of the private profile page
class _PrivateProfilePageState extends State<PrivateProfilePage> {
  var editedUser;

  /// allows user to edit their account information in a separate form and saves to database
  void _editAccount(BuildContext context) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        /// EditAccountForm is in User class
        builder: (_) => EditAccountForm(
          user: editedUser,
          firebaseFirestore: widget.firebaseFirestore,
        ),
      ),
    );
    setState(() {
      User.read(widget.firebaseFirestore, editedUser.username).then((user) {
        editedUser = user;
      });
    });
  }

  /// deletes the account from userbase and navigates back to login page
  void _deactivateAccount() {
    editedUser.deactivate(widget.firebaseFirestore);
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ));
  }

  /// builds the Profile Page with user information
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    editedUser = userProvider.user;

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
            const SizedBox(height: 5.0),
            Flexible(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "My Account",
                    style: TextStyle(
                      fontFamily: "Times New Roman",
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  /// accessibility - similar to Semantic labels
                  Tooltip(
                    message: 'Edit your account information',
                    child: IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () => {_editAccount(context)},
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10.0),

            /// accessibility
            Tooltip(
              message: 'Your profile picture',
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  border: Border.all(
                    color: Colors.black,
                    width: 2,
                  ),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(editedUser!.profilePicture),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16.0),

            /// accessibility
            Semantics(
              label: 'Username is ${editedUser.username}',
              child: Text(
                "Username: @" + editedUser.username,
                style: const TextStyle(
                  fontFamily: "Times New Roman",
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Full Name: " + editedUser.getFullName(),
                  style: const TextStyle(
                    fontFamily: "Times New Roman",
                    fontSize: 16.0,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "NEU Campus: " + editedUser.campus,
                  semanticsLabel:
                      "Northeastern University Campus: ${editedUser.campus}",
                  style: const TextStyle(
                    fontFamily: "Times New Roman",
                    fontSize: 16.0,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "NEU Email: " + editedUser.email,
                  style: const TextStyle(
                    fontFamily: "Times New Roman",
                    fontSize: 16.0,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Address:\n" + editedUser.address.toString(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: "Times New Roman",
                    fontSize: 16.0,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 10.0, width: 10.0),

                /// accessibility - similar to Semantic labels
                Tooltip(
                  message: 'Log out of your account',
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      // ignore: deprecated_member_use
                      primary: Colors.grey,
                    ),
                    onPressed: () => {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginPage(),
                        ),
                      ),
                    },
                    child: const Text(
                      "Log Out",
                      style: TextStyle(
                        fontFamily: "Times New Roman",
                        fontSize: 16.0,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 40.0, width: 40.0),

                /// accessibility - similar to Semantic labels
                Tooltip(
                  message: 'Delete your account',
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      // ignore: deprecated_member_use
                      primary: Colors.red,
                    ),
                    onPressed: () => _deactivateAccount(),
                    child: const Text(
                      "Deactivate",
                      style: TextStyle(
                        fontFamily: "Times New Roman",
                        fontSize: 16.0,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavBar(),
    );
  }
}

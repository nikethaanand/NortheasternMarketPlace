/// import statements
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gtk_flutter/login.dart';
import 'package:gtk_flutter/navbar_widget.dart';
import 'package:provider/provider.dart';
import 'Chat.dart';
import 'chat_page.dart';

/// Chat History will display previous conversations between logged in user and other users
class ChatHistory extends StatefulWidget {
  late FirebaseFirestore firebaseFirestore;
  ChatHistory({required this.firebaseFirestore});
  @override
  _ChatHistoryState createState() => _ChatHistoryState();
}

/// ChatHistoryState controsl the state of the Chat History page
class _ChatHistoryState extends State<ChatHistory> {
  /// default value for loading Conversations class
  Future<Conversations> _conversationsFuture =
      Future<Conversations>.value(Conversations(user: "", chats: []));
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';

  /// initialize page by reading in all of the user's previous chat's and setting search filter
  @override
  void initState() {
    _searchController.addListener(() {
      setState(() {
        _searchText = _searchController.text;
      });
    });
    super.initState();
  }

  /// build chat history page using user's information
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    _conversationsFuture = Conversations.read(
        widget.firebaseFirestore, userProvider.user!.username);

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
      body: Padding(
        padding: EdgeInsets.all(30.0),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black54,
                  width: 2.0,
                ),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                children: [
                  Icon(Icons.search, color: Colors.black54),
                  SizedBox(width: 10),
                  Expanded(
                    /// accessibility
                    child: Semantics(
                      label: 'Filter conversations by username',
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Search by username',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: FutureBuilder<Conversations>(
                  future: _conversationsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text('Error loading conversations'),
                      );
                    } else {
                      /// ret
                      final chats = snapshot.data!.chats;

                      /// filter by username
                      final filteredChats = chats.where((chat) => chat.other
                          .toLowerCase()
                          .contains(_searchText.toLowerCase()));

                      /// sort by recency
                      final sortedChats = filteredChats.toList()
                        ..sort((a, b) {
                          final aTimestamp = a.messages.isNotEmpty
                              ? a.messages.last.timestamp
                              : DateTime.fromMillisecondsSinceEpoch(0);
                          final bTimestamp = b.messages.isNotEmpty
                              ? b.messages.last.timestamp
                              : DateTime.fromMillisecondsSinceEpoch(0);
                          return bTimestamp.compareTo(aTimestamp);
                        });
                      return Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black54,
                            width: 2.0,
                          ),
                        ),
                        child: ListView.separated(
                          itemCount: sortedChats.length,
                          separatorBuilder: (BuildContext context, int index) {
                            return Divider(
                              thickness: 1,
                              color: Colors.grey.shade300,
                            );
                          },
                          itemBuilder: (BuildContext context, int index) {
                            final chat = sortedChats.elementAt(index);
                            final otherUser = chat.other;
                            final messages = chat.messages;
                            final lastMessage =
                                messages.isNotEmpty ? messages.last : null;
                            final messageText = lastMessage?.text ?? '';
                            final messageSender = lastMessage?.sender ?? '';

                            return ListTile(
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 16.0),
                              subtitle: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Expanded(
                                    child: Text(
                                      otherUser,
                                      style: TextStyle(
                                        fontSize: 15.0,
                                        color: Colors.black54,
                                      ),
                                      semanticsLabel:
                                          "Conversation with ${otherUser}. Click to view conversation.",
                                    ),
                                  ),
                                  VerticalDivider(
                                    thickness: 2,
                                    color: Colors.black54,
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      "${messageSender}: ${messageText}",
                                      semanticsLabel:
                                          "Last message sent by ${messageSender} saying ${messageText}. Click to view conversation.",
                                      style: TextStyle(
                                        fontSize: 12.0,
                                        color: Colors.grey.shade700,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChatPage(
                                        other: otherUser,
                                        firebaseFirestore:
                                            widget.firebaseFirestore),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      );
                    }
                  }),
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavBar(),
    );
  }
}

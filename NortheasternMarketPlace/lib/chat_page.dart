/// import statements
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'login.dart';
import 'navbar_widget.dart';
import 'public_profile.dart';
import 'chat_bubble_widget.dart';
import 'Chat.dart';

/// Chat page displays a series of messages between 2 users
class ChatPage extends StatefulWidget {
  late FirebaseFirestore firebaseFirestore;
  final String other;

  /// constructor takes in two usernames as Strings
  ChatPage({Key? key, required this.other, required this.firebaseFirestore}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}
/// controls the state environment for a chat page
class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  Chat _chat = Chat(messages: [], user: '', other: '');

  /// initializes the chat page state 
  @override
  void initState() {
    super.initState();
    _getChat();
  }

  /// loads chat from firestore databasee
  Future<void> _getChat() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    Chat chat = await Conversations.findSpecificChat(
        widget.firebaseFirestore, userProvider.user!.username, widget.other);
    setState(() {
      _chat = chat;
    });
  }

  /// handles adding a new  message to both user's conversation logs and displaying on screen
  void _sendMessage(Chat chat) async {
    final messageText = _messageController.text;
    if (messageText.isNotEmpty) {
      chat.addMessage(messageText);
      Conversations.update(widget.firebaseFirestore,chat.user, chat.other, chat.messages.last);
      Conversations.update(widget.firebaseFirestore, chat.other, chat.user, chat.messages.last);
      _messageController.clear();
      setState(() {
        _chat = chat;
      });
    }
  }

  /// build method for loading a single chat between 2 users
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
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.transparent,
            width: 20.0,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Tooltip(
              message: 'Visit ${widget.other}\'s page',
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          PublicProfilePage(other: widget.other, firebaseFirestore: widget.firebaseFirestore,),
                    ),
                  );
                },
                child: Row(
                  children: [
                    const Icon(
                      Icons.account_box,
                      color: Color.fromARGB(212, 221, 9, 44),
                    ),
                    Text(
                      '@${widget.other}',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16.0,
                        fontFamily: 'Times New Roman',
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            Expanded(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                    width: 1.0,
                  ),
                ),
                child: ListView.builder(
                  itemCount: _chat.messages.length,
                  itemBuilder: (context, index) {
                    final message = _chat.messages[index];
                    final isCurrentUser = message.sender == _chat.user;
                    return ChatBubble(
                      message: message,
                      isCurrentUser: isCurrentUser,
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Send a message',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
                Tooltip(
                  message: 'Send new message to ${_chat.other}',
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Color.fromARGB(212, 221, 9, 44),
                    ),
                    onPressed: () async {
                      _sendMessage(_chat);
                    },
                    child: Text('Send'),
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

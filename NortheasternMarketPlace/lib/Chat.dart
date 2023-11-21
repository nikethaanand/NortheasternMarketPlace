/// import statements
import 'package:cloud_firestore/cloud_firestore.dart';

/// Conversations class represents a conversation log for one user
class Conversations {
  final String user;
  late final List<Chat> chats;

  /// constructor takes in a user's username as a string and a list of chats (optional)
  Conversations({
    required this.user,
    List<Chat>? chats,
  }) : chats = chats ?? [];

  /// Convert the conversations object to a JSON map
  Map<String, dynamic> toJson() => {
        'user': user,
        'chats': chats.map((chat) => chat.toJson()).toList(),
      };

  /// Create a new conversations object from a JSON map
  static Conversations fromJson(Map<String, dynamic> json) => Conversations(
        user: json['user'],
        chats:
            List<Chat>.from(json['chats'].map((chat) => Chat.fromJson(chat))),
      );

  /// Creates a new conversation in database
  static Future<void> create(
      FirebaseFirestore firebaseFirestore, Conversations conversation) async {
    await firebaseFirestore
        .collection('Conversations')
        .add(conversation.toJson());
  }

  /// reads existing conversation from database and return as Conversations obj
  static Future<Conversations> read(
      FirebaseFirestore firebaseFirestore, String username) async {
    final conversationCollection =
        firebaseFirestore.collection('Conversations');
    final querySnapshot =
        await conversationCollection.where('user', isEqualTo: username).get();

    if (querySnapshot.docs.isEmpty) {
      return new Conversations(user: username, chats: []);
    }
    final conversationData = querySnapshot.docs.first.data();
    return fromJson(conversationData);
  }

  /// finds a specific chat between two users in the database and returns as Chat object
  static Future<Chat> findSpecificChat(
      FirebaseFirestore firebaseFirestore, String user, String other) async {
    Conversations conversations = await read(firebaseFirestore, user);
    Chat chat = conversations.chats.firstWhere((chat) => chat.other == other,
        orElse: () => Chat(user: user, other: other, messages: []));
    return chat;
  }

  /// add a new message to an existing chat/ conversation
  static Future<void> update(FirebaseFirestore firebaseFirestore, String user,
      String other, Message message) async {
    final conversationCollection =
        firebaseFirestore.collection('Conversations');
    final querySnapshot =
        await conversationCollection.where('user', isEqualTo: user).get();

    /// if current user does not have a conversation log
    if (querySnapshot.docs.isEmpty) {
      await create(
          firebaseFirestore,
          new Conversations(user: user, chats: [
            new Chat(user: user, other: other, messages: [message])
          ]));
    } else {
      /// if current user has a conversations
      bool foundUser = false;
      final id = querySnapshot.docs.first.id;
      final conversationSnapshot = await conversationCollection.doc(id).get();
      final conversation = Conversations.fromJson(conversationSnapshot.data()!);
      for (int i = 0; i < conversation.chats.length; i++) {
        if (conversation.chats[i].other == other) {
          /// if current user is already in a chat with other user
          conversation.chats[i].messages.add(message);
          foundUser = true;
        }
      }

      /// if current user is entering a new chat with other user
      if (foundUser != true) {
        conversation.chats
            .add(new Chat(user: user, other: other, messages: [message]));
      }
      await conversationCollection.doc(id).update(conversation.toJson());
    }
  }
}

/// a dart class to represent chats between two users, which takes in 2 users and a list of messages (optional)
class Chat {
  final String user;
  final String other;
  final List<Message> messages;

  Chat({
    required this.user,
    required this.other,
    List<Message>? messages,
  }) : messages = messages ?? [];

  /// method for converting a string to a message object and adding it to the messages
  void addMessage(String message) {
    messages.add(Message(text: message, sender: user));
  }

  /// Convert the chat object to a JSON map
  Map<String, dynamic> toJson() => {
        'user': user,
        'other': other,
        'messages': messages.map((message) => message.toJson()).toList(),
      };

  /// Create a new chat object from a JSON map
  static Chat fromJson(Map<String, dynamic> json) => Chat(
        user: json['user'],
        other: json['other'],
        messages: List<Message>.from(
            json['messages'].map((message) => Message.fromJson(message))),
      );
}

/// a dart class for a message object that has a text, a sender, and timestamp (optional)
class Message {
  final String text;
  final String sender;
  final DateTime timestamp; //= DateTime.now();

  Message({
    required this.text,
    required this.sender,
    timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  /// Convert the message object to a JSON map
  Map<String, dynamic> toJson() => {
        'text': text,
        'sender': sender,
        'timestamp': timestamp.toIso8601String(),
      };

  /// Create a new message object from a JSON map
  static Message fromJson(Map<String, dynamic> json) => Message(
        text: json['text'],
        sender: json['sender'],
        timestamp: DateTime.parse(json['timestamp']),
      );
}

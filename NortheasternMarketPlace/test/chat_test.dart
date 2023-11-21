import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gtk_flutter/Address.dart';
import 'package:gtk_flutter/Chat.dart';
import 'package:gtk_flutter/User.dart';
import 'package:gtk_flutter/login.dart';

void main() async {
  test('test non database methods', () {
    /// empty messages
    Chat emptyMessages = new Chat(user: 'u1', other: 'u2');
    expect(emptyMessages.messages.isEmpty, true);

    /// empty chats
    Conversations emptyChats = new Conversations(user: 'u1');
    expect(emptyChats.chats.isEmpty, true);

    /// messages: from json
    final message_json = {
      'text': 'text',
      'sender': 'sender',
      'timestamp': DateTime.now().toIso8601String(),
    };
    final ret_message = Message.fromJson(message_json);
    expect(ret_message.text, equals('text'));
    expect(ret_message.sender, equals('sender'));
    expect(ret_message.timestamp, isA<DateTime>());

    // messages: to json
    Message testMessage = new Message(sender: "sender", text: "text");
    var ret_json = testMessage.toJson();
    expect(ret_json['text'], equals('text'));
    expect(ret_json['sender'], equals('sender'));
    expect(ret_json['timestamp'], isA<String>());

    /// chats: from json
    final chat_json = {
      'user': 'sender',
      'other': 'receiver',
      'messages': [],
    };
    var ret_chat = Chat.fromJson(chat_json);
    expect(ret_chat.user, equals('sender'));
    expect(ret_chat.other, equals('receiver'));
    expect(ret_chat.messages, []);

    /// chats: to json
    Chat testChat = new Chat(
      user: "sender",
      other: "receiver",
      messages: [],
    );
    ret_json = testChat.toJson();
    expect(ret_json['user'], equals('sender'));
    expect(ret_json['other'], equals('receiver'));
    expect(ret_json['messages'], []);

    /// chats: add messsage
    expect(testChat.messages.length, 0);
    testChat.addMessage("text");
    expect(testChat.messages.length, 1);

    /// Conversations: from json
    final conversations_json = {
      'user': 'sender',
      'chats': [],
    };
    var retConversations = Conversations.fromJson(conversations_json);
    expect(retConversations.user, equals('sender'));
    expect(retConversations.chats, []);

    /// Conversations: to json
    Conversations testConversation = new Conversations(
      user: "sender",
      chats: [],
    );
    ret_json = testConversation.toJson();
    expect(ret_json['user'], equals('sender'));
    expect(ret_json['chats'], []);
  });

  test('database tested with app logic', () async {
    final fakeFirestore = FakeFirebaseFirestore();

    /// create 2 conversation logs
    final conversations1 = Conversations(user: 'user1', chats: []);
    await Conversations.create(fakeFirestore, conversations1);
    final conversations2 = Conversations(user: 'user2', chats: []);
    await Conversations.create(fakeFirestore, conversations2);
    final snapshot2 = await fakeFirestore.collection('Conversations').get();
    expect(snapshot2.docs.length, equals(2));

    /// read chats
    Chat chat1 =
        await Conversations.findSpecificChat(fakeFirestore, 'user1', 'user2');
    Chat chat2 =
        await Conversations.findSpecificChat(fakeFirestore, 'user2', 'user1');
    expect(chat1.user, 'user1');
    expect(chat1.other, 'user2');
    expect(chat1.messages.isEmpty, true);
    expect(chat2.user, 'user2');
    expect(chat2.other, 'user1');
    expect(chat2.messages.isEmpty, true);

    /// update conversation logs for both users
    Message newMessage = new Message(
        sender: 'user1', text: 'Hi user2', timestamp: DateTime.now());
    Conversations.update(fakeFirestore, 'user1', 'user2', newMessage);
    Conversations.update(fakeFirestore, 'user2', 'user1', newMessage);

    /// Wait for the updates to be persisted!!!! FAKE FIRESTORE BEHAVES DIFFERENTLY
    await Future.delayed(Duration(seconds: 1));
    chat1 =
        await Conversations.findSpecificChat(fakeFirestore, 'user1', 'user2');
    chat2 =
        await Conversations.findSpecificChat(fakeFirestore, 'user2', 'user1');

    /// new message will show up on both user's conversation logs
    expect(chat1.messages.isNotEmpty, true);
    expect(chat2.messages.isNotEmpty, true);

    /// create new chat for user 3
    Conversations.update(fakeFirestore, 'user3', 'user1', newMessage);

    /// entering new chat with user 3
    Conversations.update(fakeFirestore, 'user1', 'user3', newMessage);
    await Future.delayed(Duration(seconds: 1));
    chat1 =
        await Conversations.findSpecificChat(fakeFirestore, 'user1', 'user3');
    Chat chat3 =
        await Conversations.findSpecificChat(fakeFirestore, 'user3', 'user1');
    expect(chat1.messages.isNotEmpty, true);
    expect(chat3.messages.isNotEmpty, true);
  });
}
//flutter test --coverage
//genhtml coverage/lcov.info -o coverage/html
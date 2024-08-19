import 'package:astrology_app/models/chat_messages.dart';
import 'package:astrology_app/models/index.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String?> getOrCreateChatId(List<String> members) async {
    if (members.length == 2) {
      members.sort();
      String chatId = members.join('_');
      DocumentSnapshot chatDoc = await FirebaseFirestore.instance
          .collection('chat_messages')
          .doc(chatId)
          .get();

      if (chatDoc.exists) {
        return chatId;
      } else {
        await FirebaseFirestore.instance
            .collection('chat_messages')
            .doc(chatId)
            .set({
          'members': members,
          'created_at': Timestamp.now(),
        });
        return chatId;
      }
    } else {
      return await _createNewChatRoom(members);
    }
  }

  Future<String> _createNewChatRoom(List<String> members) async {
    DocumentReference chatDocRef =
        FirebaseFirestore.instance.collection('chat_messages').doc();
    String chatId = chatDocRef.id;
    await chatDocRef.set({
      'members': members,
      'date_time': Timestamp.now(),
    });
    return chatId;
  }

  Stream<List<ChatMessages>> getChatMessagesStream(String chatId) {
    return _firestore
        .collection('chat_messages')
        .doc(chatId)
        .collection('messages')
        .orderBy('date_time', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ChatMessages.fromFirestore(doc))
            .toList());
  }

  Future<void> sendMessage(String chatId, ChatMessages message) async {
    await _firestore
        .collection('chat_messages')
        .doc(chatId)
        .collection('messages')
        .add(message.toMap());
  }

  Future<List<User>> getUsersWhoMessaged(String userId) async {
    // Step 1: Query the 'messages' collection group to find the most recent messages
    QuerySnapshot messagesSnapshot = await _firestore
        .collectionGroup('messages')
        .where('members', arrayContains: userId)
        .orderBy('date_time', descending: true)
        .get();
      print(messagesSnapshot);
    // Step 2: Collect the sender IDs from the messages
    Set<String> userIds = {};
    for (var messageDoc in messagesSnapshot.docs) {
      var messageData = messageDoc.data() as Map<String, dynamic>;

      String? senderId = messageData['sent_by'];
      if (senderId != null && senderId != userId) {
        userIds.add(senderId);
      }
    }

    // Step 3: Fetch user details for each sender ID
    List<User> users = [];
    for (String id in userIds) {
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(id).get();
      if (userDoc.exists) {
        users.add(User.fromFirestore(userDoc));
      }
    }

    return users;
  }
}

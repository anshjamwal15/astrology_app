import 'package:astrology_app/models/chat_messages.dart';
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
        await FirebaseFirestore.instance.collection('chat_messages').doc(chatId).set({
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
}
